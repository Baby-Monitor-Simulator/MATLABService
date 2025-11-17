classdef MultiPoint < instrument.ivic.IviGroupBase
    %MULTIPOINT This class contains functions that configure
    %the multi-point capabilities of the DMM.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureMultiPoint(obj,TriggerCount,SampleCount,SampleTrigger,SampleIntervalsec)
            %CONFIGUREMULTIPOINT This function configures the
            %attributes for multi-point measurements.  These attributes
            %include the trigger count, sample count, sample trigger and
            %sample interval.  Note:  (1) This function is part of the
            %IviDmmMultiPoint [MP] extension group.
            
            narginchk(5,5)
            TriggerCount = obj.checkScalarInt32Arg(TriggerCount);
            SampleCount = obj.checkScalarInt32Arg(SampleCount);
            SampleTrigger = obj.checkScalarInt32Arg(SampleTrigger);
            SampleIntervalsec = obj.checkScalarDoubleArg(SampleIntervalsec);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDmm_ConfigureMultiPoint', session, TriggerCount, SampleCount, SampleTrigger, SampleIntervalsec);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureMeasCompleteDest(obj,MeasCompleteDestination)
            %CONFIGUREMEASCOMPLETEDEST This function configures the
            %destination of the measurement-complete signal. This signal
            %is commonly referred to as Voltmeter Complete.  Note:  (1)
            %This function is part of the IviDmmMultiPoint [MP]
            %extension group.
            
            narginchk(2,2)
            MeasCompleteDestination = obj.checkScalarInt32Arg(MeasCompleteDestination);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDmm_ConfigureMeasCompleteDest', session, MeasCompleteDestination);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
