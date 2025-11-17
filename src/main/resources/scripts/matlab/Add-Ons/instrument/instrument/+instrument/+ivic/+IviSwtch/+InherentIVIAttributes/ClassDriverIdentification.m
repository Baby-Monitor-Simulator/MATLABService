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
        
        %MAJOR_VERSION The major version number of the class
        %driver. Read Only.
        Major_Version
        
        %MINOR_VERSION The minor version number of the class
        %driver. Read Only.
        Minor_Version
        
        %REVISION A string that contains additional version
        %information about the class driver. Read Only.
        Revision
    end
    
    %% Property access methods
    methods
        %% Description property access methods
        function value = get.Description(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050518 ,4096);
        end
        
        %% Class_Driver_Prefix property access methods
        function value = get.Class_Driver_Prefix(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050301 ,4096);
        end
        
        %% Class_Driver_Vendor property access methods
        function value = get.Class_Driver_Vendor(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050517 ,4096);
        end
        
        %% Major_Version property access methods
        function value = get.Major_Version(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1050505 );
        end
        
        %% Minor_Version property access methods
        function value = get.Minor_Version(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1050506 );
        end
        
        %% Revision property access methods
        function value = get.Revision(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050552 ,4096);
        end
    end
end
