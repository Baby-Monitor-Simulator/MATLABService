classdef Trigger < instrument.ivic.IviGroupBase
    %TRIGGER Trigger
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = Trigger()
            %% Initialize properties
            obj.InternalTrigger = instrument.ivic.IviPwrMeter.Trigger.InternalTrigger();
        end
        
        function delete(obj)
            obj.InternalTrigger = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.InternalTrigger.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Properties
    properties
        %TRIGGER_SOURCE_TRG Specifies the trigger source the power
        %meter monitors for the trigger event. When the trigger
        %event occurs on the source specified by this attribute, the
        %power meter leaves the Wait-For-Trigger state and takes a
        %measurement on all enabled channels. If this attribute is
        %set to the Internal defined value, the power meter uses the
        %channel specified by the
        %IVIPWRMETER_ATTR_INTERNAL_TRIGGER_EVENT_SOURCE IT attribute
        %to monitor the internal trigger event.
        Trigger_Source_TRG
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %INTERNALTRIGGER Internal Trigger Read Only.
        InternalTrigger
    end
    
    %% Property access methods
    methods
        %% Trigger_Source_TRG property access methods
        function value = get.Trigger_Source_TRG(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250201);
        end
        function set.Trigger_Source_TRG(obj,newValue)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviPwrMeter.Trigger.*;
            attrTriggerSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250201, newValue);
        end
        %% InternalTrigger property access methods
        function value = get.InternalTrigger(obj)
            if isempty(obj.InternalTrigger)
                obj.InternalTrigger = instrument.ivic.IviPwrMeter.Trigger.InternalTrigger();
            end
            value = obj.InternalTrigger;
        end
    end
end
