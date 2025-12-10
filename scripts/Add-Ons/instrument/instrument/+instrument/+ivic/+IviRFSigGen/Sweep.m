classdef Sweep < instrument.ivic.IviGroupBase
    %SWEEP This group contains attributes to support signal
    %generators with the
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = Sweep()
            %% Initialize properties
            obj.FrequencySweep = instrument.ivic.IviRFSigGen.Sweep.FrequencySweep();
            obj.PowerSweep = instrument.ivic.IviRFSigGen.Sweep.PowerSweep();
            obj.FrequencyStep = instrument.ivic.IviRFSigGen.Sweep.FrequencyStep();
            obj.PowerStep = instrument.ivic.IviRFSigGen.Sweep.PowerStep();
            obj.List = instrument.ivic.IviRFSigGen.Sweep.List();
        end
        
        function delete(obj)
            obj.List = [];
            obj.PowerStep = [];
            obj.FrequencyStep = [];
            obj.PowerSweep = [];
            obj.FrequencySweep = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.List.setLibraryAndSession(libName, session);
            obj.PowerStep.setLibraryAndSession(libName, session);
            obj.FrequencyStep.setLibraryAndSession(libName, session);
            obj.PowerSweep.setLibraryAndSession(libName, session);
            obj.FrequencySweep.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Properties
    properties
        %SWEEP_MODE_SWP Specifies the sweep mode applied to the
        %output signal.
        Sweep_Mode_SWP
        
        %SWEEP_TRIGGER_SOURCE_SWP Specifies the trigger used to
        %start a sweep operation.
        Sweep_Trigger_Source_SWP
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %FREQUENCYSWEEP This group contains attributes to support
        %the instrument that can apply  Read Only.
        FrequencySweep
        
        %POWERSWEEP This group contains attributes to support the
        %instrument that can apply  Read Only.
        PowerSweep
        
        %FREQUENCYSTEP This group contains attributes to support
        %the instrument that can vary  Read Only.
        FrequencyStep
        
        %POWERSTEP This group contains attributes to support the
        %instrument that can vary  Read Only.
        PowerStep
        
        %LIST This group contains attributes to support the
        %instrument that can set the  Read Only.
        List
    end
    
    %% Property access methods
    methods
        %% Sweep_Mode_SWP property access methods
        function value = get.Sweep_Mode_SWP(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250201);
        end
        function set.Sweep_Mode_SWP(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.Sweep.*;
            attrSweepModeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250201, newValue);
        end
        
        %% Sweep_Trigger_Source_SWP property access methods
        function value = get.Sweep_Trigger_Source_SWP(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250202);
        end
        function set.Sweep_Trigger_Source_SWP(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.Sweep.*;
            attrSweepTriggerSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250202, newValue);
        end
        %% FrequencySweep property access methods
        function value = get.FrequencySweep(obj)
            if isempty(obj.FrequencySweep)
                obj.FrequencySweep = instrument.ivic.IviRFSigGen.Sweep.FrequencySweep();
            end
            value = obj.FrequencySweep;
        end
        
        %% PowerSweep property access methods
        function value = get.PowerSweep(obj)
            if isempty(obj.PowerSweep)
                obj.PowerSweep = instrument.ivic.IviRFSigGen.Sweep.PowerSweep();
            end
            value = obj.PowerSweep;
        end
        
        %% FrequencyStep property access methods
        function value = get.FrequencyStep(obj)
            if isempty(obj.FrequencyStep)
                obj.FrequencyStep = instrument.ivic.IviRFSigGen.Sweep.FrequencyStep();
            end
            value = obj.FrequencyStep;
        end
        
        %% PowerStep property access methods
        function value = get.PowerStep(obj)
            if isempty(obj.PowerStep)
                obj.PowerStep = instrument.ivic.IviRFSigGen.Sweep.PowerStep();
            end
            value = obj.PowerStep;
        end
        
        %% List property access methods
        function value = get.List(obj)
            if isempty(obj.List)
                obj.List = instrument.ivic.IviRFSigGen.Sweep.List();
            end
            value = obj.List;
        end
    end
end
