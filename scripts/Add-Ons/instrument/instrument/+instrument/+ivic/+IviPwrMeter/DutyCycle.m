classdef DutyCycle < instrument.ivic.IviGroupBase
    %DUTYCYCLE Duty Cycle
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %DUTY_CYCLE_CORRECTION_DC This channel-based attribute
        %specifies the duty cycle correction the power meter uses to
        %calculate the pulse power of a pulse-modulated signal.  The
        %power meter measures the average power of the pulsed input
        %signal and then divides the result by the value specified
        %for this attribute to obtain a pulse power reading.  The
        %value of this attribute is specified as a percentage.
        Duty_Cycle_Correction_DC
        
        %DUTY_CYCLE_CORRECTION_ENABLED_DC This channel-based
        %attribute specifies if the power meter performs a duty
        %cycle correction on the specified channel.
        Duty_Cycle_Correction_Enabled_DC
    end
    
    %% Property access methods
    methods
        %% Duty_Cycle_Correction_DC property access methods
        function value = get.Duty_Cycle_Correction_DC(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250402);
        end
        function set.Duty_Cycle_Correction_DC(obj,newValue)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250402, newValue);
        end
        
        %% Duty_Cycle_Correction_Enabled_DC property access methods
        function value = get.Duty_Cycle_Correction_Enabled_DC(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250401);
        end
        function set.Duty_Cycle_Correction_Enabled_DC(obj,newValue)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviPwrMeter.DutyCycle.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250401, newValue);
        end
    end
end
