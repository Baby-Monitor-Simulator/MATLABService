classdef ConfigurationInformation < instrument.ivic.IviGroupBase
    %CONFIGURATIONINFORMATION Attributes that return
    %information about the current configuration of the DMM.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %AUTO_RANGE_VALUE_ARV Always returns the actual range the
        %DMM is currently using, even when the DMM is auto-ranging.
        %Note: (1) This attribute is part of the
        %IviDmmAutoRangeValue ARV extension group. Read Only.
        Auto_Range_Value_ARV
        
        %APERTURE_TIME_DI Returns the measurement aperture time for
        %the current configuration.  The units for this attribute
        %are either seconds or powerline cycles (PLCs) and are
        %determined by the value of the
        %IVIDMM_ATTR_APERTURE_TIME_UNITS attribute.  Note: (1) This
        %attribute is part of the IviDmmDeviceInfo DI extension
        %group. Read Only.
        Aperture_Time_DI
        
        %APERTURE_TIME_UNITS_DI Returns the units for the attribute
        %IVIDMM_ATTR_APERTURE_TIME.  Possible values are the
        %following:  Defined Values:     IVIDMM_VAL_SECONDS (0) -
        %The units for the IVIDMM_ATTR_APERTURE_TIME attribute are
        %seconds.     IVIDMM_VAL_POWER_LINE_CYCLES (1) - The units
        %for the IVIDMM_ATTR_APERTURE_TIME attribute are powerline
        %cycles.  Note: (1) This attribute is part of the
        %IviDmmDeviceInfo DI extension group. Read Only.
        Aperture_Time_Units_DI
    end
    
    %% Property access methods
    methods
        %% Auto_Range_Value_ARV property access methods
        function value = get.Auto_Range_Value_ARV(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250331);
        end
        
        %% Aperture_Time_DI property access methods
        function value = get.Aperture_Time_DI(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250321);
        end
        
        %% Aperture_Time_Units_DI property access methods
        function value = get.Aperture_Time_Units_DI(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250322);
        end
    end
end
