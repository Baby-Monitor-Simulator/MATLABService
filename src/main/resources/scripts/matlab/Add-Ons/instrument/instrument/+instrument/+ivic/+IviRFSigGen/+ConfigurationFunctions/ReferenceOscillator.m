classdef ReferenceOscillator < instrument.ivic.IviGroupBase
    %REFERENCEOSCILLATOR The IviRFSigGenReferenceOscillator
    %extension group supports signal generators with a
    %configurable frequency reference.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureReferenceOscillator(obj,Source,Frequency)
            %CONFIGUREREFERENCEOSCILLATOR This function configures the
            %signal generator's reference oscillator.
            
            narginchk(3,3)
            Source = obj.checkScalarInt32Arg(Source);
            Frequency = obj.checkScalarDoubleArg(Frequency);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureReferenceOscillator', session, Source, Frequency);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
