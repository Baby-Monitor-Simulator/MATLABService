classdef Trigger < instrument.ivic.IviGroupBase
    %TRIGGER This class contains functions that configure the
    %trigger subsystem.  To configure the trigger subsystem,
    %first call the IviScope_ConfigureTrigger function.  Then
    %call the trigger configuration function that corresponds to
    %the trigger type you specify.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureTrigger(obj,TriggerType,TriggerHoldoffseconds)
            %CONFIGURETRIGGER This function configures the common
            %attributes of the trigger subsystem.  These attributes are
            %the trigger type and holdoff.  When you call
            %IviScope_ReadWaveform, IviScope_ReadWaveformMeasurement,
            %IviScope_ReadMinMaxWaveform, or
            %IviScope_InitiateAcquisition, the oscilloscope waits for a
            %trigger.  You specify the type of trigger for which the
            %oscilloscope waits with the Trigger Type parameter.  If the
            %oscilloscope requires multiple waveform acquisitions to
            %build a complete waveform, it waits for the length of time
            %you specify with the Holdoff parameter to elapse since the
            %previous trigger.  The oscilloscope then waits for the next
            %trigger.  Once the oscilloscope acquires a complete
            %waveform, it returns to the Idle state.  Notes:  (1) After
            %you call this function, you must call the trigger
            %configuration function that corresponds to the Trigger Type
            %you select to completely specify the trigger.  For example,
            %if you set the Trigger Type to IVISCOPE_VAL_EDGE_TRIGGER,
            %you use the IviScope_ConfigureEdgeTriggerSource function to
            %completely specify the trigger.
            
            narginchk(3,3)
            TriggerType = obj.checkScalarInt32Arg(TriggerType);
            TriggerHoldoffseconds = obj.checkScalarDoubleArg(TriggerHoldoffseconds);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviScope_ConfigureTrigger', session, TriggerType, TriggerHoldoffseconds);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureTriggerCoupling(obj,TriggerCoupling)
            %CONFIGURETRIGGERCOUPLING This function configures the
            %trigger coupling.
            
            narginchk(2,2)
            TriggerCoupling = obj.checkScalarInt32Arg(TriggerCoupling);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviScope_ConfigureTriggerCoupling', session, TriggerCoupling);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureTriggerModifier(obj,TriggerModifier)
            %CONFIGURETRIGGERMODIFIER This function configures the
            %trigger modifier.  The trigger modifier determines the
            %oscilloscope's behavior in the absence of the configured
            %trigger.  Notes:  (1) This function is part of the
            %IviScopeTriggerModifier [TM] extension group.
            
            narginchk(2,2)
            TriggerModifier = obj.checkScalarInt32Arg(TriggerModifier);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviScope_ConfigureTriggerModifier', session, TriggerModifier);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureEdgeTriggerSource(obj,TriggerSource,TriggerLevelvolts,TriggerSlope)
            %CONFIGUREEDGETRIGGERSOURCE This function configures the
            %edge trigger.  An edge trigger occurs when the trigger
            %signal passes through the voltage threshold that you
            %specify with the Trigger Level parameter and has the slope
            %that you specify with the Trigger Slope parameter.
            %Notes:  (1) This function affects instrument behavior only
            %if the trigger type is IVISCOPE_VAL_EDGE_TRIGGER.  Call the
            %IviScope_ConfigureTrigger and
            %IviScope_ConfigureTriggerCoupling functions to set the
            %trigger type and trigger coupling before calling this
            %function.  (2) If the trigger source is one of the analog
            %input channels, you must configure the vertical range,
            %vertical offset, vertical coupling, probe attenuation, and
            %the maximum input frequency before calling this function.
            
            narginchk(4,4)
            TriggerSource = obj.checkScalarStringArg(TriggerSource);
            TriggerLevelvolts = obj.checkScalarDoubleArg(TriggerLevelvolts);
            TriggerSlope = obj.checkScalarInt32Arg(TriggerSlope);
            try
                [libname, session ] = obj.getLibraryAndSession();
                TriggerSource = [double(TriggerSource) 0];
                
                status = calllib( libname,'IviScope_ConfigureEdgeTriggerSource', session, TriggerSource, TriggerLevelvolts, TriggerSlope);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureTVTriggerSource(obj,TriggerSource,TVSignalFormat,TVEvent,TriggerPolarity)
            %CONFIGURETVTRIGGERSOURCE This function configures the
            %oscilloscope for TV triggering. It configures the TV signal
            %format, the event and the signal polarity.  Notes:  (1)
            %This function affects instrument behavior only if the
            %trigger type is IVISCOPE_VAL_TV_TRIGGER. Call the
            %IviScope_ConfigureTrigger and
            %IviScope_ConfigureTriggerCoupling functions to set the
            %trigger type and trigger coupling before calling this
            %function.  (2) This function is part of the
            %IviScopeTVTrigger [TV] extension group.
            
            narginchk(5,5)
            TriggerSource = obj.checkScalarStringArg(TriggerSource);
            TVSignalFormat = obj.checkScalarInt32Arg(TVSignalFormat);
            TVEvent = obj.checkScalarInt32Arg(TVEvent);
            TriggerPolarity = obj.checkScalarInt32Arg(TriggerPolarity);
            try
                [libname, session ] = obj.getLibraryAndSession();
                TriggerSource = [double(TriggerSource) 0];
                
                status = calllib( libname,'IviScope_ConfigureTVTriggerSource', session, TriggerSource, TVSignalFormat, TVEvent, TriggerPolarity);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureTVTriggerLineNumber(obj,LineNumber)
            %CONFIGURETVTRIGGERLINENUMBER This function configures the
            %TV line upon which the oscilloscope triggers.  The line
            %number is absolute and not relative to the field of the TV
            %signal.  Notes:  (1) This function affects instrument
            %behavior only if the trigger type is set to
            %IVISCOPE_VAL_TV_TRIGGER and the TV trigger event is set to
            %IVISCOPE_VAL_TV_EVENT_LINE_NUMBER.  Call the
            %IviScope_ConfigureTrigger and the
            %IviScope_ConfigureTVTriggerSource functions to set the
            %trigger type and TV trigger event before calling this
            %function.  (2) This function is part of the
            %IviScopeTVTrigger [TV] extension group.
            
            narginchk(2,2)
            LineNumber = obj.checkScalarInt32Arg(LineNumber);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviScope_ConfigureTVTriggerLineNumber', session, LineNumber);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureRuntTriggerSource(obj,TriggerSource,RuntLowThresholdvolts,RuntHighThresholdvolts,RuntPolarity)
            %CONFIGURERUNTTRIGGERSOURCE This function configures the
            %runt trigger.  A runt trigger occurs when the trigger
            %signal crosses one of the runt thresholds twice without
            %crossing the other runt threshold.  You specify the runt
            %thresholds with the  Runt Low Threshold and Runt High
            %Threshold parameters.  You specify the polarity of the runt
            %with the Runt Polarity parameter.  Notes:  (1)  This
            %function affects instrument behavior only if the trigger
            %type is IVISCOPE_VAL_RUNT_TRIGGER.  Call the
            %IviScope_ConfigureTrigger and
            %IviScope_ConfigureTriggerCoupling functions to set the
            %trigger type and trigger coupling before calling this
            %function.  (2) This function is part of the
            %IviScopeRuntTrigger [RT] extension group.
            
            narginchk(5,5)
            TriggerSource = obj.checkScalarStringArg(TriggerSource);
            RuntLowThresholdvolts = obj.checkScalarDoubleArg(RuntLowThresholdvolts);
            RuntHighThresholdvolts = obj.checkScalarDoubleArg(RuntHighThresholdvolts);
            RuntPolarity = obj.checkScalarInt32Arg(RuntPolarity);
            try
                [libname, session ] = obj.getLibraryAndSession();
                TriggerSource = [double(TriggerSource) 0];
                
                status = calllib( libname,'IviScope_ConfigureRuntTriggerSource', session, TriggerSource, RuntLowThresholdvolts, RuntHighThresholdvolts, RuntPolarity);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureGlitchTriggerSource(obj,TriggerSource,TriggerLevelvolts,GlitchWidthseconds,GlitchPolarity,GlitchCondition)
            %CONFIGUREGLITCHTRIGGERSOURCE This function configures the
            %glitch trigger.  A glitch trigger occurs when the trigger
            %signal has a pulse with a width that is less than the
            %glitch width.  You specify the glitch width in the Glitch
            %Width parameter.  You specify the polarity of the pulse
            %with the Glitch Polarity parameter.  The trigger does not
            %actually occur until the edge of a pulse that corresponds
            %to the Glitch Width and Glitch Polarity crosses the
            %threshold you specify in the Trigger Level parameter.
            %Notes:  (1)  This function affects instrument behavior only
            %if the trigger type is IVISCOPE_VAL_GLITCH_TRIGGER. Call
            %the IviScope_ConfigureTrigger and
            %IviScope_ConfigureTriggerCoupling functions to set the
            %trigger type and trigger coupling before calling this
            %function.  (2) This function is part of the
            %IviScopeGlitchTrigger [GT] extension group.
            
            narginchk(6,6)
            TriggerSource = obj.checkScalarStringArg(TriggerSource);
            TriggerLevelvolts = obj.checkScalarDoubleArg(TriggerLevelvolts);
            GlitchWidthseconds = obj.checkScalarDoubleArg(GlitchWidthseconds);
            GlitchPolarity = obj.checkScalarInt32Arg(GlitchPolarity);
            GlitchCondition = obj.checkScalarInt32Arg(GlitchCondition);
            try
                [libname, session ] = obj.getLibraryAndSession();
                TriggerSource = [double(TriggerSource) 0];
                
                status = calllib( libname,'IviScope_ConfigureGlitchTriggerSource', session, TriggerSource, TriggerLevelvolts, GlitchWidthseconds, GlitchPolarity, GlitchCondition);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureWidthTriggerSource(obj,TriggerSource,TriggerLevelvolts,WidthLowThresholdseconds,WidthHighThresholdseconds,WidthPolarity,WidthCondition)
            %CONFIGUREWIDTHTRIGGERSOURCE This function configures the
            %width trigger.  A width trigger occurs when the
            %oscilloscope detects a positive or negative pulse with a
            %width between, or optionally outside, the width thresholds.
            % You specify the width thresholds with the Width Low
            %Threshold and Width High Threshold parameters.  You specify
            %whether the oscilloscope triggers on pulse widths that are
            %within or outside the width thresholds with the Width
            %Condition parameter.  You specify the polarity of the pulse
            %with the Width Polarity parameter.  The trigger does not
            %actually occur until the edge of a pulse that corresponds
            %to the Width Low Threshold, Width High Threshold, Width
            %Condition, and Width Polarity crosses the threshold you
            %specify in the Trigger Level parameter.  Notes:  (1) This
            %function affects instrument behavior only if the trigger
            %type is IVISCOPE_VAL_WIDTH_TRIGGER. Call the
            %IviScope_ConfigureTrigger and
            %IviScope_ConfigureTriggerCoupling functions to set the
            %trigger type and trigger coupling before calling this
            %function.  (2) This function is part of the
            %IviScopeWidthTrigger [WT] extension group.
            
            narginchk(7,7)
            TriggerSource = obj.checkScalarStringArg(TriggerSource);
            TriggerLevelvolts = obj.checkScalarDoubleArg(TriggerLevelvolts);
            WidthLowThresholdseconds = obj.checkScalarDoubleArg(WidthLowThresholdseconds);
            WidthHighThresholdseconds = obj.checkScalarDoubleArg(WidthHighThresholdseconds);
            WidthPolarity = obj.checkScalarInt32Arg(WidthPolarity);
            WidthCondition = obj.checkScalarInt32Arg(WidthCondition);
            try
                [libname, session ] = obj.getLibraryAndSession();
                TriggerSource = [double(TriggerSource) 0];
                
                status = calllib( libname,'IviScope_ConfigureWidthTriggerSource', session, TriggerSource, TriggerLevelvolts, WidthLowThresholdseconds, WidthHighThresholdseconds, WidthPolarity, WidthCondition);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureAcLineTriggerSlope(obj,TriggerSlope)
            %CONFIGUREACLINETRIGGERSLOPE This function configures the
            %slope of the AC Line trigger.  Notes:  (1) This function
            %affects instrument behavior only if the trigger type is
            %IVISCOPE_VAL_AC_LINE_TRIGGER. Call the
            %IviScope_ConfigureTrigger function to set the trigger type
            %before calling this function.  (2) This function is part of
            %the IviScopeAcLineTrigger [AT] extension group.
            
            narginchk(2,2)
            TriggerSlope = obj.checkScalarInt32Arg(TriggerSlope);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviScope_ConfigureAcLineTriggerSlope', session, TriggerSlope);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
