classdef Trigger < instrument.ivic.IviGroupBase
    %TRIGGER This class contains a function that can specify a
    %trigger source on which to trigger a measurement.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureTriggerSource(obj,TriggerSource)
            %CONFIGURETRIGGERSOURCE This function configures the
            %trigger source of the power meter.
            
            narginchk(2,2)
            TriggerSource = obj.checkScalarInt32Arg(TriggerSource);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviPwrMeter_ConfigureTriggerSource', session, TriggerSource);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureInternalTrigger(obj,EventSource,Slope)
            %CONFIGUREINTERNALTRIGGER This function configures the
            %internal trigger event source and the internal trigger
            %slope of the power meter.
            
            narginchk(3,3)
            EventSource = obj.checkScalarStringArg(EventSource);
            Slope = obj.checkScalarInt32Arg(Slope);
            try
                [libname, session ] = obj.getLibraryAndSession();
                EventSource = [double(EventSource) 0];
                
                status = calllib( libname,'IviPwrMeter_ConfigureInternalTrigger', session, EventSource, Slope);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureInternalTriggerLevel(obj,TriggerLevel)
            %CONFIGUREINTERNALTRIGGERLEVEL This function configures the
            %internal trigger level of the power meter.
            
            narginchk(2,2)
            TriggerLevel = obj.checkScalarDoubleArg(TriggerLevel);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviPwrMeter_ConfigureInternalTriggerLevel', session, TriggerLevel);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
