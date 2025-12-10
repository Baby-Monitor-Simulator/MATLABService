classdef MatrixConfiguration < instrument.ivic.IviGroupBase
    %MATRIXCONFIGURATION Attributes you use to configure a
    %matrix switch module.\n
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %NUMBER_OF_ROWS_SCN This attribute returns the number of
        %rows of a matrix or scanner.  If the switch module is a
        %scanner, this value is the number of output channels.
        %The IVISWTCH_ATTR_WIRE_MODE attribute affects the number of
        %available rows.  For example, if your module has 2 output
        %lines and you use the two-wire mode, then the number of
        %rows you have available is 1.  Notes:  (1) This attribute
        %is part of the IviSwtchScanner SCN extension group. Read
        %Only.
        Number_of_Rows_SCN
        
        %NUMBER_OF_COLUMNS_SCN This attribute returns the number of
        %columns of a matrix or scanner.  If the switch module is a
        %scanner, this value is the number of input channels.
        %The IVISWTCH_ATTR_WIRE_MODE attribute affects the number of
        %available columns.  For example, if your module has 8 input
        %lines and you use the four-wire mode, then the number of
        %columns you have available is 2.  Notes:  (1) This
        %attribute is part of the IviSwtchScanner SCN extension
        %group. Read Only.
        Number_of_Columns_SCN
        
        %WIRE_MODE This attribute specifies the wire mode of the
        %switch module.     This attribute affects the values of the
        %IVISWTCH_ATTR_NUM_OF_ROWS and IVISWTCH_ATTR_NUM_OF_COLUMNS
        %attributes.   The actual number of input and output lines
        %on the switch module is fixed, but the number of channels
        %depends on how many lines constitute each channel. Read
        %Only.
        Wire_mode
    end
    
    %% Property access methods
    methods
        %% Number_of_Rows_SCN property access methods
        function value = get.Number_of_Rows_SCN(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250018);
        end
        
        %% Number_of_Columns_SCN property access methods
        function value = get.Number_of_Columns_SCN(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250019);
        end
        
        %% Wire_mode property access methods
        function value = get.Wire_mode(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250017);
        end
    end
end
