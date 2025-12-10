classdef PulseGenerator < instrument.ivic.IviGroupBase
    %PULSEGENERATOR This class contains sub-classes to
    %configure the pulse generator functionality of RFSigGens.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigurePulseExternalTrigger(obj,ExternalSlope,Delay)
            %CONFIGUREPULSEEXTERNALTRIGGER This function configures the
            %triggering of the pulse generator within the RF signal
            %generator.  This function specifies the external trigger
            %slope and the delay time for starting the pulse after the
            %trigger pulse.
            
            narginchk(3,3)
            ExternalSlope = obj.checkScalarInt32Arg(ExternalSlope);
            Delay = obj.checkScalarDoubleArg(Delay);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigurePulseExternalTrigger', session, ExternalSlope, Delay);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigurePulseInternalTrigger(obj,Period)
            %CONFIGUREPULSEINTERNALTRIGGER This function specifies the
            %time period (repetition rate) of the pulse generator when
            %using the internal trigger (free run) mode.
            
            narginchk(2,2)
            Period = obj.checkScalarDoubleArg(Period);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigurePulseInternalTrigger', session, Period);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigurePulse(obj,TriggerSource,PulseWidth,GatingEnabled)
            %CONFIGUREPULSE This function configures the trigger
            %source, pulse width, and gating enabled for the pulse
            %generator within the RF signal generator.
            
            narginchk(4,4)
            TriggerSource = obj.checkScalarInt32Arg(TriggerSource);
            PulseWidth = obj.checkScalarDoubleArg(PulseWidth);
            GatingEnabled = obj.checkScalarBoolArg(GatingEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigurePulse', session, TriggerSource, PulseWidth, GatingEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigurePulseDouble(obj,Enabled,Delay)
            %CONFIGUREPULSEDOUBLE This function sets the double pulse
            %state and delay for the pulse generator within the RF
            %signal generator.
            
            narginchk(3,3)
            Enabled = obj.checkScalarBoolArg(Enabled);
            Delay = obj.checkScalarDoubleArg(Delay);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigurePulseDouble', session, Enabled, Delay);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigurePulseOutput(obj,Polarity,Enabled)
            %CONFIGUREPULSEOUTPUT This function configures the output
            %and polarity of the pulse generator within the RF signal
            %generator.
            
            narginchk(3,3)
            Polarity = obj.checkScalarInt32Arg(Polarity);
            Enabled = obj.checkScalarBoolArg(Enabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigurePulseOutput', session, Polarity, Enabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
