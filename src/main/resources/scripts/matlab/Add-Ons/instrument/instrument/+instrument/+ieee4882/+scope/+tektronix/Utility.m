classdef Utility < instrument.ieee4882.scope.Utility & instrument.ieee4882.scope.tektronix.Tekbase
    %UTILITY Class provides an implementation for Tektronix Oscilloscope for
    %the abstract methods defined in its abstract parent class.

    % Copyright 2011 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = Utility(interface)
            obj.Interface = interface;
        end

    end
    
    %% Public Methods
    methods
        
         function autoSetup(obj)
           obj.sendCmdToInstrument('AUTOSet EXECUTE');
         end
        
        function reset(obj)
            %RESET This function resets the instrument to a known state.
            obj.sendCmdToInstrument ('FACtory');
            obj.sendCmdToInstrument ( 'HEADER OFF');
            
        end
        
        function value = getInstrumentInfo(obj)
            value = obj.queryInstrument ('*IDN?');
            
            % remove firmware info portion
            positions = strfind (value , ',');
            if ~isempty (positions)
                value = value (1: positions(2) -1 );
            end
        end
        

    end
    

   
end
