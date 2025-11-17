classdef IviConfigStoreHandler
    %IVICONFIGSTOREHANDLER class is responsible for returning a valid
    % logical name for class-compliant driver communication.

    % Copyright 2023 The MathWorks, Inc.

    methods (Static)
        function logicalName = getLogicalName(resource, driver)
            % Return logical name if one already exists for the resource
            % and driver specified. If no logical name is found for the
            % resource and driver specified, then create a new logical
            % name.

            if startsWith(driver, "NimSc")
                driver = "NimSc";
            end

            logicalName = ividevapp.utilities.IviConfigStoreHandler.findLogicalName(resource, driver);

            if ~isempty(logicalName)
                return
            end

            logicalName = ividevapp.utilities.IviConfigStoreHandler.createLogicalName(resource, driver);
        end
    end

    methods (Static, Access = ?matlabshared.transportapp.internal.utilities.ITestable)
        function logicalNameToUse = findLogicalName(resource, driver)
            % Goes through all logical names present in
            % iviconfigurationstore and compares the resource and driver
            % provided against the resource and driver combinations present
            % in each logical name.
            % Returns the logical name containing the matching combination.
            logicalNameToUse = struct.empty;
            store = iviconfigurationstore;
            data = get(store);

            for logicalName = data.LogicalNames
                details = ividevapp.utilities.IviConfigStoreHandler.findLogicalNameDetails(store, logicalName.Name);

                matchFound = ~isempty(details) && details.DriverRsrcName == resource && details.DriverName == driver;
                if matchFound
                    logicalNameToUse = logicalName.Name;
                    return
                end
            end
        end

        function details = findLogicalNameDetails(store, logicalName)
            % Locates driver details including driver name and resource
            % name information in the iviconfigurationstore and returns this
            % info in a details struct.

            details = [];

            % Search through the Ivi Configuration Store to find the driver
            % details.
            try
                logicalNameAttribute = findConfigStoreInfo(store, "LogicalNames", logicalName);
                driverSession = logicalNameAttribute.Session;
                driverSessionAttribute = findConfigStoreInfo(store, "DriverSessions", driverSession);
                hardwareAsset = driverSessionAttribute.HardwareAsset;
                hardwareAssetAttribute = findConfigStoreInfo(store, "HardwareAssets", hardwareAsset);
                resource = hardwareAssetAttribute.IOResourceDescriptor;
            catch
                % Return with empty details if error occurs.
                return
            end

            % Save important driver information into details to be returned.
            details.DriverRsrcName = resource;
            details.DriverName = driverSessionAttribute.SoftwareModule;

            %% NESTED FUNCTION
            function attribute = findConfigStoreInfo(store, attributeToSearch, userInfo)
                % Locate information related to user input
                % "store" is an instance of the iviconfigurationstore.
                % "idx" saves the index of "userInfo" within the
                % "attributeInfo.Name" list.

                attributeInfo = store.(attributeToSearch);
                idx = string({attributeInfo.Name})==userInfo;

                % If found, return attribute information for particular idx.
                attribute = attributeInfo(idx);
            end
        end

        function logicalName = createLogicalName(resource, driver)
            % Creates iviconfigurationstore object and adds entries to it
            % to be used for class-compliant driver communication.
            % Returns created logical name from the iviconfigurationstore
            % object.

            % Construct a configStore and get its value.
            configStore = iviconfigurationstore;
            data = get(configStore);

            % Get unique entry names to be added to iviconfigurationstore.
            logicalNamePrefix = "myLogicalName";
            list = getAttributeList(data, "LogicalNames");
            logicalName = ividevapp.utilities.IviConfigStoreHandler.getUniqueEntryName(logicalNamePrefix, list);

            driverSessionNamePrefix = "myDriverSession";
            list = getAttributeList(data, "DriverSessions");
            driverSessionName = ividevapp.utilities.IviConfigStoreHandler.getUniqueEntryName(driverSessionNamePrefix, list);

            hwAssetNamePrefix = "myHardwareAsset";
            list = getAttributeList(data, "HardwareAssets");
            hwAssetName = ividevapp.utilities.IviConfigStoreHandler.getUniqueEntryName(hwAssetNamePrefix, list);

            % Add a hardware asset.
            add(configStore, "HardwareAsset", hwAssetName, resource);

            % Add a driver session and use the HardwareAsset created in the step above.
            add(configStore, "DriverSession", driverSessionName, driver, hwAssetName);

            % Add a logical name to the configStore.
            add(configStore, "LogicalName", logicalName, driverSessionName);

            % Save the changes to the IVI configuration store data file.
            commit(configStore);

            %% NESTED FUNCTION
            function list = getAttributeList(data, attribute)
                if isempty(data.(attribute))
                    list = string.empty;
                else
                    list = string({data.(attribute).Name});
                end
            end
        end

        function entryName = getUniqueEntryName(namePrefix, list)
            % Returns unique entry names to be added to
            % iviconfigurationstore.

            configStoreNameSuffixNum = 1;
            list = list(startsWith(list, namePrefix));

            while true
                entryName = namePrefix + string(configStoreNameSuffixNum);
                if any(entryName == list)
                    % Since name is part of list, update
                    % configStoreNameSuffixNum variable used when adding
                    % entries to iviconfigurationstore so that unique
                    % entries are added.
                    configStoreNameSuffixNum = configStoreNameSuffixNum + 1;
                else
                    % Break out of loop once unique name is determined for
                    % iviconfigurationstore entries.
                    break
                end
            end
        end
    end
end