classdef ByteOrderUtility
    % This is a utility class that converts ByteOrder values from the
    % legacy format to the new format.

    % Copyright 2022 The MathWorks, Inc.

    methods (Static)
        function newByteOrder = convertByteOrder(byteOrder)
            % Check if byteOrder is a legacy value and if so then
            % convert to equivalent new values.
            arguments
                byteOrder (1, 1) string
            end

            newByteOrder = byteOrder;
            if strcmpi(byteOrder, 'bigEndian')
                newByteOrder = "big-endian";
            elseif strcmpi(byteOrder, 'littleEndian')
                newByteOrder = "little-endian";
            end
        end
    end

    %% Lifetime
    methods (Access = private)
        function obj = ByteOrderUtility()
            % Private constructor as utility class should not be
            % instantiated.
        end
    end
end