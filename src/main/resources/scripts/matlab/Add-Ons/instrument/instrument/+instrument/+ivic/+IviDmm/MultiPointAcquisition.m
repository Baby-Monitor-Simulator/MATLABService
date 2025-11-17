classdef MultiPointAcquisition < instrument.ivic.IviGroupBase
    %MULTIPOINTACQUISITION Attributes for acquiring data on
    %multiple triggers and acquiring multiple
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %TRIGGER_COUNT_MP Specifies the number of triggers the DMM
        %accepts before it returns to the idle state.  Note: (1)
        %This attribute is part of the IviDmmMultiPoint MP extension
        %group.
        Trigger_Count_MP
        
        %SAMPLE_COUNT_MP Specifies the number of measurements the
        %DMM takes each time it receives a trigger.  Note: (1) This
        %attribute is part of the IviDmmMultiPoint MP extension
        %group.
        Sample_Count_MP
        
        %SAMPLE_TRIGGER_MP Specifies the sample trigger source.
        %This attribute affects instrument operation only when the
        %IVIDMM_ATTR_SAMPLE_COUNT attribute is greater than 1. When
        %the DMM takes a measurement and the
        %IVIDMM_ATTR_SAMPLE_COUNT attribute is greater than 1, the
        %DMM does not take the next measurement until the event you
        %specify with this attribute occurs.     When you set this
        %attribute to IVIDMM_VAL_IMMEDIATE, the DMM does not wait
        %for a trigger of any kind between measurements.  When you
        %set this attribute to IVIDMM_VAL_EXTERNAL, the DMM waits
        %for a trigger on the external trigger input before it takes
        %the next measurement.  When you set this attribute to
        %IVIDMM_VAL_SOFTWARE_TRIG, the DMM waits until you call the
        %IviDmm_SendSoftwareTrigger function before it takes the
        %next measurement.  When you set this attribute to
        %IVIDMM_VAL_INTERVAL, the DMM waits the length of time you
        %specify with the IVIDMM_ATTR_SAMPLE_INTERVAL attribute
        %before it takes the next measurement.  Note: (1) This
        %attribute is part of the IviDmmMultiPoint MP extension
        %group.
        Sample_Trigger_MP
        
        %SAMPLE_INTERVAL_MP Specifies the interval between samples
        %in seconds. This attribute affects instrument operation
        %only when the IVIDMM_ATTR_SAMPLE_COUNT attribute is greater
        %than 1 and the IVIDMM_ATTR_SAMPLE_TRIGGER attribute is set
        %to IVIDMM_VAL_INTERVAL.  In this case, the DMM waits
        %between measurements for the length the time you specify
        %with this attribute.  Note: (1) This attribute is part of
        %the IviDmmMultiPoint MP extension group.
        Sample_Interval_MP
        
        %MEAS_COMPLETE_DESTINATION_MP After each measurement, the
        %DMM generates a measurement-complete signal.  This
        %attributes specifies the destination of the
        %measurement-complete signal.  This signal is commonly
        %referred to as Voltmeter Complete.  Note: (1) This
        %attribute is part of the IviDmmMultiPoint MP extension
        %group.
        Meas_Complete_Destination_MP
    end
    
    %% Property access methods
    methods
        %% Trigger_Count_MP property access methods
        function value = get.Trigger_Count_MP(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250304);
        end
        function set.Trigger_Count_MP(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarInt32Arg(newValue);
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250304, newValue);
        end
        
        %% Sample_Count_MP property access methods
        function value = get.Sample_Count_MP(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250301);
        end
        function set.Sample_Count_MP(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarInt32Arg(newValue);
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250301, newValue);
        end
        
        %% Sample_Trigger_MP property access methods
        function value = get.Sample_Trigger_MP(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250302);
        end
        function set.Sample_Trigger_MP(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDmm.MultiPointAcquisition.*;
            attrSampleTriggerRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250302, newValue);
        end
        
        %% Sample_Interval_MP property access methods
        function value = get.Sample_Interval_MP(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250303);
        end
        function set.Sample_Interval_MP(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250303, newValue);
        end
        
        %% Meas_Complete_Destination_MP property access methods
        function value = get.Meas_Complete_Destination_MP(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250305);
        end
        function set.Meas_Complete_Destination_MP(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDmm.MultiPointAcquisition.*;
            attrMeasCompleteDestRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250305, newValue);
        end
    end
end
