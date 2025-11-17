classdef (Abstract) IMetaDataAdapter < handle
    %IMETADATAADAPTER interface specifies methods that will be implemented
    % by adapter classes to return meta data information for a driver.

    % Copyright 2023-2024 The MathWorks, Inc.

    %% Abstract properties that hold function and property meta data
    properties (Abstract)
        FunctionMetaData (1, :) struct
        PropertyMetaData (1, :) struct
    end

    %% Abstract methods - General purpose
    methods (Abstract)
        % This method retrieves the driver name.
        driver = getDriverName(obj);
    end

    %% Abstract methods that should return driver function data.
    methods (Abstract)
        % Returns driver's function meta data as a struct array.
        funcMetaData = getFunctionMetaData(obj);

        % Returns index of the first valid function in the
        % function/function group meta data as a scalar double.
        index = getFuncMetaDataStartIndex(obj);

        % Returns total number of functions as present in the function
        % meta data as a scalar double.
        numFunctions = getNumFunctions(obj);

        % Returns name of the indexed function in the function meta data as
        % a scalar string.
        funcName = getFunctionName(obj, index);

        % Returns name of the indexed function group in the function meta
        % data as a scalar string.
        funcGroupName = getFunctionGroupName(obj, index);

        % Returns the hierarchy level for the function in the function
        % meta data tree as a scalar double.
        level = getFunctionLevel(obj, index);

        % Returns true if function node indexed currently is a leaf
        % function node.
        flag = functionHasNoChild(obj, index);

        % Returns true if function node indexed previously is a parent
        % of function node indexed currently.
        flag = isPreviousFuncNodeParent(obj, level, indexOfCurrentNode);

        % Returns true if function node indexed next is a child
        % of function node indexed currently.
        flag = isNextFuncNodeChild(obj, level, indexOfCurrentNode);

        % Returns function input and output arguments and their
        % corresponding property values as a struct array.
        functionArgStruct = getFunctionArguments(obj, index);

        % Returns names of function input arguments as a string array.
        inputs = getFuncInputArgNames(obj, index);

        % Returns names of function output arguments as a string array.
        outputs = getFuncOutputArgNames(obj, index);

        % Returns function argument position in the list of function
        % arguments as a scalar double.
        paramPos = getFuncArgPosition(obj, functionArg);

        % Returns the type for a function argument as a scalar double.
        type = getFuncArgType(obj, functionArg);

        % Returns function argument name as a scalar string.
        name = getFuncArgName(obj, functionArg);

        % Returns default value of function argument as a scalar string.
        defaultText = getFuncArgDefaultValue(obj, functionArg);

        % Returns enum values for relevant function arguments as a string
        % array.
        enums = getFuncArgEnumValues(obj, functionArg);

        % Returns default enum value for function argument as a scalar
        % string.
        defaultEnumVal = getFuncArgDefaultEnumValue(obj, functionArg);

        % Returns the help text for the function group indexed currently as
        % a scalar string.
        help = getFunctionGroupHelp(obj, index);

        % Returns the help text for the function indexed currently as a
        % scalar string.
        help = getFunctionHelp(obj, index);

        % Returns the help text for the function argument indexed currently
        % as a scalar string.
        help = getFuncArgHelp(obj, functionArg);
    end

    %% Abstract methods that should return driver property data
    methods (Abstract)
        % Returns driver's property meta data as a struct array.
        propData = getPropertyMetaData(obj);

        % Returns name for the selected attribute identifier (property)
        % as a scalar string.
        name = getAttributeIdentifierName(obj, attributeIdentifier);

        % Returns access type for the selected attribute identifier
        % (property) as a scalar string.
        accessMode = getAttributeIdentifierAccessMode(obj, attributeIdentifier);

        % Returns Vi data type for the selected attribute identifier
        % (property) as a scalar string.
        visaType = getAttributeIdentifierVISAType(obj, attributeIdentifier);

        % Returns help text for the selected attribute identifier
        % (property) as a scalar string.
        help = getAttributeIdentifierHelp(obj, attributeIdentifier);

        % Returns list of attribute identifiers (properties) for the
        % selected class identifier (property group) as a struct array.
        structData = getAttributeIdentifiers(obj, classIdentifier);

        % Returns true if selected class identifier (property group)
        % contains any attribute identifiers (properties).
        flag = hasAttributeIdentifiers(obj, classIdentifier);

        % Returns name for the selected class identifier (property group)
        % as a scalar string.
        name = getClassIdentifierName(obj, classIdentifier);

        % Returns help text for the selected class identifier
        % (property group) as a scalar string.
        help = getClassIdentifierHelp(obj, classIdentifier);

        % Returns list of class identifiers (property groups) for the
        % selected class identifier (property group) as a struct array.
        structData = getClassIdentifiers(obj, classIdentifier);

        % Returns true if selected class identifier (property group)
        % contains any class identifiers (other property groups).
        flag = hasClassIdentifiers(obj, classIdentifier);

        % Returns repeated capability getNameFcn information associated
        % with the selected class identifier (property group) as a scalar
        % string.
        rcNames = getClassIdentifierRCNames(obj, classIdentifier);

        % Returns dynamic repeated capabilities from sub data as a
        % struct array.
        dynamicRC = getDynamicRepeatedCapabilities(obj);

        % Returns static repeated capabilities from sub data as a
        % struct array.
        staticRC = getStaticRepeatedCapabilities(obj);

        % Returns string array of repeated capability ID values and map
        % of repeated capability ID values with their corresponding
        % getNameFcn and/or Rep Cap name values.
        [repcaps, repCapIDToGetNameFcnMap] = getRepCaps(obj, dev);
    end
end