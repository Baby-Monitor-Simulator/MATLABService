classdef (Hidden) ConflictManagerImplLinux < visalib.internal.ConflictManagerImplBase
    %ConflictManagerImplLinux class for handling requests from the
    %ConflictManager on Linux. (Linux is not supported.)
    %
    %    This undocumented class may be removed in a future release.
    
    %    Copyright 2020 The MathWorks, Inc.

    methods
        function obj = ConflictManagerImplLinux(conflictManagerPath)
            arguments
                % No linux support enabled (fill out the appropriate
                % library version when that's on the horizon).
                % conflictManagerPath = "libivivisa.so.<LIBRARYVERSION>";
                conflictManagerPath (1, 1) string %#ok<INUSA>
            end
            
            % Until support is provided, this value is ""; once support is
            % provided, remove this line
            conflictManagerPath = "";
            obj@visalib.internal.ConflictManagerImplBase(conflictManagerPath);
            obj.checkPlatform("glnxa64");
        end
    end
end


