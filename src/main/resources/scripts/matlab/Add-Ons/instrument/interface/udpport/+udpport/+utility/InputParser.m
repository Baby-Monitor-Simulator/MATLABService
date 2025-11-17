classdef InputParser
    %INPUTPARSER parses the udpport constructor inputs and returns the
    %udpport Type, IPAddressVersion, and the NV pairs. This parses 2
    %optional arguments - Type("byte", "datagram") and IPAddressVersion
    %("IPV4", "IPV6"), and NV pairs. This parsing of 2 optional arguments
    %could not be done by MATLAB's inputParser.

    %   Copyright 2020-2023 The MathWorks, Inc.

    properties (Constant)
        NVPairNames = ["LocalHost" "LocalPort" "Timeout" ...
                "ByteOrder" "OutputDatagramSize" "EnablePortSharing", "Tag"]
    end

    methods (Static)
        function [mode, addressType, allNVPairs] = parse(varargin)
            % Parse the udpport constructor inputs to get the Type,
            % IPAddressVersion and NV pairs.

            mode = "";
            addressType = "";
            nvPairStartIndex = [];

            % Default constructor
            if nargin == 0
               mode = "byte";
               addressType = "IPV4";
               allNVPairs = {};
               return
            end
            if nargin >= 1
                try
                    % The first argument needs to be either "byte",
                    % "datagram", "IPV4", "IPV6", or an NV pair name.
                    possibleFirstArgumentValues = ...
                        ["byte", "datagram", "IPV4", "IPV6", udpport.utility.InputParser.NVPairNames];
                    varargin{1} = validatestring(varargin{1}, possibleFirstArgumentValues, "", "", 1);
                catch ex
                    throwAsCaller(ex);
                end

                % Get the mode value from the first argument. Check if the
                % first index is an NV pair.
                [mode, nvPairStartIndex] = udpport.utility.InputParser.queryFirstArgument(string(varargin{1}));

                % For nargin == 1, we can decipher the address type from the
                % first argument. This also means that there are no NV
                % pairs passed in.
                if nargin == 1
                    addressType = udpport.utility.InputParser.getAddressType(string(varargin{1}));
                end
            end
            if nargin >= 2
                if ischar(varargin{2}) || isstring(varargin{2})
                    % Query the second argument. Could be the
                    % IPAddressVersion or the name of an NV pair.
                    [addressType, nvPairStartIndex] = ...
                        udpport.utility.InputParser.querySecondArgument(string(varargin{2}), nvPairStartIndex, string(varargin{1}));
                else
                    % This means that the first argument needs to be a name
                    % of an NV pair, meaning, nvPairStartIndex needs to be
                    % already set. Set the addresstype to "IPV4"
                    if isempty(nvPairStartIndex)
                        throwAsCaller(MException(message("instrument:interface:udpport:IncorrectSecondArgument")));
                    end
                    addressType = "IPV4";
                end
            end
            % Get NV Pairs and create the UDPPort object.
            allNVPairs = udpport.utility.InputParser.getPossibleNVPairs(varargin, nvPairStartIndex);
        end
    end

    methods(Static, Access = private)
        %% Argument validation methods

        function [mode, nvPairStartIndex] = queryFirstArgument(data)
            % Get the mode from the first argument.
            data = instrument.internal.stringConversionHelpers.str2char(data);
            nvPairStartIndex = [];
            switch lower(data)
                case 'datagram'
                    mode = "datagram";
                case 'byte'
                    mode = "byte";
                case {'ipv4' 'ipv6'}
                    mode = "byte";

                    % The first argument can also be one of the names of
                    % the NV pairs
                case lower(cellstr(udpport.utility.InputParser.NVPairNames))
                    mode = "byte";
                    nvPairStartIndex = 1;
            end
        end

        function [addressType, nvPairStartIndex] = ...
                querySecondArgument(secondArgument, nvPairStartIndex, firstArgument)
            % Parse the second argument. The second argument can be "IPV4",
            % "IPV6", the name or a value of an NV Pair.

            % If nvPairStartIndex is not empty, this means that NV Pair
            % starts at index 1. No IPAddressVersion or Type was provided.
            % Set the default IPAddressVersion, type was already set above.
            if nvPairStartIndex == 1
                addressType = "IPV4";
                return
            end

            try
                % Check whether the second argument is "IPV4" or "IPV6"
                secondArgument = validatestring(secondArgument, ["IPV4", "IPV6"]);

                % If second argument was either ["IPV4", "IPV6"], that
                % implies that the first argument must be "byte" or
                % "datagram". Error otherwise.
                udpport.utility.InputParser.validateByteOrDatagram(firstArgument);
                addressType = secondArgument;
                return
            catch ex
                % For string matches that could not be deciphered (like
                % "IPV"), or when the first argument was not "byte" or
                % "datagram", throw the error.
                if string(ex.identifier) == "MATLAB:ambiguousStringChoice" ...
                        || string(ex.identifier) == "instrument:interface:udpport:IncorrectFirstArgument"
                    throwAsCaller(ex);
                end
            end
            try
                % If we reached here, this means that the second argument
                % has to be a name of the NV pair. Check for names in NV
                % pair
                validatestring(secondArgument, udpport.utility.InputParser.NVPairNames, "", "", 2);

                % Get the address type from the first argument
                addressType = udpport.utility.InputParser.getAddressType(string(firstArgument));
                nvPairStartIndex = 2;
            catch ex
                throwAsCaller(ex);
            end
        end

        function validateByteOrDatagram(firstArgument)
            % For the second argument to be "IPV4" or "IPV6", validate that
            % the first argument is "byte" or "datagram". Error otherwise.

            try
                validatestring(firstArgument, ["byte", "datagram"]);
            catch ex
                throwAsCaller(MException(message("instrument:interface:udpport:IncorrectFirstArgument")));
            end
        end

        function addressType = getAddressType(data)
            % Get the address type from the first argument
            data = instrument.internal.stringConversionHelpers.str2char(data);
            switch lower(data)
                case {'byte' 'datagram' 'ipv4'}
                    addressType = "IPV4";
                case 'ipv6'
                    addressType = "IPV6";
                    %If nargin == 1, and it is an NV pair, error.
                case lower(cellstr(udpport.utility.InputParser.NVPairNames))
                    throwAsCaller(MException(message("instrument:interface:udpport:UnmatchedPVPairs")));
            end
        end
    end

    methods(Static, Access = private)
        function possibleNVPairs = getPossibleNVPairs(values, nvPairStartIndex)
            % From the nvPairStartIndex value, prepare the list of NV
            % pairs.
            possibleNVPairs = {};

            if isempty(nvPairStartIndex) && length(values) > 2
                nvPairStartIndex = 3;
            end
            if ~isempty(nvPairStartIndex)
                possibleNVPairs = values(nvPairStartIndex:end);
            end
        end
    end
end
