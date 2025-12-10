classdef Measurement < instrument.ivic.IviGroupBase
    %MEASUREMENT This class contains functions and sub-classes
    %that initiate and retrieve measurements using the current
    %configuration.  The class contains high-level read
    %functions that initiate a measurement and fetch the data in
    %one operation.  The class also contains low-level functions
    %that initiate the measurement process, send a software
    %trigger, and fetch measurement values in separate
    %operations.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = Measurement()
            %% Initialize properties
            obj.LowLevelMeasurement = instrument.ivic.IviPwrMeter.Measurement.LowLevelMeasurement();
        end
        
        function delete(obj)
            obj.LowLevelMeasurement = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.LowLevelMeasurement.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %LOWLEVELMEASUREMENT The class contains functions that give
        %low-level control over how the Power Meter takes
        %measurements.  The functions perform the following
        %operations:  - initiate the measurement process, - send a
        %software trigger,  - fetch measurement values, and  - abort
        %the measurement process.     Read Only.
        LowLevelMeasurement
    end
    
    %% Property access methods
    methods
        %% LowLevelMeasurement property access methods
        function value = get.LowLevelMeasurement(obj)
            if isempty(obj.LowLevelMeasurement)
                obj.LowLevelMeasurement = instrument.ivic.IviPwrMeter.Measurement.LowLevelMeasurement();
            end
            value = obj.LowLevelMeasurement;
        end
    end
    
    %% Public Methods
    methods
        function Reading = Read(obj,MaximumTimems)
            %READ This function initiates a measurement, waits until
            %the power meter has returned to the Idle state, and returns
            %the result of the measurement.  After this function
            %executes, the value of the Reading parameter depends on the
            %math operation specified in the
            %IviPwrMeter_ConfigureMeasurement function.   If an out of
            %range condition occurs on one or more enabled channels, the
            %reading is a value indicating that an out of range
            %condition occurred. In such a case, the Reading parameter
            %contains an IEEE defined -Inf (Negative Infinity) or +Inf
            %(Positive Infinity) value and the function returns the
            %Under Range (0x3FFA2001) or Over Range (0x3FFA2002)
            %warning. Test if the measurement value is out of range with
            %the IviPwrMeter_QueryResultRangeType function.
            
            narginchk(2,2)
            MaximumTimems = obj.checkScalarInt32Arg(MaximumTimems);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Reading = libpointer('doublePtr', 0);
                
                status = calllib( libname,'IviPwrMeter_Read', session, MaximumTimems, Reading);
                
                Reading = Reading.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Reading = ReadChannel(obj,ChannelName,MaximumTimems)
            %READCHANNEL This function initiates a measurement, waits
            %until the power meter has returned to the Idle state, and
            %returns the result of the measurement on the specified
            %channel.  After this function executes, the Reading
            %parameter contains an actual reading on the channel
            %specified by the Channel parameter. If the specified
            %channel is not enabled for measurement, this function
            %returns the Channel Not Enabled (0xBFFA2001) error. The
            %Reading result is in the same unit as the value of the
            %Units attribute.  After this function executes, the Reading
            %parameter may contain a value indicating that an
            %out-of-range condition occurred. If an out-of-range
            %condition occurs, the Result parameter contains an IEEE
            %defined -Inf (Negative Infinity) or +Inf (Positive
            %Infinity) value and the function returns the Under Range
            %(0x3FFA2001) or Over Range (0x3FFA2002) warning. Test if
            %the measurement value is out of range with the
            %IviPwrMeter_QueryResultRangeType function.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            MaximumTimems = obj.checkScalarInt32Arg(MaximumTimems);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                Reading = libpointer('doublePtr', 0);
                
                status = calllib( libname,'IviPwrMeter_ReadChannel', session, ChannelName, MaximumTimems, Reading);
                
                Reading = Reading.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
