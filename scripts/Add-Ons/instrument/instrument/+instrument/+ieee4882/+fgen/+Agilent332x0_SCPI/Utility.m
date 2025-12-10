classdef Utility < instrument.ieee4882.fgen.Utility & instrument.ieee4882.fgen.Agilent332x0_SCPI.Agilentbase
    %UTILITY Class provides an implementation for Agilent fgen for
    %the abstract methods defined in its abstract parent class.
    
    % Copyright 2012 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = Utility(interface)
            obj.Interface = interface;
        end

    end    
        
    %% Public Read Only Properties
    
    methods
        
        function reset(obj)
            %RESET This function resets the instrument to the factory default state
            obj.sendCmdToInstrument('*RST');
        end
        
        function [manufacturer, model] = getInstrumentInfo(obj)
            value = obj.queryInstrument ('*IDN?');
            % remove firmware info portion
            positions = strfind (value , ',');
            if ~isempty (positions)
                manufacturer = value (1: positions(1) -1 );
                model = value(positions(1)+1:positions(2)-1);
            end
        end        
       
    end
end
