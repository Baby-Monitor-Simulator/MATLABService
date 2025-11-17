classdef DriverIdentification < instrument.ivic.IviGroupBase
    %DRIVERIDENTIFICATION Attributes that provide identity and
    %version information about this
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %DESCRIPTION A string that contains a brief description of
        %the specific driver. Read Only.
        Description
        
        %DRIVER_PREFIX A string that contains the prefix for the
        %instrument driver.  The name of each user-callable function
        %in this driver starts with this prefix. Read Only.
        Driver_Prefix
        
        %DRIVER_VENDOR A string that contains the name of the
        %vendor that supplies this driver. Read Only.
        Driver_Vendor
        
        %REVISION A string that contains additional version
        %information about this instrument driver. Read Only.
        Revision
        
        %CLASS_SPECIFICATION_MAJOR_VERSION The major version number
        %of the class specification with which this driver is
        %compliant. Read Only.
        Class_Specification_Major_Version
        
        %CLASS_SPECIFICATION_MINOR_VERSION The minor version number
        %of the class specification with which this driver is
        %compliant. Read Only.
        Class_Specification_Minor_Version
    end
    
    %% Property access methods
    methods
        %% Description property access methods
        function value = get.Description(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050514 ,4096);
        end
        
        %% Driver_Prefix property access methods
        function value = get.Driver_Prefix(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050302 ,4096);
        end
        
        %% Driver_Vendor property access methods
        function value = get.Driver_Vendor(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050513 ,4096);
        end
        
        %% Revision property access methods
        function value = get.Revision(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050551 ,4096);
        end
        
        %% Class_Specification_Major_Version property access methods
        function value = get.Class_Specification_Major_Version(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1050515);
        end
        
        %% Class_Specification_Minor_Version property access methods
        function value = get.Class_Specification_Minor_Version(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1050516);
        end
    end
end
