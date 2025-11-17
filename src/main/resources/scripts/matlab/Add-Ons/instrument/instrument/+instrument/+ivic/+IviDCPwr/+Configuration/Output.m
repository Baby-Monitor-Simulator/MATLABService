classdef Output < instrument.ivic.IviGroupBase
    %OUTPUT This class contains functions for configuring the
    %output.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureOutputEnabled(obj,ChannelName,Enabled)
            %CONFIGUREOUTPUTENABLED Configures whether the signal that
            %the power supply produces on a channel appears at the
            %output connector.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            Enabled = obj.checkScalarBoolArg(Enabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviDCPwr_ConfigureOutputEnabled', session, ChannelName, Enabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureOutputRange(obj,ChannelName,RangeType,Range)
            %CONFIGUREOUTPUTRANGE Configures the power supply's output
            %range on a channel.  You specify whether you want to
            %configure the voltage or current range, and the value to
            %which to set the range.  Notes:  1) Setting a voltage range
            %can invalidate a previously configured current range.  2)
            %Setting a current range can invalidate a previously
            %configured voltage range.
            
            narginchk(4,4)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            RangeType = obj.checkScalarInt32Arg(RangeType);
            Range = obj.checkScalarDoubleArg(Range);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviDCPwr_ConfigureOutputRange', session, ChannelName, RangeType, Range);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureCurrentLimit(obj,ChannelName,Behavior,Limit)
            %CONFIGURECURRENTLIMIT This function configures the current
            %limit.  You specify the output current limit value and the
            %behavior of the power supply when the output current is
            %greater than or equal to that value.
            
            narginchk(4,4)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            Behavior = obj.checkScalarInt32Arg(Behavior);
            Limit = obj.checkScalarDoubleArg(Limit);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviDCPwr_ConfigureCurrentLimit', session, ChannelName, Behavior, Limit);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureOVP(obj,ChannelName,Enabled,Limit)
            %CONFIGUREOVP This function configures the power supply's
            %over-voltage protection.  You specify the over-voltage
            %limit and the behavior of the power supply when the output
            %voltage is greater than or equal to that value.  When the
            %enabled parameter is False, the limit parameter does not
            %affect the instrument's behavior, and the driver ignores
            %the limit parameter.
            
            narginchk(4,4)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            Enabled = obj.checkScalarBoolArg(Enabled);
            Limit = obj.checkScalarDoubleArg(Limit);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviDCPwr_ConfigureOVP', session, ChannelName, Enabled, Limit);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureVoltageLevel(obj,ChannelName,Level)
            %CONFIGUREVOLTAGELEVEL This function configures the DC
            %voltage level that the power supply attempts to generate.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            Level = obj.checkScalarDoubleArg(Level);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviDCPwr_ConfigureVoltageLevel', session, ChannelName, Level);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
