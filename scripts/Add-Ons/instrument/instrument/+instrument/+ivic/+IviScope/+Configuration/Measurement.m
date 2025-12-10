classdef Measurement < instrument.ivic.IviGroupBase
    %MEASUREMENT This class contains functions that configure
    %the measurement subsystem.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureRefLevels(obj,LowRefpercentage,MidRefpercentage,HighRefpercentage)
            %CONFIGUREREFLEVELS This function configures the reference
            %levels for waveform measurements.    You must call this
            %function before you call the
            %IviScope_ReadWaveformMeasurement or
            %IviScope_FetchWaveformMeasurement to take measurements.
            %Notes:  (1) This function is part of the
            %IviScopeWaveformMeasurement [WM] extension group.
            
            narginchk(4,4)
            LowRefpercentage = obj.checkScalarDoubleArg(LowRefpercentage);
            MidRefpercentage = obj.checkScalarDoubleArg(MidRefpercentage);
            HighRefpercentage = obj.checkScalarDoubleArg(HighRefpercentage);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviScope_ConfigureRefLevels', session, LowRefpercentage, MidRefpercentage, HighRefpercentage);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
