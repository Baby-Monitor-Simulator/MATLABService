classdef BasicOperation < instrument.ivic.IviGroupBase
    %BASICOPERATION Attributes that control the basic features
    %of the DMM.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %FUNCTION Specifies the measurement function.
        Function
        
        %RANGE Specifies the measurement range.  You use positive
        %values to represent the absolute value of the maximum
        %expected measurement.  The value is in units appropriate
        %for the current value of the IVIDMM_ATTR_FUNCTION
        %attribute.  For example, when you set the
        %IVIDMM_ATTR_FUNCTION attribute to IVIDMM_VAL_DC_VOLTS, the
        %units are volts.  For example, setting this attribute to
        %10.0 configures the DMM to measure DC voltages from -10.0
        %to +10.0 volts.     Negative values are reserved for
        %controlling the DMM's auto-ranging capability. -
        %IVIDMM_VAL_AUTO_RANGE_ON (-1.0) - Configures the DMM to
        %calculate the range before each measurement automatically.
        %- IVIDMM_VAL_AUTO_RANGE_OFF (-2.0) - Disables auto-ranging.
        % The DMM sets the range to the value it most recently
        %calculated. - IVIDMM_VAL_AUTO_RANGE_ONCE (-3.0) -
        %Configures the DMM to calculate the range before the next
        %measurement.  The DMM uses this range value for all
        %subsequent measurements.     After you set this attribute
        %to IVIDMM_VAL_AUTO_RANGE_OFF or IVIDMM_VAL_AUTO_RANGE_ONCE,
        %further queries of this attribute return the actual range.
        %   When you set this attribute to IVIDMM_VAL_AUTO_RANGE_ON,
        %you can obtain the actual range the DMM is currently using
        %by getting the value of the IVIDMM_ATTR_AUTO_RANGE_VALUE
        %attribute.
        Range
        
        %RESOLUTION Specifies the measurement resolution of the
        %DMM in absolute units. Setting this attribute to lower
        %values increases the measurement accuracy.  Setting this
        %attribute to higher values increases the measurement speed.
        % The valid range for this attribute depends on both the
        %measurement function and the value of the IVIDMM_ATTR_RANGE
        %attribute.
        Resolution
    end
    
    %% Property access methods
    methods
        %% Function property access methods
        function value = get.Function(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250001);
        end
        function set.Function(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDmm.BasicOperation.*;
            attrFunctionRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250001, newValue);
        end
        
        %% Range property access methods
        function value = get.Range(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250002);
        end
        function set.Range(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250002, newValue);
        end
        
        %% Resolution property access methods
        function value = get.Resolution(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250008);
        end
        function set.Resolution(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250008, newValue);
        end
    end
end
