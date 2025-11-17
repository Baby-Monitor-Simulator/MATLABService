classdef VisadevIdentification < handle
    % VISADEVIDENTIFICATION class provides utility functions for
    % identifying visa resources and creating hardware manager visadev
    % devices for valid visadev resources.

    % Copyright 2022-2023 The MathWorks, Inc.

    properties
        VisadevObj
    end

    properties (Constant)
        DeviceCardIcon = matlabshared.testmeasapps.internal.themeableiconrepository.IconRepository.getIcon("hwmgrclient", ...
            "VisaDeviceCard")
        VisadevTimeoutValue = 5 % in seconds
    end

    methods
        function id = identify(obj, resourceString, identificationStr, identificationDelimiter)
            % Attempts a visadev connection to the "resourceString". If
            % connection is successful, attempts to do an identification
            % query using the "identificationStr".
            % Returns the output in a ConnectionIdentificationForm object.

            arguments
                obj
                resourceString (1, 1) string
                identificationStr (1, 1) string = "*IDN?"
                identificationDelimiter (1, 1) string = ","
            end
            cleanup = onCleanup(@obj.cleanupVisa);

            id = matlabshared.transportapp.internal.visamodaldialog.ConnectionIdentificationForm;
            id.ResourceName = resourceString;
            id.Identification = identificationStr;
            try
                obj.VisadevObj = visadev(resourceString);
                obj.VisadevObj.Timeout = transportapp.visadev.internal.VisadevIdentification.VisadevTimeoutValue;
            catch ex
                msg = ex.message;
                msg = obj.extractAppErrorMsg(msg);
                newEx = MException(ex.identifier, msg);
                id.Error = newEx;
                return
            end

            id.Type = string(obj.VisadevObj.Type);
            try
                id.IdentificationResponse = writeread(obj.VisadevObj, identificationStr);
            catch
                return
            end

            % Extract model and vendor information from the query
            % identification response.
            parts = split(id.IdentificationResponse, identificationDelimiter);

            % This can be the case for a loop back device that just echoes
            % back the identificationStr.
            if length(parts) < 2
                return
            end

            id.Vendor = parts(1);
            id.Model = parts(2);
        end

        function cleanupVisa(obj)
            obj.VisadevObj = [];
        end

        function msg = extractAppErrorMsg(~, msg)
            % Removes the "See related documentation" error link from the
            % visadev connection error message, and returns the updated
            % error message.

            arguments
                ~
                msg (1, 1) string
            end

            % Find all instances of newline.
            idx = strfind(msg, newline);

            if isempty(idx)
                return
            end

            % To remove the "See related documentation" line, use the last
            % idx value.
            msg = extractBefore(msg, idx(end));
        end
    end

    %% Dialog Generation
    methods (Static)
        function resourceString = getVXI11ResourceString(form)
            arguments
                form (1, 1) matlabshared.transportapp.internal.visamodaldialog.ResourceStringForm
            end

            resourceString = sprintf("TCPIP%s::%s::inst%s::INSTR", ...
                form.BoardNumber, ...
                form.IPAddress, ...
                form.DeviceID);
        end

        function resourceString = getSocketResourceString(form)
            arguments
                form (1, 1) matlabshared.transportapp.internal.visamodaldialog.ResourceStringForm
            end

            resourceString = sprintf("TCPIP%s::%s::%s::SOCKET", ...
                form.BoardNumber, ...
                form.IPAddress, ...
                form.Port);
        end

        function resourceString = getHiSlipResourceString(form)
            arguments
                form (1, 1) matlabshared.transportapp.internal.visamodaldialog.ResourceStringForm
            end

            % If port is empty or 4880, the port is not used as part of the
            % visa identification string.
            if form.Port == "" || form.Port == "4880"
                resourceString = sprintf("TCPIP%s::%s::hislip%s::INSTR", ...
                    form.BoardNumber, ...
                    form.IPAddress, ...
                    form.DeviceID);
            else
                resourceString = sprintf("TCPIP%s::%s::hislip%s,%s::INSTR", ...
                    form.BoardNumber, ...
                    form.IPAddress, ...
                    form.DeviceID, ...
                    form.Port);
            end
        end
    end

    %% Hardware Manager Visa Device Discovery and identification
    methods (Static)
        function devices = getHwMgrDevice(deviceInfo)
            import transportapp.visadev.internal.VisadevIdentification
            if nargin == 0
                devices = VisadevIdentification.getVisaEnumerableDevices;
            else
                devices = ...
                    VisadevIdentification.getVisaNonEnumerableDevice(deviceInfo);
            end

        end
    end

    %% Private Helper functions
    methods (Static, Access = ?matlabshared.transportapp.internal.utilities.ITestable)
        function devices = getVisaEnumerableDevices()
            % Get list of hardware manager devices for visa enumerable
            % resources.

            import transportapp.visadev.internal.VisadevIdentification
            devices = [];
            
            try
                devList = visadevlist();
            catch
                % Error with visadevlist indicates VISA installation issue,
                % return early with empty device list
                return
            end

            if isempty(devList)
                return
            end

            % Get the "Vendor" column
            vendorColumn = find(devList.Properties.VariableNames == "Vendor");

            % Sort visadevlist output by decreasing order of Vendor name -
            % this is to ensure that resources where the Vendor is
            % identified is placed higher in the list of discoverable
            % devices.
            devList = sortrows(devList, vendorColumn, "descend");

            % Get the list of hardware manager devices.
            for i = 1 : height(devList)
                deviceInfo = devList(i,:);
                devices = [devices VisadevIdentification.privateGetHwMgrDevice(deviceInfo)]; %#ok<AGROW>
            end
        end

        function device = getVisaNonEnumerableDevice(devInfo)
            % Get a Hardware Manager Device from a Connection Form
            % instance.
            arguments
                devInfo (1, 1) matlabshared.transportapp.internal.visamodaldialog.ConnectionIdentificationForm
            end
            structVal = getStructFromConnectionForm(devInfo);
            structVal.Alias = "";
            % SerialNumber field has to be present during enumeration (its
            % value isn't used anywhere and should not be visible in the
            % app).
            structVal.SerialNumber = "MYDEV_12345";

            device = ...
                transportapp.visadev.internal.VisadevIdentification.privateGetHwMgrDevice(structVal);

            function structVal = getStructFromConnectionForm(devInfo)
                % Get a struct from the Connection Identification Form
                % instance.
                allProps = string(properties(devInfo))';
                for prop = allProps
                    structVal.(prop) = devInfo.(prop);
                end
            end
        end

        function hwmgrDevice = privateGetHwMgrDevice(deviceInfo)
            % Create a hardware manager device instance from the input
            % device information. This is invoked by both enumerable and
            % non-enumerable visa hardware manager devices.

            import transportapp.visadev.internal.VisadevIdentification

            % Get a list of Devices
            deviceCardDetails = VisadevIdentification.getDeviceCardDetails(deviceInfo);
            deviceCardTitle = VisadevIdentification.getDeviceCardTitle(deviceInfo);
            hwmgrDevice = matlab.hwmgr.internal.Device(deviceCardTitle);

            % Set DeviceCard info
            hwmgrDevice.DeviceCardDisplayInfo = deviceCardDetails;

            hwmgrDevice.IconID = ...
                transportapp.visadev.internal.VisadevIdentification.DeviceCardIcon;

            hwmgrDevice.DeviceAppletData = matlab.hwmgr.internal.data.DataFactory.createDeviceAppletData("transportapp.visadev.internal.VisadevApp", "IC");
            hwmgrDevice.CustomData.ResourceName = deviceInfo.ResourceName;
            hwmgrDevice.UUID = compose("%s_%s", deviceInfo.ResourceName, deviceInfo.SerialNumber);
        end

        function deviceCardTitle = getDeviceCardTitle(deviceInfo)
            % Get the device card title.

            deviceCardTitle = "";
            if deviceInfo.Alias ~= ""
                deviceCardTitle = " " + deviceCardTitle + deviceInfo.Alias;
            elseif deviceInfo.Model ~= ""
                deviceCardTitle = " " + deviceCardTitle + deviceInfo.Model;
            end

            deviceCardTitle = " " + deviceCardTitle +  " VISA-" + ...
                string(deviceInfo.Type);
            deviceCardTitle = strtrim(deviceCardTitle);
        end

        function deviceCardDetails = getDeviceCardDetails(deviceInfo)
            % Get the device card contents.

            deviceCardDetails = ["Resource Name", deviceInfo.ResourceName];

            % If alias is not empty, alias will be used in the Device Card
            % Title. For this case, the model will not be part of the
            % Device Card Title, and needs to be part of the Device
            % Card Details. If alias is empty, the model is part of the
            % device card title and does not need to be part of the Card
            % Details.
            if deviceInfo.Alias ~= "" && deviceInfo.Model ~= ""
                deviceCardDetails(end+1, :) = ["Model", deviceInfo.Model];
            end

            if deviceInfo.Vendor ~= ""
                deviceCardDetails(end+1, :) = ["Vendor", deviceInfo.Vendor];
            end
        end
    end
end
