classdef InstrumentIdentification < instrument.ivic.IviGroupBase
    %INSTRUMENTIDENTIFICATION Attributes that provide identity
    %information about the instrument that you are using.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %MANUFACTURER A string that contains the name of the
        %instrument manufacturer you are currently using. Read Only.
        Manufacturer
        
        %MODEL A string that contains the model number or name of
        %the instrument that you are currently using. Read Only.
        Model
        
        %FIRMWARE_REVISION A string that contains the firmware
        %revision information for the instrument you are currently
        %using. Read Only.
        Firmware_Revision
    end
    
    %% Property access methods
    methods
        %% Manufacturer property access methods
        function value = get.Manufacturer(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050511 ,4096);
        end
        
        %% Model property access methods
        function value = get.Model(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050512 ,4096);
        end
        
        %% Firmware_Revision property access methods
        function value = get.Firmware_Revision(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050510 ,4096);
        end
    end
end
