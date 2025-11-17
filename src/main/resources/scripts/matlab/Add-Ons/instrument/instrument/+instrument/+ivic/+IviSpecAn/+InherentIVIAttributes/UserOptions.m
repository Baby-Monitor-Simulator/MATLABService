classdef UserOptions < instrument.ivic.IviGroupBase
    %USEROPTIONS Attributes you can set to affect the operation
    %of this instrument driver.\n
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %RANGE_CHECK Specifies whether to validate attribute values
        %and function parameters.  If enabled, the instrument driver
        %validates the parameter values that you pass to driver
        %functions.  Range checking parameters is very useful for
        %debugging.  After you validate your program, you can set
        %this attribute to FALSE to disable range checking and
        %maximize performance.     The default value is TRUE.   Use
        %the IviSpecAn_InitWithOptions function to override this
        %value.
        Range_Check
        
        %QUERY_INSTRUMENT_STATUS Specifies whether the instrument
        %driver queries the instrument status after each operation.
        %Querying the instrument status is very useful for
        %debugging.  After you validate your program, you can set
        %this attribute to FALSE to disable status checking and
        %maximize performance     The instrument driver can choose
        %to ignore status checking for particular attributes
        %regardless of the setting of this attribute.     The
        %default value is FALSE.   Use the
        %IviSpecAn_InitWithOptionsfunction to override this value.
        Query_Instrument_Status
        
        %CACHE Specifies whether to cache the value of attributes.
        %When caching is enabled, the instrument driver keeps track
        %of the current instrument settings and avoids sending
        %redundant commands to the instrument.  Thus, you can
        %significantly increase execution speed.     The instrument
        %driver can choose always to cache or never to cache
        %particular attributes regardless of the setting of this
        %attribute.     The default value is TRUE.   Use the
        %IviSpecAn_InitWithOptions function to override this value.
        Cache
        
        %SIMULATE Specifies whether or not to simulate instrument
        %driver IO operations.  If simulation is enabled, instrument
        %driver functions perform range checking and call
        %Ivi_GetAttribute and Ivi_SetAttribute functions, but they
        %do not perform instrument IO.  For output parameters that
        %represent instrument data, the instrument driver functions
        %return calculated values.     The default value is FALSE.
        %Use the IviSpecAn_InitWithOptions function to override this
        %value.
        Simulate
        
        %RECORD_VALUE_COERCIONS Specifies whether the IVI engine
        %keeps a list of the value coercions it makes for integer
        %and real type attributes.  You call
        %IviSpecAn_GetNextCoercionRecord function to extract and
        %delete the oldest coercion record from the list.     The
        %default value is FALSE.   Use the IviSpecAn_InitWithOptions
        %function to override this value.
        Record_Value_Coercions
        
        %INTERCHANGE_CHECK Specifies whether to perform
        %interchangeability checking and retrieve interchangeability
        %warnings.  The default value is FALSE.  Interchangeability
        %warnings indicate that using your application with a
        %different instrument might cause different behavior.  You
        %call IviSpecAn_GetNextInterchangeWarning function to
        %extract interchange warnings.  Call the
        %IviSpecAn_ClearInterchangeWarnings function to clear the
        %list of interchangeability warnings without reading them.
        %Interchangeability checking logs a warning for each
        %attribute you have not set that affects the behavior of the
        %instrument.
        Interchange_Check
    end
    
    %% Property access methods
    methods
        %% Range_Check property access methods
        function value = get.Range_Check(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050002);
        end
        function set.Range_Check(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050002, newValue);
        end
        
        %% Query_Instrument_Status property access methods
        function value = get.Query_Instrument_Status(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050003);
        end
        function set.Query_Instrument_Status(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050003, newValue);
        end
        
        %% Cache property access methods
        function value = get.Cache(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050004);
        end
        function set.Cache(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050004, newValue);
        end
        
        %% Simulate property access methods
        function value = get.Simulate(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050005);
        end
        function set.Simulate(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050005, newValue);
        end
        
        %% Record_Value_Coercions property access methods
        function value = get.Record_Value_Coercions(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050006);
        end
        function set.Record_Value_Coercions(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050006, newValue);
        end
        
        %% Interchange_Check property access methods
        function value = get.Interchange_Check(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050021);
        end
        function set.Interchange_Check(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050021, newValue);
        end
    end
end
