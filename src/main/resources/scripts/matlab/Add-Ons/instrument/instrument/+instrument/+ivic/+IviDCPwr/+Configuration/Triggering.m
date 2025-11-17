classdef Triggering < instrument.ivic.IviGroupBase
    %TRIGGERING This class contains functions for configuring
    %the trigger system.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureTriggerSource(obj,ChannelName,Source)
            %CONFIGURETRIGGERSOURCE This function configures the
            %trigger source to which the power supply responds after you
            %call IviDCPwr_Initiate.  When the power supply receives a
            %trigger signal on the source you specify, it changes its
            %current and voltage outputs.  You configure the triggered
            %current and voltage outputs with the
            %IviDCPwr_ConfigureTriggeredCurrentLimit and
            %IviDCPwr_ConfigureTriggeredVoltageLevel functions.   Notes:
            % (1) This function is part of the IviDCPwrTrigger [TRG]
            %extension group.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            Source = obj.checkScalarInt32Arg(Source);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviDCPwr_ConfigureTriggerSource', session, ChannelName, Source);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureTriggeredVoltageLevel(obj,ChannelName,TriggeredLevel)
            %CONFIGURETRIGGEREDVOLTAGELEVEL This function configures
            %the DC voltage level the power supply attempts to generate
            %after it receives a trigger.  Notes:  (1) This function is
            %part of the IviDCPwrTrigger [TRG] extension group.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            TriggeredLevel = obj.checkScalarDoubleArg(TriggeredLevel);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviDCPwr_ConfigureTriggeredVoltageLevel', session, ChannelName, TriggeredLevel);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureTriggeredCurrentLimit(obj,ChannelName,TriggeredLimit)
            %CONFIGURETRIGGEREDCURRENTLIMIT This function configures
            %the current limit the power supply uses after it receives a
            %trigger.  Notes:  (1) This function is part of the
            %IviDCPwrTrigger [TRG] extension group.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            TriggeredLimit = obj.checkScalarDoubleArg(TriggeredLimit);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviDCPwr_ConfigureTriggeredCurrentLimit', session, ChannelName, TriggeredLimit);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
