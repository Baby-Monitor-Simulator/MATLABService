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
            obj.LowLevelMeasurement = instrument.ivic.IviDmm.Measurement.LowLevelMeasurement();
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
        %low-level control over how the DMM takes measurements.  The
        %functions perform the following operations:  - initiate the
        %measurement process, - send a software trigger,  - fetch
        %measurement values, and  - abort the measurement process.
        %  Read Only.
        LowLevelMeasurement
    end
    
    %% Property access methods
    methods
        %% LowLevelMeasurement property access methods
        function value = get.LowLevelMeasurement(obj)
            if isempty(obj.LowLevelMeasurement)
                obj.LowLevelMeasurement = instrument.ivic.IviDmm.Measurement.LowLevelMeasurement();
            end
            value = obj.LowLevelMeasurement;
        end
    end
    
    %% Public Methods
    methods
        function Reading = Read(obj,MaximumTimems)
            %READ This function initiates a measurement, waits until
            %the DMM has returned to the Idle state, and returns the
            %measured value.  Notes:  (1) After this function executes,
            %the Reading parameter contains  an actual reading or a
            %value indicating that an over-range condition occurred.
            %(2) If an over-range condition occurs, the Reading
            %parameter contains an IEEE defined NaN (Not a Number) value
            %and the function returns IVIDMM_WARN_OVER_RANGE
            %(0x3FFA2001).    (3) You can test the measurement value for
            %an over-range condition by calling the IviDmm_IsOverRange
            %function.  (4) This function performs interchangeability
            %checking when the IVIDMM_ATTR_INTERCHANGE_CHECK attribute
            %is set to True.  If the IVIDMM_ATTR_SPY attribute is set to
            %True, you use the NI Spy utility to view interchangeability
            %warnings.  You use the IviDmm_GetNextInterchangeWarning
            %function to retrieve interchangeability warnings when the
            %IVIDMM_ATTR_SPY attribute is set to False.  For more
            %information about interchangeability checking, refer to the
            %help text for the IVIDMM_ATTR_INTERCHANGE_CHECK attribute.
            %(5) The class driver returns a simulated measurement when
            %this  function is called and the IVIDMM_ATTR_SIMULATE
            %attribute is set to True and the
            %IVIDMM_ATTR_USE_SPECIFIC_SIMULATION attribute is set to
            %False.  For information on how to configure a simulated
            %measurement, refer to the online help manual.
            
            narginchk(2,2)
            MaximumTimems = obj.checkScalarInt32Arg(MaximumTimems);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Reading = libpointer('doublePtr', 0);
                
                status = calllib( libname,'IviDmm_Read', session, MaximumTimems, Reading);
                
                Reading = Reading.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function [ReadingArray,ActualNumberofPoints] = ReadMultiPoint(obj,MaximumTimems,ArraySize,ReadingArray)
            %READMULTIPOINT This function initiates the measurement,
            %waits for the DMM to return to the Idle state, and returns
            %an array of measured values.  The number of measurements
            %the DMM takes is determined by the values you specify for
            %the Trigger Count and Sample Count parameters of the
            %IviDmm_ConfigureMultiPoint function.  Notes:  (1) This
            %function is part of the IviDmmMultiPoint [MP] extension
            %group.  (2) After this function executes, each element in
            %the Reading Array parameter is an actual reading or a value
            %indicating that an over-range condition occurred.  (3) If
            %an over-range condition occurs, the corresponding Reading
            %Array element contains an IEEE defined NaN (Not a Number)
            %value and the function returns IVIDMM_WARN_OVER_RANGE
            %(0x3FFA2001).   (4) You can test each element in the
            %Reading Array parameter for an over-range condition by
            %calling the IviDmm_IsOverRange function.  (5) This function
            %performs interchangeability checking when the
            %IVIDMM_ATTR_INTERCHANGE_CHECK attribute is set to True.  If
            %the IVIDMM_ATTR_SPY attribute is set to True, you use the
            %NI Spy utility to view interchangeability warnings.  You
            %use the IviDmm_GetNextInterchangeWarning function to
            %retrieve interchangeability warnings when the
            %IVIDMM_ATTR_SPY attribute is set to False.  For more
            %information about interchangeability checking, refer to the
            %help text for the IVIDMM_ATTR_INTERCHANGE_CHECK attribute.
            %(6) The class driver initiates an array of simulated
            %measurements when this function is called and the
            %IVIDMM_ATTR_SIMULATE attribute is set to True and the
            %IVIDMM_ATTR_USE_SPECIFIC_SIMULATION attribute is set to
            %False.  For information on how to configure a simulated
            %measurement, refer to the online help manual.
            
            narginchk(4,4)
            MaximumTimems = obj.checkScalarInt32Arg(MaximumTimems);
            ArraySize = obj.checkScalarInt32Arg(ArraySize);
            ReadingArray = obj.checkVectorDoubleArg(ReadingArray);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ReadingArray = libpointer('doublePtr', ReadingArray);
                ActualNumberofPoints = libpointer('int32Ptr', 0);
                
                status = calllib( libname,'IviDmm_ReadMultiPoint', session, MaximumTimems, ArraySize, ReadingArray, ActualNumberofPoints);
                
                ReadingArray = ReadingArray.Value;
                ActualNumberofPoints = ActualNumberofPoints.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
