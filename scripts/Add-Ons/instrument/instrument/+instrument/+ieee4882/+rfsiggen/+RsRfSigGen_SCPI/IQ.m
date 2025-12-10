classdef IQ < instrument.ieee4882.rfsiggen.IQ & instrument.ieee4882.rfsiggen.RsRfSigGen_SCPI.RohdeSchwarzbase
    % IQ This class supports RFSigGens that can apply IQ
    % (vector) modulation to the output RF signal.
    
    % Copyright 2017 The MathWorks, Inc.
    
    %% Constructor
    methods (Hidden = true)
        function obj = IQ(interface)
            obj.Interface = interface;
        end
    end
    
    %% Public Properties
    properties (Dependent)
        % IQENABLED Specifies whether the signal generator
        % applies IQ (vector) modulation to the output RF signal.
        IQEnabled
        
        % IQSOURCE Specifies the source of the signal that the
        % signal generator uses for IQ modulation.
        %         DigitalModulation (0)
        %         CDMA              (1)
        %         TDMA              (2)
        %         ArbGenerator      (3)
        %         External          (4)
        IQSource
        
        % IQSWAPENABLED Enables or disables the I and Q channel
        % swaps of the baseband signal.
        IQSwapEnabled
    end
    
    
    %% Property access methods
    methods
        %% IQENABLED property access methods
        function value = get.IQEnabled(obj)
            value = str2double(obj.queryInstrument(':SOURce:IQ:STATe?'));
            value = logical(value);
        end
        function set.IQEnabled(obj,newValue)
            % Deactivates all modulations
            obj.sendCmdToInstrument(':SOURce:MODulation:ALL:STATe 0');
            % Activates/deactivates I/Q modulation.
            obj.sendCmdToInstrument([':SOURce:IQ:STATe ', num2str(newValue)]);
        end
        
        %% IQSOURCE property access methods
        function value = get.IQSource(obj)
            if strcmpi(deblank(obj.queryInstrument(':SOURce:IQ:SOURce?')), 'ANAL')
                value = 'External';
            elseif str2double(obj.queryInstrument(':SOURce:BB:ARBitrary:STATe?'))
                value = 'ArbGenerator';
            elseif str2double(obj.queryInstrument(':SOURce:BB:DM:STATe?'))
                value = 'DigitalModulation';
            elseif strcmpi(deblank(obj.queryInstrument(':SOURce:BB:DM:STANdard?')), 'CFOR') || ...
                    strcmpi(deblank(obj.queryInstrument(':SOURce:BB:DM:STANdard?')), 'CREV')
                value = 'CDMA';
            elseif strcmpi(deblank(obj.queryInstrument(':SOURce:BB:DM:STANdard?')), 'GSME')
                value = 'TDMA';
            else
                % If IQ Source has been set yet, set it to 'External'.
                value = 'External';
            end
        end
        function set.IQSource(obj,newValue)
            switch newValue
                case 'ArbGenerator'
                    obj.sendCmdToInstrument(':SOURce:MODulation:ALL:STATe 0');
                    obj.sendCmdToInstrument(':SOURce:IQ:STATe 0');
                    obj.sendCmdToInstrument(':SOURce:BB:DM:STATe 0');
                    % Enables the arbitrary waveform generator function.
                    obj.sendCmdToInstrument(':SOURce:BB:ARBitrary:STATe 1');
                    obj.sendCmdToInstrument(':SOURce:IQ:SOURce BASeband');
                    obj.sendCmdToInstrument(':SOURce:IQ:STATe 1');
                case 'CDMA'
                    obj.sendCmdToInstrument(':SOURce:MODulation:ALL:STATe 0');
                    obj.sendCmdToInstrument(':SOURce:IQ:STATe 0');
                    obj.sendCmdToInstrument(':SOURce:BB:ARBitrary:STATe 0');
                    obj.sendCmdToInstrument(':SOURce:BB:DM:STATe 0');
                    % Enables the CDMA modulation format.
                    obj.sendCmdToInstrument(':SOURce:BB:DM:STANdard CFORward');
                    obj.sendCmdToInstrument(':SOURce:IQ:SOURce BASeband');
                    obj.sendCmdToInstrument(':SOURce:IQ:STATe 1');
                case 'DigitalModulation'
                    obj.sendCmdToInstrument(':SOURce:MODulation:ALL:STATe 0');
                    obj.sendCmdToInstrument(':SOURce:IQ:STATe 0');
                    obj.sendCmdToInstrument(':SOURce:BB:ARBitrary:STATe 0');
                    % Enables the digital modulation capability.
                    obj.sendCmdToInstrument(':SOURce:BB:DM:STATe 1');
                    obj.sendCmdToInstrument(':SOURce:IQ:SOURce BASeband');
                    obj.sendCmdToInstrument(':SOURce:IQ:STATe 1');
                case 'External'
                    obj.sendCmdToInstrument(':SOURce:MODulation:ALL:STATe 0');
                    obj.sendCmdToInstrument(':SOURce:IQ:STATe 0');
                    obj.sendCmdToInstrument(':SOURce:BB:ARBitrary:STATe 0');
                    obj.sendCmdToInstrument(':SOURce:BB:DM:STATe 0');
                    % Selects the I/Q modulator source.
                    obj.sendCmdToInstrument(':SOURce:IQ:SOURce ANALog');
                case 'TDMA'
                    obj.sendCmdToInstrument(':SOURce:MODulation:ALL:STATe 0');
                    obj.sendCmdToInstrument(':SOURce:IQ:STATe 0');
                    obj.sendCmdToInstrument(':SOURce:BB:ARBitrary:STATe 0');
                    obj.sendCmdToInstrument(':SOURce:BB:DM:STATe 0');
                    % Enables the TDMA modulation format.
                    obj.sendCmdToInstrument(':SOURce:BB:DM:STANdard GSMEdge');
                    obj.sendCmdToInstrument(':SOURce:IQ:SOURce BASeband');
                    obj.sendCmdToInstrument(':SOURce:IQ:STATe 1');
            end
        end
        %% IQSWAPENABLED property access methods
        function value = get.IQSwapEnabled(obj)
            value = obj.queryInstrument(':SOURce:IQ:SWAP:STATe?');
        end
        function set.IQSwapEnabled(obj,newValue)
            if newValue == true
                obj.sendCmdToInstrument(':SOURce:IQ:SWAP:STATe 1');
            else
                obj.sendCmdToInstrument(':SOURce:IQ:SWAP:STATe 0');
            end
        end
        
    end
    %% Public Methods
    methods
        function ConfigureIQEnabled(obj,iqEnabled)
            % CONFIGUREIQENABLED This function activates/deactivates I/Q modulation.
            narginchk(2,2)
            obj.IQEnabled = obj.checkScalarBoolArg(iqEnabled);
        end
        function ConfigureIQ(obj,source,swapEnabled)
            % CONFIGUREIQ This function configures the signal generator
            % to apply IQ (vector) modulation to the RF output signal.
            narginchk(3,3)
            source = obj.checkScalarInt32Arg(source);
            swapEnabled = obj.checkScalarBoolArg(swapEnabled);
            obj.IQSource = source;
            obj.IQSwapEnabled = swapEnabled;
        end
    end
end
