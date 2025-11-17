classdef CodeLogGenerator < matlabshared.mediator.internal.Publisher & ...
        matlabshared.mediator.internal.Subscriber
    %CODELOGGENERATOR displays the MATLAB code associated with executing
    % the selected function or getting/setting the selected property.
    % It is also responsible for exporting Code log text as a live script
    % to MATLAB.

    % Copyright 2023 The MathWorks, Inc.

    properties
        SharedAppCodeLogGenerator
    end

    properties (SetObservable)
        % true - means export code operation is starting
        % false - means export code operation has completed or not begun
        ExportCodeStatusBar (1, 1) logical = false
    end

    properties (Constant)
        % Overriding default value of 90 in matlabshared.transportapp.internal.utilities.MATLABCodeGenerator
        CommentLength (1, 1) double = 75
        
        AppName (1, 1) string = message("ividevapp:ividevapp:AppDisplayName").string
        InterfaceName (1, 1) string = message("ividevapp:ividevapp:InterfaceName").string
        InterfaceObj (1, 1) string = message("ividevapp:ividevapp:InterfaceObject").string
    end

    %% Lifetime
    methods
        function obj = CodeLogGenerator(mediator)
            arguments
                mediator (1, 1) matlabshared.mediator.internal.Mediator
            end

            obj@matlabshared.mediator.internal.Publisher(mediator);
            obj@matlabshared.mediator.internal.Subscriber(mediator);
            obj.SharedAppCodeLogGenerator = matlabshared.transportapp.internal.utilities.MATLABCodeGenerator(mediator, obj.AppName, obj.InterfaceName, obj.InterfaceObj);
            obj.SharedAppCodeLogGenerator.CodeLinesIndented = true;
        end
    end

    %% API
    methods
        function connect(obj, constructorCode, constructorComment)
            % Delegate adding the constructor comment and constructor code
            % in the Code Log to SharedAppCodeLogGenerator.
            obj.SharedAppCodeLogGenerator.connect(constructorComment, constructorCode, obj.CommentLength);
        end

        function disconnect(obj)
            obj.SharedAppCodeLogGenerator.disconnect();
        end
    end

    %% Implementing Subscriber Abstract methods
    methods
        function subscribeToMediatorProperties(obj, ~, ~)
            obj.subscribe("ExportMATLABCodeLog", ...
                @(src, event)obj.exportCodeLogPressed());

            obj.subscribe("CodeLogInfo", ...
                @(src, event)obj.updateCodeLog(event.AffectedObject.CodeLogInfo));
        end
    end

    %% Subscriber Handler Functions
    methods (Access = ?matlabshared.transportapp.internal.utilities.ITestable)
        function exportCodeLogPressed(obj)
            % Handler for when the user pushes the "Export Code Log"
            % button.

            % Set ExportCodeStatusBar to true to indicate that operation is
            % starting. This will be used when making status bar text
            % updates.
            obj.ExportCodeStatusBar = true;

            % Delegate the export MATLAB code operation to the
            % SharedAppCodeLogGenerator.
            obj.SharedAppCodeLogGenerator.exportMATLABScript();

            % Set ExportCodeStatusBar to false to indicate that operation has
            % completed. This will be used when making status bar text
            % updates.
            obj.ExportCodeStatusBar = false;
        end

        function updateCodeLog(obj, src)
            % Updates the code log whenever the user executes a function
            % or gets/sets a property.

            comment = src(1);
            code = src(2);
            obj.SharedAppCodeLogGenerator.addComment(comment);
            obj.SharedAppCodeLogGenerator.addCode(code);
            obj.SharedAppCodeLogGenerator.addNewLine();
        end
    end
end
