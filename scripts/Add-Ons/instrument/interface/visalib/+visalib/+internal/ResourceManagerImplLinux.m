classdef (Hidden) ResourceManagerImplLinux < visalib.internal.ResourceManagerImplBase
    %ResourceManagerImplLinux class for handling requests from the
    %ResourceManager on Linux. (Linux is not supported.)
    %
    %    This undocumented class may be removed in a future release.
    
    %    Copyright 2020 The MathWorks, Inc.

    methods
        function obj = ResourceManagerImplLinux()
            % Linux is not supported. Once support is added, see
            % ResourceManagerImplWindows as a template.
            id = "instrument:interface:visa:unsupportedPlatform";
            throwAsCaller(MException(id, getString(message(id))));
        end
    end
end


