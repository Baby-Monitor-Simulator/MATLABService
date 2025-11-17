classdef Controller < matlabshared.testmeasapps.internal.dialoghandler.DialogSource & ...
        matlabshared.transportapp.internal.utilities.ITestable
    %CONTROLLER is the Toolstrip Help Controller class. It contains
    % business logic for operations that need to be performed when the user
    % interacts with the View elements.

    % Copyright 2024 The MathWorks, Inc.

    properties (Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        % The handle to the ViewConfiguration instance containing the View.
        ViewConfiguration

        ViewListeners = event.listener.empty

        VendorDriverName
    end

    properties (Dependent)
        View
    end

    properties (Constant)
        IVIDriverPath = fullfile("C:", "Program Files", "IVI Foundation", "IVI", "Drivers")
        VISADriverPath = fullfile("C:", "Program Files", "IVI Foundation", "VISA", "Win64")
    end

    %% Lifetime
    methods
        function obj = Controller(mediator, viewConfiguration)
            arguments
                mediator (1, 1) matlabshared.mediator.internal.Mediator
                viewConfiguration (1, 1) matlabshared.transportapp.internal.utilities.viewconfiguration.IViewConfiguration
            end

            obj@matlabshared.testmeasapps.internal.dialoghandler.DialogSource(mediator);
            obj.ViewConfiguration = viewConfiguration;

            % Only for production mode
            if isa(obj.ViewConfiguration, ...
                    "matlabshared.transportapp.internal.utilities.viewconfiguration.ViewConfiguration")
                obj.setupListeners();
            end
        end

        function delete(obj)
            delete(obj.ViewListeners);
        end
    end

    %% Listener Handler Functions
    methods
        function handleButtonPressed(obj, ~, ~)
            % Handler for when the user presses the "Driver Documentation"
            % button.

            cleanup = onCleanup(@()obj.reEnableButton());
            obj.ViewConfiguration.setViewProperty("DriverDocButton", "Enabled", false);

            % Attempt to launch documentation for driver from IVI location first.
            fileFound = launchDriverDocFileinIVILocation(obj);

            if ~fileFound
                % Attempt to launch documentation for driver from VISA location
                % next, if it was not found in IVI location.
                launchDriverDocFileinVisaLocation(obj);
            end

            %% NESTED FUNCTIONS
            function fileFound = launchDriverDocFileinIVILocation(obj)
                % Attempt to launch documentation for driver from IVI location.
                fileFound = false;
                folderPath = fullfile(obj.IVIDriverPath, obj.VendorDriverName);
                files = dir(fullfile(folderPath, '*.chm'));

                % Attempt to open file if it was found.
                if isempty(files)
                    return
                end

                try
                    for file = files'
                        winopen(fullfile(file.folder, file.name));
                    end
                    fileFound = true;
                catch
                    fileFound = false;
                end
            end

            function launchDriverDocFileinVisaLocation(obj)
                % Attempt to launch documentation for driver from VISA
                % location (needed for VXIPnP drivers), if it was not found
                % in IVI location.
                folderPath = fullfile(obj.VISADriverPath, obj.VendorDriverName);
                files = dir(fullfile(folderPath, '*.chm'));

                if isempty(files)
                    ex = MException(message("ividevapp:ividevapp:DriverDocLaunchError"));
                    obj.showErrorDialog(ex);
                end

                try
                    for file = files'
                        winopen(fullfile(file.folder, file.name));
                    end
                catch
                    ex = MException(message("ividevapp:ividevapp:DriverDocLaunchError"));
                    obj.showErrorDialog(ex);
                end
            end
        end
    end

    %% Helper Functions
    methods (Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        function setupListeners(obj)
            obj.ViewListeners(end+1) = listener(obj.View, "DriverDocButtonPressed", ...
                @(src, evt)obj.handleButtonPressed(src, evt));
        end

        function reEnableButton(obj)
            obj.ViewConfiguration.setViewProperty("DriverDocButton", "Enabled", true);
        end
    end

    %% Getters and setters
    methods
        function value = get.View(obj)
            value = obj.ViewConfiguration.View;
        end

        function setVendorDriver(obj, vendorDriver)
            obj.VendorDriverName = vendorDriver;
        end
    end
end