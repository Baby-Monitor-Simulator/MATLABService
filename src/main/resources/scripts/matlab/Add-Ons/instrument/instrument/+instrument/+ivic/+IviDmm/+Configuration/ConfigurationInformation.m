classdef ConfigurationInformation < instrument.ivic.IviGroupBase
    %CONFIGURATIONINFORMATION This class contains functions
    %that return information about the current state of the
    %instrument. This information includes the actual range,
    %aperture time, and the aperture time units.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ActualRange = GetAutoRangeValue(obj)
            %GETAUTORANGEVALUE This function returns the actual range
            %the DMM is currently using, even while it is auto-ranging.
            %Note:   (1) This function is part of the
            %IviDmmAutoRangeValue [ARV] extension group.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                ActualRange = libpointer('doublePtr', 0);
                
                status = calllib( libname,'IviDmm_GetAutoRangeValue', session, ActualRange);
                
                ActualRange = ActualRange.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function [ApertureTime,ApertureTimeUnits] = GetApertureTimeInfo(obj)
            %GETAPERTURETIMEINFO This function returns additional
            %information about the state of the instrument.
            %Specifically, it returns the aperture time and the aperture
            %time units.  Note:   (1) This function is part of the
            %IviDmmDeviceInfo [DI] extension group.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                ApertureTime = libpointer('doublePtr', 0);
                ApertureTimeUnits = libpointer('int32Ptr', 0);
                
                status = calllib( libname,'IviDmm_GetApertureTimeInfo', session, ApertureTime, ApertureTimeUnits);
                
                ApertureTime = ApertureTime.Value;
                ApertureTimeUnits = ApertureTimeUnits.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
