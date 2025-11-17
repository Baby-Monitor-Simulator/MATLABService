classdef Factory
    %FACTORY creates and returns an instance of the byte type or datagram
    %type udpport object.

    %   Copyright 2020 The MathWorks, Inc.

    methods (Static)
        function udpportObj = getInstance(mode, addressType, varargin)
            % Based on the mode, return either a byte type or datagram type udpport
            % object.
            switch mode
                case "byte"
                    udpportObj = udpport.byte.UDPPort(addressType, varargin{:});
                case "datagram"
                    udpportObj = udpport.datagram.UDPPort(addressType, varargin{:});
            end
        end
    end
end