classdef Trigger < instrument.ivic.IviGroupBase
    %TRIGGER Attributes for trigger configuration and control.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = Trigger()
            %% Initialize properties
            obj.ExternalTrigger = instrument.ivic.IviSpecAn.Trigger.ExternalTrigger();
            obj.VideoTrigger = instrument.ivic.IviSpecAn.Trigger.VideoTrigger();
        end
        
        function delete(obj)
            obj.VideoTrigger = [];
            obj.ExternalTrigger = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.VideoTrigger.setLibraryAndSession(libName, session);
            obj.ExternalTrigger.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Properties
    properties
        %TRIGGER_SOURCE_TRG Specifies the source of the trigger
        %signal that causes the analyzer to leave the
        %Wait-For-Trigger state.
        Trigger_Source_TRG
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %EXTERNALTRIGGER Attributes to configure and control
        %external triggers Read Only.
        ExternalTrigger
        
        %VIDEOTRIGGER Attributes to configure and control video
        %triggers Read Only.
        VideoTrigger
    end
    
    %% Property access methods
    methods
        %% Trigger_Source_TRG property access methods
        function value = get.Trigger_Source_TRG(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250301);
        end
        function set.Trigger_Source_TRG(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.Trigger.*;
            attrTriggerSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250301, newValue);
        end
        %% ExternalTrigger property access methods
        function value = get.ExternalTrigger(obj)
            if isempty(obj.ExternalTrigger)
                obj.ExternalTrigger = instrument.ivic.IviSpecAn.Trigger.ExternalTrigger();
            end
            value = obj.ExternalTrigger;
        end
        
        %% VideoTrigger property access methods
        function value = get.VideoTrigger(obj)
            if isempty(obj.VideoTrigger)
                obj.VideoTrigger = instrument.ivic.IviSpecAn.Trigger.VideoTrigger();
            end
            value = obj.VideoTrigger;
        end
    end
end
