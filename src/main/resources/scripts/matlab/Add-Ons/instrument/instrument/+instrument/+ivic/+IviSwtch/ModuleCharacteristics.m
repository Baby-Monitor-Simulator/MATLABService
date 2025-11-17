classdef ModuleCharacteristics < instrument.ivic.IviGroupBase
    %MODULECHARACTERISTICS Attributes you use to obtain the
    %characteristics of the switch module.\n
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %SETTLING_TIME This channel-based attribute returns the
        %maximum length of time from after you make a connection
        %until the signal flowing through the channel settles.
        %The units are seconds.
        Settling_Time
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %IS_DEBOUNCED This attribute indicates whether the entire
        %switch module has settled since the last switching command.
        % A value of VI_TRUE indicates that all signals going
        %through the switch module are valid. Read Only.
        Is_Debounced
        
        %BANDWIDTH This channel-based attribute returns the
        %bandwidth for the channel.     The units are hertz. Read
        %Only.
        Bandwidth
        
        %MAXIMUM_DC_VOLTAGE This channel-based attribute returns
        %the maximum DC voltage the channel can switch.     The
        %units are volts. Read Only.
        Maximum_DC_Voltage
        
        %MAXIMUM_AC_VOLTAGE This channel-based attribute returns
        %the maximum AC voltage the channel can switch.     The
        %units are volts RMS. Read Only.
        Maximum_AC_Voltage
        
        %MAXIMUM_SWITCHING_DC_CURRENT This channel-based attribute
        %returns the maximum DC current the channel can switch.
        %The units are amperes. Read Only.
        Maximum_Switching_DC_Current
        
        %MAXIMUM_SWITCHING_AC_CURRENT This channel-based attribute
        %returns the maximum AC current the channel can switch.
        %The units are amperes RMS. Read Only.
        Maximum_Switching_AC_Current
        
        %MAXIMUM_CARRY_DC_CURRENT This channel-based attribute
        %returns the maximum DC current the channel can carry.
        %The units are amperes. Read Only.
        Maximum_Carry_DC_Current
        
        %MAXIMUM_CARRY_AC_CURRENT This channel-based attribute
        %returns the maximum AC current the channel can carry.
        %The units are amperes RMS. Read Only.
        Maximum_Carry_AC_Current
        
        %MAXIMUM_SWITCHING_DC_POWER This channel-based attribute
        %returns the maximum DC power the channel can switch.
        %The units are watts. Read Only.
        Maximum_Switching_DC_Power
        
        %MAXIMUM_SWITCHING_AC_POWER This channel-based attribute
        %returns the maximum AC power the channel can switch.
        %The units are volt-amperes. Read Only.
        Maximum_Switching_AC_Power
        
        %MAXIMUM_CARRY_DC_POWER This channel-based attribute
        %returns the maximum DC power the channel can carry.     The
        %units are watts. Read Only.
        Maximum_Carry_DC_Power
        
        %MAXIMUM_CARRY_AC_POWER This channel-based attribute
        %returns the maximum AC power the channel can carry.     The
        %units are volt-amperes. Read Only.
        Maximum_Carry_AC_Power
        
        %CHARACTERISTIC_IMPEDANCE This channel-based attribute
        %returns the characteristic impedance for the channel.
        %The units are ohms. Read Only.
        Characteristic_Impedance
    end
    
    %% Property access methods
    methods
        %% Settling_Time property access methods
        function value = get.Settling_Time(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250004);
        end
        function set.Settling_Time(obj,newValue)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250004, newValue);
        end
        %% Is_Debounced property access methods
        function value = get.Is_Debounced(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250002);
        end
        
        %% Bandwidth property access methods
        function value = get.Bandwidth(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250005);
        end
        
        %% Maximum_DC_Voltage property access methods
        function value = get.Maximum_DC_Voltage(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250006);
        end
        
        %% Maximum_AC_Voltage property access methods
        function value = get.Maximum_AC_Voltage(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250007);
        end
        
        %% Maximum_Switching_DC_Current property access methods
        function value = get.Maximum_Switching_DC_Current(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250008);
        end
        
        %% Maximum_Switching_AC_Current property access methods
        function value = get.Maximum_Switching_AC_Current(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250009);
        end
        
        %% Maximum_Carry_DC_Current property access methods
        function value = get.Maximum_Carry_DC_Current(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250010);
        end
        
        %% Maximum_Carry_AC_Current property access methods
        function value = get.Maximum_Carry_AC_Current(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250011);
        end
        
        %% Maximum_Switching_DC_Power property access methods
        function value = get.Maximum_Switching_DC_Power(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250012);
        end
        
        %% Maximum_Switching_AC_Power property access methods
        function value = get.Maximum_Switching_AC_Power(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250013);
        end
        
        %% Maximum_Carry_DC_Power property access methods
        function value = get.Maximum_Carry_DC_Power(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250014);
        end
        
        %% Maximum_Carry_AC_Power property access methods
        function value = get.Maximum_Carry_AC_Power(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250015);
        end
        
        %% Characteristic_Impedance property access methods
        function value = get.Characteristic_Impedance(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250016);
        end
    end
end
