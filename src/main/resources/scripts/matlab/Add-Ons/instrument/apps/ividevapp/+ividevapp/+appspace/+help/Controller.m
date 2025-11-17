classdef Controller < matlabshared.mediator.internal.Subscriber
    %CONTROLLER is the Appspace Help Controller Class. It contains business
    % logic to retrieve the help text to be shown in the Help Panel when
    % the user selects a particular function/property in the dropdown.

    % Copyright 2023-2024 The MathWorks, Inc.

    properties (Dependent)
        UITextArea
    end

    properties
        ViewConfiguration
        MetaDataAdapter
        EditorExampleManager
        IvidevConstructorCode
        SideFigPanel (1, 1) matlab.ui.internal.FigurePanel
        SideFigPanelShowingListener = event.listener.empty
        SelectedTreeNode

        % Flag that keeps track of the last state of the Showing property
        % for the SideFigPanel.
        % true - SideFigPanel was expanded before.
        % false - SideFigPanel was collapsed before.
        LastShowing (1, 1) logical = false
    end

    properties (Constant)
        FunctionExampleHeader = message("ividevapp:ividevapp:FunctionExampleHeader").string
        PropertyExampleHeader = message("ividevapp:ividevapp:PropertyExampleHeader").string
    end

    %% Lifetime
    methods
        function obj = Controller(mediator, viewConfiguration)
            arguments
                mediator matlabshared.mediator.internal.Mediator
                viewConfiguration matlabshared.transportapp.internal.utilities.viewconfiguration.IViewConfiguration
            end

            obj@matlabshared.mediator.internal.Subscriber(mediator);
            obj.ViewConfiguration = viewConfiguration;

            % Create EditorManager instance to display the function and
            % property ividev examples within the Driver Help Side Panel.
            setUpEditorExampleManager(obj);
        end
        
        function disconnect(obj)
            obj.EditorExampleManager = ...
                matlabshared.testmeasapps.internal.plaintexteditor.EditorManager.empty;
            ividevapp.appspace.help.Controller.getEditorExampleManager([], true);
        end

        function delete(obj)
            delete(obj.SideFigPanelShowingListener);
        end
    end

    %% Implement matlabshared.mediator.internal.Subscriber abstract methods
    methods
        function subscribeToMediatorProperties(obj, ~, ~)
            obj.subscribe("SelectedNode", ...
                @(src, event)obj.updateHelp(event.AffectedObject.SelectedNode));
        end
    end

    %% Subscriber Handler Functions
    methods
        function updateHelp(obj, node, ~)
            % Re-create the EditorExampleManager only if the SideFigPanel
            % was not expanded before and is expanded now.
            if obj.LastShowing == false
                setUpEditorExampleManager(obj);
            end

            % Handler that is invoked when a user selects a new function or
            % property node in the "Functions/Properties" drop-down.

            % Help text display should be blank if the selected node is the
            % "Functions" or "Properties" header.
            if node.Text == "Functions" || node.Text == "Properties"
                setViewProperty(obj.ViewConfiguration, "UITextArea", "Value", "");
                return
            end

            % Get help text for valid node selected.
            nodeType = node.NodeData.Type;
            if nodeType == "Function"
                helpText = obj.getFunctionHelp(node.NodeData);
            elseif nodeType == "Property"
                helpText = obj.getPropertyHelp(node.NodeData);
            end

            % Update the view with the help text string.
            setViewProperty(obj.ViewConfiguration, "UITextArea", "Value", helpText);
            obj.SelectedTreeNode = node;
        end

        function propertyChangeCallback(obj, ~, ~)
            % Re-create the content in the Side Panel if the SideFigPanel
            % is expanded and a valid node has been selected in the
            % Functions/Properties tree.
            if obj.SideFigPanel.Showing == true && ~isempty(obj.SelectedTreeNode)
                updateHelp(obj, obj.SelectedTreeNode);
            end
            obj.LastShowing = obj.SideFigPanel.Showing;
        end
    end

    %% Helper Functions
    methods (Access = ?matlabshared.transportapp.internal.utilities.ITestable)
        function setUpEditorExampleManager(obj)
            % Create EditorManager instance to display the function and
            % property ividev examples within the Driver Help Side Panel.
            obj.EditorExampleManager = matlabshared.testmeasapps.internal.plaintexteditor.EditorManager();
            ividevapp.appspace.help.Controller.getEditorExampleManager(obj.EditorExampleManager, true);
            obj.EditorExampleManager.CommentLength = 90;
            obj.EditorExampleManager.setEditorReadOnly(true);
            setViewProperty(obj.ViewConfiguration, "ExampleUIHTMLHandle", "HTMLSource", obj.EditorExampleManager.URL);
        end

        function help = getFunctionHelp(obj, nodeData)
            % Get the function or function group help text.

            index = nodeData.Index;

            % If the selected function does not have any children then get
            % the function help otherwise get the function group help
            % directly from the meta data.
            if functionHasNoChild(obj.MetaDataAdapter, index)
                help = getFunctionNodeHelp(obj, index);
            else
                help = getFunctionGroupHelp(obj.MetaDataAdapter, index);

                % Clear the EditorManager display for a function group.
                obj.EditorExampleManager.clearText();
            end

            function funcHelp = getFunctionNodeHelp(obj, index)
                % Get the function help text along with the help text for
                % each function argument.

                % Create the function help text string to be displayed in the
                % Help Panel.
                funcHelp = getFunctionHelp(obj.MetaDataAdapter, index) + repmat(newline, 1, 3);

                for funcArg = getFunctionArguments(obj.MetaDataAdapter, index)

                    % Display name and help text for all function arguments
                    % except "Vi" and "Status".
                    if getFuncArgPosition(obj.MetaDataAdapter, funcArg) > 0
                        name = getFuncArgName(obj.MetaDataAdapter, funcArg);
                        helpText = getFuncArgHelp(obj.MetaDataAdapter, funcArg);
                        funcHelp = funcHelp + name + ": " + helpText + repmat(newline, 1, 2);
                    end
                end

                % If there is any relevant ividev example for the selected
                % function, then add it to the EditorManager display.
                setExampleHelp(obj, @getFunctionMatlabExamples, index, obj.FunctionExampleHeader);
            end
        end

        function help = getPropertyHelp(obj, nodeData)
            % Get the property help text.
            help = nodeData.Help;

            % If there is any relevant ividev example for the selected
            % property, then add it to the EditorManager display.
            setExampleHelp(obj, @getAttributeIdentifierExamples, nodeData, obj.PropertyExampleHeader);
        end

        function setExampleHelp(obj, getExampleFcn, getExampleFcnInput, sectionHeader)
            % Adds the example description, code and comments for the
            % selected function or property to the EditorManager example
            % display within the Driver Help side panel.

            arguments
                obj 
                getExampleFcn
                getExampleFcnInput
                sectionHeader (1, 1) string
            end

            % Clear the EditorManager display before adding example for a
            % new function or property.
            obj.EditorExampleManager.clearText();

            % Retrieve the example code and corresponding description from
            % the MetaDataAdapter.
            [exampleDescription, examples] = getExampleFcn(obj.MetaDataAdapter, getExampleFcnInput);

            if isempty(examples)
                return
            end

            obj.EditorExampleManager.addSectionHeader(sectionHeader);

            % Iterate and add code for all relevant examples for the
            % selected function or property to the EditorManager display.
            for i = 1 : numel(examples)
                % Add an example title and description before adding the
                % code to the display.
                obj.EditorExampleManager.addNewLine();
                obj.EditorExampleManager.addComment(message("ividevapp:ividevapp:ExampleDescriptionPrefix", exampleDescription(i)).string);

                % Add code to the display.
                ividevPattern = "dev = ividev(";
                matlabDriverHelpLines = split(examples(i), newline);
                for matlabDriverHelpLine = matlabDriverHelpLines'
                    code = matlabDriverHelpLine;
                    if contains(code, ividevPattern)
                        leadingWhiteSpaces = extractBefore(code, ividevPattern);
                        code = leadingWhiteSpaces + obj.IvidevConstructorCode;
                    end
                    obj.EditorExampleManager.addCodeWithoutSemicolon(code);
                end
            end
        end
    end

    %% API
    methods
        function setSideFigPanel(obj, sideFigPanel)
            obj.SideFigPanel = sideFigPanel;
            obj.SideFigPanelShowingListener = listener(obj.SideFigPanel, "PropertyChanged", @(src, evt)propertyChangeCallback(obj, src, evt));
        end
    end

    %% Getters and setters
    methods
        function value = get.UITextArea(obj)
            value = getViewProperty(obj.ViewConfiguration, "UITextArea", "Value");
        end

        function setIvidevConstructorCode(obj, code)
            obj.IvidevConstructorCode = code;
        end

    end

    methods (Static)
        function val = getEditorExampleManager(em, clearVal)
            % This function has the following capabilities:
            % Caches EditorExampleManager instance to persistent variable.
            % Clears EditorExampleManager instance to persistent variable.
            % Returns saved EditorExampleManager instance when requested (if not empty)

            arguments
                em = []
                clearVal (1, 1) logical = false
            end
            persistent editorExampleManager

            if clearVal
                editorExampleManager = [];
            end
            if isempty(editorExampleManager)
                editorExampleManager = em;
            end
            val = editorExampleManager;
        end
    end
end
