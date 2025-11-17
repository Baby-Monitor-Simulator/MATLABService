classdef Datagram
    %DATAGRAM is the class that is returned by the "read" method of the
    %udpport.Datagram class. This will contain the read data, the sender
    %address and the sender port.

    % Copyright 2020 The MathWorks, Inc.

    properties
        Data
        SenderAddress (1, 1) string
        SenderPort
    end

    methods
        function obj = Datagram(varargin)
            narginchk(0, 3);
            if nargin == 0
                return
            end

            if nargin < 3
                validSyntaxes = message("instrument:interface:udpport:DatagramSyntax").getString;
                throwAsCaller(MException(message("instrument:interface:udpport:IncorrectInputArgumentsPlural", ...
                    "udpport.datagram.Datagram", validSyntaxes)));
            end

            obj.Data = varargin{1};
            obj.SenderAddress = varargin{2};
            obj.SenderPort = varargin{3};
        end
    end
end