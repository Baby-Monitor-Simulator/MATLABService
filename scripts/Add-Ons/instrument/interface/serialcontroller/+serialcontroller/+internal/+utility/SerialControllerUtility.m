classdef SerialControllerUtility
    % SERIALCONTROLLERUTILITY provides utilitites like platform validation
    % and returning asyncIO channel information for a particular vendor or mock.

    %   Copyright 2022 The MathWorks, Inc.

    %% Utility API
    methods (Static)
        function validatePlatform(vendor)
            % Throw an error if an attempt is made to use an unsupported
            % platform.
            arguments
                vendor serialcontroller.internal.utility.Vendor
            end

            if ~ispc
                switch vendor
                    case "ni845x"
                        throw(MException(message("instrument:interface:serialcontroller:UnsupportedPlatformNI845x")));
                    case "aardvark"
                        throw(MException(message("instrument:interface:serialcontroller:UnsupportedPlatformAardvark")));
                end
            end
        end

        function channelDetails = getChannelCreationInfo(vendor,serialNumber)
            % Returns the asyncIO channel details as a struct which will be
            % used to create an asyncIO channel.
            arguments
                vendor serialcontroller.internal.utility.Vendor
                serialNumber (1,1) string
            end

            % Choose asyncIO device type and adapter name based on vendor
            % input.
            switch vendor
                case "ni845x"
                    device = "ni845xdevice";
                    adapter = "NI845x";
                case "aardvark"
                    device = "aardvarkdevice";
                    adapter = "Aardvark";
                case "mock"
                    device = "mockdevice";
                    adapter = "MockAdapter";
            end

            % Create asyncIO channel struct
            devicePlugin = fullfile(toolboxdir(fullfile("instrument","interface","serialcontroller","bin",computer("arch"))),device);
            converterPlugin = fullfile(toolboxdir(fullfile("shared","testmeaslib","general","bin",computer("arch"))),"mdaconverter2x2");
            options = struct("Driver",adapter,"SerialNumber",serialNumber);
            channelDetails = struct("DevicePlugin",devicePlugin,"ConverterPlugin",converterPlugin,"Options",options);
        end

        function controllerList = createList(vendor,numInputArgs,functionName)
            % createList is used by controller list functions to return a
            % table of discovered controller information.
            arguments
                vendor serialcontroller.internal.utility.Vendor
                numInputArgs (1,1) double
                functionName (1,1) string
            end

            try
                serialcontroller.internal.utility.SerialControllerUtility.validatePlatform(vendor);
            catch ex
                throwAsCaller(ex);
            end

            serialcontroller.internal.utility.SerialControllerUtility.validateInput(numInputArgs,functionName);

            controllerList = table.empty();

            try
                % Create the Asyncio Channel
                channelDetails = serialcontroller.internal.utility.SerialControllerUtility.getChannelCreationInfo(vendor,"");
                channel = matlabshared.asyncio.internal.Channel(channelDetails.DevicePlugin,channelDetails.ConverterPlugin,Options = channelDetails.Options,StreamLimits = [inf,inf]);

                % Execute asyncIO command to find controllers.
                channel.execute("FindControllers");

                % Parse the discovered controller information.
                finalBoardInfo = serialcontroller.internal.utility.SerialControllerUtility.parseBoardInfo(vendor,channel);

                % Get the discovered controller information. Convert to expected table format.
                controllerList = struct2table(finalBoardInfo);
                controllerList.Properties.RowNames = string(1:height(controllerList))';
            catch ex
                % Looks for the error caught and throws appropriate error
                % based on that.
                serialcontroller.internal.utility.ErrorHandler.LookUpAndThrowError(ex);
            end
        end

        function paramValue = validateDoubleArrayParameterRanged(paramValue,min,max)
            % Validate and return double values in the range specified by min and max
            % values specified by the user.
            % Throw appropriate errors if the value is of a different data
            % type or if the value exceeds the range specified.
            try
                validateattributes(paramValue,"double",["2d","real","finite","nonnan"]);
            catch
                throwAsCaller(MException(message("instrument:interface:serialcontroller:InvalidWriteDataTypeDouble")));
            end

            paramValue = double(paramValue);

            if all(paramValue >= min) && all(paramValue <= max)
                return
            end

            if isscalar(paramValue)
                id = "instrument:interface:serialcontroller:InvalidDoubleTypeRanged";
            else
                id = "instrument:interface:serialcontroller:InvalidDoubleArrayValueRanged";
            end
            throwAsCaller(MException(message(id,num2str(min),num2str(max))));
        end

        function paramValue = validateSingleArrayParameterRanged(paramValue,min,max)
            % Validate and return single values in the range specified by min and max
            % values specified by the user.
            % Throw appropriate errors if the value is of a different data
            % type or if the value exceeds the range specified.
            try
                validateattributes(paramValue,["single","double"],["2d","real","finite","nonnan"]);
            catch
                throwAsCaller(MException(message("instrument:interface:serialcontroller:InvalidWriteDataTypeSingle")));
            end

            paramValue = double(paramValue);

            if all(paramValue >= min) && all(paramValue <= max)
                return
            end

            if isscalar(paramValue)
                id = "instrument:interface:serialcontroller:InvalidSingleTypeRanged";
            else
                id = "instrument:interface:serialcontroller:InvalidSingleArrayValueRanged";
            end
            throwAsCaller(MException(message(id,num2str(min),num2str(max))));
        end

        function paramValue = validateHexParameterRanged(paramName,paramValue,min,max)
            % Validate decimal or hexadecimal value in the range specified
            % by min and max values and return as decimal values.
            % Throw appropriate errors if the value is of a different data
            % type or if the value exceeds the range specified.
            if isnumeric(paramValue) && isscalar(paramValue)
                try
                    paramValue = serialcontroller.internal.utility.SerialControllerUtility.validateIntParameterRanged(paramName,paramValue,min,max);
                    return
                catch e
                    throwAsCaller(e);
                end
            end

            id = "instrument:interface:serialcontroller:InvalidIntValueRanged";

            if ischar(paramValue) || isstring(paramValue)
                tmpValue = char(paramValue);
                if length(tmpValue) ~= 1 && strcmpi(tmpValue(1:2),'0x')
                    tmpValue = tmpValue(3:end);
                end
                if ~isempty(tmpValue) && strcmpi(tmpValue(end),'h')
                    tmpValue(end) = [];
                end

                try
                    dec = hex2dec(tmpValue);
                catch
                    throwAsCaller(MException(message(id,paramName,num2str(min),num2str(max))));
                end

                if isempty(dec) || dec < min || dec > max
                    throwAsCaller(MException(message(id,paramName,num2str(min),num2str(max))));
                end

                paramValue = dec;
                return
            end

            throwAsCaller(MException(message(id,paramName,num2str(min),num2str(max))));
        end

        function paramValue = validateIntParameterRanged(paramName,paramValue,min,max)
            % Validate numeric integer value in the range specified by min
            % and max values.
            % Throw appropriate errors if the value is of a different data
            % type or if the value exceeds the range specified.
            try
                validateattributes(paramValue,["double","single","int8","uint8","int16","uint16","int32","uint32","int64","uint64"],["scalar","integer","real","finite","nonnan"]);
            catch
                throwAsCaller(MException(message("instrument:interface:serialcontroller:InvalidIntTypeRanged",paramName,num2str(min),num2str(max))));
            end

            paramValue = floor(paramValue);

            if paramValue >= min && paramValue <= max
                return
            end

            throwAsCaller(MException(message("instrument:interface:serialcontroller:InvalidIntValueRanged",paramName,num2str(min),num2str(max))));
        end

        function paramValue = validateIntArrayParameterRanged(paramName,paramValue,min,max)
            % Validate numeric integer value array in the range specified
            % by min and max values.
            % Throw appropriate errors if the value is of a different data
            % type or if the value exceeds the range specified.
            try
                validateattributes(paramValue,["double","single","int8","uint8","int16","uint16","int32","uint32","int64","uint64"],["2d","integer","real","finite","nonnan"]);
            catch
                throwAsCaller(MException(message("instrument:interface:serialcontroller:InvalidIntArrayTypeRanged",num2str(min),num2str(max))));
            end

            paramValue = floor(paramValue);

            if all(paramValue >= min) && all(paramValue <= max)
                return
            end

            if isscalar(paramValue)
                throwAsCaller(MException(message("instrument:interface:serialcontroller:InvalidIntValueRanged",paramName,num2str(min),num2str(max))));
            end
            throwAsCaller(MException(message("instrument:interface:serialcontroller:InvalidIntArrayValueRanged",num2str(min),num2str(max))));
        end
    end

    %% Helper functions
    methods (Static,Access = private)
        function finalBoardInfo = parseBoardInfo(vendor,channel)
            % Parses discovered controller information based on vendor type.

            if vendor == "ni845x"
                % Parse the discovered controller information to get
                % SerialNumber from USB resource string.

                finalBoardInfo = struct.empty;
                delimiter = "::";
                for b = channel.BoardInfo
                    splitStr = split(b.SerialNumber,delimiter);
                    b.SerialNumber = splitStr(4);
                    finalBoardInfo = [finalBoardInfo,b]; %#ok<AGROW>
                end
            else
                % Return discovered controller information as is for other
                % vendor controllers.
                finalBoardInfo = channel.BoardInfo;
            end
        end

        function validateInput(numInputArgs,functionName)
            % Validates number of input arguments for list functions.
            if numInputArgs  > 0
                throwAsCaller(MException(message("instrument:interface:serialcontroller:InvalidSyntaxListFcn",functionName)));
            end
        end
    end

    %% Lifetime
    methods (Access = private)
        function obj = SerialControllerUtility()
            % Private constructor as utility class should not be
            % instantiated.
        end
    end
end