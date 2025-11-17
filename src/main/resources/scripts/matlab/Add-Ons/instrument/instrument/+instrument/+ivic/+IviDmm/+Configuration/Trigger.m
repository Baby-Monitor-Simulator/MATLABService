classdef Trigger < instrument.ivic.IviGroupBase
    %TRIGGER This class contains functions that configure the
    %triggering capabilities of the DMM. These include the
    %trigger source, trigger delay, and trigger slope.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureTrigger(obj,TriggerSource,TriggerDelaysec)
            %CONFIGURETRIGGER This function configures the common DMM
            %trigger attributes.  These attributes are the trigger
            %source and trigger delay.
            
            narginchk(3,3)
            TriggerSource = obj.checkScalarInt32Arg(TriggerSource);
            TriggerDelaysec = obj.checkScalarDoubleArg(TriggerDelaysec);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDmm_ConfigureTrigger', session, TriggerSource, TriggerDelaysec);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureTriggerSlope(obj,TriggerSlope)
            %CONFIGURETRIGGERSLOPE This function configures the
            %polarity of the external trigger source of the DMM.  Note:
            %(1) This function is part of the IviDmmTriggerSlope [TS]
            %extension group.
            
            narginchk(2,2)
            TriggerSlope = obj.checkScalarInt32Arg(TriggerSlope);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDmm_ConfigureTriggerSlope', session, TriggerSlope);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
