classdef TriggerSubsystem < instrument.ivic.IviGroupBase
    %TRIGGERSUBSYSTEM Attributes that control how the
    %oscilloscope triggers an acquisition.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = TriggerSubsystem()
            %% Initialize properties
            obj.TVTriggeringTV = instrument.ivic.IviScope.TriggerSubsystem.TVTriggeringTV();
            obj.RuntTriggeringRT = instrument.ivic.IviScope.TriggerSubsystem.RuntTriggeringRT();
            obj.GlitchTriggeringGT = instrument.ivic.IviScope.TriggerSubsystem.GlitchTriggeringGT();
            obj.WidthTriggeringWT = instrument.ivic.IviScope.TriggerSubsystem.WidthTriggeringWT();
            obj.ACLineTriggeringAT = instrument.ivic.IviScope.TriggerSubsystem.ACLineTriggeringAT();
        end
        
        function delete(obj)
            obj.ACLineTriggeringAT = [];
            obj.WidthTriggeringWT = [];
            obj.GlitchTriggeringGT = [];
            obj.RuntTriggeringRT = [];
            obj.TVTriggeringTV = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.ACLineTriggeringAT.setLibraryAndSession(libName, session);
            obj.WidthTriggeringWT.setLibraryAndSession(libName, session);
            obj.GlitchTriggeringGT.setLibraryAndSession(libName, session);
            obj.RuntTriggeringRT.setLibraryAndSession(libName, session);
            obj.TVTriggeringTV.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Properties
    properties
        %TRIGGER_TYPE This attribute specifies the trigger type.
        Trigger_Type
        
        %TRIGGER_SOURCE Specifies the source the oscilloscope
        %monitors for a trigger.  Set this attribute to a channel
        %name or to one of the values below.      Additional Trigger
        %Sources:     IVISCOPE_VAL_EXTERNAL (\VAL_EXTERNAL\) - The
        %oscilloscope waits for a trigger on the external trigger
        %input.     IVISCOPE_VAL_GPIB_GET (\VAL_GPIB_GET\) - The
        %oscilloscope waits until it receives a GPIB Group Execute
        %Trigger (GET).     IVISCOPE_VAL_TTL0 (\VAL_TTL0\) - The
        %oscilloscope waits until it receives a trigger on the PXI
        %TRIG0 line (for PXI instruments) or the VXI TTL0 line (for
        %VXI instruments).     IVISCOPE_VAL_TTL1 (\VAL_TTL1\) - The
        %oscilloscope waits until it receives a trigger on the PXI
        %TRIG1 line (for PXI instruments) or the VXI TTL1 line (for
        %VXI instruments).     IVISCOPE_VAL_TTL2 (\VAL_TTL2\) - The
        %oscilloscope waits until it receives a trigger on the PXI
        %TRIG2 line (for PXI instruments) or the VXI TTL2 line (for
        %VXI instruments).     IVISCOPE_VAL_TTL3 (\VAL_TTL3\) - The
        %oscilloscope waits until it receives a trigger on the PXI
        %TRIG3 line (for PXI instruments) or the VXI TTL3 line (for
        %VXI instruments).     IVISCOPE_VAL_TTL4 (\VAL_TTL4\) - The
        %oscilloscope waits until it receives a trigger on the PXI
        %TRIG4 line (for PXI instruments) or the VXI TTL4 line (for
        %VXI instruments).     IVISCOPE_VAL_TTL5 (\VAL_TTL5\) - The
        %oscilloscope waits until it receives a trigger on the PXI
        %TRIG5 line (for PXI instruments) or the VXI TTL5 line (for
        %VXI instruments).     IVISCOPE_VAL_TTL6 (\VAL_TTL6\) - The
        %oscilloscope waits until it receives a trigger on the PXI
        %TRIG6 line (for PXI instruments) or the VXI TTL6 line (for
        %VXI instruments).     IVISCOPE_VAL_TTL7 (\VAL_TTL7\) - The
        %oscilloscope waits until it receives a trigger on the PXI
        %TRIG7 line (for PXI instruments) or the VXI TTL7 line (for
        %VXI instruments).     IVISCOPE_VAL_ECL0 (\VAL_ECL0\) - The
        %oscilloscope waits for a trigger on the ECL line 0.
        %IVISCOPE_VAL_ECL1 (\VAL_ECL1\) - The oscilloscope waits for
        %a trigger on the ECL line 1.     IVISCOPE_VAL_PXI_STAR
        %(\VAL_PXI_STAR\) - The oscilloscope waits for a trigger on
        %the PXI Star bus.     IVISCOPE_VAL_RTSI_0 (\VAL_RTSI_0\) -
        %The oscilloscope waits for a trigger on RTSI line 0.
        %IVISCOPE_VAL_RTSI_1 (\VAL_RTSI_1\) - The oscilloscope waits
        %for a trigger on RTSI line 1.     IVISCOPE_VAL_RTSI_2
        %(\VAL_RTSI_2\) - The oscilloscope waits for a trigger on
        %RTSI line 2.     IVISCOPE_VAL_RTSI_3 (\VAL_RTSI_3\) - The
        %oscilloscope waits for a trigger on RTSI line 3.
        %IVISCOPE_VAL_RTSI_4 (\VAL_RTSI_4\) - The oscilloscope waits
        %for a trigger on RTSI line 4.     IVISCOPE_VAL_RTSI_5
        %(\VAL_RTSI_5\) - The oscilloscope waits for a trigger on
        %RTSI line 5.     IVISCOPE_VAL_RTSI_6 (\VAL_RTSI_6\) - The
        %oscilloscope waits for a trigger on RTSI line 6.
        Trigger_Source
        
        %TRIGGER_COUPLING Specifies how the oscilloscope couples
        %the trigger source.
        Trigger_Coupling
        
        %TRIGGER_HOLDOFF Specifies the length of time the
        %oscilloscope waits after it detects a trigger until the
        %oscilloscope enables the trigger subsystem to detect
        %another trigger.  The units are seconds.     The
        %IVISCOPE_ATTR_TRIGGER_HOLDOFF attribute affects instrument
        %operation only when the oscilloscope requires multiple
        %acquisitions to build a complete waveform.  The
        %oscilloscope requires multiple waveform acquisitions when
        %it uses equivalent-time sampling or when you set the
        %IVISCOPE_ATTR_ACQUISITION_TYPE attribute to
        %IVISCOPE_VAL_ENVELOPE or IVISCOPE_VAL_AVERAGE.
        Trigger_Holdoff
        
        %TRIGGER_LEVEL Specifies the voltage threshold for the
        %trigger subsystem.  The units are volts.  This attribute
        %affects instrument behavior only when you set the
        %IVISCOPE_ATTR_TRIGGER_TYPE to IVISCOPE_VAL_EDGE_TRIGGER,
        %IVISCOPE_VAL_GLITCH_TRIGGER, or IVISCOPE_VAL_WIDTH_TRIGGER.
        Trigger_Level
        
        %TRIGGER_SLOPE Specifies whether a rising or a falling edge
        %triggers the oscilloscope.  This attribute affects
        %instrument operation only when the
        %IVISCOPE_ATTR_TRIGGER_TYPE attribute is set to
        %IVISCOPE_VAL_EDGE_TRIGGER.
        Trigger_Slope
        
        %TRIGGER_MODIFIER_TM Specifies the trigger modifier.  The
        %trigger modifier determines the oscilloscope's behavior in
        %the absence of the trigger you configure.  Note: (1) This
        %attribute is part of the IviScopeTriggerModifier TM
        %extension group.
        Trigger_Modifier_TM
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %TVTRIGGERINGTV Attributes that configure the oscilloscope
        %to trigger on TV signals.  You  Read Only.
        TVTriggeringTV
        
        %RUNTTRIGGERINGRT Attributes that configure the
        %oscilloscope for runt triggering.  You use  Read Only.
        RuntTriggeringRT
        
        %GLITCHTRIGGERINGGT Attributes that configure the
        %oscilloscope for glitch triggering.  You use  Read Only.
        GlitchTriggeringGT
        
        %WIDTHTRIGGERINGWT Attributes that configure the
        %oscilloscope for width triggering.  You use  Read Only.
        WidthTriggeringWT
        
        %ACLINETRIGGERINGAT Attributes for synchronizing the
        %trigger with the AC Line.  You  Read Only.
        ACLineTriggeringAT
    end
    
    %% Property access methods
    methods
        %% Trigger_Type property access methods
        function value = get.Trigger_Type(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250012);
        end
        function set.Trigger_Type(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.TriggerSubsystem.*;
            attrTriggerTypeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250012, newValue);
        end
        
        %% Trigger_Source property access methods
        function value = get.Trigger_Source(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1250013 ,4096);
        end
        function set.Trigger_Source(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarStringArg(newValue);
            attributAccessors.SetAttributeViString( obj.RepCapIdentifier ,1250013, newValue);
        end
        
        %% Trigger_Coupling property access methods
        function value = get.Trigger_Coupling(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250014);
        end
        function set.Trigger_Coupling(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.TriggerSubsystem.*;
            attrTriggerCouplingRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250014, newValue);
        end
        
        %% Trigger_Holdoff property access methods
        function value = get.Trigger_Holdoff(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250016);
        end
        function set.Trigger_Holdoff(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250016, newValue);
        end
        
        %% Trigger_Level property access methods
        function value = get.Trigger_Level(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250017);
        end
        function set.Trigger_Level(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250017, newValue);
        end
        
        %% Trigger_Slope property access methods
        function value = get.Trigger_Slope(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250018);
        end
        function set.Trigger_Slope(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.TriggerSubsystem.*;
            attrTriggerSlopeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250018, newValue);
        end
        
        %% Trigger_Modifier_TM property access methods
        function value = get.Trigger_Modifier_TM(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250102);
        end
        function set.Trigger_Modifier_TM(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.TriggerSubsystem.*;
            attrTriggerModifierRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250102, newValue);
        end
        %% TVTriggeringTV property access methods
        function value = get.TVTriggeringTV(obj)
            if isempty(obj.TVTriggeringTV)
                obj.TVTriggeringTV = instrument.ivic.IviScope.TriggerSubsystem.TVTriggeringTV();
            end
            value = obj.TVTriggeringTV;
        end
        
        %% RuntTriggeringRT property access methods
        function value = get.RuntTriggeringRT(obj)
            if isempty(obj.RuntTriggeringRT)
                obj.RuntTriggeringRT = instrument.ivic.IviScope.TriggerSubsystem.RuntTriggeringRT();
            end
            value = obj.RuntTriggeringRT;
        end
        
        %% GlitchTriggeringGT property access methods
        function value = get.GlitchTriggeringGT(obj)
            if isempty(obj.GlitchTriggeringGT)
                obj.GlitchTriggeringGT = instrument.ivic.IviScope.TriggerSubsystem.GlitchTriggeringGT();
            end
            value = obj.GlitchTriggeringGT;
        end
        
        %% WidthTriggeringWT property access methods
        function value = get.WidthTriggeringWT(obj)
            if isempty(obj.WidthTriggeringWT)
                obj.WidthTriggeringWT = instrument.ivic.IviScope.TriggerSubsystem.WidthTriggeringWT();
            end
            value = obj.WidthTriggeringWT;
        end
        
        %% ACLineTriggeringAT property access methods
        function value = get.ACLineTriggeringAT(obj)
            if isempty(obj.ACLineTriggeringAT)
                obj.ACLineTriggeringAT = instrument.ivic.IviScope.TriggerSubsystem.ACLineTriggeringAT();
            end
            value = obj.ACLineTriggeringAT;
        end
    end
end
