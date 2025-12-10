classdef RF < instrument.ieee4882.rfsiggen.RF & instrument.ieee4882.rfsiggen.RsRfSigGen_SCPI.RohdeSchwarzbase
    % RF This class contains all of the fundamental attributes
    % for the RFSigGen
    
    % Copyright 2017 The MathWorks, Inc.
    
    %% Constructor
    methods (Hidden = true)
        function obj = RF(interface)
            obj.Interface = interface;
        end
    end
    
    %% Public Properties
    properties  (Dependent)
        % FREQUENCY Specifies the frequency of the generated RF
        % output signal.
        Frequency
        
        % POWERLEVEL Specifies the amplitude (power level) of the
        % RF output signal. The value is in dBm.
        % Note: -90~20 dBm
        PowerLevel
        
        % OUTPUTENABLED Specifies whether to enable or disable the
        % RF output signal.
        OutputEnabled
    end
    
    %% Property access methods
    methods
        %% FREQUENCY property access methods
        function value = get.Frequency(obj)
            % Get the Frequency
            value = str2double(obj.queryInstrument(':SOURce:FREQuency:CW?'));
        end
        function set.Frequency(obj,newValue)
            % Set the Frequency
            obj.sendCmdToInstrument([':SOURce:FREQuency:CW ', num2str(newValue)]);
        end
        
        %% POWERLEVEL property access methods
        function value = get.PowerLevel(obj)
            % Get the Power Level
            value = str2double(obj.queryInstrument(':POWer:LEVel:IMMediate:AMPLitude?'));
        end
        function set.PowerLevel(obj,newValue)
            % Set the Power Level
            obj.sendCmdToInstrument([':SOURce:POWer:LEVel:IMMediate:AMPLitude ', num2str(newValue)]);
        end
        
        %% OUTPUTENABLED property access methods
        function value = get.OutputEnabled(obj)
            % Get OutputEnabled
            value = str2double(obj.queryInstrument(':OUTPut:STATe?'));
            value = logical(value);
        end
        function set.OutputEnabled(obj,newValue)
            % Set the OutputEnabled
            obj.sendCmdToInstrument([':OUTPut:STATe ', num2str(newValue)]);
        end
    end
    
    %% Public Methods
    methods
        function ConfigureRF(obj,Frequency,PowerLevel)
            % CONFIGURERF This function configures the frequency and the
            % power level of the RF output signal.
            narginchk(3,3)
            obj.Frequency = obj.checkScalarDoubleArg(Frequency);
            obj.PowerLevel = obj.checkScalarDoubleArg(PowerLevel);
        end
        
        
        function ConfigureOutputEnabled(obj,OutputEnabled)
            % CONFIGUREOUTPUTENABLED This function enables the RF output
            % signal.
            narginchk(2,2)
            OutputEnabled = obj.checkScalarBoolArg(OutputEnabled);
            obj.OutputEnabled = OutputEnabled;
        end
    end
end
