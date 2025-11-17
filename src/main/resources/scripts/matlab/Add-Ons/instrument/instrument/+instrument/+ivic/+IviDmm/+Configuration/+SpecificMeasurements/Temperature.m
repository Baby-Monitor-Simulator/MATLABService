classdef Temperature < instrument.ivic.IviGroupBase
    %TEMPERATURE This class contains functions that configure
    %additional parameters for temperature measurements. These
    %parameters include the transducer type and settings
    %specific to each transducer type.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureTransducerType(obj,TransducerType)
            %CONFIGURETRANSDUCERTYPE This function configures the DMM
            %to take temperature measurements from a specified
            %transducer type.  This function affects the behavior of the
            %instrument only when the IVIDMM_ATTR_FUNCTION is set to
            %IVIDMM_VAL_TEMPERATURE.   Note:  (1) This function is part
            %of the IviDmmTemperatureMeasurement [TMP] extension group.
            
            narginchk(2,2)
            TransducerType = obj.checkScalarInt32Arg(TransducerType);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDmm_ConfigureTransducerType', session, TransducerType);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureThermocouple(obj,ThermocoupleType,ReferenceJunctionType)
            %CONFIGURETHERMOCOUPLE This function configures the
            %thermocouple type and the reference junction type of the
            %thermocouple for DMMs that take temperature measurements
            %using a thermocouple transducer type.  This function
            %affects the behavior of the instrument only if the
            %IVIDMM_ATTR_TEMP_TRANSDUCER_TYPE is set to
            %IVIDMM_VAL_THERMOCOUPLE.   Note:  (1) This function is part
            %of the IviDmmThermocouple [TC] extension group.
            
            narginchk(3,3)
            ThermocoupleType = obj.checkScalarInt32Arg(ThermocoupleType);
            ReferenceJunctionType = obj.checkScalarInt32Arg(ReferenceJunctionType);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDmm_ConfigureThermocouple', session, ThermocoupleType, ReferenceJunctionType);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureFixedRefJunction(obj,FixedReferenceJunction)
            %CONFIGUREFIXEDREFJUNCTION This function configures the
            %fixed reference junction for a thermocouple with a fixed
            %reference junction type.  This function affects the
            %behavior of the instrument only when the
            %IVIDMM_ATTR_TEMP_TC_REF_JUNC_TYPE attribute is set to
            %IVIDMM_VAL_TEMP_REF_JUNC_FIXED.  Note:  (1) This function
            %is part of the IviDmmThermocouple [TC] extension group.
            
            narginchk(2,2)
            FixedReferenceJunction = obj.checkScalarDoubleArg(FixedReferenceJunction);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDmm_ConfigureFixedRefJunction', session, FixedReferenceJunction);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureRTD(obj,Alpha,Resistance)
            %CONFIGURERTD This function configures the alpha and
            %resistance parameters for a resistance temperature device.
            %This function affects the behavior of the instrument only
            %when the IVIDMM_ATTR_TEMP_TRANSDUCER_TYPE attribute is set
            %to IVIDMM_VAL_2_WIRE_RTD or IVIDMM_VAL_4_WIRE_RTD.  Note:
            %(1) This function is part of the
            %IviDmmResistanceTemperatureDevice [RTD] extension group.
            %(2) The driver assumes that you are using a Platinum
            %Resistance Temperature Device.
            
            narginchk(3,3)
            Alpha = obj.checkScalarDoubleArg(Alpha);
            Resistance = obj.checkScalarDoubleArg(Resistance);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDmm_ConfigureRTD', session, Alpha, Resistance);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureThermistor(obj,Resistance)
            %CONFIGURETHERMISTOR This function configures the
            %resistance for a thermistor temperature measurement device.
            % This function affects the behavior of the instrument only
            %when the IVIDMM_ATTR_TEMP_TRANSDUCER_TYPE attribute is set
            %to IVIDMM_VAL_THERMISTOR.  Note:  (1) This function is part
            %of the IviDmmThermistor [THM] extension group.
            
            narginchk(2,2)
            Resistance = obj.checkScalarDoubleArg(Resistance);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDmm_ConfigureThermistor', session, Resistance);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
