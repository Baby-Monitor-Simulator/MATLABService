classdef IQ < instrument.ieee4882.rfsiggen.IQ & instrument.ieee4882.rfsiggen.AgRfSigGen_SCPI.Agilentbase
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
        % applies IQ (vector) modulation to the output RF signal
        IQEnabled
        
        % IQSOURCE Specifies the source of the signal that the
        % signal generator uses for IQ modulation.
        %         DigitalModulation (0)
        %         CDMA              (1)
        %         TDMA              (2)
        %         ArbGenerator      (3)
        %         External          (4)
        IQSource
        
        % IQSWAPENABLED Enables or disables the inverse phase
        % rotation of the IQ signal by swapping the I and Q inputs.
        % If VI_TRUE, the RF signal generator applies non-inverse
        % phase rotation of the IQ signal.  If VI_FALSE, the RF
        % signal generator applies inverse phase rotation of the IQ
        % signal.
        IQSwapEnabled
    end
    
    %% Property access methods
    methods
        %% IQEnabled property access methods
        function value = get.IQEnabled(obj)
            % Get IQEnabled
            value = str2double(obj.queryInstrument('OUTPut:MODulation:STATe?'));
            value = logical(value);
        end
        function set.IQEnabled(obj,newValue)
            % Set IQEnabled
            
            % Enables or disables the modulation of the RF output with the
            % currently active modulation type(s)
            obj.sendCmdToInstrument(['OUTPut:MODulation:STATe ', num2str(newValue)]);
            % Enables or disables the I/Q modulator
            obj.sendCmdToInstrument(['SOURce:DM:STATe ', num2str(newValue)]);
        end
        
        %% IQSource property access methods
        function value = get.IQSource(obj)
            
            if strcmpi(deblank(obj.queryInstrument('SOURce:DM:SOURce?')), 'EXT')
                value = 'External';
            elseif str2double(obj.queryInstrument('SOURce:RADio:CDMA:ARB:STATe?'))
                value = 'CDMA';
            elseif str2double(obj.queryInstrument('SOURce:RADio:DMODulation:ARB:STATe?'))
                value = 'DigitalModulation';
            elseif str2double(obj.queryInstrument('SOURce:RADio:EDGE:BURSt:STATe?'))
                value = 'TDMA';
            elseif str2double(obj.queryInstrument('SOURce:RADio:ARB:STATe?'))
                value = 'ArbGenerator';
            else
                % If IQ Source has been set yet, set it to 'External'.
                value = 'External';
            end
            
            
        end
        function set.IQSource(obj,newValue)
            switch newValue
                case 'ArbGenerator'
                    obj.sendCmdToInstrument('OUTPut:MODulation:STATe 0');
                    obj.sendCmdToInstrument('SOURce:DM:STATe 0');
                    obj.sendCmdToInstrument('SOURce:RADio:CDMA:ARB:STATe 0');
                    obj.sendCmdToInstrument('SOURce:RADio:DMODulation:ARB:STATe 0');
                    obj.sendCmdToInstrument('SOURce:RADio:EDGE:STATe 0');
                    % Enables the arbitrary waveform generator function.
                    obj.sendCmdToInstrument('SOURce:RADio:ARB:STATe 1');
                    obj.sendCmdToInstrument('SOURce:DM:SOURce INTernal');
                    obj.sendCmdToInstrument('SOURce:DM:STATe 1');
                case 'CDMA'
                    obj.sendCmdToInstrument('OUTPut:MODulation:STATe 0');
                    obj.sendCmdToInstrument('SOURce:DM:STATe 0');
                    obj.sendCmdToInstrument('SOURce:RADio:ARB:STATe 0');
                    obj.sendCmdToInstrument('SOURce:RADio:DMODulation:ARB:STATe 0');
                    obj.sendCmdToInstrument('SOURce:RADio:EDGE:STATe 0');
                    % Enables the CDMA modulation format.
                    obj.sendCmdToInstrument('SOURce:RADio:CDMA:ARB:STATe 1');
                    obj.sendCmdToInstrument('SOURce:DM:SOURce INTernal');
                    obj.sendCmdToInstrument('SOURce:DM:STATe 1');
                case 'DigitalModulation'
                    obj.sendCmdToInstrument('OUTPut:MODulation:STATe 0');
                    obj.sendCmdToInstrument('SOURce:DM:STATe 0');
                    obj.sendCmdToInstrument('SOURce:RADio:ARB:STATe 0');
                    obj.sendCmdToInstrument('SOURce:RADio:CDMA:ARB:STATe 0');
                    obj.sendCmdToInstrument('SOURce:RADio:EDGE:STATe 0');
                    % Enables the digital modulation capability.
                    obj.sendCmdToInstrument('SOURce:RADio:DMODulation:ARB:STATe 1');
                    obj.sendCmdToInstrument('SOURce:DM:SOURce INTernal');
                    obj.sendCmdToInstrument('SOURce:DM:STATe 1');
                case 'External'
                    obj.sendCmdToInstrument('OUTPut:MODulation:STATe 0');
                    obj.sendCmdToInstrument('SOURce:DM:STATe 0');
                    obj.sendCmdToInstrument('SOURce:RADio:ARB:STATe 0');
                    obj.sendCmdToInstrument('SOURce:RADio:CDMA:ARB:STATe 0');
                    obj.sendCmdToInstrument('SOURce:RADio:DMODulation:ARB:STATe 0');
                    obj.sendCmdToInstrument('SOURce:RADio:EDGE:STATe 0');
                    % Selects the I/Q modulator source.
                    obj.sendCmdToInstrument('SOURce:DM:SOURce EXTernal');
                case 'TDMA'
                    obj.sendCmdToInstrument('OUTPut:MODulation:STATe 0');
                    obj.sendCmdToInstrument('SOURce:DM:STATe 0');
                    obj.sendCmdToInstrument('SOURce:RADio:ARB:STATe 0');
                    obj.sendCmdToInstrument('SOURce:RADio:CDMA:ARB:STATe 0');
                    obj.sendCmdToInstrument('SOURce:RADio:DMODulation:ARB:STATe 0');
                    % Enables the EDGE modulation format.
                    obj.sendCmdToInstrument('SOURce:RADio:EDGE:STATe 1');
                    % Enables the burst function.
                    obj.sendCmdToInstrument('SOURce:RADio:EDGE:BURSt:STATe 1');
                    obj.sendCmdToInstrument('SOURce:DM:SOURce INTernal');
                    obj.sendCmdToInstrument('SOURce:DM:STATe 1');
            end
        end
        
        %% IQSWAPENABLED property access methods
        function value = get.IQSwapEnabled(obj)
            % Get IQSwapEnabled
            value = obj.queryInstrument('SOURce:DM:POLarity:ALL?');
            if contains(value,'NORM')
                value = 0;
            elseif contains(value,'INV')
                value = 1;
            end
        end
        function set.IQSwapEnabled(obj,newValue)
            if newValue == true
                obj.sendCmdToInstrument('SOURce:DM:POLarity:ALL INVert');
            else
                obj.sendCmdToInstrument('SOURce:DM:POLarity:ALL NORMal');
            end
        end
    end
    
    %% Public Methods
    methods
        function ConfigureIQEnabled(obj,iqEnabled)
            % CONFIGUREIQENABLED This function configures the signal
            % generator to apply IQ (vector) modulation to the RF output
            % signal.
            
            narginchk(2,2)
            iqEnabled = obj.checkScalarBoolArg(iqEnabled);
            obj.IQEnabled = iqEnabled;
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