classdef ErrorProxyMixin < handle
    %ERRORPROXYMIXIN maps errorIDs of Driver Interface to corresponding
    %legacyICdevice errorIDs

    % Copyright 2024 The MathWorks, Inc.

    properties(Hidden)
        UseErrorProxy (1, 1) logical = true
    end

    properties(Constant)
        ExceptionsMap = containers.Map(...
            ["instrument_icdevice:driver:opfailed", ...
            "instrument_icdevice:driver:driverAlreadyConnected", ...
            "instrument:fopen:opfailed", ...
            "instrument_icdevice:driver:invalidOBJ", ...
            "instrument_icdevice:driver:nonexistentProperty", ...
            "instrument:fclose:opfailed",...
            "instrument_icdevice:driver:needRsrcObject",...
            "instrument_icdevice:driver:configStoreDriverNotFound", ...
            "instrument_icdevice:driver:typeNotSupported", ...
            "instrument:instrhelp:invalidSyntaxArgOne",...
            "instrument:instrhwinfo:invalidDriverName", ...
            "instrument:instrnotify:invalidSyntax", ...
            "instrument:instrnotify:invalidSyntaxArgv",...
            "instrument_icdevice:driver:needToConnect",...
            "instrument_icdevice:driver:nonexistentMethod",...
            "instrument_icdevice:driver:invalidProp",...
            "instrument_icdevice:driver:invokeInvalidSyntax",...
            "instrument_icdevice:driver:invokeInvalidArgName",...
            "instrument_icdevice:driver:invokeInvalidFcn",...
            "instrument_icdevice:driver:invokeGroupInvalidSyntax",...
            "instrument_icdevice:driver:invokeGroupInvalidArgName",...
            "instrument_icdevice:driver:invokeGroupInvalidFcn",...
            "instrument_icdevice:driver:executionErr",...
            "instrument_icdevice:driver:executionGroupErr",...
            "instrument_icdevice:driver:exceedingArgument",...
            "instrument_icdevice:driver:invalidArgumentFormat",...
            "instrument_icdevice:driver:invokeInvalidArgDim",...
            "instrument_icdevice:driver:unsupportedRepCapIdentier",...
            "instrument_icdevice:driver:ambiguousMatch",...
            "instrument_icdevice:driver:invalidNVPairs",...
            "instrument_icdevice:driver:unsupportedFileType",...
            ], ...
            {
            ["instrument:methods:invalidObj","instrument:icdevice:devicereset:opfailed", "instrument:connect:opfailed", "instrument:disconnect:opfailed", "instrument:get:invalidOBJ", "instrument:icgroup:get:invalidOBJ", "instrument:icdevice:geterror:opfailed", "instrument:icdevice:selftest:opfailed", "instrument:set:invalidOBJ", "instrument:propinfo:opfailed", "instrument:icgroup:propinfo:opfailed"], ... %'instrument_icdevice:driver:opfailed'
            "instrument:connect:opfailed", ... % 'instrument_icdevice:driver:driverAlreadyConnected'
            "instrument:connect:opfailed", ... % 'instrument:fopen:opfailed'
            ["instrument:icdevice:devicereset:invalidOBJ", "instrument:icdevice:geterror:invalidOBJ", "instrument:icdevice:invoke:invalidArgDim", "instrument:icdevice:selftest:invalidOBJ", "instrument:set:scalarHandle"], ... % 'instrument_icdevice:driver:invalidOBJ'
            ["instrument:get:invalidArg", "instrument:set:opfailed"],... % 'instrument_icdevice:driver:nonexistentProperty'
            "instrument:icdevice:icdevice:invalidobj",... % 'instrument:fclose:opfailed'
            "instrument:icdevice:icdevice:driverNotLoaded",... %'instrument_icdevice:driver:needRsrcObject'
            ["instrument:icdevice:icdevice:driverNotFound", "instrument:icdevice:icdevice:invalidType"],... %'instrument_icdevice:driver:configStoreDriverNotFound'
            "instrument:icdevice:icdevice:invalidDriver",... %'instrument_icdevice:driver:typeNotSupported'
            ["instrument:icgroup:instrhelp:invalidOBJ", "instrument:instrhelp:invalidOBJDim", "instrument:instrhelp:invalidArgFirst", "instrument:instrhelp:invalidArgSecond", "instrument:icgroup:instrhelp:invalidArgSecond", "instrument:instrhelp:invalidArgSecond", "instrument:instrhelp:invalidOBJ", "instrument:icgroup:instrhelp:invalidArgFirst"], ... % 'instrument:instrhelp:invalidSyntaxArgOne'
            ["instrument:instrhwinfo:invalidOBJFirst", "instrument:icgroup:instrhwinfo:invalidOBJDevice"], ... %'instrument:instrhwinfo:invalidDriverName'
            ["instrument:instrnotify:invalidArg", "instrument:instrnotify:invalidSyntaxObj"], ... %'instrument:instrnotify:invalidSyntax'
            ["instrument:instrnotify:invalidSyntaxType", "instrument:instrnotify:invalidArg"], ... %'instrument:instrnotify:invalidSyntaxArgv'
            ["instrument:icdevice:invoke:invalidState", "instrument:icgroup:invoke:invalidState", "instrument:icdevice:devicereset:opfailed", "instrument:icdevice:geterror:opfailed", "instrument:icdevice:selftest:opfailed"]...% 'instrument_icdevice:driver:needToConnect'
            ["instrument:icgroup:invoke:invalidArgName", "instrument:icgroup:invoke:invalidArgObj"],... % 'instrument_icdevice:driver:nonexistentMethod'
            ["instrument:icgroup:propinfo:opfailed", "instrument:propinfo:invalidPROPERTY", "instrument:icgroup:propinfo:opfailed","instrument:icgroup:propinfo:invalidPROPERTY"],...% 'instrument_icdevice:driver:invalidProp'
            "instrument:icdevice:invoke:invalidSyntax",... % instrument_icdevice:driver:invokeInvalidSyntax
            "instrument:icdevice:invoke:invalidArgName", ... % instrument_icdevice:driver:invokeInvalidArgName
            "instrument:icdevice:invoke:invalidFcn",... % instrument_icdevice:driver:invokeInvalidFcn
            "instrument:icgroup:invoke:invalidSyntax", ... % instrument_icdevice:driver:invokeGroupInvalidSyntax
            "instrument:icgroup:invoke:invalidArgName",...  % instrument_icdevice:driver:invokeGroupInvalidArgName
            "instrument:icgroup:invoke:invalidFcn",... % instrument_icdevice:driver:invokeGroupInvalidFcn
            "instrument:icdevice:invoke:executionErr",... % instrument_icdevice:driver:executionErr
            "instrument:icgroup:invoke:executionErr",... % instrument_icdevice:driver:executionGroupErr
            ["instrument:get:nolhswithvector", "instrument:set:nolhswithvector"],... % instrument_icdevice:driver:exceedingArgument
            "instrument:set:invalidPVPair",... % instrument_icdevice:driver:invalidArgumentFormat
            "instrument:icdevice:invoke:invalidArgDim",... % instrument_icdevice:driver:invokeInvalidArgDim
            "instrument:set:opfailed",... % instrument_icdevice:driver:unsupportedRepCapIdentier
            "instrument:set:opfailed",... % instrument_icdevice:driver:ambiguousMatch
            "instrument:set:opfailed",... % instrument_icdevice:driver:invalidNVPairs
            "instrument:icdevice:icdevice:driverNotFound",... % instrument_icdevice:driver:unsupportedFileType
            }...
            )
    end

    methods(Hidden)
        function ex = getMException(obj, ex, index)
            % Function returns a new MException object that corresponds to
            % a legacy error ID mapped from the original exception's
            % identifier. If the original exception's identifier is not a
            % key in 'obj.ExceptionsMap', the function returns without
            % modifying the exception.
            arguments
                obj 
                ex (1,1) MException
                index (1,1) double {mustBeGreaterThan(index,0),mustBeInteger} = 1
            end

            % Return the same MException if
            %
            % - UseErrorProxy flag is true (needed for unit-testing)
            %
            % - The input MException id did not match any of the keys of
            % the ErrorMap.
            if ~obj.UseErrorProxy || ~isKey(obj.ExceptionsMap, ex.identifier)
                return
            end

            errorIdToCheck = ex.identifier;
            finalMessage = ex.message;

            % Retrieve the exception message(s) string associated with the
            % errorKey
            legacyId = obj.ExceptionsMap(errorIdToCheck);

            % Check if the index is within the range of available messages
            if index > length(legacyId)
                throw(MException(message("instrument_icdevice:driver:indexOutOfBound")));
            end

            % Select the specific exception id using the provided index
            legacyId = legacyId{index};

            % Construct a new exception with the following attributes:
            %
            % - Error ID from the Legacy IC Device
            %
            % - Error message from the driver interface's corresponding
            % error ID
            ex = MException(legacyId, finalMessage);
        end
    end
end