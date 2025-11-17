classdef PulseModulation < instrument.ivic.IviGroupBase
    %PULSEMODULATION The IviRFSigGenModulatePulse Extension
    %Group supports signal generators that can apply pulse
    %modulation to the RF output signal. The user can enable or
    %disable pulse modulation, and specify the source and the
    %polarity of the modulating signal.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigurePulseModulationEnabled(obj,PulseModulationEnabled)
            %CONFIGUREPULSEMODULATIONENABLED This function configures
            %the signal generator to apply pulse modulation to the RF
            %output signal.
            
            narginchk(2,2)
            PulseModulationEnabled = obj.checkScalarBoolArg(PulseModulationEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigurePulseModulationEnabled', session, PulseModulationEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigurePulseModulationSource(obj,Source)
            %CONFIGUREPULSEMODULATIONSOURCE This function sets the
            %source for pulse modulation of the RF output signal.
            
            narginchk(2,2)
            Source = obj.checkScalarInt32Arg(Source);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigurePulseModulationSource', session, Source);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigurePulseModulationExternalPolarity(obj,ExternalPolarity)
            %CONFIGUREPULSEMODULATIONEXTERNALPOLARITY This function
            %specifies the polarity of the external source signal.
            
            narginchk(2,2)
            ExternalPolarity = obj.checkScalarInt32Arg(ExternalPolarity);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigurePulseModulationExternalPolarity', session, ExternalPolarity);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
