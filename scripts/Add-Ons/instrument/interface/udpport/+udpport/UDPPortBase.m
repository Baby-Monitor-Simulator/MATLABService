classdef (Abstract) UDPPortBase < matlabshared.testmeas.internal.mixins.CacheEnabler & ...
        matlabshared.transportlib.internal.TagAccessor & ...
        matlab.mixin.Heterogeneous
    %UDPPORTBASE class is the common parent class for both the UDP Byte and
    % Datagram classes. As a result of inheriting this class, both UDP Byte
    % and Datagram classes
    %
    % 1. Can be included in an array together, i.e. an array with both UDP
    % Byte and UDP Datagram objects is possible.
    %
    % 2. Have the "Tag" property.
    %
    % 3. Have the ability to be cached and later retrieved with the
    % "udpportfind" function.

    %   Copyright 2023 The MathWorks, Inc.

    properties (Constant, Hidden)
        ObjectType = "udpport"
    end

    methods (Access=protected)
        function parseNVPairForTag(obj, varargin)
            % Parses the NV pairs for the tag property for UDP. NOTE - this
            % function expects the NV pairs to be passed in as pairs.

            p = inputParser;
            p.KeepUnmatched = true;
            addParameter(p, 'Tag', "", @(x) isstring(x) || ischar(x));
            parse(p, varargin{:});

            output = p.Results;
            obj.Tag = output.Tag;
        end
    end
end
