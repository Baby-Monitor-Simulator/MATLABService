classdef Triggering < instrument.ivic.IviGroupBase
    %TRIGGERING This class contains functions that configure
    %the triggering source.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = Triggering()
            %% Initialize properties
            obj.InternalTrigger = instrument.ivic.IviFgen.ConfigurationFunctions.Triggering.InternalTrigger();
        end
        
        function delete(obj)
            obj.InternalTrigger = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.InternalTrigger.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %INTERNALTRIGGER This class contains functions that
        %configure the internal trigger source. Read Only.
        InternalTrigger
    end
    
    %% Property access methods
    methods
        %% InternalTrigger property access methods
        function value = get.InternalTrigger(obj)
            if isempty(obj.InternalTrigger)
                obj.InternalTrigger = instrument.ivic.IviFgen.ConfigurationFunctions.Triggering.InternalTrigger();
            end
            value = obj.InternalTrigger;
        end
    end
    
    %% Public Methods
    methods
        function ConfigureTriggerSource(obj,ChannelName,TriggerSource)
            %CONFIGURETRIGGERSOURCE This function configures the
            %function generator's trigger source.  Notes:  (1) This
            %function is part of the IviFgenTrigger [TRG] extension
            %group.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            TriggerSource = obj.checkScalarInt32Arg(TriggerSource);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviFgen_ConfigureTriggerSource', session, ChannelName, TriggerSource);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
