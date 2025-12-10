classdef DriverMetaDataAdapter < ividevapp.IMetaDataAdapter
    %DRIVERMETADATAADAPTER Adapter class that is used to get meta data
    % information for functions and properties for a driver from the
    % makeMATLABDriver code.

    % Copyright 2023-2024 The MathWorks, Inc.

    %% Abstract properties
    properties
        FunctionMetaData
        PropertyMetaData
        DataConverter
    end

    %% Lifetime
    methods
        function obj = DriverMetaDataAdapter(dataConverter)
            try
                obj.DataConverter = dataConverter;
            catch ex
                throwAsCaller(ex);
            end
        end
    end

    %% Abstract method implementations - General purpose
    methods
        function driver = getDriverName(obj)
            % This method retrieves the driver name
            driver = obj.DataConverter.Driver;
        end
    end

    %% Abstract method implementations for FP data
    methods
        %% To-Do: (Drop-down tree building functions)
        function index = getFuncMetaDataStartIndex(~)
            % Returns index of the first valid function in the
            % function/function group meta data as a scalar double.
            % Skips the driver name, "Initialize", and "Initialize With
            % Options" function groups so the next valid index is 4.

            index = 4;
        end

        function data = getFunctionMetaData(obj)
            % Returns driver's function meta data as a struct array.

            data = obj.DataConverter.DriverFuncTreeData;
        end

        function numFunctions = getNumFunctions(obj)
            % Returns total number of functions as present in the function
            % meta data as a scalar double.

            numFunctions = numel(getFunctionMetaData(obj));
        end

        function funcName = getFunctionName(obj, index)
            % Returns name of the indexed function in the function meta
            % data as a scalar string.

            funcTreeData = getFunctionMetaData(obj);
            funcName = ividev.makeMATLABDriver.internal.camelcase(funcTreeData(index).Panel(1).FunctionName);
        end

        function funcGroupName = getFunctionGroupName(obj, index)
            % Returns name of the indexed function group in the function
            % meta data as a scalar string.

            funcTreeData = getFunctionMetaData(obj);
            funcGroupName = funcTreeData(index).Name;
        end

        function level = getFunctionLevel(obj, index)
            % Returns the hierarchy level for the function in the function
            % meta data tree as a scalar double.
            % (assumes level of root node is 0 and also assumes level for
            % child node is one more than the level of parent node).

            funcTreeData = getFunctionMetaData(obj);
            level = funcTreeData(index).Level;
        end

        function flag = functionHasNoChild(obj, index)
            % Returns true if function node indexed currently is a leaf
            % node.

            funcTreeData = getFunctionMetaData(obj);
            flag = funcTreeData(index).Type == 2;
        end

        function flag = isPreviousFuncNodeParent(obj, previousNodeLevel, currentNodeIndex)
            % Returns true if function node indexed previously is a parent
            % of function node indexed currently.

            flag = getFunctionLevel(obj, currentNodeIndex) == previousNodeLevel + 1;
        end

        function flag = isNextFuncNodeChild(obj, previousNodeLevel, currentNodeIndex)
            % Returns true if function node indexed next is a child
            % of function node indexed currently.

            treeLength = getNumFunctions(obj);
            nextNodeIndex = currentNodeIndex + 1;
            isInBounds = nextNodeIndex <= treeLength;

            % If the node level for the next function node is 2 more than
            % the previousNodeLevel, then the next function node will be a
            % child of the current node selected.
            nextNodeLevel = previousNodeLevel + 2;
            flag = isInBounds && getFunctionLevel(obj, nextNodeIndex) == nextNodeLevel;
        end

        %% (Actions tab functions)
        function functionArgStruct = getFunctionArguments(obj, index)
            % Returns function input and output arguments and their
            % corresponding property values as a struct array.

            idx = getDataConverterFuncIndex(obj, index);
            functionArgStruct = accessDataProp(obj.DataConverter, "FuncArgStruct", idx);
        end

        function inputs = getFuncInputArgNames(obj, index)
            % Returns names of function input arguments as a string array.

            idx = getDataConverterFuncIndex(obj, index);

            inputs = string.empty;
            if ~isempty(idx)
                inputs = accessDataProp(obj.DataConverter, "InputArgNames", idx);
            end

            % Convert function input names to camelcase form to be used for the Activity Log table.
            if ~isempty(inputs)
                inputs = ividev.makeMATLABDriver.internal.camelcase(inputs);
            end
        end

        function outputs = getFuncOutputArgNames(obj, index)
            % Returns names of function output arguments as a string array.

            idx = getDataConverterFuncIndex(obj, index);

            outputs = string.empty;
            if ~isempty(idx)
                outputs = accessDataProp(obj.DataConverter, "Outputs", idx);
            end
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

        function dataType = getFuncArgDataType(~, functionArg)
            % Returns the data type for a function argument as a scalar string.

            dataType = functionArg.DataTypeID;
        end

        function name = getFuncArgName(~, functionArg)
            % Returns function argument name as a scalar string.

            name = functionArg.Label;
        end

        function defaultText = getFuncArgDefaultValue(~, functionArg) %#ok<INUSD>
            % Returns default value of function argument as a scalar string.

            defaultText = "";
        end

        function enums = getFuncArgEnumValues(~, functionArg)
            % Returns enum values for relevant function arguments as a
            % string array.

            % For testing: Replace custom NimSc MATLAB Driver name with
            % "NimScTestDriver".
            nimScIndexArray = contains(split(functionArg.EnumValues, "."), "NimSc");
            if any(nimScIndexArray)
                nimScStr = split(functionArg.EnumValues, ".");
                nimScStr(nimScIndexArray) = "NimScTestDriver";
                functionArg.EnumValues = join(nimScStr, ".");
            end

            [~, s] = enumeration(functionArg.EnumValues);
            enums = string(s)';
        end

        function defaultEnumVal = getFuncArgDefaultEnumValue(obj, functionArg)
            % Returns default enum value for function argument as a scalar
            % string.

            if functionArg.DataTypeID == "logical"
                defaultEnumVal = "VI_FALSE";
                return
            end

            enums = getFuncArgEnumValues(obj, functionArg);
            defaultEnumVal = enums(1);
        end

        %% (Help functions)
        function help = getFunctionGroupHelp(obj, index)
            % Returns the help text for the function group indexed
            % currently as a scalar string.

            funcTreeData = getFunctionMetaData(obj);
            help = funcTreeData(index).HelpText;
        end

        function help = getFunctionHelp(obj, index)
            % Returns the help text for the function indexed currently as a
            % scalar string.

            idx = getDataConverterFuncIndex(obj, index);
            help = accessDataProp(obj.DataConverter, "HelpText", idx);
        end

        function [exampleDescription, examples] = getFunctionMatlabExamples(obj, index)
            % Returns the m-help example code and example description for
            % the function indexed currently as string arrays.

            idx = getDataConverterFuncIndex(obj, index);
            examples = accessDataProp(obj.DataConverter, "MatlabExamples", idx);
            exampleDescription = accessDataProp(obj.DataConverter, "MatlabExampleDescription", idx);
        end

        function help = getFuncArgHelp(~, functionArg)
            % Returns the help text for the function argument indexed
            % currently as a scalar string.

            help = functionArg.HelpText;
        end
    end

    %% Abstract method implementations for Sub data
    methods
        function structData = getPropertyMetaData(obj)
            % Returns driver's property meta data as a struct array.

            % First-time initialization
            if isempty(obj.PropertyMetaData)
                structData = obj.DataConverter.DriverPropData;
                obj.PropertyMetaData = structData;
            else
                structData = obj.PropertyMetaData;
            end
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

        function [exampleDescription, examples] = getAttributeIdentifierExamples(obj, nodeData)
            % Returns the m-help example code and example description for
            % the property indexed currently as string arrays.

            examples = string.empty;
            exampleDescription = string.empty;

            exampleForm = obj.DataConverter.PropMExampleForm;
            idx = find(nodeData.Name == string({exampleForm.PropName}), 1, "first");

            % No matching name => no example
            if isempty(idx)
                return
            end

            % No matching parent name => no example
            if nodeData.ParentNodeName ~= exampleForm(idx).ParentNodeName
                return
            end

            % Matching example
            examples = exampleForm(idx).MatlabExamples;
            exampleDescription = exampleForm(idx).MatlabExampleDescription;
        end

        function structData = getAttributeIdentifiers(obj, classIdentifier)
            % Returns list of attribute identifiers (properties) for the
            % selected class identifier (property group) as a struct array.

            attributeIdentifiers = classIdentifier.AttributeIdentifier;
            structData = getStructData(obj.DataConverter, attributeIdentifiers);
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
            structData = getStructData(obj.DataConverter, classIdentifiers);
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
        function data = getDynamicRepeatedCapabilities(obj)
            % Returns dynamic repeated capabilities from sub data as a
            % struct array.

            data = obj.DataConverter.DynamicRepCapMetaData;
        end

        function data = getStaticRepeatedCapabilities(obj)
            % Returns static repeated capabilities from sub data as a
            % struct array.

            data = obj.DataConverter.StaticRepCapMetaData;
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
                repCapIDs = dev.(repcapName);
                [repcaps, repCapIDToGetNameFcnMap] = mapRepCapData(obj, repcaps, repCapIDToGetNameFcnMap, repCapIDs, dynamicRCData, getNameFcn);
            end

            % Static rep cap data
            staticRepCapData = getStaticRepeatedCapabilities(obj);

            for staticRCData = staticRepCapData
                % Get the rep cap name of each static repeated capability
                % from the sub parser data.
                repcapName = staticRCData.RepCapID;

                % Map each rep cap ID value for each rep cap name to the
                % corresponding rep cap name.
                [repcaps, repCapIDToGetNameFcnMap] = mapRepCapData(obj, repcaps, repCapIDToGetNameFcnMap, staticRCData.Names, staticRCData, repcapName);
            end

            % NESTED HELPER FUNCTIONS
            function [repcaps, repCapIDToGetNameFcnMap] = mapRepCapData(obj, repcaps, repCapIDToGetNameFcnMap, repCapIDs, repCapMetaData, repCapName)
                % Map each rep cap ID value for each rep cap name to the
                % corresponding getNameFcn or the corresponding rep cap
                % name.
                for id = repCapIDs
                    repcaps = unique([repcaps, id]);
                    updateCurrentRepCapIDKey(obj, repCapIDToGetNameFcnMap, id, repCapName);
                    storeRepCapOrAliasInMap(obj, repCapMetaData, repCapIDToGetNameFcnMap, id);
                    repCapIDToGetNameFcnMap(id) = unique(repCapIDToGetNameFcnMap(id));
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

            function storeRepCapOrAliasInMap(~, repCapMetaData, repCapIDToGetNameFcnMap, repCapID)
                % Store rep cap name in repCapID value to getNameFcn map.
                % Add alias to the map also if alias is different than the
                % rep cap name.
                name = repCapMetaData.RepCapID;
                alias = repCapMetaData.Alias;

                if name ~= ""
                    repCapIDToGetNameFcnMap(repCapID) = [repCapIDToGetNameFcnMap(repCapID), name];
                end

                if alias ~= "" && name ~= alias
                    repCapIDToGetNameFcnMap(repCapID) = [repCapIDToGetNameFcnMap(repCapID), alias];
                end
            end
        end
    end

    %% Helper function
    methods (Access = private)
        function idx = getDataConverterFuncIndex(obj, index)
            % Get the function or function group name index to retrieve
            % function information saved in the DataConverter.

            if obj.functionHasNoChild(index)
                fcnName = obj.getFunctionName(index);
            else
                fcnName = obj.getFunctionGroupName(index);
            end

            idx = find(string(accessDataProp(obj.DataConverter, "FuncName")) == fcnName);
        end
    end
end
