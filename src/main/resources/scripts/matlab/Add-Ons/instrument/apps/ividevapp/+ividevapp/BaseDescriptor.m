classdef (Abstract) BaseDescriptor < matlab.hwmgr.internal.DeviceParamsDescriptor
    %BASEDESCRIPTOR is the base descriptor class for all descriptors
    % in the ividevapp.

    % Copyright 2023-2024 The MathWorks, Inc.

    properties
        IvidevObjForm
        Identification

        % ividriverlist related information
        IVIDriverList
        SelectedDriverIVIClass (1, 1) string = ""
    end

    properties (Constant)
        TFValues = ["true", "false"]
        FTValues = flip(ividevapp.BaseDescriptor.TFValues)
        DefaultTimeout = '30'

        % Dictionary of supported ividev NV-Pair property names (as keys)
        % and their default values (as key-value).
        NVPairNamesAndDefaults = ...
            ividevapp.BaseDescriptor.getNVPairNamesDefaultValuesDictionary()

        IVIClasses = ["IVIACPwr", "IVICounter", "IVIDCPwr", "IVIDigitizer", "IVIDmm", "IVIDownconverter", ...
            "IVIFgen", "IVIPwrMeter", "IVIRfSigGen", "IVIScope", "IVISpecAn", "IVISwtch", "IVIUpconverter"]

        IVIMATLABDrivers = ividevapp.BaseDescriptor.lowerVIChars(ividevapp.BaseDescriptor.IVIClasses)

        IVIMATLABDriverLookup = dictionary(ividevapp.BaseDescriptor.IVIClasses, ividevapp.BaseDescriptor.IVIMATLABDrivers)

        DeviceCardIcon = matlabshared.testmeasapps.internal.themeableiconrepository.IconRepository.getIcon("hwmgrclient", ...
            "VisaDeviceCard_Descriptor")

        UIFieldNameLookUp = dictionary(["ResourceName", "Drivers"], ["Resource", "Driver"])
        IviConfigStoreDriverNameLookUp = dictionary(["NIFGEN", "NIDCPower"], ["NI-FGEN", "NI-DCPower"])
    end

    %% Lifetime
    methods
        function obj = BaseDescriptor(descriptorName, mapFile, topicID, tooltipText)
            import ividevapp.BaseDescriptor
            obj@matlab.hwmgr.internal.DeviceParamsDescriptor( ...
                descriptorName, ...
                mapFile, ...
                topicID, ...
                tooltipText);
        end
    end

    %% Implementing Abstract Methods from DeviceParamsDescriptor
    methods
        function validateParams(obj, paramMap)
            % Get the identification details for the ividev object.

            checkEmptyField(obj, paramMap, "ResourceName");
            checkEmptyField(obj, paramMap, "Drivers");

            % Get param values from the configuration tab toolstrip.
            driver = string(paramMap("Drivers").NewValue);
            resourceString = string(paramMap("ResourceName").NewValue);

            % Get logical name if class-compliant driver option is selected
            % otherwise use the selected driver directly to interact with
            % the instrument.
            if string(paramMap("ClassCompliant").NewValue) == "true"
                if ~ismember(obj.SelectedDriverIVIClass, obj.IVIClasses)
                    throwAsCaller(MException(message("ividevapp:ividevapp:ClassComDriverNotSupported")));
                end

                % Returns logical name if one already exists for the resource
                % and driver specified.
                % If no logical name is found for the resource and driver
                % specified, then creates and returns a new logical name.
                iviConfigStoreDriverName = getIviConfigStoreDriverName(obj, driver);
                logicalName = ividevapp.utilities.IviConfigStoreHandler.getLogicalName(resourceString, iviConfigStoreDriverName);

                % Create the parameter string that will be used to create
                % the ividev object using class-compliant driver.
                paramStr = '"' + obj.IVIMATLABDriverLookup(obj.SelectedDriverIVIClass) + '", "' + logicalName + '"';
            else
                % Create the parameter string that will be used to create
                % the ividev object using the selected driver.
                paramStr = '"' + driver + '", "' + resourceString + '"';
                logicalName = string.empty;
            end

            % Get the NV-Pair arguments (if any)
            [nvPair, nvPairCodeStr] = getNVPairs(obj, paramMap);
            paramStr = paramStr + nvPairCodeStr;

            % Creates the ividev object using paramStr and returns the
            % ividev object properties as values in a struct.
            obj.Identification = ividevapp.IvidevIdentification;
            setDeviceCardDriverName(obj.Identification, driver);
            form = identify(obj.Identification, paramStr, logicalName, nvPair);

            if ~isempty(form.Error)
                switch form.Error.identifier
                    case "instrument:ividev:general:invalidMATLABDriver"
                        throwAsCaller(MException(message("ividevapp:ividevapp:MATLABDriverNotSupported")));
                    otherwise
                        throwAsCaller(form.Error);
                end
            end

            % Save the ividev object values to IvidevObjForm. These values
            % will be used to create the hardware manager device card for
            % the configured instrument.
            obj.IvidevObjForm = form;

            %% NESTED FUNCTION
            function [nameValue, nvPairCode] = getNVPairs(obj, paramMap)
                % Get a dictionary only containing names and values of NV
                % Pairs that have been changed from their default value.
                % Also, get the associated constructor NV pair code.

                allKeys = keys(ividevapp.BaseDescriptor.NVPairNamesAndDefaults)';
                nameValue = configureDictionary("string", "string");
                nvPairCode = "";

                for key = allKeys
                    currValue = paramMap(key).NewValue;
                    currValue = stripQuotesAndSpaces(obj, currValue);

                    % Only save the NV-Pair and value, and update the
                    % nvPairStr if the current value is not equal to the
                    % default value.
                    if currValue == ividevapp.BaseDescriptor.NVPairNamesAndDefaults(key)
                        continue
                    end

                    % For DriverSetup and OptionString, add "" around the
                    % value.
                    if any(key == ["DriverSetup", "OptionString"])
                        currValue = """" + currValue + """";
                    end

                    % Populate the dictionary and the nv pair constructor
                    % code.
                    nameValue(key) = currValue;
                    nvPairCode = nvPairCode + ", " + key + "=" + currValue;
                end
            end
        end

        function device = createHwmgrDevice(obj, ~)
            % Create the hardware manager device for the configured ividev
            % resource.
            device = getHwMgrDevice(obj.Identification, obj.IvidevObjForm);
        end

        function icon = getIcon(obj)
            % Returns the device card icon.
            [~, icon] = matlab.hwmgr.internal.data.plugins.InstrumentExplorerDataPlugin.getIconDetails("ToolstripIcon", obj.DeviceCardIcon);
        end
    end

    %% Configuration tab parameter handler functions
    methods
        function val = driverValuesFcn(obj, paramMap)
            % Returns the list of vendor drivers discovered.
            if isempty(obj.IVIDriverList)
                obj.IVIDriverList = ividriverlist;
            end

            driverList = obj.IVIDriverList;
            drivers = string.empty;
            for i = 1:numel(driverList.VendorDriver)
                if startsWith(driverList.VendorDriver(i), "Ivi")
                    % Skip the class-compliant drivers.
                    continue
                end
                drivers = [drivers, driverList.VendorDriver(i)]; %#ok<*AGROW>

                if startsWith(driverList.MATLABDriver(i), "NimSc")
                    drivers = [drivers, driverList.MATLABDriver(i)];
                end
            end

            % Show empty Driver drop-down if no vendor driver installed.
            if isempty(drivers)
                val = "";
                return
            end

            drivers = unique(drivers);

            devList = ividevlist;
            if isempty(devList)
                val = drivers;
                return
            end

            % Pick the correct driver for the user if the device is detected.
            for i = 1:numel(devList.ResourceName)
                if string(paramMap("ResourceName").NewValue) == devList.ResourceName(i)
                    idx = find(ismember(drivers, devList.VendorDriver(i)));
                    foundDriverName = drivers(idx);

                    % Remove the found driver from the original list and
                    % add it to the beginning of the list.
                    drivers(idx) = [];
                    drivers = [foundDriverName drivers];
                    break
                end
            end

            val = drivers;
        end

        function val = classComValuesFcn(obj, paramMap)
            % Returns the value for the class-compliant drop-down.
            val = obj.FTValues;
            obj.SelectedDriverIVIClass = "";

            % Automatically update the value to return to "true" when the
            % selected driver is not supported directly but the instrument
            % can be communicated with using the class-compliant driver instead.
            selectedDriver = string(paramMap("Drivers").NewValue);

            % For empty list of drivers, show empty class-compliant
            % drop-down field.
            idx = find(obj.IVIDriverList.VendorDriver == selectedDriver, 1);

            if isempty(idx)
                val = "";
                return
            end

            for i = 1:numel(obj.IVIDriverList.VendorDriver)
                if selectedDriver ~= obj.IVIDriverList.VendorDriver(i)
                    continue
                end

                obj.SelectedDriverIVIClass = obj.IVIDriverList.IVIClass(i);

                elem = paramMap("ClassCompliant");
                if obj.IVIDriverList.MATLABDriver(i) == "" && ismember(obj.SelectedDriverIVIClass, obj.IVIClasses)
                    elem.NewValue = 'true';
                    val =  "true";
                elseif ~ismember(obj.SelectedDriverIVIClass, obj.IVIClasses)
                    elem.NewValue = 'false';
                    val =  "false";
                end
                paramMap("ClassCompliant") = elem; %#ok<NASGU>
                break
            end
        end

        function flag = classComEnabledFcn(obj, paramMap)
            % Enables/disables the class-compliant drop-down based on the
            % driver selected.
            flag = true;
            selectedDriver = string(paramMap("Drivers").NewValue);

            % For empty list of drivers, disable the empty class-compliant
            % drop-down field.
            idx = find(obj.IVIDriverList.VendorDriver == selectedDriver, 1);

            if isempty(idx)
                flag = false;
                return
            end

            for i = 1:numel(obj.IVIDriverList.VendorDriver)
                if selectedDriver ~= obj.IVIDriverList.VendorDriver(i)
                    continue
                end

                isClassCompliantDriver = ismember(obj.IVIDriverList.IVIClass(i), obj.IVIClasses);
                flag = ~((obj.IVIDriverList.MATLABDriver(i) == "" && isClassCompliantDriver) || ~isClassCompliantDriver);
                break
            end
        end

        function val = launchDontSeeYourDriverPage(~, ~)
            % Launches the MATLAB documentation page when the Dont See Your
            % Driver button is clicked.
            val = [];
            helpview("instrument", "ividevappDriverNotFound");
        end

        function val = trueFalseValuesFcn(obj, ~)
            % Returns true and false values for the optional parameters.
            val = obj.TFValues;
        end

        function val = falseTrueValuesFcn(obj, ~)
            % Returns false and true values for the optional parameters.
            val = obj.FTValues;
        end

        function val = defaultTimeoutValueFcn(obj, ~)
            % Returns default timeout to find and connect to ividev object.
            val = obj.DefaultTimeout;
        end
    end

    %% Helper functions
    methods
        function val = stripQuotesAndSpaces(~, val)
            % Remove quotes and spaces from around the string.

            arguments
                ~
                val (1, 1) string
            end

            val = replace(val, ["'", """"], "");
            val = strip(val);
        end
    end

    %% Private Helper functions
    methods (Access = ?matlabshared.transportapp.internal.utilities.ITestable)
        function checkEmptyField(obj, paramMap, name)
            % Check whether a given modal tab UI element's (defined by
            % "name") value is empty. If empty, this method throws an
            % error.
            arguments
                obj
                paramMap containers.Map
                name (1, 1) string
            end

            field = paramMap(name);
            if string(field.NewValue) == ""
                fieldName = obj.UIFieldNameLookUp(name);
                throwAsCaller(MException(message("ividevapp:ividevapp:FieldEmpty", fieldName)));
            end
        end

        function iviConfigStoreDriverName = getIviConfigStoreDriverName(obj, driver)
            % Get the driver name that is expected by
            % iviconfigurationstore() to create a logical name for
            % class-compliant connection.

            iviConfigStoreDriverName = driver;
            if isKey(obj.IviConfigStoreDriverNameLookUp, driver)
                iviConfigStoreDriverName = obj.IviConfigStoreDriverNameLookUp(driver);
            end
        end
    end

    %% Static helper functions
    methods (Static, Access = ?matlabshared.transportapp.internal.utilities.ITestable)
        function matlabDriverClasses = lowerVIChars(iviClasses)
            matlabDriverClasses = [];
            for iviClass = iviClasses
                className = replace(iviClass, "VI", "vi");
                matlabDriverClasses = [matlabDriverClasses className];
            end
        end

        function dict = getNVPairNamesDefaultValuesDictionary()
            % Returns a dictionary where the keys are the names of all
            % supported NV Pairs, and the value for each key is the default
            % value for each NV Pair name.

            dict = configureDictionary("string", "string");

            % All NV Pair properties with default value = "true"
            trueProps = ["IDQuery", "RangeCheck", "QueryInstrStatus", "Cache"];
            trueValue = ividevapp.BaseDescriptor.TFValues(1);
            populateDictionary(trueProps, trueValue);

            % All NV Pair properties with default value = "false"
            falseProps = ["InterchangeCheck", "RecordCoercions", "ResetDevice", "Simulate"];
            falseValue = ividevapp.BaseDescriptor.TFValues(2);
            populateDictionary(falseProps, falseValue);

            % All NV Pair with default value as other string values.
            populateDictionary("Timeout", ividevapp.BaseDescriptor.DefaultTimeout);
            populateDictionary("DriverSetup", "");
            populateDictionary("OptionString", "");

            %% NESTED FUNCTION
            function populateDictionary(names, value)
                % Populate all name in "names" to "value".

                for n = names
                    dict(n) = value;
                end
            end
        end
    end
end
