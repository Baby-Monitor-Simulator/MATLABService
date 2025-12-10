classdef (Hidden) InstrumentManager < handle
    %InstrumentManager class for managing instrument objects.
    % InstrumentManager singleton class to track Universal Driver model
    %objects. Instrreset uses this class to remove all UDM objects.

    % Copyright 2011 The MathWorks, Inc.
    
    
    events
        ResetEvent;
    end
    
    %private constructor prevent instantiate class directly
    methods(Access=private)
        function obj = InstrumentManager()
        end
    end
    
    %static methods
    methods(Static)
        
        % GetInstance is the only way to access InstrumentManager singleton object
        function value = getInstance()
            
            persistent Instance;
            
            if isempty(Instance) || ~isvalid(Instance)
                Instance = instrument.internal.udm.InstrumentManager();
            end
            value = Instance;
        end
        
        
        %reset is called by instrreset to delete all(UDM)instrument object.
        function reset()
            
            notify (instrument.internal.udm.InstrumentManager.getInstance, 'ResetEvent');
            %remove itself.
            delete ( instrument.internal.udm.InstrumentManager.getInstance);
            
        end
        
    end
end

