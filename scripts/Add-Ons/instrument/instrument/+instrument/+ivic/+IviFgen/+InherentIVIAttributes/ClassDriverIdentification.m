classdef ClassDriverIdentification < instrument.ivic.IviGroupBase
    %CLASSDRIVERIDENTIFICATION Attributes that provide identity
    %and version information about the class driver.\n
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %DESCRIPTION A string that contains a brief description of
        %the class driver Read Only.
        Description
        
        %CLASS_DRIVER_PREFIX A string that contains the prefix for
        %the class driver.  The name of each user-callable function
        %in this driver starts with this prefix. Read Only.
        Class_Driver_Prefix
        
        %CLASS_DRIVER_VENDOR A string that contains the name of the
        %vendor that supplies this class driver. Read Only.
        Class_Driver_Vendor
        
        %REVISION A string that contains additional version
        %information about the class driver. Read Only.
        Revision
        
        %CLASS_SPECIFICATION_MAJOR_VERSION The major version number
        %of the class specification with which the class driver is
        %compliant. Read Only.
        Class_Specification_Major_Version
        
        %CLASS_SPECIFICATION_MINOR_VERSION The minor version number
        %of the class specification with which the class driver is
        %compliant. Read Only.
        Class_Specification_Minor_Version
    end
    
    %% Property access methods
    methods
        %% Description property access methods
        function value = get.Description(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050518 ,4096);
        end
        
        %% Class_Driver_Prefix property access methods
        function value = get.Class_Driver_Prefix(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050301 ,4096);
        end
        
        %% Class_Driver_Vendor property access methods
        function value = get.Class_Driver_Vendor(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050517 ,4096);
        end
        
        %% Revision property access methods
        function value = get.Revision(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050552 ,4096);
        end
        
        %% Class_Specification_Major_Version property access methods
        function value = get.Class_Specification_Major_Version(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1050519);
        end
        
        %% Class_Specification_Minor_Version property access methods
        function value = get.Class_Specification_Minor_Version(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1050520);
        end
    end
end
