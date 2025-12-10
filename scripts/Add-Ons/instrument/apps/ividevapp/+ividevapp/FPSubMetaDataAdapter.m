classdef FPSubMetaDataAdapter < ividevapp.IMetaDataAdapter
    %FPSUBMETADATAADAPTER Adapter class that is used to get meta data
    % information for functions and properties for a driver using the
    % driver's fp and sub files.

    % Copyright 2023-2024 The MathWorks, Inc.

    %% Abstract properties
    properties
        FunctionMetaData
        PropertyMetaData
    end

    %% Other private properties to access fp and sub data
    properties (Access = private)
        FPData
        SubData
        VendorDriver
    end

    properties (Constant)
        DataTypeLookup = dictionary([1018, 1011, 1022, 1001, 1002, 1004, 1012, 1016], ...
            ["ViConstString", "ViChar[]", "ViByte[]", "ViInt32", "ViInt64", "ViReal64", "ViInt16[]", "ViReal64[]" ])

        DriverRootFolder (1, 1) string = fullfile("C:", "Program Files", "IVI Foundation")
        IVIFolder (1, 1) string = fullfile(ividevapp.FPSubMetaDataAdapter.DriverRootFolder, "IVI", "Drivers")
        VXIPnPFolder (1, 1) string = fullfile(ividevapp.FPSubMetaDataAdapter.DriverRootFolder, "VISA", "Win64")

        FolderLocationForDriverType = dictionary("IVI", ividevapp.FPSubMetaDataAdapter.IVIFolder, ...
            "VXIPnP", ividevapp.FPSubMetaDataAdapter.VXIPnPFolder)
    end

    %% Abstract method implementations for FP data
    methods
        function index = getFuncMetaDataStartIndex(~)
            % Returns index of the first valid function in the
            % function/function group meta data as a scalar double.
            % Skips the driver name, "Initialize", and "Initialize With
            % Options" function groups.
            index = 4;
        end

        function structData = getFunctionMetaData(obj)
            % Returns function meta data after processing the fp data as a
            % struct array.
            if ~isempty(obj.FunctionMetaData)
                structData = obj.FunctionMetaData;
                return
            end

            funcMetaData = obj.FPData.FunctionTreeNode;
            structData = getStructData(obj, funcMetaData);
            obj.FunctionMetaData = structData;
        end

        function numFunctions = getNumFunctions(obj)
            % Returns total number of functions as present in the function
            % meta data as a scalar double.
            numFunctions = numel(getFunctionMetaData(obj));
        end

        function funcName = getFunctionName(obj, index)
            % Returns name of the indexed function in the function meta
            % data as a scalar string.
            funcMetaData = getFunctionMetaData(obj);
            funcName = ividev.makeMATLABDriver.internal.camelcase(funcMetaData(index).Panel(1).FunctionName);
        end

        function funcGroupName = getFunctionGroupName(obj, index)
            % Returns name of the indexed function group in the function
            % meta data as a scalar string.
            funcMetaData = getFunctionMetaData(obj);
            funcGroupName = funcMetaData(index).Name;
        end

        function level = getFunctionLevel(obj, index)
            % Returns the hierarchy level for the function in the function
            % meta data tree as a scalar double.
            % (assumes level of root node is 0 and also assumes level for
            % child node is one more than the level of parent node).
            funcMetaData = getFunctionMetaData(obj);
            level = funcMetaData(index).Level;
        end

        function flag = functionHasNoChild(obj, index)
            % Returns true if function node indexed currently is a leaf
            % node.
            funcMetaData = getFunctionMetaData(obj);
            flag = funcMetaData(index).Type == 2;
        end

        function flag = isPreviousFuncNodeParent(obj, previousNodeLevel, currentNodeIndex)
            % Returns true if function node indexed previously is a parent
            % of function node indexed currently.

            % Has the level increased by 1 for it to be level of child node.
            flag = getFunctionLevel(obj, currentNodeIndex) == previousNodeLevel + 1;
        end

        function flag = isNextFuncNodeChild(obj, previousNodeLevel, currentNodeIndex)
            % Returns true if function node indexed next is a child
            % of function node indexed currently.

            treeLength = getNumFunctions(obj);
            nextNodeIndex = currentNodeIndex + 1;
            isInBounds = nextNodeIndex <= treeLength;

            % Has the level increased by 2 for it to be level of child of
            % child node.
            nextNodeLevel = previousNodeLevel + 2;
            flag = isInBounds && getFunctionLevel(obj, nextNodeIndex) == nextNodeLevel;
        end

        function functionArgStruct = getFunctionArguments(obj, index)
            % Returns function input and output arguments and their
            % corresponding property values as a struct array.

            funcMetaData = getFunctionMetaData(obj);

            functionArgStruct = struct.empty;

            if isempty(funcMetaData(index).Panel)
                return
            end

            functionArguments = funcMetaData(index).Panel.Ctrl;
            functionArgStruct = getStructData(obj, functionArguments);
        end

        function argNames = getFuncInputArgNames(obj, index)
            % Returns names of function input arguments as a string array.

            argNames = getFuncArgNames(obj, index, @ne);
        end

        function argNames = getFuncOutputArgNames(obj, index)
            % Returns names of function output arguments as a string array.

            argNames = getFuncArgNames(obj, index, @isequal);
        end

        function paramPos = getFuncArgPosition(~, functionArg)
            % Returns function argument position in the list of function
            % arguments as a scalar double.
            paramPos = functionArg.ParamPos;
        end

        function type = getFuncArgType(~, functionArg)
            % Returns the type for a function argument as a scalar double.
            type = functionArg.CtrlType;
        end

        function dataType = getFuncArgDataType(obj, functionArg)
            % Returns the type for a function argument as a scalar string.
            dataType = string.empty;
            id = functionArg.DataTypeID;
            matchedObj = findobj(obj.FPData.UserDataType, 'ID', id);

            if ~isempty(matchedObj)
                dataType = matchedObj.DataTypeStr;
            elseif obj.DataTypeLookup.isKey(id)
                dataType = obj.DataTypeLookup(id);
            end
        end

        function name = getFuncArgName(~, functionArg)
            % Returns function argument name as a scalar string.
            name = functionArg.Label;
        end

        function defaultText = getFuncArgDefaultValue(~, functionArg)
            % Returns default value of function argument as a scalar string.
            if isempty(functionArg.DefaultText)
                functionArg.DefaultText = "";
            end
            defaultText = erase(functionArg.DefaultText, '"');
        end

        function enums = getFuncArgEnumValues(obj, functionArg)
            % Returns enum values for relevant function arguments as a
            % string array.

            % Get the instrument prefix name to crop out of
            % the enumValues.
            cropPrefix = extractInstrumentPrefix(obj);
            enums = string.empty;

            enumValues = functionArg.RingLabelValues;
            for labelValue = enumValues
                croppedEnumName = ividev.makeMATLABDriver.internal.processEnumPropertyName(replace(labelValue, cropPrefix, string));
                croppedEnumName = erase(croppedEnumName, '"');
                enums(end+1) = croppedEnumName; %#ok<*AGROW>
            end
        end

        function defaultEnumVal = getFuncArgDefaultEnumValue(obj, functionArg)
            % Returns default enum value for function argument as a scalar
            % string.
            defaultEnumValueIndex = functionArg.RingDefaultIndexValue;
            enums = getFuncArgEnumValues(obj, functionArg);
            defaultEnumVal = enums(defaultEnumValueIndex);
        end

        function help = getFunctionGroupHelp(obj, index)
            % Returns the help text for the function group indexed
            % currently as a scalar string.
            funcMetaData = getFunctionMetaData(obj);
            help = funcMetaData(index).HelpText;
        end

        function help = getFunctionHelp(obj, index)
            % Returns the help text for the function indexed currently as a
            % scalar string.
            funcMetaData = getFunctionMetaData(obj);
            help = funcMetaData(index).Panel(1).HelpText;
        end

        function help = getFuncArgHelp(~, functionArg)
            % Returns the help text for the function argument indexed
            % currently as a scalar string.
            help = functionArg.HelpText;
        end

        function [exampleDescription, examples] = getFunctionMatlabExamples(~, ~)
            % Returns the m-help example code and example description for
            % the function indexed currently as string arrays.

            examples = string.empty;
            exampleDescription = string.empty;
        end
    end

    %% Abstract method implementations for Sub data
    methods
        function structData = getPropertyMetaData(obj)
            % Returns property meta data after processing the sub data as a
            % struct array.

            if ~isempty(obj.PropertyMetaData)
                structData = obj.PropertyMetaData;
                return
            end

            propMetaData = obj.SubData.Data.ClassIdentifier;
            structData = getStructData(obj, propMetaData);
            obj.PropertyMetaData = structData;
        end

        % AttributeIdentifier methods
        function name = getAttributeIdentifierName(~, attributeIdentifier)
            % Returns name for the selected attribute identifier (property)
            % as a scalar string.
            name = attributeIdentifier.AttributeName;
        end

        function accessMode = getAttributeIdentifierAccessMode(~, attributeIdentifier)
            % Returns access type for the selected attribute identifier
            % (property) as a scalar string.
            % e.g. get, get and set, set
            accessMode = attributeIdentifier.AccessMode;
        end

        function visaType = getAttributeIdentifierVISAType(~, attributeIdentifier)
            % Returns Vi data type for the selected attribute identifier
            % (property) as a scalar string.
            % e.g. ViString, ViInt32, ViBoolean, etc
            visaType = attributeIdentifier.VISAType;
        end

        function help = getAttributeIdentifierHelp(~, attributeIdentifier)
            % Returns help text for the selected attribute identifier
            % (property) as a scalar string.
            help = attributeIdentifier.Help;
        end

        function [exampleDescription, examples] = getAttributeIdentifierExamples(~, ~)
            % Returns the m-help example code and example description for
            % the property indexed currently as string arrays.

            examples = string.empty;
            exampleDescription = string.empty;
        end

        function structData = getAttributeIdentifiers(obj, classIdentifier)
            % Returns list of attribute identifiers (properties) for the
            % selected class identifier (property group) as a struct array.

            attributeIdentifiers = classIdentifier.AttributeIdentifier;
            structData = getStructData(obj, attributeIdentifiers);
        end

        function flag = hasAttributeIdentifiers(obj, classIdentifier)
            % Returns true if selected class identifier (property group)
            % contains any attribute identifiers (properties).
            % Returns false otherwise.
            flag = ~isempty(getAttributeIdentifiers(obj, classIdentifier));
        end

        % ClassIdentifier methods
        function name = getClassIdentifierName(~, classIdentifier)
            % Returns name for the selected class identifier (property group)
            % as a scalar string.
            name = classIdentifier.ClassName;
        end

        function help = getClassIdentifierHelp(~, classIdentifier)
            % Returns help text for the selected class identifier
            % (property group) as a scalar string.
            help = classIdentifier.Help;
        end

        function structData = getClassIdentifiers(obj, classIdentifier)
            % Returns list of class identifiers (property groups) for the
            % selected class identifier (property group) as a struct array.

            classIdentifiers = classIdentifier.ClassIdentifier;
            structData = getStructData(obj, classIdentifiers);
        end

        function flag = hasClassIdentifiers(obj, classIdentifier)
            % Returns true if selected class identifier (property group)
            % contains any class identifiers (other property groups).
            % Returns false otherwise.
            flag = ~isempty(getClassIdentifiers(obj, classIdentifier));
        end

        function rcNames = getClassIdentifierRCNames(~, classIdentifier)
            % Returns repeated capability getNameFcn information associated
            % with the selected class identifier (property group) as a scalar
            % string.
            rcNames = classIdentifier.RCNames;
        end
    end

    %% Abstract RepCap methods implementation
    methods
        function structData = getDynamicRepeatedCapabilities(obj)
            % Returns dynamic repeated capabilities from sub data as a
            % struct array.

            dynamicRC = obj.SubData.DynamicRepeatedCapabilities;
            structData = getStructData(obj, dynamicRC);
        end

        function structData = getStaticRepeatedCapabilities(obj)
            % Returns static repeated capabilities from sub data as a
            % struct array.

            staticRC = obj.SubData.StaticRepeatedCapabilities;
            structData = getStructData(obj, staticRC);
        end

        function [repcaps, repCapIDToGetNameFcnMap] = getRepCaps(obj, dev)
            % Returns string array of repeated capability ID values and map
            % of repeated capability ID values to their corresponding
            % getNameFcn and/or Rep Cap name values.

            repcaps = [];
            repCapIDToGetNameFcnMap = containers.Map();

            % Dynamic rep cap data
            dynamicRepCapData = getDynamicRepeatedCapabilities(obj);

            for dynamicRCData = dynamicRepCapData
                % Get the rep cap names and getNameFcns of each dynamic
                % repeated capability from the sub parser data.
                repcapName = dynamicRCData.RepCapID;
                getNameFcn = dynamicRCData.GetNameFcn;

                % Map each rep cap ID value for each rep cap name to the
                % corresponding getNameFcn.
                for repCapID = dev.(repcapName)
                    repcaps = unique([repcaps, repCapID]);
                    updateCurrentRepCapIDKey(obj, repCapIDToGetNameFcnMap, repCapID, getNameFcn);
                    storeRepCapOrAliasInMap(obj, dynamicRCData, repCapIDToGetNameFcnMap, repCapID);
                    repCapIDToGetNameFcnMap(repCapID) = unique(repCapIDToGetNameFcnMap(repCapID));
                end
            end

            % Static rep cap data
            staticRepCapData = getStaticRepeatedCapabilities(obj);

            for staticRCData = staticRepCapData
                % Get the rep cap name of each static repeated capability
                % from the sub parser data.
                repcapName = staticRCData.RepCapID;

                % Map each rep cap ID value for each rep cap name to the
                % corresponding rep cap name.
                for repCapID = staticRCData.Names
                    repcaps = unique([repcaps, repCapID]);
                    updateCurrentRepCapIDKey(obj, repCapIDToGetNameFcnMap, repCapID, repcapName);
                    storeRepCapOrAliasInMap(obj, staticRCData, repCapIDToGetNameFcnMap, repCapID);
                    repCapIDToGetNameFcnMap(repCapID) = unique(repCapIDToGetNameFcnMap(repCapID));
                end
            end

            function updateCurrentRepCapIDKey(~, repCapIDToGetNameFcnMap, repCapID, getNameFcn)
                % Map repCapID value to getNameFcn.
                % If repCapID value already exists as a key then append
                % getNameFcn to key value.

                if isKey(repCapIDToGetNameFcnMap, repCapID)
                    repCapIDToGetNameFcnMap(repCapID) = [repCapIDToGetNameFcnMap(repCapID), getNameFcn]; %#ok<*NASGU>
                else
                    repCapIDToGetNameFcnMap(repCapID) = getNameFcn;
                end
            end

            function storeRepCapOrAliasInMap(~, repeatedCapability, repCapIDToGetNameFcnMap, repCapID)
                % Store rep cap name in repCapID value to getNameFcn map.
                % Add alias to the map also if alias is different than the
                % rep cap name.
                repcapName = repeatedCapability.RepCapID;
                alias = repeatedCapability.Alias;

                if repcapName ~= ""
                    repCapIDToGetNameFcnMap(repCapID) = [repCapIDToGetNameFcnMap(repCapID), repcapName];
                end

                if alias ~= "" && repcapName ~= alias
                    repCapIDToGetNameFcnMap(repCapID) = [repCapIDToGetNameFcnMap(repCapID), alias];
                end
            end
        end
    end

    %% Lifetime
    methods
        function obj = FPSubMetaDataAdapter(vendorDriver)
            obj.VendorDriver = vendorDriver;
            saveFPData(obj, vendorDriver);
            saveSubData(obj, vendorDriver);
        end
    end

    %% Helper methods
    methods (Access = private)
        function saveFPData(obj, vendorDriver)
            % Returns fp metadata for vendor driver

            fpPath = getDriverFilePath(obj, vendorDriver, vendorDriver + ".fp");

            % searching for ni specific fp file
            if ~isfile(fpPath)
                fpPath = getDriverFilePath(obj, vendorDriver + "_ni", vendorDriver + "_ni.fp");

                % For VXIPNP drivers
                if ~isfile(fpPath)
                    fpPath = getDriverFilePath(obj, vendorDriver, vendorDriver + ".fp", "VXIPnP");
                end
            end

            obj.FPData = fpParser(fpPath);
        end

        function saveSubData(obj, vendorDriver)
            % Returns sub metadata for vendor driver

            subPath = getDriverFilePath(obj, vendorDriver, vendorDriver + ".sub");

            % searching for ni specific sub file
            if ~isfile(subPath)
                subPath = getDriverFilePath(obj, vendorDriver + "_ni", vendorDriver + "_ni.sub");

                % For VXIPNP drivers
                if ~isfile(subPath)
                    subPath = getDriverFilePath(obj, vendorDriver, vendorDriver + ".sub", "VXIPnP");
                end
            end

            obj.SubData = ividev.sub.SubPreprocessor(subPath);
        end

        function driverFilePath = getDriverFilePath(obj, vendorFolder, vendorDriver, driverType)
            arguments
                obj
                vendorFolder
                vendorDriver
                driverType (1, 1) string {mustBeMember(driverType, ["IVI", "VXIPnP"])} = "IVI"
            end

            driverFilePath = fullfile(obj.FolderLocationForDriverType(driverType), vendorFolder, vendorDriver);
        end

        function instrPrefix = extractInstrumentPrefix(obj)
            % Returns the instrument prefix for a driver. Currently, the
            % instrument prefix is obtained by extracting the file name.
            % Search for "_ni.fp" first since the file names of some
            % drivers end in "_ni.fp", while others end only in ".fp".

            if ~ismissing(extractBefore(obj.FPData.File, "_ni.fp"))
                pattern = "_ni.fp";
            else
                pattern = ".fp";
            end
            instrPrefix = extractBefore(obj.FPData.File, pattern);

            % The prefix could be <DriverName>_VAL_
            instrPrefix = sprintf("%s_VAL_", upper(instrPrefix));
        end

        function argNames = getFuncArgNames(obj, index, fcn)
            % Returns either input or output function argument names
            % depending on the fcn logic passed in.
            functionArguments = getFunctionArguments(obj, index);

            argNames = string.empty;
            for functionArg = functionArguments
                paramPos = getFuncArgPosition(obj, functionArg);
                if paramPos > 0 && fcn(functionArg.CtrlType, 2)
                    argNames(end+1) = getFuncArgName(obj, functionArg);
                end
            end

            if ~isempty(argNames)
                argNames = ividev.makeMATLABDriver.internal.camelcase(argNames);
            end
        end

        function structData = getStructData(~, data)
            % Takes metadata and converts into a struct array.

            structData = struct.empty;

            for metaData = data
                props = string(properties(metaData))';
                for prop = props
                    st.(prop) = metaData.(prop);
                end
                structData = [structData st];
                st = [];
            end
        end
    end

    %% Abstract method implementations - General purpose
    methods
        function driver = getDriverName(obj)
            % This method retrieves the driver name.
            driver = obj.VendorDriver;
        end
    end
end
