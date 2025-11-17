classdef ScanningConfiguration < instrument.ivic.IviGroupBase
    %SCANNINGCONFIGURATION Attributes you use to configure a
    %switch module using a scan list string.\n
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %SCAN_LIST_SCN This attribute contains a scan list, which
        %is a string that specifies channel connections and trigger
        %conditions.  The IviSwtch_InitiateScan function makes or
        %breaks connections and waits for triggers according to the
        %instructions in the scan list.     The scan list is
        %comprised of channel names that you separate with special
        %characters.  These special characters determine the
        %operations the scanner performs on the channels when it
        %executes this scan list.  To create a path between two
        %channels, use the following character between the two
        %channel names:     -> (a dash followed by a '>' sign)
        %Example: \CH1->CH2\ tells the switch to make a path from
        %channel CH1 to channel CH2.  To break or clear a path, use
        %the following character as a prefix before the path:     ~
        %(tilde) Example: \~CH1->CH2\ tells the switch to break the
        %path from channel CH1 to channel CH2.  To tell the switch
        %module to wait for a trigger event, use the following
        %character as a separator between paths:     ; (semicolon)
        %Example: \CH1->CH2;CH3->CH4\ tells the switch to make the
        %path from channel CH1 to channel CH2, wait for a trigger,
        %and then make the path from CH3 to CH4.  To tell the switch
        %module to create multiple paths simultaneously, use the
        %following character as a separator between the paths:     ,
        %(comma) Example: \A->B;CH1->CH2,CH3->CH4\ instructs the
        %scanner to make the path between channels A and B, wait for
        %a trigger, and then simultaneously make the paths between
        %channels CH1 and CH2 and between channels CH3 and CH4.
        %Notes:  (1) This attribute is part of the IviSwtchScanner
        %SCN extension group.
        Scan_List_SCN
        
        %SCAN_MODE_SCN This attribute specifies what happens to
        %existing connections that conflict with the connections you
        %make in a scan list.  For example, if CH1 is already
        %connected to CH2 and the scan list instructs the switch
        %module to connect CH1 to CH3, this attribute specifies what
        %happens to the connection between CH1 and CH2.     If the
        %value of this attribute is IVISWTCH_VAL_NONE, the switch
        %module takes no action on existing paths.  If the value is
        %IVISWTCH_VAL_BREAK_BEFORE_MAKE, the switch module breaks
        %conflicting paths before making new ones.  If the value is
        %IVISWTCH_VAL_BREAK_AFTER_MAKE, the switch module breaks
        %conflicting paths after making new ones.     Most switch
        %modules support only one of the possible values.  In such
        %cases, this attribute serves as an indicator of the
        %module's behavior.  Notes:  (1) This attribute is part of
        %the IviSwtchScanner SCN extension group.
        Scan_Mode_SCN
        
        %CONTINUOUS_SCAN_SCN This attribute specifies whether the
        %switch module continues scanning from the top of the scan
        %list after reaching the end of the list.  A value of
        %VI_TRUE indicates that the switch module continuously
        %scans.  A value of VI_FALSE indicates that the switch
        %module does not continuously scan.     If you set this
        %attribute to VI_TRUE, the function
        %IviSwtch_WaitForScanComplete always times out, and you must
        %call IviSwtch_AbortScan to stop the scan.  Notes:  (1) This
        %attribute is part of the IviSwtchScanner SCN extension
        %group.
        Continuous_Scan_SCN
        
        %TRIGGER_INPUT_SCN This attribute specifies the source of
        %the trigger for which the switch module can wait when
        %processing a scan list.  The switch module waits for a
        %trigger when it encounters a semicolon in a scan list.
        %When the trigger occurs, the switch module advances to the
        %next entry in the scan list.  Notes:  (1) This attribute is
        %part of the IviSwtchScanner SCN extension group.
        Trigger_Input_SCN
        
        %SCAN_ADVANCED_OUTPUT_SCN This attribute specifies the
        %method you want to use to notify another instrument that
        %all signals going through the switch module have settled
        %following the processing of one entry in the scan list.
        %Notes:  (1) This attribute is part of the IviSwtchScanner
        %SCN extension group.
        Scan_Advanced_Output_SCN
        
        %SCAN_DELAY_SCN This attribute specifies the minimum amount
        %of time the switch module waits before it asserts the scan
        %advanced output trigger after opening or closing the
        %switch.  The switch module always waits for debounce before
        %asserting the trigger.  Thus, the actual delay will always
        %be the greater value of the settling time and the value you
        %specify as the switch delay. The units are seconds.     Due
        %to different designs of the switch modules, the actual time
        %might be longer.   Notes:  (1) This attribute is part of
        %the IviSwtchScanner SCN extension group.
        Scan_Delay_SCN
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %IS_SCANNING_SCN This attribute indicates whether the
        %switch module has completed the scan operation.  The value
        %VI_TRUE indicates that the scan is complete. Notes:  (1)
        %This attribute is part of the IviSwtchScanner SCN extension
        %group. Read Only.
        Is_Scanning_SCN
    end
    
    %% Property access methods
    methods
        %% Scan_List_SCN property access methods
        function value = get.Scan_List_SCN(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1250020 ,4096);
        end
        function set.Scan_List_SCN(obj,newValue)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarStringArg(newValue);
            attributAccessors.SetAttributeViString( obj.RepCapIdentifier ,1250020, newValue);
        end
        
        %% Scan_Mode_SCN property access methods
        function value = get.Scan_Mode_SCN(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250021);
        end
        function set.Scan_Mode_SCN(obj,newValue)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSwtch.ScanningConfiguration.*;
            attrScanModeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250021, newValue);
        end
        
        %% Continuous_Scan_SCN property access methods
        function value = get.Continuous_Scan_SCN(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250026);
        end
        function set.Continuous_Scan_SCN(obj,newValue)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSwtch.ScanningConfiguration.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250026, newValue);
        end
        
        %% Trigger_Input_SCN property access methods
        function value = get.Trigger_Input_SCN(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250022);
        end
        function set.Trigger_Input_SCN(obj,newValue)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSwtch.ScanningConfiguration.*;
            attrTriggerInputRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250022, newValue);
        end
        
        %% Scan_Advanced_Output_SCN property access methods
        function value = get.Scan_Advanced_Output_SCN(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250023);
        end
        function set.Scan_Advanced_Output_SCN(obj,newValue)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSwtch.ScanningConfiguration.*;
            attrScanAdvancedOutputRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250023, newValue);
        end
        
        %% Scan_Delay_SCN property access methods
        function value = get.Scan_Delay_SCN(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250025);
        end
        function set.Scan_Delay_SCN(obj,newValue)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250025, newValue);
        end
        %% Is_Scanning_SCN property access methods
        function value = get.Is_Scanning_SCN(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250024);
        end
    end
end
