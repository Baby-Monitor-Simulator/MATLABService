classdef ARBGenerator < instrument.ieee4882.rfsiggen.ARBGenerator & instrument.ieee4882.rfsiggen.AgRfSigGen_SCPI.Agilentbase
    % ARBGENERATOR This class contains the attributes to control
    % the internal arbitrary generator.

    % Copyright 2017-2022 The MathWorks, Inc.

    %% Constructor
    methods (Hidden=true)
        function obj = ARBGenerator(interface)
            % Initialize properties
            obj.Interface = interface;
        end
    end

    %% Public Properties
    properties (Dependent)
        % CLOCKFREQUENCY Specifies the sample frequency.
        % The waveform is generated with this clock frequency.
        % Note: The upper limit is 100MHZ
        ClockFrequency

        % TRIGGERSOURCE Specifies how the Arb waveform is
        % started (triggered).
        %         Immediate (0)
        %         External  (1)
        %         Software  (2)
        TriggerSource

        % SELECTEDWAVEFORM Specifies the selected waveform from the pool of available waveforms.
        SelectedWaveform
    end

    properties
        % BYTEORDER Specifies the byte order of the data sent to, and read
        % from the instrument in a binblock. Valid values are
        % "little-endian" and "big-endian".
        ByteOrder
    end

    %% Public Properties ReadOnly
    properties (Constant)
        % WAVEFORMQUANTUM Specifies the waveform length must be a multiple of this quantum.
        WaveformQuantum = 2

        % WAVEFORMSIZEMIN Specifies the waveform length must be equal or greater than the min size.
        WaveformSizeMin = 60

        % WAVEFORMSIZEMAX Specifies the waveform length must be equal or less than the max size.
        WaveformSizeMax = 8000000
    end

    %% Private Properties ReadOnly
    properties (SetAccess = private)
        % MAXNUMBEROFWAVEFORMS Specifies the max number of waveform files.
        MaxNumberOfWaveforms
    end

    %% Private Properties
    properties (Access = private)
        MoreDataPending = false
    end

    %% Property access methods - Read Only
    methods
        %% MAXNUMBEROFWAVEFORMS property access methods
        function value = get.MaxNumberOfWaveforms(obj)
            % Maximum number of waveforms the instrument can hold in memory

            results = obj.queryInstrument('DIAGnostic:CPU:INFOrmation:OPTions?');
            % The max number of waveforms is:
            % without options 002, 602, 019 or 005 - 53,710
            if (~contains(results,'002') && ~contains(results,'602') &&...
                    ~contains(results,'019')) && ~contains(results,'005')
                obj.MaxNumberOfWaveforms = 53710;
            end
            % With option 002 and without 005 - 170,898
            if contains(results,'002') && ~contains(results,'005')
                obj.MaxNumberOfWaveforms = 170898;
            end
            % With option 602, or with 019 along with 651, 652 or 654, and without 005 - 327,148
            if (contains(results,'602') || ...
                    (contains(results,'019') && ...
                    (contains(results,'651') || contains(results,'652') || contains(results,'654'))))...
                    && ~contains(results,'005')
                obj.MaxNumberOfWaveforms = 327148;
            end
            % With options 002 and 005 - 29,453,125
            if contains(results,'002') && contains(results,'005')
                obj.MaxNumberOfWaveforms = 29453125;
            end
            % Without options 002, 602 or 019, and with 005 - 29,335,937
            if (~contains(results,'002') && ~contains(results,'602') && ~contains(results,'019'))...
                    && contains(results,'005')
                obj.MaxNumberOfWaveforms = 29335937;
            end
            % With option 602, or with 019 along with 651, 652 or 654, and with 005 - 29,609,375
            if (contains(results,'602') || ...
                    (contains(results,'019') && ...
                    (contains(results,'651') || contains(results,'652') || contains(results,'654'))))...
                    && contains(results,'005')
                obj.MaxNumberOfWaveforms = 29609375;
            end
            value = obj.MaxNumberOfWaveforms;
        end
    end

    %% Property access methods
    methods

        %% CLOCKFREQUENCY property access methods
        function value = get.ClockFrequency(obj)
            % Gets the sample clock rate for the dual ARB format
            value = str2double(obj.queryInstrument('SOURce:RADio:ARB:SCLock:RATE?'));
        end
        function set.ClockFrequency(obj,newValue)
            % Sets the sample clock rate for the dual ARB format
            obj.sendCmdToInstrument(['SOURce:RADio:ARB:SCLock:RATE ', num2str(newValue)]);
        end

        %% TRIGGERSOURCE property access methods
        function value = get.TriggerSource(obj)
            %value = obj.TriggerSource;
            %         Immediate (0)
            %         External  (1)
            %         Software  (2)
            triggerType = obj.queryInstrument('SOURce:RADio:ARB:TRIGger:TYPE?');
            switch triggerType
                case 'CONT' % 'Immediate'
                    value = 0;
                case 'SING'
                    triggerSource = obj.queryInstrument('SOURce:RADio:ARB:TRIGger:SOURce?');
                    switch triggerSource
                        case 'EXT' % 'External'
                            value = 1;
                        case 'BUS' % 'Software'
                            value = 2;
                    end
            end
        end
        function set.TriggerSource(obj,newValue)
            switch newValue
                case 'Immediate'
                    obj.sendCmdToInstrument(':SOURce:RADio:ARB:TRIGger:TYPE CONTinuous');
                case 'External'
                    obj.sendCmdToInstrument(':SOURce:RADio:ARB:TRIGger:TYPE SINGle');
                    obj.sendCmdToInstrument(':SOURce:RADio:ARB:TRIGger:SOURce EXT');
                case 'Software'
                    obj.sendCmdToInstrument(':SOURce:RADio:ARB:TRIGger:TYPE SINGle');
                    obj.sendCmdToInstrument(':SOURce:RADio:ARB:TRIGger:SOURce BUS');
            end
        end

        %% SELECTEDWAVEFORM property access methods
        function value = get.SelectedWaveform(obj)
            waveform = obj.queryInstrument(':SOURce:RADio:ARB:WAVeform?');
            if isempty(waveform)
                value = '';
            else
                value = erase(strip(waveform,'"'),'WFM1:');
            end

        end
        function set.SelectedWaveform(obj,newValue)
            obj.sendCmdToInstrument([':SOURce:RADio:ARB:WAVeform "WFM1:', newValue, '"']);
        end

        %% BYTEORDER property access methods
        function set.ByteOrder(obj,val)
            % Check if byteOrder is a legacy value and if so then
            % convert to equivalent new values.
            val = instrument.internal.ByteOrderUtility.convertByteOrder(val);

            val = validatestring(val, ["little-endian" "big-endian"]);
            obj.ByteOrder = val;
        end

        function out = get.ByteOrder(obj)
            out = obj.ByteOrder;
        end
    end

    %% Public Methods
    methods
        function SetClockFrequency(obj, value)
            % SETCLOCKFREQUENCY Accessor for protected ClockFrequency
            % property
            try
                obj.ClockFrequency = value;
            catch ex
                throwAsCaller(ex);
            end
        end

        function WriteArbWaveform(obj,fileName,iWave,qWave,moreDataPending)
            % WRITEARBWAVEFORM This function stores the transmitted
            % waveform in the drivers's or instrument's memory.

            narginchk(5,5)
            fileName = obj.checkScalarStringArg(fileName);
            iWave = obj.checkVectorDoubleArg(iWave);
            qWave = obj.checkVectorDoubleArg(qWave);
            moreDataPending = obj.checkScalarBoolArg(moreDataPending);

            % Refer to the E4428C/38C ESG Signal Generators Programming
            % Guide for more information on downloading and using files.
            % Page 278

            % Interleave the IQ data
            waveform = [iWave;qWave];
            waveform = waveform(:)';

            % Scale to use full range of the DAC
            % Data is now effectively signed short integer values
            waveform = int16(round(waveform * 32767));
            % Disables the arbitrary waveform generator.
            obj.sendCmdToInstrument('SOURce:RADio:ARB:STATe 0');
            if obj.MoreDataPending
                obj.binblockWrite(waveform, ['MEMory:DATA:APPend "WFM1:' fileName '",'], obj.ByteOrder);
            else
                obj.binblockWrite(waveform, ['MEMory:DATA:UNPRotected "WFM1:' fileName '",'], obj.ByteOrder);
            end
            obj.MoreDataPending = moreDataPending;
            obj.sendCmdToInstrument([':SOURce:RADio:ARB:WAVeform "WFM1:',fileName,'"']);
            obj.sendCmdToInstrument(':SOURce:RADio:ARB:STATe 1');
        end

        function SelectArbWaveform(obj,name)
            % SELECTARBWAVEFORM This function sets a named waveform to
            % be the active waveform.  Create arb waveform names using
            % the WriteArbWaveform function.

            narginchk(2,2)
            name = obj.checkScalarStringArg(name);
            obj.sendCmdToInstrument(['SOURce:RADio:ARB:WAVeform "WFM1:', name, '"']);
        end

        function ClearAllArbWaveforms(obj)
            % CLEARALLARBWAVEFORMS This function deletes all the
            % currently defined arb waveforms.
            narginchk(1,1)
            obj.sendCmdToInstrument('RAD:ARB OFF;:MMEM:DEL:WFM1;:MMEM:DEL:NVWF');
        end

        function [maxNumberOfWaveforms,waveformQuantum,waveformSizeMin,waveformSizeMax] = QueryArbWaveformCapabilities(obj)
            % QUERYARBWAVEFORMCAPABILITIES This function returns the arb
            % generator settings that are related to creating arbitrary
            % waveforms. These attributes are the maximum number of
            % waveforms, waveform quantum, minimum waveform size, and
            % maximum waveform size.

            narginchk(1,1)
            maxNumberOfWaveforms = obj.MaxNumberOfWaveforms;
            waveformQuantum = obj.WaveformQuantum;
            waveformSizeMin = obj.WaveformSizeMin;
            waveformSizeMax = obj.WaveformSizeMax;
        end

        function ConfigureArbTriggerSource(obj,Source)
            % CONFIGUREARBTRIGGERSOURCE This function configures the
            % trigger source for the waveform generation. The output
            % waveform is generated continuously if the source is
            % immediate.  Otherwise, the output is triggered.

            narginchk(2,2)
            Source = obj.checkScalarInt32Arg(Source);
            import instrument.internal.udm.rfsiggen.*;
            Source = ArbTriggerSourceEnum.getString (Source);
            obj.TriggerSource = Source;
        end
    end

    methods (Hidden)
        function SetDefaultByteOrder(obj, ~)
            % SETDEFAULTBYTEORDER Sets the byte order for .
            obj.ByteOrder = "big-endian";
        end
    end
end
