classdef Configuration < instrument.ivic.IviGroupBase
    %CONFIGURATION This class contains functions and
    %sub-classes that configure the DMM.  The class includes
    %high-level functions that configure the basic measurement
    %operation and subclasses that configure the trigger and the
    %multi-point measurement capability.  It also contains
    %sub-classes that configure additional parameters for some
    %measurement types and that return information about the
    %current state of the instrument. The class also contains
    %the low-level functions that set, get, and check individual
    %attribute values.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = Configuration()
            %% Initialize properties
            obj.Trigger = instrument.ivic.IviPwrMeter.Configuration.Trigger();
            obj.ReferenceOscillator = instrument.ivic.IviPwrMeter.Configuration.ReferenceOscillator();
            obj.SetGetCheckAttribute = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute();
        end
        
        function delete(obj)
            obj.SetGetCheckAttribute = [];
            obj.ReferenceOscillator = [];
            obj.Trigger = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.SetGetCheckAttribute.setLibraryAndSession(libName, session);
            obj.ReferenceOscillator.setLibraryAndSession(libName, session);
            obj.Trigger.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %TRIGGER This class contains a function that can specify a
        %trigger source on which to trigger a measurement. Read Only.
        Trigger
        
        %REFERENCEOSCILLATOR This class contains functions to
        %perform the calibration. Read Only.
        ReferenceOscillator
        
        %SETGETCHECKATTRIBUTE This class contains sub-classes for
        %the set, get, and check attribute functions.   Read Only.
        SetGetCheckAttribute
    end
    
    %% Property access methods
    methods
        %% Trigger property access methods
        function value = get.Trigger(obj)
            if isempty(obj.Trigger)
                obj.Trigger = instrument.ivic.IviPwrMeter.Configuration.Trigger();
            end
            value = obj.Trigger;
        end
        
        %% ReferenceOscillator property access methods
        function value = get.ReferenceOscillator(obj)
            if isempty(obj.ReferenceOscillator)
                obj.ReferenceOscillator = instrument.ivic.IviPwrMeter.Configuration.ReferenceOscillator();
            end
            value = obj.ReferenceOscillator;
        end
        
        %% SetGetCheckAttribute property access methods
        function value = get.SetGetCheckAttribute(obj)
            if isempty(obj.SetGetCheckAttribute)
                obj.SetGetCheckAttribute = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute();
            end
            value = obj.SetGetCheckAttribute;
        end
    end
    
    %% Public Methods
    methods
        function ConfigureUnits(obj,MeasurementUnits)
            %CONFIGUREUNITS This function configures the unit to which
            %the RF power is converted after measurement.
            
            narginchk(2,2)
            MeasurementUnits = obj.checkScalarInt32Arg(MeasurementUnits);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviPwrMeter_ConfigureUnits', session, MeasurementUnits);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureMeasurement(obj,Operator,Operand1,Operand2)
            %CONFIGUREMEASUREMENT This function configures the
            %instrument to take single or dual channel measurements.
            %For single channel measurements, this function enables the
            %channel specified by Operand1 and disables all other
            %channels. The result returned by the Fetch or Read
            %functions is the measurement taken at the channel specified
            %by the Operand1 parameter.  Although, the driver measures
            %the power in Watts, the result is converted to the same
            %unit the IVIPWRMETER_ATTR_UNITS attribute.  For dual
            %channel measurements, this function enables the channels
            %specified by the Operand1 and Operand2 parameters and
            %disables all other channels. The result returned by the
            %Fetch or Read functions is the result of the specified math
            %operation applied to the measurements on the channels
            %specified by Operand1 and Operand2.  Although, the math
            %operation is performed on the measured values in Watts, the
            %result is converted to the appropriate units depending on
            %the value of the IVIPWRMETER_ATTR_UNITS attribute and the
            %value of the Operator.    For Difference and Sum
            %operations, the resulting units is the same as the
            %IVIPWRMETER_ATTR_UNITS attribute.  For Quotient operations,
            %the resulting units are in dB, except when
            %IVIPWRMETER_ATTR_UNITS attribute is set to Watts.  When set
            %to Watts, the resulting measurement is without units.
            
            narginchk(4,4)
            Operator = obj.checkScalarInt32Arg(Operator);
            Operand1 = obj.checkScalarStringArg(Operand1);
            Operand2 = obj.checkScalarStringArg(Operand2);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Operand1 = [double(Operand1) 0];
                Operand2 = [double(Operand2) 0];
                
                status = calllib( libname,'IviPwrMeter_ConfigureMeasurement', session, Operator, Operand1, Operand2);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureRangeAutoEnabled(obj,ChannelName,RangeAutoEnabled)
            %CONFIGURERANGEAUTOENABLED This function enables or
            %disables the auto range mode for a given channel.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            RangeAutoEnabled = obj.checkScalarBoolArg(RangeAutoEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviPwrMeter_ConfigureRangeAutoEnabled', session, ChannelName, RangeAutoEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureAveragingAutoEnabled(obj,ChannelName,AutoAveragingEnabled)
            %CONFIGUREAVERAGINGAUTOENABLED This function enables or
            %disables the auto-averaging mode for a given channel.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            AutoAveragingEnabled = obj.checkScalarBoolArg(AutoAveragingEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviPwrMeter_ConfigureAveragingAutoEnabled', session, ChannelName, AutoAveragingEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureCorrectionFrequency(obj,ChannelName,Frequency)
            %CONFIGURECORRECTIONFREQUENCY  This function specifies the
            %frequency of the input signal in Hertz. The instrument uses
            %this value to determine the appropriate correction factor
            %for the sensor.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            Frequency = obj.checkScalarDoubleArg(Frequency);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviPwrMeter_ConfigureCorrectionFrequency', session, ChannelName, Frequency);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureOffset(obj,ChannelName,Offset)
            %CONFIGUREOFFSET This function specifies the offset to be
            %added to the measured value in units of dB.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            Offset = obj.checkScalarDoubleArg(Offset);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviPwrMeter_ConfigureOffset', session, ChannelName, Offset);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureRange(obj,ChannelName,RangeLower,RangeUpper)
            %CONFIGURERANGE This function configures lower and upper
            %range values for a given channel.
            
            narginchk(4,4)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            RangeLower = obj.checkScalarDoubleArg(RangeLower);
            RangeUpper = obj.checkScalarDoubleArg(RangeUpper);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviPwrMeter_ConfigureRange', session, ChannelName, RangeLower, RangeUpper);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureAveragingCount(obj,ChannelName,AveragingCount)
            %CONFIGUREAVERAGINGCOUNT This function sets the average
            %count that the instrument uses in manual averaging mode.
            %The averaging count specifies the number of samples that
            %the instrument takes before the measurement is complete.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            AveragingCount = obj.checkScalarInt32Arg(AveragingCount);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviPwrMeter_ConfigureAveragingCount', session, ChannelName, AveragingCount);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureDutyCycleCorrection(obj,ChannelName,CorrectionEnabled,CorrectionValue)
            %CONFIGUREDUTYCYCLECORRECTION This function enables or
            %disables the duty cycle correction and sets the duty cycle
            %correction for pulse power measurements.
            
            narginchk(4,4)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            CorrectionEnabled = obj.checkScalarBoolArg(CorrectionEnabled);
            CorrectionValue = obj.checkScalarDoubleArg(CorrectionValue);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviPwrMeter_ConfigureDutyCycleCorrection', session, ChannelName, CorrectionEnabled, CorrectionValue);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ChannelName = GetChannelName(obj,Index,BufferSize)
            %GETCHANNELNAME This function returns the physical channel
            %identifier that corresponds to the one-based index
            %specified by the ChannelIndex parameter.   Notes:  (1) If
            %you pass in a value for the ChannelIndex parameter that is
            %less than one or greater than the value of the Channel
            %Count attribute, the function returns an empty string in
            %the ChannelName parameter and returns an error.   (2) By
            %passing 0 for the buffer size, you can ascertain the buffer
            %size required to get the entire channel name string and
            %then call the function again with a sufficiently large
            %buffer.
            
            narginchk(3,3)
            Index = obj.checkScalarInt32Arg(Index);
            BufferSize = obj.checkScalarInt32Arg(BufferSize);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                
                status = calllib( libname,'IviPwrMeter_GetChannelName', session, Index, BufferSize, ChannelName);
                
                ChannelName = strtrim(char(ChannelName.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureChannelEnabled(obj,ChannelName,ChannelEnabled)
            %CONFIGURECHANNELENABLED This function enables or disables
            %a specified channel for measurement.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            ChannelEnabled = obj.checkScalarBoolArg(ChannelEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviPwrMeter_ConfigureChannelEnabled', session, ChannelName, ChannelEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
