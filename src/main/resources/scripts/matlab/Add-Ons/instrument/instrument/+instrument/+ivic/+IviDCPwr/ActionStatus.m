classdef ActionStatus < instrument.ivic.IviGroupBase
    %ACTIONSTATUS This class contains functions that initiate
    %instrument operations and report their status.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function Initiate(obj)
            %INITIATE This function initiates output changes that you
            %previously specified.  After you call this function, the
            %power supply waits for the trigger you specify with the
            %IviDCPwr_ConfigureTriggerSource function.  After the power
            %supply detects the trigger, it updates its voltage level
            %and current limit to the values you specify with the
            %IviDCPwr_ConfigureTriggeredVoltageLevel and
            %IviDCPwr_ConfigureTriggeredCurrentLimit functions.  Notes:
            %(1) This function is part of the IviDCPwrTrigger [TRG]
            %extension group.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDCPwr_Initiate', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Abort(obj)
            %ABORT This function aborts all pending output changes.
            %Notes:  (1) This function is part of the IviDCPwrTrigger
            %[TRG] extension group.  (2) If you call this function after
            %calling the IviDCPwr_Initiate function, the power supply
            %ignores any trigger and does not change the output.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDCPwr_Abort', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SendSoftwareTrigger(obj)
            %SENDSOFTWARETRIGGER This function sends a command to
            %trigger the power supply.  Call this function if you
            %configure the power supply to respond to software triggers.
            % If the power supply is not configured to respond to
            %software triggers, this function returns the error
            %IVIDCPWR_ERROR_TRIGGER_NOT_SOFTWARE.  Notes:  (1) This
            %function is part of the IviDCPwrSoftwareTrigger [SWT]
            %extension group.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDCPwr_SendSoftwareTrigger', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function InState = QueryOutputState(obj,ChannelName,OutputState)
            %QUERYOUTPUTSTATE This function returns whether the power
            %supply is in a particular output state.  A constant voltage
            %condition occurs when the output voltage is equal to the
            %value of the IVIDCPWR_ATTR_VOLTAGE_LEVEL attribute and the
            %current is less than or equal to the value of the
            %IVIDCPWR_ATTR_CURRENT_LIMIT attribute.  A constant current
            %condition occurs when the output current is equal to the
            %value of the IVIDCPWR_ATTR_CURRENT_LIMIT attribute and the
            %IVIDCPWR_ATTR_CURRENT_LIMIT_BEHAVIOR attribute is set to
            %IVIDCPWR_VAL_CURRENT_REGULATE.  An unregulated condition
            %occurs when the output voltage is less than the value of
            %the IVIDCPWR_ATTR_VOLTAGE_LEVEL attribute and the current
            %is less than the value of the IVIDCPWR_ATTR_CURRENT_LIMIT
            %attribute.  An over-voltage condition occurs when the
            %output voltage is equal to or greater than the value of the
            %IVIDCPWR_ATTR_OVP_LIMIT attribute and the
            %IVIDCPWR_ATTR_OVP_ENABLED attribute is set to True.  An
            %over-current condition occurs when the output current is
            %equal to or greater than the value of the
            %IVIDCPWR_ATTR_CURRENT_LIMIT attribute and the
            %IVIDCPWR_ATTR_CURRENT_LIMIT_BEHAVIOR attribute is set to
            %IVIDCPWR_VAL_CURRENT_TRIP.    When either an over-voltage
            %condition or an over-current condition occurs, the power
            %supply's output protection disables the output.  If the
            %power supply is in an over-voltage or over-current state,
            %it does not produce power until the output protection is
            %reset.  The IviDCPwr_ResetOutputProtection function resets
            %the output protection.  Once the output protection is
            %reset, the power supply resumes generating a power signal.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            OutputState = obj.checkScalarInt32Arg(OutputState);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                InState = libpointer('uint16Ptr', 0);
                
                status = calllib( libname,'IviDCPwr_QueryOutputState', session, ChannelName, OutputState, InState);
                
                InState = InState.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function MaxCurrentLimit = QueryMaxCurrentLimit(obj,ChannelName,VoltageLevel)
            %QUERYMAXCURRENTLIMIT This function returns the maximum
            %programmable current limit that the power supply accepts
            %for a particular voltage level on a channel for the output
            %range to which the power supply is currently configured.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            VoltageLevel = obj.checkScalarDoubleArg(VoltageLevel);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                MaxCurrentLimit = libpointer('doublePtr', 0);
                
                status = calllib( libname,'IviDCPwr_QueryMaxCurrentLimit', session, ChannelName, VoltageLevel, MaxCurrentLimit);
                
                MaxCurrentLimit = MaxCurrentLimit.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function MaxVoltageLevel = QueryMaxVoltageLevel(obj,ChannelName,CurrentLimit)
            %QUERYMAXVOLTAGELEVEL This function returns the maximum
            %programmable voltage level that the power supply accepts
            %for a particular current limit on a channel for the output
            %range to which the power supply is currently configured.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            CurrentLimit = obj.checkScalarDoubleArg(CurrentLimit);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                MaxVoltageLevel = libpointer('doublePtr', 0);
                
                status = calllib( libname,'IviDCPwr_QueryMaxVoltageLevel', session, ChannelName, CurrentLimit, MaxVoltageLevel);
                
                MaxVoltageLevel = MaxVoltageLevel.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ResetOutputProtection(obj,ChannelName)
            %RESETOUTPUTPROTECTION This function clears all
            %output-protection conditions on the power supply.
            
            narginchk(2,2)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviDCPwr_ResetOutputProtection', session, ChannelName);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Measurement = Measure(obj,ChannelName,MeasurementType)
            %MEASURE This function takes a single measurement on the
            %channel you specify.  Notes:  (1) This function is part of
            %the IviDCPwrMeasure [MSR] extension group.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            MeasurementType = obj.checkScalarInt32Arg(MeasurementType);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                Measurement = libpointer('doublePtr', 0);
                
                status = calllib( libname,'IviDCPwr_Measure', session, ChannelName, MeasurementType, Measurement);
                
                Measurement = Measurement.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
