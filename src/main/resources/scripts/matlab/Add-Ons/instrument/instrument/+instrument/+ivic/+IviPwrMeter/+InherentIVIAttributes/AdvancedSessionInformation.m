classdef AdvancedSessionInformation < instrument.ivic.IviGroupBase
    %ADVANCEDSESSIONINFORMATION Attributes that contain
    %additional information concerning the instrument
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %LOGICAL_NAME A string containing the logical name you
        %specified when opening the current IVI session.      You
        %may pass a logical name to the IviPwrMeter_init or
        %IviPwrMeter_InitWithOptions functions.  The IVI
        %Configuration utility must contain an entry for the logical
        %name.  The logical name entry refers to a driver session
        %section in the IVI Configuration file.  The driver session
        %section specifies a physical device and initial user
        %options. Read Only.
        Logical_Name
        
        %I_O_RESOURCE_DESCRIPTOR Indicates the resource descriptor
        %the driver uses to identify the physical device.     If you
        %initialize the driver with a logical name, this attribute
        %contains the resource descriptor that corresponds to the
        %entry in the IVI Configuration utility.       If you
        %initialize the instrument driver with the resource
        %descriptor, this attribute contains that value. Read Only.
        I_O_Resource_Descriptor
        
        %DRIVER_SETUP Some cases exist where you must specify
        %instrument driver options at initialization time.  An
        %example of this is specifying a particular instrument model
        %from among a family of instruments that the driver
        %supports.  This is useful when using simulation.  You can
        %specify driver-specific options through the DriverSetup
        %keyword in the optionsString parameter to the
        %IviPwrMeter_InitWithOptions function.  If you open an
        %instrument using a logical name, you can also specify the
        %options through the IVI Configuration Utility.     The
        %default value is an empty string. Read Only.
        Driver_Setup
    end
    
    %% Property access methods
    methods
        %% Logical_Name property access methods
        function value = get.Logical_Name(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050305 ,4096);
        end
        
        %% I_O_Resource_Descriptor property access methods
        function value = get.I_O_Resource_Descriptor(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050304 ,4096);
        end
        
        %% Driver_Setup property access methods
        function value = get.Driver_Setup(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050007 ,4096);
        end
    end
end
