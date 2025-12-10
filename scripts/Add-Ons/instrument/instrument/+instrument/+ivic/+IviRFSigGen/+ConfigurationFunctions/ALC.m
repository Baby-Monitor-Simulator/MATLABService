classdef ALC < instrument.ivic.IviGroupBase
    %ALC For generators with configurable Automatic Level
    %Control(ALC).
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureALC(obj,Source,Bandwidth)
            %CONFIGUREALC This function configures the ALC (Automatic
            %Level Control) of the signal generator's RF output.
            
            narginchk(3,3)
            Source = obj.checkScalarInt32Arg(Source);
            Bandwidth = obj.checkScalarDoubleArg(Bandwidth);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureALC', session, Source, Bandwidth);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
