classdef MeasurementOperationOptions < instrument.ivic.IviGroupBase
    %MEASUREMENTOPERATIONOPTIONS This class contains functions
    %that configure the instrument for different measurement
    %operations. These operations are the auto zero mode and
    %powerline frequency.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureAutoZeroMode(obj,AutoZeroMode)
            %CONFIGUREAUTOZEROMODE This function configures the auto
            %zero mode of the DMM.  Note:  (1) This function is part of
            %the IviDmmAutoZero [AZ] extension group.
            
            narginchk(2,2)
            AutoZeroMode = obj.checkScalarInt32Arg(AutoZeroMode);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDmm_ConfigureAutoZeroMode', session, AutoZeroMode);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigurePowerLineFrequency(obj,PowerLineFrequency)
            %CONFIGUREPOWERLINEFREQUENCY This function configures the
            %power line frequency of the DMM.  Note:  (1) This function
            %is part of the IviDmmPowerLineFrequency [PLF] extension
            %group.
            
            narginchk(2,2)
            PowerLineFrequency = obj.checkScalarDoubleArg(PowerLineFrequency);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDmm_ConfigurePowerLineFrequency', session, PowerLineFrequency);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
