classdef Controller < matlabshared.mediator.internal.Publisher & ...
        matlabshared.mediator.internal.Subscriber & ...
        matlabshared.testmeasapps.internal.dialoghandler.DialogSource
    %CONTROLLER is the Appspace Actions tab Controller class. It contains
    % business logic for operations that are performed when user interacts
    % with View elements.
    %
    % Examples of operations are:
    % When a user -
    % 1) Selects a function or property in the "Functions/Property" tree
    % drop-down.
    % 2) Enters values for a selected function or property and hits the
    % "Execute", "Set" or "Get" button.

    % Copyright 2023-2024 The MathWorks, Inc.

    properties (SetObservable)
        IvidevObjFuncArgs
        GetPropValue
        SetPropValue
        SelectedRepCapID
    end

    properties (Dependent)
        View
    end

    properties
        ViewListeners = event.listener.empty

        % Adapter instance that will provide information about driver
        % functions and properties
        MetaDataAdapter

        % UI elements
        FuncInputArgElemList
        PropSetterElem
        EditableDropdownElemList
        FuncInputArgLabels

        % Array that stores the order in which the function takes in
        % each input parameter.
        ParamPositions

        % Counter that keep track of the number of outputs.
        OutputCounter

        % Name of the selected function
        SelectedFunction

        % Selected property node in the drop-down tree
        SelectedPropertyNode

        % Map that has repeated capability values as keys and property
        % nodes that use a repeated capability as corresponding values.
        RepCapMap

        % Stores all attribute IDs that are used by attribute accessor
        % functions.
        AttributeIDs (1, :) string = string.empty
    end

    properties (Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        % A list that contains valid Workspace Variable names to be
        % shown as items in editable drop-down fields.
        WorkspaceVariableList (1, :) string = string.empty

        % Stores the values of the editable drop-down edit fields
        EditFieldVal

        % Contains list of last Workspace Variable values used as values
        % for the editable drop-down edit fields.
        LatestWorkspaceVariable (1, :) string

        ViewConfiguration
    end

    properties (Constant)
        % Dictionary that maps function argument types to a readable UI element string representation.
        FuncArgTypeToUIElementLookUp = dictionary([1, 2, 3, 4, 5], ["EditableDropDown", "Output", "Dropdown", "BooleanDropDown", "Dropdown"]);
        AttributeConstNameMaxLength = 63
        RepCapID (1, 1) string = message("ividevapp:ividevapp:RepCapID").string
        SetterUIElemLookUp = dictionary([true, false], ["logical", "editable"]);
    end

    %% Lifetime
    methods
        function obj = Controller(mediator, viewConfiguration, ~)
            arguments
                mediator matlabshared.mediator.internal.Mediator
                viewConfiguration matlabshared.transportapp.internal.utilities.viewconfiguration.IViewConfiguration
                ~
            end

            obj@matlabshared.mediator.internal.Publisher(mediator);
            obj@matlabshared.mediator.internal.Subscriber(mediator);
            obj@matlabshared.testmeasapps.internal.dialoghandler.DialogSource(mediator);

            obj.ViewConfiguration = viewConfiguration;
            obj.RepCapMap = containers.Map;

            % Populate the WorkspaceVariableList and set the workspace
            % variable dropdown.
            setupWorkspaceVariableList(obj);

            % Only for production mode
            if isa(obj.ViewConfiguration, ...
                    "matlabshared.transportapp.internal.utilities.viewconfiguration.ViewConfiguration")
                obj.setupListeners();
            end
        end
    end

    %% Implement matlabshared.mediator.internal.Subscriber abstract methods
    methods
        function subscribeToMediatorProperties(obj, ~, ~)
            obj.subscribe("DisplayFunctionPanel", ...
                @(src, event)obj.displayFunctionPanel(event.AffectedObject.DisplayFunctionPanel));

            obj.subscribe("PropertyNode", ...
                @(src, event)obj.displayPropertyPanel(event.AffectedObject.PropertyNode));

            obj.subscribe('WorkspaceUpdated', ...
                @(src, event)obj.handleWorkspaceUpdated(event.AffectedObject.WorkspaceUpdated));
        end
    end

    %% Subscriber Handler Functions
    methods
        function displayFunctionPanel(obj, nodeData, ~)
            % Handler for when a function or function group is selected in
            % the tree dropdown.

            % If src is not empty, it will be a cell array containing the
            % function index and the function tree, which are used to
            % create the function view.
            if isempty(nodeData)
                obj.createBlankView();
                return
            end

            obj.SelectedFunction = nodeData.Name;
            obj.createFunctionView(nodeData);

            % If the selected function is an Attribute accessor function,
            % then get the applicable Attribute IDs for the selected
            % function and populate the Attribute ID input argument
            % drop-down for the function with the Attribute IDs.
            if contains(obj.SelectedFunction, "Attribute") && ~isempty(obj.SelectedRepCapID)
                obj.AttributeIDs = obj.getAttributeIDs();
                obj.populateDropdownForAttributeIDs();
            end

            % Create the workspace variable list needed for editable
            % drop-down fields in functions.
            obj.EditFieldVal = string.empty;
            setupWorkspaceVariableList(obj);
        end

        function displayPropertyPanel(obj, node, ~)
            % Handler for when a property or property group is selected in
            % the tree dropdown.

            % If src is a tree node then a property has been selected
            % otherwise a property group is selected.
            if isempty(node)
                obj.createBlankView();
                return
            end

            obj.createPropertyView(node);

            % Create the workspace variable list needed for editable
            % drop-down fields in properties.
            obj.EditFieldVal = string.empty;
            setupWorkspaceVariableList(obj);
        end

        function handleWorkspaceUpdated(obj, varUpdateForm)
            % Handler for when there is a change in the MATLAB Workspace
            % Variables list.

            arguments
                obj
                varUpdateForm matlabshared.transportapp.internal.utilities.forms.WorkspaceUpdateInfo
            end

            % Save the values of the editable drop-down edit fields in
            % EditFieldVal property. These values will be used again to
            % re-populate the editable drop-down edit field values after
            % all workspace variable update operations have completed.
            obj.EditFieldVal = string.empty;
            for i = 1:length(obj.EditableDropdownElemList)
                if ~ismember(obj.EditableDropdownElemList{i}.Value, obj.WorkspaceVariableList)
                    obj.EditFieldVal(end+1) = obj.EditableDropdownElemList{i}.Value;
                else
                    obj.EditFieldVal(end+1) = "";
                end
            end

            % Handle different workspace variable update operations.
            switch varUpdateForm.EventType
                case "WORKSPACE_CLEARED"
                    % Set the WorkspaceVariableList to an empty list
                    obj.resetWorkspaceVariableList();

                    % Clear the items in the editable dropdown list
                    for i = 1:length(obj.EditableDropdownElemList)
                        obj.EditableDropdownElemList{i}.Value = "";
                        obj.EditableDropdownElemList{i}.Items = {''};
                    end

                case "VARIABLE_DELETED"
                    % Remove all occurrences of the variable name from the
                    % WorkspaceVariableList
                    obj.removeValueFromWorkspaceVariableList ...
                        (varUpdateForm.ChangedVariableNames);

                case {"VARIABLE_CHANGED", "VARIABLE_ADDED"}
                    % Remove all occurrences of the variable name from the
                    % WorkspaceVariableList
                    if isscalar(varUpdateForm.ChangedVariableNames) ...
                            && varUpdateForm.ChangedVariableNames == ""
                        return
                    end

                    obj.removeValueFromWorkspaceVariableList ...
                        (varUpdateForm.ChangedVariableNames);

                    % Parse the new variables changed again.
                    parsedVariableList = ...
                        matlabshared.transportapp.internal.utilities.WorkspaceVariableHandler.parse(varUpdateForm.ChangedVariableNames);

                    % Re-populate the WorkspaceVariableList property with valid
                    % variable names.
                    obj.populateWorkspaceVariableList(parsedVariableList);
                otherwise
                    return
            end

            % Set the editable drop-down fields list using the
            % WorkspaceVariableList values for the selected function or property.
            % Update the current value of the editable drop-down fields for
            % the selected function or property.
            setEditableDropDownWorkspaceVariableList(obj);
            setEditableDropDownValue(obj);
        end
    end

    %% Listener Functions
    methods (Access = ?matlabshared.transportapp.internal.utilities.ITestable)
        function executeFcnPanel(obj, ~, ~)
            % Handler that is called when user presses the "Execute" button
            % for the selected function.

            data = {};

            try
                % Get data for all function input argument fields.
                for elem = obj.FuncInputArgElemList
                    data{end+1} = validateData(obj, elem{1}, elem{1}.Tag); %#ok<AGROW>
                end

                obj.IvidevObjFuncArgs = {data, obj.OutputCounter, obj.FuncInputArgElemList};
            catch ex
                obj.showErrorDialog(ex);
            end
        end

        function executePropPanelGet(obj, src, ~)
            % Handler that is called when user presses the "Get" button
            % for the selected property.
            obj.GetPropValue = {obj.SelectedPropertyNode, src.GetterUIElem};
        end

        function executePropPanelSet(obj, ~, ~)
            % Handler that is called when user presses the "Set" button
            % for the selected property.

            try
                data = validateData(obj, obj.PropSetterElem, string(obj.SelectedPropertyNode.NodeData.Name));
                obj.SetPropValue = {obj.SelectedPropertyNode, obj.PropSetterElem, data};
            catch ex
                obj.showErrorDialog(ex);
            end

            % Clear getter value after setting property value.
            setViewProperty(obj.ViewConfiguration, "GetterUIElem", "Value", "");
        end
    end

    %% API
    methods
        function createBlankView(obj)
            % Creates a blank actions tab view when a function group or a
            % property group is selected.
            obj.View.createControlPanelGridEmpty();
        end

        function generateRepCapMap(obj, repCapIDToGetNameFcnMap, getNameFcnToNodesMap)
            % Generates map of repeated capability values to AttributeNodes
            % (properties).
            % The repCapIDToGetNameFcnMap maps repeated capability values
            % to one or more corresponding getNameFcns, and the
            % getNameFcnToNodesMap maps getNameFcns to one or more
            % corresponding AttributeNodes (properties).

            repCapMap = containers.Map;
            repCapIDs = unique(string(repCapIDToGetNameFcnMap.keys));

            for repCapID = repCapIDs
                for getNameFcn = repCapIDToGetNameFcnMap(repCapID)

                    % If the current repeated capability value has already
                    % been added as a key to the repCapMap, append the
                    % current getNameFcn to the value array.
                    % Otherwise, set the value of the key to be the current getFcnName.
                    if isKey(getNameFcnToNodesMap, getNameFcn)
                        val = getNameFcnToNodesMap(getNameFcn);

                        if isKey(repCapMap, repCapID)
                            val = [repCapMap(repCapID), val]; %#ok<AGROW>
                        end

                        repCapMap(repCapID) = val;
                    end
                end
            end

            % Setup initial Controller properties.
            obj.RepCapMap = repCapMap;

            if ~isempty(repCapIDs)
                obj.SelectedRepCapID = repCapIDs(1);
            end
        end
    end

    %% Helper Functions
    methods (Access = ?matlabshared.transportapp.internal.utilities.ITestable)
        function data = validateData(obj, element, elementName)
            % Parses and validates data passed to it before this data can
            % be used to do ividev operations for the app.

            % For non-editable drop-downs, value of the field is limited to
            % the values in the drop-down list. Hence no further validation
            % is needed.
            if ~(element.Type == "uidropdown" && element.Editable == "on")
                data = element.Value;
                return
            end

            if isempty(element.Value)
                throw(MException(message("ividevapp:ividevapp:EmptyFuncInputError")));
            end

            % For editable drop-downs, check if the value is a workspace
            % variable and then retrieve the data from the workspace variable.
            % If value is not a workspace variable then parse the data
            % further.
            if ismember(element.Value, obj.WorkspaceVariableList)
                data = evalin("base", element.Value);
            else
                data = getData(obj, element, elementName);
            end

            % Validate parsed or evaluated data against the data type of
            % the editable drop-down field.
            validateDataTypeInfo(obj, data, element, elementName);
        end

        function validateDataTypeInfo(~, data, element, elementName)
            % Validates parsed or evaluated data against the data type of
            % the editable drop-down field.

            if isempty(element.UserData)
                return
            end

            if isnumeric(data)
                if element.UserData.DataType == "string"
                    % Numeric data should not be entered in a string type field.
                    throw(MException(message("ividevapp:ividevapp:StringDataTypeError", elementName)));
                elseif any(data > element.UserData.MaxValue) || any(data < element.UserData.MinValue)
                    % Check if numeric data is in the range specified by the datatype.
                    throw(MException(message("ividevapp:ividevapp:NumericDataRangeError", elementName, string(element.UserData.MinValue), string(element.UserData.MaxValue))));
                end
            elseif (isstring(data) || ischar(data)) && element.UserData.DataType ~= "string"
                % String data should not be entered in a numeric type field.
                throw(MException(message("ividevapp:ividevapp:NumericDataTypeError", elementName)));
            end
        end

        function data = getData(obj, elem, elementName)
            % Evaluate and validate the entered data that will be used to
            % do ividev operations in the app.

            % NOTE - data is a "char" value by default.
            data = str2num(elem.Value); %#ok<ST2NM>

            % Data can be either a numeric or char or string.
            if isnumeric(data) && ~isempty(data)
                validateNumericData(obj, data, elementName);
            else
                data = parseASCIIData(obj, elem.Value, elementName);

                % Update the edit field value with the parsed data .
                elem.Value = data;
            end
        end

        function data = parseASCIIData(~, value, elementName)
            % Parse the given data and return the data as a string.

            % If data is ASCII and is enclosed within double-quotes or
            % single-quotes, remove the quotes.
            data = string(value);
            if (data.startsWith("""") && data.endsWith("""") && data.strlength > 1) || ...
                    (data.startsWith('''') && data.endsWith('''') && data.strlength > 1)

                % Remove the starting and ending quotes
                data = data.extractBetween(2, data.strlength()-1);
            end

            % If data stills contains more double-quotes or single-quotes then show an error.
            if contains(string(data), """") || contains(string(data), '''')
                throw(MException(message("ividevapp:ividevapp:StringQuotesError", elementName)));
            end

            try
                % If eval does not fail, then data is not a string (could
                % be numeric or struct or something else but not a string).
                eval(data);

                % Edge case:
                % If original string value contains double-quotes or
                % single-quotes then eval might not fail.
                % e.g. for "struct" or 'struct' the value is still
                % considered a string.
                dataIsString = contains(string(value), """") || contains(string(value), '''');
            catch
                % If eval fails then data is a string.
                dataIsString = true;
            end

            % Throw error since an invalid data type is specified.
            if ~dataIsString
                throw(MException(message("ividevapp:ividevapp:InvalidDataTypeError", elementName)));
            end
        end

        function validateNumericData(~, data, elementName)
            % Validate that the numeric data to be used for ividev
            % operations is valid.
            %
            % Only the following types are valid -
            %    1xn or nx1 numeric or real values

            if ~isnumeric(data) || ~isreal(data)
                throw(MException(message("ividevapp:ividevapp:NumericRealDataError", elementName)));
            end

            rowSize = size(data, 1);
            columnSize = size(data, 2);

            % Throw for invalid numeric sizes.
            if rowSize > 1 && columnSize > 1
                throw(MException(message("ividevapp:ividevapp:InvalidDataSizeError", elementName)));
            end
        end

        function createFunctionView(obj, nodeData)
            % Display function panel with input parameters for the selected
            % function and an execute button.

            index = nodeData.Index;
            funcName = nodeData.Name;
            resetUIProperties(obj);

            % Creates grid layout for Function in the actions tab.
            if isempty(getFuncInputArgNames(obj.MetaDataAdapter, index))
                obj.View.createControlPanelGrid("FunctionWithNoInputs");
            else
                obj.View.createControlPanelGrid("Function");
            end

            % Create function label in actions tab
            obj.View.createLabel(1, funcName, [2 3], "bold");

            % Variables to calculate the row position of each function
            % input argument and the "Execute button".
            funcArgRow = 1;
            executeButtonPos = 2;

            functionArguments = getFunctionArguments(obj.MetaDataAdapter, index);

            for param = functionArguments
                % Get the function argument position of the function argument.
                paramPos = getFuncArgPosition(obj.MetaDataAdapter, param);

                % Ignore certain function arguments such as "Status" and "Vi"
                if propertyToBeIgnored(obj, paramPos)
                    continue
                end

                % Get the UI element type to create for the current
                % function input argument.
                type = getFuncArgType(obj.MetaDataAdapter, param);
                uiElementType = obj.FuncArgTypeToUIElementLookUp(type);

                % Position of the "Execute button" is not affected by
                % output arguments as output arguments are not shown in the
                % Actions tab.
                if uiElementType ~= "Output"
                    executeButtonPos = executeButtonPos + 1;
                else
                    % No UI field is created for output argument.
                    obj.OutputCounter = obj.OutputCounter + 1;
                    continue
                end

                % Increment by 1 to account for adding function name as
                % heading.
                funcArgRow = funcArgRow + 1;

                % Create label for function input parameter.
                paramName = getFuncArgName(obj.MetaDataAdapter, param);

                if paramName == "RepCapIdentifier"
                    label = obj.View.createLabel(funcArgRow, obj.RepCapID);
                else
                    label = obj.View.createLabel(funcArgRow, paramName);
                end

                % Use label name as the tag for corresponding UI elements.
                tag = ividev.makeMATLABDriver.internal.mixedcase(string(label.Text));

                % Handle special case
                % For a dropdown that does not have associated enum
                % values, instead create an editable dropdown.
                enumValues = getFuncArgEnumValues(obj.MetaDataAdapter, param);
                uiElementType = convertDropDownToEditableDropDown(obj, uiElementType, enumValues, tag);

                % Handle special case
                % For "RepCapIdentifier" input argument the UI element to
                % create has to be a drop-down.
                % For "AttributeID" input argument, the UI element to
                % create will be a drop-down unless there are no attribute
                % IDs associated with the selected function.
                if tag == obj.RepCapID || obj.isAttributeID(tag)
                    uiElementType = "Dropdown";
                end

                if obj.isAttributeID(tag) && isempty(obj.getAttributeIDs())
                    uiElementType = "EditableDropDown";
                end

                % Create UI element based on the uiElementType and fill
                % values for the UI element using data from the meta data
                % adapter.
                switch uiElementType
                    case "Dropdown"
                        if obj.isAttributeID(label.Text)
                            uiElement = obj.View.createDropDown(funcArgRow, "", "", tag);
                        elseif label.Text == obj.RepCapID
                            repcaps = string(obj.RepCapMap.keys);
                            dropDownValue = obj.SelectedRepCapID;

                            uiElement = obj.View.createDropDown(funcArgRow, repcaps, dropDownValue, tag);
                            uiElement.ValueChangedFcn = @(editBox, event)repCapSelectedFcn(obj, editBox);
                        else
                            defaultEnumVal = getFuncArgDefaultEnumValue(obj.MetaDataAdapter, param);
                            uiElement = obj.View.createDropDown(funcArgRow, enumValues, defaultEnumVal, tag);
                        end
                    case "EditableDropDown"
                        defaultText = getFuncArgDefaultValue(obj.MetaDataAdapter, param);

                        % Get the associated edit box for the input argument.
                        uiElement = obj.View.createEditableDropDown(funcArgRow, "", defaultText, tag);

                        % Retrieve and save information related to datatype of the function
                        % input argument.
                        getDataTypeInfo(obj, param, uiElement);

                    case "BooleanDropDown"
                        defaultEnumVal = getFuncArgDefaultEnumValue(obj.MetaDataAdapter, param);
                        if defaultEnumVal == "VI_TRUE"
                            value = "true";
                        else
                            value = "false";
                        end

                        items = ["false", "true"];
                        uiElement = obj.View.createDropDown(funcArgRow, items, value, tag);
                        uiElement.ItemsData = [false true];
                end

                % Save UI elements, corresponding labels and function input
                % positions.
                obj.FuncInputArgElemList{end+1} = uiElement;
                obj.FuncInputArgLabels = [obj.FuncInputArgLabels, label];
                obj.ParamPositions = [obj.ParamPositions, paramPos];

                % Save only editable drop-down UI elements.
                if uiElementType == "EditableDropDown"
                    obj.EditableDropdownElemList{end+1} = uiElement;
                end
            end

            % Sort UI elements, corresponding labels and function input
            % positions. The order of the input arguments will be needed
            % to execute the selected ividev function.
            [~, sortIdx] = sort(obj.ParamPositions, "ascend");
            obj.FuncInputArgElemList = obj.FuncInputArgElemList(sortIdx);
            obj.FuncInputArgLabels = obj.FuncInputArgLabels(sortIdx);

            % Create "Execute" button and setup UI element event callback
            % handler.
            obj.View.createExecuteButton(executeButtonPos);
            obj.View.setupEvents("Function");

            function flag = propertyToBeIgnored(~, paramPos)
                % Ignore "Status" and "Vi" related input and output
                % arguments. paramPos <= 0 for "Status" and "Vi".
                flag = paramPos <= 0;
            end

            function uiElementType = convertDropDownToEditableDropDown(obj, uiElementType, enumValues, tag)
                % For a dropdown that does not have associated enum
                % values, instead create an editable dropdown.
                % The dropdown should not be an "AttributeID" input
                % argument drop-down to begin with.
                if uiElementType == "Dropdown" && ~obj.isAttributeID(tag) && isempty(enumValues)
                    uiElementType = "EditableDropDown";
                end
            end
        end

        function getDataTypeInfo(obj, param, uiElement)
            % Save information related to datatype of the function
            % input argument.

            dataType = getFuncArgDataType(obj.MetaDataAdapter, param);

            if isempty(dataType)
                return
            end

            % Save data type information for function input argument.
            storeDataTypeInfo(obj, dataType, uiElement, string(uiElement.Tag));
        end

        function storeDataTypeInfo(~, dataType, uiElement, fieldName)
            % Save data type information for UI element specified.

            % Create a tooltip message to be displayed for the user
            % that will inform them about the datatype of the specified
            % UI element.
            dataType = ividev.makeMATLABDriver.internal.ivi2mlcasttype(dataType);
            uiElement.Tooltip = message("ividevapp:ividevapp:FunctionPropertyEditFieldTooltip", fieldName, dataType).string;

            % Save the dataype in UserData to be used later once the
            % function/property is executed.
            % Saved datatype is used to validate data entered for
            % function/property fields in validateDataTypeInfo function.
            uiElement.UserData.DataType = dataType;

            if dataType == "string"
                return
            end

            % Set the max and min value for different numeric
            % datatypes.
            if any(dataType == ["single", "double"])
                uiElement.UserData.MaxValue = realmax(dataType);
                uiElement.UserData.MinValue = 0;
            else
                uiElement.UserData.MaxValue = intmax(dataType);
                uiElement.UserData.MinValue = intmin(dataType);
            end
        end

        function resetUIProperties(obj)
            % Clears any function or property related UI element properties
            % that were set previously when a different function or
            % property was selected.
            obj.EditableDropdownElemList = {};
            obj.FuncInputArgElemList = {};
            obj.FuncInputArgLabels = [];
            obj.ParamPositions = [];
            obj.OutputCounter = 0;
            obj.PropSetterElem = [];
        end

        function createPropertyView(obj, node)
            % Display property panel with get/set options as specified by
            % the node's access mode, along with separate run buttons for
            % getting/setting.

            resetUIProperties(obj);
            obj.SelectedPropertyNode = node;

            % Creates grid layout for Property in the actions tab.
            obj.View.createControlPanelGrid("Property");

            % Set property name in actions tab
            obj.View.createLabel(1, obj.SelectedPropertyNode.NodeData.Name, [2 3], "bold");

            % Get repeated capability values for the selected property if
            % any exist.
            repcaps = string.empty;
            for k = string(obj.RepCapMap.keys)
                for prop = obj.RepCapMap(k)
                    if doesSelectedPropUseRepCap(obj, prop)
                        % Add repcap value to repcap list only if:
                        % 1) Selected property name is present as a value
                        % in the repcap to property node map.
                        % 2) And if the parent of the selected property
                        % is same as the parent of the map value (prop node)
                        % that matched in 1).

                        repcaps(end+1) = k; %#ok<AGROW>
                        break
                    end
                end
            end

            % Create drop-down list of repeated capability values if any.
            if ~isempty(repcaps)
                % The repeated capability values drop-down is always
                % created in the second row if there are any repeated
                % capability values.
                row = 2;
                dropDown = obj.View.createRepCap(row, repcaps);
                obj.SelectedRepCapID = dropDown.Value;
                dropDown.ValueChangedFcn = @(dropDown, event) repCapSelectedFcn(obj, dropDown);
                currentRow = row;
            else
                % If repeated capability values are not present, then
                % repeated capability values drop-down will not be created
                % at any later position (can only created on row 2).
                % The other input arguments should then be created starting
                % at row 2.
                currentRow = 1;
            end

            % Check if property is of boolean type
            dataType = node.NodeData.VisaType;
            isbool = dataType == "ViBoolean";

            % Returns enum values for selected property.
            enums = getEnumPropValues(obj, node);

            % Get the access type of the property - "gs", "g", or "s".
            % Create UI elements based on the access type.
            accessMode = node.NodeData.AccessType;
            switch accessMode
                case "gs"
                    getterRow = currentRow + 1;
                    setterRow = currentRow + 2;
                    if isempty(enums)
                        setterType = obj.SetterUIElemLookUp(isbool);
                    else
                        setterType = "enum";
                    end
                    obj.PropSetterElem = obj.View.createSetter(setterRow, setterType, enums);
                    obj.View.createGetter(getterRow);
                case "g"
                    getterRow = currentRow + 1;
                    obj.View.createGetter(getterRow);
                case "s"
                    setterRow = currentRow + 1;
                    if isempty(enums)
                        setterType = obj.SetterUIElemLookUp(isbool);
                    else
                        setterType = "enum";
                    end
                    obj.PropSetterElem = obj.View.createSetter(setterRow, setterType, enums);
            end

            % If there is a setter field and it is an editable drop-down then add
            % it to the EditableDropdownElemList and add datatype information about
            % the setter.
            if ~isempty(obj.PropSetterElem) && obj.PropSetterElem.Type == "uidropdown" && obj.PropSetterElem.Editable == "on"
                obj.EditableDropdownElemList{end+1} = obj.PropSetterElem;

                % Save data type information for property.
                storeDataTypeInfo(obj, dataType, obj.PropSetterElem, string(obj.SelectedPropertyNode.NodeData.Name));
            end

            % Setup UI element event callback handler.
            obj.View.setupEvents(accessMode);

            %% NESTED FUNCTIONS
            function flag = doesSelectedPropUseRepCap(obj, prop)
                % Return true if:
                % 1) Selected property name is present as a value
                % in the repcap to property node map.
                % 2) And if the parent of the selected property
                % is same as the parent of the map value (prop node)
                % that matched in 1).
                flag = prop.AttributeName == obj.SelectedPropertyNode.NodeData.Name && ...
                    prop.Parent == obj.SelectedPropertyNode.NodeData.ParentNodeName;
            end

            function enums = getEnumPropValues(obj, node)
                % Returns enum values for selected property.

                % Get all parents of the selected property node until the
                % "Properties" root node but not including it.
                parents = "";
                tempNode = node;
                while tempNode.Parent.Text ~= "Properties"
                    parents = tempNode.Parent.NodeData.Name + "." + parents;
                    tempNode = tempNode.Parent;
                end

                % Get enum values for selected property.
                [~, enums] = enumeration("ividev." + obj.MetaDataAdapter.getDriverName + ".enums." + parents + node.NodeData.Name);
                enums = string(enums)';
            end
        end

        function repCapSelectedFcn(obj, src, ~)
            % Handler that gets called when a repeated capability value is
            % selected for a property or for a attribute accessor function.
            obj.SelectedRepCapID = src.Value;
        end

        function populateDropdownForAttributeIDs(obj)
            % Updates the AttributeID drop-down field with the Attribute
            % IDs for the selected function if Attribute IDs are not empty.

            % If there is no AttributeID drop-down field then return
            if numel(obj.FuncInputArgElemList) <= 1
                return
            end

            % AttributeID drop-down field will always be the second UI
            % element after the Repeated Capability dropdown for the
            % selected Attribute Accessor function.
            if obj.isAttributeID(obj.FuncInputArgElemList{2}.Tag)
                if ~isempty(obj.AttributeIDs)
                    obj.FuncInputArgElemList{2}.Items = obj.AttributeIDs;
                end
            end
        end

        function attributeIDs = getAttributeIDs(obj)
            % Obtain the AttributeIDs corresponding to the selected
            % function.

            attributeIDs = string.empty;

            % Get the VISAType from the Attribute Accessor function name
            % and add AttributeIDs based on VISAType corresponding to
            % the selected function.
            type = extractAfter(obj.SelectedFunction, "Attribute");

            % Attribute ID information is present in property nodes that
            % have repeated capability values. The VISAType for the
            % property nodes (that have repeated capability values) is
            % compared to the VISAType from the Attribute Accessor
            % function and Attribute IDs are added for only the matching
            % VISAType.
            for k = string(obj.RepCapMap.keys)
                nodes = obj.RepCapMap(k);

                for node = nodes
                    if node.VISAType ~= type
                        continue
                    end

                    % Truncate AttributeConstNames that are
                    % longer than 63 characters.
                    if strlength(node.AttributeConstName) > obj.AttributeConstNameMaxLength
                        attributeConstName = extractBefore(node.AttributeConstName, obj.AttributeConstNameMaxLength + 1);
                    else
                        attributeConstName = node.AttributeConstName;
                    end
                    attributeIDs(end+1) = attributeConstName; %#ok<AGROW>
                end
            end

            attributeIDs = unique(attributeIDs);
        end

        function flag = isAttributeID(~, text)
            % Check if input argument name is "AttributeID".
            flag = replace(text, string(blanks(1)), string) == "AttributeID";
        end

        function setupWorkspaceVariableList(obj)
            % Gets all workspace variables, parses these variables to get
            % their type and adds them to the WorkspaceVariableList
            % property if they have a valid type (numeric or ASCII).
            % Also populates the editable drop-down list in the selected
            % function or property with the valid workspace variables.

            import matlabshared.transportapp.internal.utilities.WorkspaceVariableHandler

            % Get all workspace variables
            allVariables = WorkspaceVariableHandler.getWorkspaceVariableNames();

            % Get the variable names and associated types for the workspace
            % variables.
            parsedVariableList = WorkspaceVariableHandler.parse(allVariables);

            obj.resetWorkspaceVariableList();

            % Populate the WorkspaceVariableList property with valid
            % variable names.
            obj.populateWorkspaceVariableList(parsedVariableList);

            % Set the editable drop-down fields list using the
            % WorkspaceVariableList values for the selected function or property.
            % Update the current value of the editable drop-down fields for
            % the selected function or property.
            obj.setEditableDropDownWorkspaceVariableList();
            obj.setEditableDropDownValue();
        end

        function resetWorkspaceVariableList(obj)
            % Clear the WorkspaceVariableList property. This is needed
            % before re-populating the property with new values.
            obj.WorkspaceVariableList = string.empty;
        end

        function populateWorkspaceVariableList(obj, varList)
            % Populate the WorkspaceVariableList property with a list of
            % valid variable names.

            arguments
                obj
                varList matlabshared.transportapp.internal.utilities.forms.WorkspaceVariableInfo
            end

            import matlabshared.transportapp.internal.utilities.forms.WorkspaceTypeEnum
            for var = varList
                if any(var.Type == [WorkspaceTypeEnum.Numeric, WorkspaceTypeEnum.String, WorkspaceTypeEnum.Char])
                    obj.WorkspaceVariableList(end+1) = var.Name;
                end
            end
        end

        function setEditableDropDownWorkspaceVariableList(obj)
            % Populates the editable drop-down items list in the selected
            % function or property with the valid workspace variables.

            obj.LatestWorkspaceVariable = string.empty;

            % Create the LatestWorkspaceVariable list by populating with
            % current values of the editable drop-down fields.
            % Add the variables in the WorkspaceVariableList as items
            % in the editable drop-down fields for the selected
            % function or property.
            for i = 1:length(obj.EditableDropdownElemList)
                obj.LatestWorkspaceVariable(end+1) = obj.EditableDropdownElemList{i}.Value;
                obj.EditableDropdownElemList{i}.Items = {''};

                for item = obj.WorkspaceVariableList
                    obj.EditableDropdownElemList{i}.Items(end+1) = {char(item)};
                end
            end
        end

        function setEditableDropDownValue(obj)
            % Sets the value for the editable drop-down fields for the
            % selected function or property.

            % If the WorkspaceVariableList is empty, then set the editable
            % drop-down value to the edit field value if one is present.
            % Otherwise the editable drop-down value will be empty - "".
            if isempty(obj.WorkspaceVariableList)
                for i = 1:length(obj.EditableDropdownElemList)
                    if ~isempty(obj.EditFieldVal)
                        obj.EditableDropdownElemList{i}.Value = obj.EditFieldVal(i);
                    else
                        obj.EditableDropdownElemList{i}.Value = "";
                    end
                end
                return
            end

            % If the WorkspaceVariableList is not empty and
            % LatestWorkspaceVariable is a valid workspace variable, then
            % set the editable drop-down value to
            % LatestWorkspaceVariable.
            % Otherwise set the editable drop-down value to the value of
            % the edit field if one is present.
            % Otherwise the editable drop-down value will be empty - "".
            for i = 1:length(obj.EditableDropdownElemList)
                obj.EditableDropdownElemList{i}.Value = "";

                if ismember(obj.LatestWorkspaceVariable(i), obj.WorkspaceVariableList)
                    obj.EditableDropdownElemList{i}.Value = obj.LatestWorkspaceVariable(i);
                else
                    if ~isempty(obj.EditFieldVal) && obj.EditFieldVal(i) ~= ""
                        obj.EditableDropdownElemList{i}.Value = obj.EditFieldVal(i);
                    end
                end
            end
        end

        function removeValueFromWorkspaceVariableList(obj, variableNamesToRemove)
            % Remove the given variableNames from the WorkspaceVariableList

            if isempty(obj.WorkspaceVariableList)
                return
            end

            variableNamesToRemove = sort(variableNamesToRemove);
            values = obj.WorkspaceVariableList;

            % Find all indices of values that contain variableNamesToRemove
            [~, idx] = intersect(values, variableNamesToRemove);

            % Return if no matching names found.
            if isempty(idx)
                return
            end

            % Remove the indices from the values and update WorkspaceVariableList
            % with the updated values.
            values(idx') = [];
            obj.WorkspaceVariableList = values;
        end
    end

    %% Private Helper Functions
    methods (Access = private)
        function setupListeners(obj)
            obj.ViewListeners(end+1) = listener(obj.View, "ExecuteFunction", ...
                @(src, evt)obj.executeFcnPanel(src, evt));

            obj.ViewListeners(end+1) = listener(obj.View, "GetPropValue", ...
                @(src, evt)obj.executePropPanelGet(src, evt));

            obj.ViewListeners(end+1) = listener(obj.View, "SetPropValue", ...
                @(src, evt)obj.executePropPanelSet(src, evt));
        end
    end

    %% Getters and setters
    methods
        function value = get.View(obj)
            value = obj.ViewConfiguration.View;
        end
    end
end
