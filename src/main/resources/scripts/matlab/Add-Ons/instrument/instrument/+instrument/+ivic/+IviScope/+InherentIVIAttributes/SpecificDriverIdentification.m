classdef SpecificDriverIdentification < instrument.ivic.IviGroupBase
    %SPECIFICDRIVERIDENTIFICATION Attributes that provide
    %identity and version information about the specific
    %driver.\n
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %DESCRIPTION A string that contains a brief description of
        %the specific driver Read Only.
        Description
        
        %SPECIFIC_DRIVER_PREFIX A string that contains the prefix
        %for the instrument driver.  The name of each user-callable
        %function in this driver starts with this prefix. Read Only.
        Specific_Driver_Prefix
        
        %SPECIFIC_DRIVER_LOCATOR Indicates the location at which
        %the class driver attempts to find the specific driver
        %module file. Read Only.
        Specific_Driver_Locator
        
        %SPECIFIC_DRIVER_VENDOR A string that contains the name of
        %the vendor that supplies this driver. Read Only.
        Specific_Driver_Vendor
        
        %REVISION A string that contains additional version
        %information about the specific driver. Read Only.
        Revision
        
        %CLASS_SPECIFICATION_MAJOR_VERSION The major version number
        %of the class specification with which the specific driver
        %is compliant. Read Only.
        Class_Specification_Major_Version
        
        %CLASS_SPECIFICATION_MINOR_VERSION The minor version number
        %of the class specification with which the specific driver
        %is compliant. Read Only.
        Class_Specification_Minor_Version
    end
    
    %% Property access methods
    methods
        %% Description property access methods
        function value = get.Description(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050514 ,4096);
        end
        
        %% Specific_Driver_Prefix property access methods
        function value = get.Specific_Driver_Prefix(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050302 ,4096);
        end
        
        %% Specific_Driver_Locator property access methods
        function value = get.Specific_Driver_Locator(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050303 ,4096);
        end
        
        %% Specific_Driver_Vendor property access methods
        function value = get.Specific_Driver_Vendor(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050513 ,4096);
        end
        
        %% Revision property access methods
        function value = get.Revision(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050551 ,4096);
        end
        
        %% Class_Specification_Major_Version property access methods
        function value = get.Class_Specification_Major_Version(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1050515);
        end
        
        %% Class_Specification_Minor_Version property access methods
        function value = get.Class_Specification_Minor_Version(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1050516);
        end
    end
end
