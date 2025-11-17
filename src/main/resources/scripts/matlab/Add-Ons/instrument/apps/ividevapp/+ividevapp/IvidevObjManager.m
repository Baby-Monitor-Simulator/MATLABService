classdef IvidevObjManager < matlabshared.mediator.internal.Publisher & ...
        matlabshared.mediator.internal.Subscriber & ...
        matlabshared.testmeasapps.internal.dialoghandler.DialogSource
    %IvidevObjManager creates the ividev object and executes the actions
    % performed by the user relating to the ividev object.

    % Copyright 2023-2024 The MathWorks, Inc.

    properties (SetObservable)
        ActivityLogTableData
        CodeLogInfo

        % Status bar text update properties

        % true - means function/property execution operation is starting
        % false - means function/property execution operation has completed
        % or not begun
        FunctionPropertyStatusBar (1, 1) logical = false

        % true - means function/property execution operation was successful
        % false - means function/property execution operation failed
        ExecutionSuccessful (1, 1) logical = false
    end

    properties
        IvidevObj
        Command
        GetValue
        RepCapID
        MetaDataAdapter
        FuncName
        FuncInputArgs
        FuncOutputArgs

        % Keeps track of the number of times the user invokes property getter.
        % It is used to create a unique variable in the Code Log to store
        % the property value.
        ExecuteGetPropCounter
    end

    properties (Constant)
        CommandObjectString (1, 1) string = "(obj.IvidevObj"
        DisplayObjectString (1, 1) string = "(dev"
        VendorDriverErrorPrefix = "Vendor Driver Error"
    end

    %% Lifetime
    methods
        function obj = IvidevObjManager(mediator, paramStr, metaDataAdapter)
            arguments
                mediator matlabshared.mediator.internal.Mediator
                paramStr (1, 1) string
                metaDataAdapter (1, 1) ividevapp.IMetaDataAdapter
            end

            obj@matlabshared.mediator.internal.Publisher(mediator);
            obj@matlabshared.mediator.internal.Subscriber(mediator);
            obj@matlabshared.testmeasapps.internal.dialoghandler.DialogSource(mediator);

            % Initalize properties
            obj.ExecuteGetPropCounter = 0;
            obj.MetaDataAdapter = metaDataAdapter;
            constructor = "ividev(" + paramStr + ")";
            obj.Command = "dev = " + constructor;
            obj.IvidevObj = eval(constructor);
        end
    end

    %% API
    methods
        function [dev, constructorCode] = connect(obj)
            % Save the ividev object and the command to create the object
            % to be passed in to other locations.
            dev = obj.IvidevObj;
            constructorCode = obj.Command;
        end
    end

    %% Implement matlabshared.mediator.internal.Subscriber abstract methods
    methods
        function subscribeToMediatorProperties(obj, ~, ~)
            obj.subscribe("IvidevObjFuncArgs", ...
                @(src, event)obj.executeFcnPanel(event.AffectedObject.IvidevObjFuncArgs));

            obj.subscribe("GetPropValue", ...
                @(src, event)obj.executePropPanelGet(event.AffectedObject.GetPropValue));

            obj.subscribe("SetPropValue", ...
                @(src, event)obj.executePropPanelSet(event.AffectedObject.SetPropValue));

            obj.subscribe("SelectedRepCapID", ...
                @(src, event)obj.repCapSelected(event.AffectedObject.SelectedRepCapID));

            obj.subscribe("SelectedNode", ...
                @(src, event)obj.nodeChange(event.AffectedObject.SelectedNode));
        end
    end

    %% Subscriber Handler Functions
    methods
        function executeFcnPanel(obj, src, ~)
            % Handler to execute the selected function.

            % Set FunctionPropertyStatusBar to true to indicate that
            % function execution operation is starting. This will be used
            % when making status bar text updates.
            obj.FunctionPropertyStatusBar = true;

            data = src{1};
            uiElements = src{3};
            inputValues = {};

            % Create the ividev function command to evaluate.
            % Also create the command and comment strings to display in the Code Log.
            args = obj.CommandObjectString;
            dispArgs = obj.DisplayObjectString;
            codeLogComment = message("ividevapp:ividevapp:FunctionCodeLogComment", obj.FuncName).string;

            for i = 1:length(data)
                % Properly format and add each input to the string of
                % arguments.

                % Retrieve the data for the function input argument.
                value = data{i};

                % Update the ividev function command string "args" by
                % appending function input data to it. This will be used to
                % evaluate the function.
                % Update the ividev function string "dispArgs" which will be
                % used to display the succesfully evaluated command in
                % the Code Log.
                if islogical(value)
                    args = args + ", " + string(value);
                    dispArgs = dispArgs + ", " + string(uiElements{i}.Value);

                elseif isnumeric(value)
                    if isscalar(value)
                        args = args + ", " + num2str(value);
                    else
                        args = args + ", " + "[" + num2str(value) + "]";
                    end
                    dispArgs = dispArgs + ", " + num2str(uiElements{i}.Value);

                    if checkIfWorkspaceVariable(obj, value, uiElements{i})
                        codeLogComment = getWorkspaceVarCodeLogComment(obj, codeLogComment, uiElements{i}.Value);
                    end

                elseif isa(value, "string") || isa(value, "char")
                    if value == ""
                        args = args + ', ""';
                    else
                        args = args + ', "' + value + '"';
                    end

                    % If the data for the function input is different from
                    % the function input UI element value, this means that
                    % a workspace variable was chosen for the function
                    % input in the actions tab (instead of a value being
                    % entered).
                    % So, dont add extra quotes around the workspace
                    % variable in the "dispArgs" string.
                    if contains(value, "") && checkIfWorkspaceVariable(obj, value, uiElements{i})
                        dispArgs = dispArgs + ", " + uiElements{i}.Value;
                        codeLogComment = getWorkspaceVarCodeLogComment(obj, codeLogComment, uiElements{i}.Value);
                    else
                        dispArgs = dispArgs + ", " + """" + uiElements{i}.Value  + """";
                    end
                end

                % Store data to be displayed in the Activity Log table.
                inputValues{end+1} = data{i}; %#ok<AGROW>
            end

            % Create the complete command to evaluate and string to display
            % in the Code Log.
            command = obj.FuncName + args + ");";
            displayedCommand = obj.FuncName + dispArgs + ");";

            try
                % Try executing the selected function with the given
                % parameters. Assign outputs if function executes successfully.
                numOutputs = src{2};
                [varargout{1:numOutputs}] = eval(command);

                % Generate the CodeLog string to display and also create
                % the cell array for the Activity Log data.
                % If the function outputs values, include these outputs in
                % the Code Log display and in the Activity Log.
                if numOutputs >= 1

                    % Change the name of any output variables that are
                    % the same as the name of the function being invoked to
                    % avoid MATLAB errors (same variable and function name
                    % in MATLAB).
                    idx = find(ismember(obj.FuncOutputArgs, obj.FuncName));
                    if ~isempty(idx)
                        obj.FuncOutputArgs(idx) = obj.FuncName + "Var";
                    end

                    outputs = getFunctionOutputs(obj);
                    obj.CodeLogInfo = [codeLogComment, outputs + displayedCommand];
                    obj.ActivityLogTableData = {obj.FuncName, obj.FuncInputArgs, inputValues, obj.FuncOutputArgs, varargout};
                else
                    obj.CodeLogInfo = [codeLogComment, displayedCommand];
                    obj.ActivityLogTableData = {obj.FuncName, obj.FuncInputArgs, inputValues, [], {}};
                end

                % Set ExecutionSuccessful to true to indicate that
                % function execution operation has completed successfully.
                % This will be used when making status bar text updates.
                obj.ExecutionSuccessful = true;
            catch ex
                % Show error dialog if the evaluated command is invalid.
                msg = getVendorError(obj, ex);
                obj.showErrorDialog(MException(message("ividevapp:ividevapp:InvalidFunctionInputError", msg)));

                % Set ExecutionSuccessful to false to indicate that
                % function execution operation has failed.
                % This will be used when making status bar text updates.
                obj.ExecutionSuccessful = false;
            end

            % Set FunctionPropertyStatusBar to false to indicate that
            % function execution operation has completed. This will be used
            % when making status bar text updates.
            obj.FunctionPropertyStatusBar = false;

            %% NESTED FUNCTION
            function codeLogComment = getWorkspaceVarCodeLogComment(obj, codeLogComment, uiElementVal)
                % Construct the function codeLogComment by adding
                % information about workspace variables that were used for
                % function input arguments.

                workspaceVarCodeLogStr = message("ividevapp:ividevapp:WorkspaceVarFunctionCodeLogComment", obj.FuncName, "").string;
                if contains(codeLogComment, extractBefore(workspaceVarCodeLogStr, """."))
                    codeLogComment = extractBefore(codeLogComment, ".") + ", " + """" + uiElementVal + """.";
                else
                    codeLogComment = message("ividevapp:ividevapp:WorkspaceVarFunctionCodeLogComment", obj.FuncName, uiElementVal).string;
                end
            end
        end

        function executePropPanelGet(obj, src, ~)
            % Handler to execute the getter for the selected property.

            % Set FunctionPropertyStatusBar to true to indicate that
            % property get operation is starting. This will be used
            % when making status bar text updates.
            obj.FunctionPropertyStatusBar = true;

            % Initialize the selected property node and its parents variable.
            parents = "";
            node = src{1};

            % Get all parents of the selected property node until the
            % "Properties" root node but not including it.
            while node.Parent.Text ~= "Properties"
                if node.Parent.NodeData.HasRepCap
                    parents = node.Parent.NodeData.Name + "(""" + obj.RepCapID + """)." + parents;
                else
                    parents = node.Parent.NodeData.Name + "." + parents;
                end
                node = node.Parent;
            end

            % Create the command to evaluate for the property getter.
            child = src{1}.NodeData.Name;
            command = "obj.IvidevObj." + parents + child + ";";

            % Use "dev" as the object in the displayed code to be
            % consistent with creating the ividev object. This string will
            % be shown in the Code Log upon successfull execution.
            displayedCommand = replace(command, "obj.IvidevObj", "dev");

            try
                % Try getting the selected property value.
                obj.GetValue = eval(command);

                % Assign get value to variable in the code displayed in the
                % Code Log.
                variable = "data" + string(obj.ExecuteGetPropCounter);

                codeLogComment = message("ividevapp:ividevapp:GetPropertyCodeLogComment", child).string;
                obj.CodeLogInfo = [codeLogComment, variable + " = " + displayedCommand];
                obj.ActivityLogTableData = {child, [], {}, [], {obj.GetValue}};

                % Increment the counter for the next get property value
                % operation.
                obj.ExecuteGetPropCounter = obj.ExecuteGetPropCounter + 1;

                % Set ExecutionSuccessful to true to indicate that
                % property get operation has completed successfully.
                % This will be used when making status bar text updates.
                obj.ExecutionSuccessful = true;
            catch ex
                % Show error dialog if the command is invalid.
                obj.showErrorDialog(ex);

                % Show an error message in the Get edit field in the actions tab.
                obj.GetValue = message("ividevapp:ividevapp:PropertyAccessMessage").string;

                % Set ExecutionSuccessful to false to indicate that
                % property get operation has failed.
                % This will be used when making status bar text updates.
                obj.ExecutionSuccessful = false;
            end

            % Display property value or error message in edit field.
            if isa(obj.GetValue, "string") && obj.GetValue == ""
                obj.GetValue = '""';
            end

            % Update the get edit field with the value from the getter operation.
            getEditBox = src{2};
            getEditBox.Value = string(obj.GetValue);

            % Set FunctionPropertyStatusBar to false to indicate that
            % property get operation has completed. This will be used
            % when making status bar text updates.
            obj.FunctionPropertyStatusBar = false;
        end

        function executePropPanelSet(obj, src, ~)
            % Handler to execute the setter for the selected property.

            % Set FunctionPropertyStatusBar to true to indicate that
            % property set operation is starting. This will be used
            % when making status bar text updates.
            obj.FunctionPropertyStatusBar = true;

            % Initialize the selected property node and its parents variable.
            parents = "";
            node = src{1};

            % Get all parents of the selected property node until the
            % "Properties" root node but not including it.
            while node.Parent.Text ~= "Properties"
                if node.Parent.NodeData.HasRepCap
                    parents = node.Parent.NodeData.Name + "(""" + obj.RepCapID + """)." + parents;
                else
                    parents = node.Parent.NodeData.Name + "." + parents;
                end
                node = node.Parent;
            end

            % Create the command to evaluate for the property setter.
            child = src{1}.NodeData.Name;
            data = src{3};

            if isa(data, "string")
                command = "obj.IvidevObj." + parents + child + " = " + """" + data + """" + ";";
            else
                command = "obj.IvidevObj." + parents + child + " = " + data + ";";
            end

            % Use "dev" as the object in the displayed code to be
            % consistent with creating the ividev object.
            codeLogComment = message("ividevapp:ividevapp:SetPropertyCodeLogComment", child).string;
            setterUIElem = src{2};
            if isa(data, "string") && data == setterUIElem.Value
                displayedCommand = "dev." + parents + child + " = " + """" + setterUIElem.Value + """" + ";";
            else
                displayedCommand = "dev." + parents + child + " = " + setterUIElem.Value + ";";
                if checkIfWorkspaceVariable(obj, data, setterUIElem)
                    codeLogComment = message("ividevapp:ividevapp:WorkspaceVarSetPropertyCodeLogComment", child, string(setterUIElem.Value)).string;
                end
            end

            try
                % Try setting the selected property and add corresponding
                % comment/code to Code Log.
                eval(command);
                obj.CodeLogInfo = [codeLogComment, displayedCommand];
                obj.ActivityLogTableData = {child, [], {data}, [], {}};

                % Set ExecutionSuccessful to true to indicate that
                % property set operation has completed successfully.
                % This will be used when making status bar text updates.
                obj.ExecutionSuccessful = true;
            catch ex
                % Show error dialog if the command is invalid.
                msg = getVendorError(obj, ex);
                obj.showErrorDialog(MException(message("ividevapp:ividevapp:InvalidPropertyValueError", msg)));

                % Set ExecutionSuccessful to false to indicate that
                % property set operation has failed.
                % This will be used when making status bar text updates.
                obj.ExecutionSuccessful = false;
            end

            % Set FunctionPropertyStatusBar to false to indicate that
            % property set operation has completed. This will be used
            % when making status bar text updates.
            obj.FunctionPropertyStatusBar = false;
        end

        function repCapSelected(obj, src, ~)
            % Handler to set the current repeated capability value
            obj.RepCapID = src;
        end

        function nodeChange(obj, node, ~)
            % Handler that sets the function name, function input names and
            % function output names when a new function node is selected.

            if node.Text == "Functions" || node.Text == "Properties"
                return
            end

            nodeType = node.NodeData.Type;

            if nodeType ~= "Function"
                return
            end

            index = node.NodeData.Index;

            % No need to get function information if function group is
            % encountered.
            if ~functionHasNoChild(obj.MetaDataAdapter, index)
                obj.FuncName = node.NodeData.Name;
                obj.FuncInputArgs = [];
                obj.FuncOutputArgs = [];
                return
            end

            obj.FuncName = getFunctionName(obj.MetaDataAdapter, index);
            obj.FuncInputArgs = getFuncInputArgNames(obj.MetaDataAdapter, index);
            obj.FuncOutputArgs = getFuncOutputArgNames(obj.MetaDataAdapter, index);

            funcArgLabels = getSortedFuncArgLabels(obj, index);

            obj.FuncInputArgs = sortFuncArgs(obj.FuncInputArgs, funcArgLabels, 'first');
            obj.FuncOutputArgs = sortFuncArgs(obj.FuncOutputArgs, funcArgLabels, 'last');

            %% NESTED FUNCTION
            function funcArgLabels = getSortedFuncArgLabels(obj, index)
                % Returns the function input and output argument names in a
                % sorted array.

                paramPositions = [];
                funcArgLabels = [];

                for param = getFunctionArguments(obj.MetaDataAdapter, index)
                    paramPos = getFuncArgPosition(obj.MetaDataAdapter, param);
                    if paramPos > 0
                        paramPositions = [paramPositions, paramPos]; %#ok<AGROW>
                        funcArgLabels = [funcArgLabels, param.Label]; %#ok<AGROW>
                    end
                end

                % sort funcArgLabels based on the expected parameter
                % positions for the function.
                [~, sortIdx] = sort(paramPositions);
                funcArgLabels = funcArgLabels(sortIdx);
                if ~isempty(funcArgLabels)
                    funcArgLabels = ividev.makeMATLABDriver.internal.camelcase(funcArgLabels);
                end
            end

            %% NESTED FUNCTION
            function funcArgs = sortFuncArgs(funcArgs, funcArgLabels, direction)
                indices = [];
                for arg = funcArgs
                    idx = find(ismember(funcArgLabels, arg), 1, direction);
                    indices = [indices idx]; %#ok<AGROW>
                end
                [~, sIdx] = sort(indices);
                funcArgs = funcArgs(sIdx);
            end
        end
    end

    %% Helper Functions
    methods (Access = ?matlabshared.transportapp.internal.utilities.ITestable)
        function outputs = getFunctionOutputs(obj)
            % Get string of function output names separated by commas.
            outputs = "[" + join(obj.FuncOutputArgs,", ") + "] = ";
        end

        function flag = checkIfWorkspaceVariable(~, data, uiElem)
            flag = string(data) ~= string(uiElem.Value);

            % Workspace variable is not used if the evaluated value of
            % uiElem is equal to data.
            try
                output = eval(uiElem.Value);
                if output == data
                    flag = false;
                end
            catch
            end
        end

        function msg = getVendorError(obj, ex)
            msg = ex.message;
            if contains(ex.message, obj.VendorDriverErrorPrefix) && contains(ex.message, ":")
                msg = extractBefore(ex.message, ":") + ":" + newline + extractAfter(ex.message, ":");
            end
        end
    end
end
