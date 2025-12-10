classdef Burst < instrument.ivic.IviGroupBase
    %BURST This class contains functions that configure the
    %number of waveform cycles the function generator produces
    %when in the burst operation mode.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureBurstCount(obj,ChannelName,Count)
            %CONFIGUREBURSTCOUNT This function configures the burst
            %count.  When the function generator receives a trigger
            %while in the Burst operation mode, it generates the number
            %of waveform cycles you specify in the Count parameter.
            %Notes:  (1) This function is part of the IviFgenBurst [BST]
            %extension group.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            Count = obj.checkScalarInt32Arg(Count);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviFgen_ConfigureBurstCount', session, ChannelName, Count);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
