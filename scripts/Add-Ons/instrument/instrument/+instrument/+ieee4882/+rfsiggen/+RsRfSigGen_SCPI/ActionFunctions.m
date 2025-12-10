classdef ActionFunctions < instrument.ieee4882.rfsiggen.ActionFunctions & instrument.ieee4882.rfsiggen.RsRfSigGen_SCPI.RohdeSchwarzbase
    % ACTIONFUNCTIONS This class contains functions that
    % initiate instrument operations and report their status.
    
    % Copyright 2017 The MathWorks, Inc.
    
    %% Constructor
    methods (Hidden=true)
        function obj = ActionFunctions(interface)
            % Initialize properties
            obj.Interface = interface;
        end
    end
    
    %% Public Methods
    methods
        function WaitUntilSettled(obj,maxTime)
            % WAITUNTILSETTLED This function waits until the state of
            % the RF output signal has settled.
            
            narginchk(2,2)
            % Defines the maximum time the function waits for the output to
            % be settled. The units are milliseconds.
            maxTime = obj.checkScalarInt32Arg(maxTime);
            tStart = tic;
            tElapsed = toc(tStart);
            while ~obj.IsSettled && (tElapsed <= round(maxTime/1000))
                tElapsed = toc(tStart);
            end
        end
        
        function isSettled = IsSettled(obj)
            % ISSETTLED This function queries if the RF output signal is
            % currently settled.
            
            narginchk(1,1)
            isSettled = ~str2double(obj.queryInstrument(':STATus:OPERation:CONDition?'));
        end
        
        function DisableAllModulation(obj)
            % DISABLEALLMODULATION This function disables the modulation of
            % the RF output with the currently active modulation type(s).
            
            narginchk(1,1)
            obj.sendCmdToInstrument(':SOURce:MODulation:ALL:STATe 0');
        end
        
        function SendSoftwareTrigger(obj)
            % SENDSOFTWARETRIGGER This function triggers the device if 'Software'
            % is the selected trigger source, otherwise, *TRG is ignored.
            
            narginchk(1,1)
            obj.sendCmdToInstrument('*TRG');
            
        end
    end
end
