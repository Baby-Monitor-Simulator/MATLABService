classdef Sweep < instrument.ivic.IviGroupBase
    %SWEEP This class contains functions and sub-classes to
    %configure the different sweep functionalities of the
    %RFSigGen.  The IviRFSigGenSweep extension group supports
    %signal generators with the ability to sweep (or step) the
    %frequency or the power of the RF output signal.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureSweep(obj,Mode,TriggerSource)
            %CONFIGURESWEEP This function configures the signal
            %generator sweep mode and trigger source.
            
            narginchk(3,3)
            Mode = obj.checkScalarInt32Arg(Mode);
            TriggerSource = obj.checkScalarInt32Arg(TriggerSource);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureSweep', session, Mode, TriggerSource);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureFrequencySweepStartStop(obj,Start,Stop)
            %CONFIGUREFREQUENCYSWEEPSTARTSTOP This function configures
            %the start and stop frequencies for a frequency sweep. If
            %the stop frequency is less than the start frequency, the
            %frequency decreases during the sweep
            
            narginchk(3,3)
            Start = obj.checkScalarDoubleArg(Start);
            Stop = obj.checkScalarDoubleArg(Stop);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureFrequencySweepStartStop', session, Start, Stop);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureFrequencySweepCenterSpan(obj,Center,Span)
            %CONFIGUREFREQUENCYSWEEPCENTERSPAN This function configures
            %the center frequency and span for a frequency sweep. This
            %function modifies the start and stop attributes as follows:
            % IVIRFSIGGEN_ATTR_FREQUENCY_STEP_START = Center - Span / 2
            %IVIRFSIGGEN_ATTR_FREQUENCY_STEP_STOP  = Center + Span / 2
            
            narginchk(3,3)
            Center = obj.checkScalarDoubleArg(Center);
            Span = obj.checkScalarDoubleArg(Span);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureFrequencySweepCenterSpan', session, Center, Span);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureFrequencySweepTime(obj,Time)
            %CONFIGUREFREQUENCYSWEEPTIME This function configures the
            %duration of one frequency sweep.
            
            narginchk(2,2)
            Time = obj.checkScalarDoubleArg(Time);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureFrequencySweepTime', session, Time);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigurePowerSweepStartStop(obj,Start,Stop)
            %CONFIGUREPOWERSWEEPSTARTSTOP This function configures the
            %start and stop power for a power sweep. If the stop power
            %is less than the start power, the power decreases in value
            %during the sweep.
            
            narginchk(3,3)
            Start = obj.checkScalarDoubleArg(Start);
            Stop = obj.checkScalarDoubleArg(Stop);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigurePowerSweepStartStop', session, Start, Stop);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigurePowerSweepTime(obj,Time)
            %CONFIGUREPOWERSWEEPTIME This function configures the
            %duration of one power sweep.
            
            narginchk(2,2)
            Time = obj.checkScalarDoubleArg(Time);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigurePowerSweepTime', session, Time);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureFrequencyStepStartStop(obj,Start,Stop,Scaling,StepSize)
            %CONFIGUREFREQUENCYSTEPSTARTSTOP This function configures
            %the settings that control the step frequencies of the
            %generator's RF output signal. These settings are start and
            %stop frequency, step size, and lin/log scaling. If the stop
            %frequency is less than the start frequency, the frequency
            %decreases during the sweep.
            
            narginchk(5,5)
            Start = obj.checkScalarDoubleArg(Start);
            Stop = obj.checkScalarDoubleArg(Stop);
            Scaling = obj.checkScalarInt32Arg(Scaling);
            StepSize = obj.checkScalarDoubleArg(StepSize);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureFrequencyStepStartStop', session, Start, Stop, Scaling, StepSize);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureFrequencyStepDwell(obj,SingleEnabled,Dwell)
            %CONFIGUREFREQUENCYSTEPDWELL This function configures how
            %the frequency sweep advances.
            
            narginchk(3,3)
            SingleEnabled = obj.checkScalarBoolArg(SingleEnabled);
            Dwell = obj.checkScalarDoubleArg(Dwell);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureFrequencyStepDwell', session, SingleEnabled, Dwell);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ResetFrequencyStep(obj)
            %RESETFREQUENCYSTEP This function resets the current
            %frequency step to the frequency step start value.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ResetFrequencyStep', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigurePowerStepStartStop(obj,Start,Stop,StepSize)
            %CONFIGUREPOWERSTEPSTARTSTOP This function configures the
            %settings that control the power steps of the generator's RF
            %output signal. These settings are start and stop power and
            %step size. If the stop power is less than the start power,
            %the power decreases in value during the sweep
            
            narginchk(4,4)
            Start = obj.checkScalarDoubleArg(Start);
            Stop = obj.checkScalarDoubleArg(Stop);
            StepSize = obj.checkScalarDoubleArg(StepSize);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigurePowerStepStartStop', session, Start, Stop, StepSize);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigurePowerStepDwell(obj,SingleEnabled,Dwell)
            %CONFIGUREPOWERSTEPDWELL This function configures how the
            %power sweep advances.
            
            narginchk(3,3)
            SingleEnabled = obj.checkScalarBoolArg(SingleEnabled);
            Dwell = obj.checkScalarDoubleArg(Dwell);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigurePowerStepDwell', session, SingleEnabled, Dwell);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ResetPowerStep(obj)
            %RESETPOWERSTEP This function resets the current power step
            %to the power step start value.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ResetPowerStep', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
