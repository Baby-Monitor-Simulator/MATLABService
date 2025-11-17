classdef MeasurementOperationOptions < instrument.ivic.IviGroupBase
    %MEASUREMENTOPERATIONOPTIONS Attributes that configure
    %different measurement operations.\n
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %AUTO_ZERO_AZ Specifies the auto-zero mode.  In general,
        %the auto-zero capability of a DMM normalizes all
        %measurements based on a Zero Reading.  When auto-zeroing is
        %enabled, the DMM internally disconnects the input signal
        %and takes a Zero Reading.  The DMM then subtracts the Zero
        %Reading from the measurement.  This prevents offset
        %voltages present in the DMM's input circuitry from
        %affecting measurement accuracy.  Note: (1) This attribute
        %is part of the IviDmmAutoZero AZ extension group.
        Auto_Zero_AZ
        
        %POWERLINE_FREQUENCY_PLF Specifies the power line frequency
        %in hertz.  Note: (1) This attribute is part of the
        %IviDmmPowerLineFrequency PLF extension group.
        Powerline_Frequency_PLF
    end
    
    %% Property access methods
    methods
        %% Auto_Zero_AZ property access methods
        function value = get.Auto_Zero_AZ(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250332);
        end
        function set.Auto_Zero_AZ(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDmm.MeasurementOperationOptions.*;
            attrAutoZeroRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250332, newValue);
        end
        
        %% Powerline_Frequency_PLF property access methods
        function value = get.Powerline_Frequency_PLF(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250333);
        end
        function set.Powerline_Frequency_PLF(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250333, newValue);
        end
    end
end
