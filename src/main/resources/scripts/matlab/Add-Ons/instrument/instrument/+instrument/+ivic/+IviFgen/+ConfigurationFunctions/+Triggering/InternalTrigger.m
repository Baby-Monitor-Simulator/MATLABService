classdef InternalTrigger < instrument.ivic.IviGroupBase
    %INTERNALTRIGGER This class contains functions that
    %configure the internal trigger source.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureInternalTriggerRate(obj,Rate)
            %CONFIGUREINTERNALTRIGGERRATE This function configures the
            %rate at which the function generator's internal trigger
            %source generates trigger signals.  Notes:  (1) This
            %function is part of the IviFgenInternalTrigger [IT]
            %extension group.
            
            narginchk(2,2)
            Rate = obj.checkScalarDoubleArg(Rate);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviFgen_ConfigureInternalTriggerRate', session, Rate);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
