classdef TriggerExtensionGroup < instrument.ivic.IviGroupBase
    %TRIGGEREXTENSIONGROUP This extension group specifies the
    %source of the trigger signal that causes the analyzer to
    %leave the Wait-For-Trigger state.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureTriggerSource(obj,TriggerSource)
            %CONFIGURETRIGGERSOURCE This function specifies the trigger
            %source that causes the spectrum analyzer to leave the
            %Wait-for-Trigger state.
            
            narginchk(2,2)
            TriggerSource = obj.checkScalarInt32Arg(TriggerSource);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ConfigureTriggerSource', session, TriggerSource);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureExternalTrigger(obj,ExternalTriggerLevel,ExternalTriggerPolarity)
            %CONFIGUREEXTERNALTRIGGER This function specifies the
            %external level and polarity for triggering.  This is
            %applicable when the trigger source is set to external.
            
            narginchk(3,3)
            ExternalTriggerLevel = obj.checkScalarDoubleArg(ExternalTriggerLevel);
            ExternalTriggerPolarity = obj.checkScalarInt32Arg(ExternalTriggerPolarity);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ConfigureExternalTrigger', session, ExternalTriggerLevel, ExternalTriggerPolarity);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureVideoTrigger(obj,VideoTriggerLevel,VideoTriggerSlope)
            %CONFIGUREVIDEOTRIGGER This function specifies the video
            %level and polarity for video triggering.  This is
            %applicable when the trigger source is set to video.
            
            narginchk(3,3)
            VideoTriggerLevel = obj.checkScalarDoubleArg(VideoTriggerLevel);
            VideoTriggerSlope = obj.checkScalarInt32Arg(VideoTriggerSlope);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ConfigureVideoTrigger', session, VideoTriggerLevel, VideoTriggerSlope);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
