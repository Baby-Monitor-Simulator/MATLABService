classdef IvidevIdentification < handle
    % IVIDEVIDENTIFICATION class provides functions for filling information
    % for hardware manager ividevapp device cards.

    % Copyright 2023-2024 The MathWorks, Inc.

    properties (Access = private)
        IvidevObj
        DeviceCardDriverName
    end

    properties (Constant)
        DeviceCardIcon = matlabshared.testmeasapps.internal.themeableiconrepository.IconRepository.getIcon("hwmgrclient", ...
            "VisaDeviceCard")
    end

    methods
        function setDeviceCardDriverName(obj, driver)
            obj.DeviceCardDriverName = driver;
        end

        function form = identify(obj, paramStr, logicalName, nvPair)
            % Attempts to create an ividev object and fills ividev object
            % information in a form if connection is successful.
            % If connection is unsuccessful, only error is returned in
            % form.

            arguments
                obj
                paramStr (1, 1) string
                logicalName
                nvPair
            end

            cleanup = onCleanup(@obj.cleanupIvi);
            form.Params = paramStr;

            try
                obj.IvidevObj = eval("ividev(" + paramStr + ")");
                form.Error = [];
            catch ex
                % Set the error exception in the form if any parameter
                % value is invalid.
                msg = message("ividevapp:ividevapp:IvidevConnectionError").string + ...
                    newline + newline + "Additional information: " + newline + ex.message;
                newEx = MException(ex.identifier, msg);
                form.Error = newEx;
                return
            end

            form.Manufacturer = upper(string(obj.IvidevObj.Manufacturer));
            form.Model = string(obj.IvidevObj.Model);
            form.ResourceName = string(obj.IvidevObj.ResourceName);
            form.VendorDriver = string(obj.IvidevObj.VendorDriver);
            form.SerialNumber = string(obj.IvidevObj.SerialNumber);
            form.Simulate = obj.IvidevObj.Simulate;
            form.LogicalName = logicalName;
            form.NVPairsChanged = nvPair;
        end

        function cleanupIvi(obj)
            obj.IvidevObj = [];
        end
    end

    %% Hardware Manager Device Identification
    methods
        function hwmgrDevice = getHwMgrDevice(obj, deviceInfo)
            % Create a hardware manager device instance from the input
            % device information.

            % Set DeviceCard title.
            deviceCardTitle = getDeviceCardTitle(obj, deviceInfo);
            hwmgrDevice = matlab.hwmgr.internal.Device(deviceCardTitle);

            % Set DeviceCard info.
            hwmgrDevice.DeviceCardDisplayInfo = getDeviceCardDetails(obj, deviceInfo);

            [iconFieldName, icon] = matlab.hwmgr.internal.data.plugins.InstrumentExplorerDataPlugin.getIconDetails("DeviceCardOrAppletDataIcon", obj.DeviceCardIcon);
            hwmgrDevice.(iconFieldName) = icon;
            hwmgrDevice.DeviceAppletData = matlab.hwmgr.internal.data.DataFactory.createDeviceAppletData("ividevapp.IvidevApp", "IC");

            % deviceInfo.VendorDriver can be "" when the ividev object used
            % to get this information does not return any driver
            % information.
            % Noticed this for a simulated ividev object created for
            % "rsrtx" driver in the identify() function.
            if deviceInfo.VendorDriver == ""
                hwmgrDevice.CustomData.VendorDriver = obj.DeviceCardDriverName;
            else
                hwmgrDevice.CustomData.VendorDriver = deviceInfo.VendorDriver;
            end

            hwmgrDevice.CustomData.DeviceCardDriverName = obj.DeviceCardDriverName;
            hwmgrDevice.CustomData.Params = deviceInfo.Params;
            hwmgrDevice.CustomData.ResourceName = deviceInfo.ResourceName;
            hwmgrDevice.CustomData.NVPairsChanged = deviceInfo.NVPairsChanged;

            if ~isempty(deviceInfo.LogicalName)
                hwmgrDevice.CustomData.LogicalName = deviceInfo.LogicalName;
            end
        end
    end

    %% Private Helper Functions
    methods (Access = ?matlabshared.transportapp.internal.utilities.ITestable)
        function deviceCardTitle = getDeviceCardTitle(~, deviceInfo)
            % Get the device card title.

            if deviceInfo.Manufacturer ~= ""
                deviceCardTitle = deviceInfo.Model + blanks(1) + deviceInfo.Manufacturer;
            else
                deviceCardTitle = deviceInfo.Model;
            end
        end

        function deviceCardDetails = getDeviceCardDetails(obj, deviceInfo)
            % Get the device card contents.

            deviceCardFirstRowDetails = [message("ividevapp:ividevapp:Resource").string, string(deviceInfo.ResourceName)];

            if deviceInfo.SerialNumber ~= ""
                deviceCardSecondRowDetails = [message("ividevapp:ividevapp:SerialNumber").string, deviceInfo.SerialNumber];
            else
                deviceCardSecondRowDetails = [];
            end

            deviceCardThirdRowDetails = [message("ividevapp:ividevapp:Driver").string, string(obj.DeviceCardDriverName)];

            deviceCardForthRowDetails = [];
            if deviceInfo.Simulate
                deviceCardForthRowDetails = [message("ividevapp:ividevapp:Simulate").string, "true"];
            end

            deviceCardDetails = [ ...
                deviceCardFirstRowDetails; ...
                deviceCardSecondRowDetails; ...
                deviceCardThirdRowDetails; ...
                deviceCardForthRowDetails];
        end
    end
end
