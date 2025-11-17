classdef ARBGenerator < instrument.ieee4882.rfsiggen.ARBGenerator & instrument.ieee4882.rfsiggen.RsRfSigGen_SCPI.RohdeSchwarzbase
    % ARBGENERATOR This class contains the attributes to control
    % the internal arbitrary signal generator.

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
        % from the instrument in a binblock. All supported models are big endian
        % except for the SMBV100A which is little endian. Valid values are
        % "little-endian" and "big-endian".
        ByteOrder
    end

    %% Constant Properties
    properties (Constant)
        % MAXNUMBEROFWAVEFORMS Specifies the max number of waveform files.
        % This is number depends on the hard drive size and the size of each data file, hense can not be determined.
        % Please refer to R&S SMBV100A Vector Signal Generator Specifications for more information.
        % Page 21
        MaxNumberOfWaveforms = NaN

        % WAVEFORMQUANTUM Specifies the waveform length must be a multiple of this quantum.
        % This is number come from R&S®SMBV100A Vector Signal Generator Specifications
        % Page 21
        WaveformQuantum = 1

        % WAVEFORMSIZEMIN Specifies the waveform length must be equal or greater than min size
        % This is number come from R&S®SMBV100A Vector Signal Generator Specifications
        % Page 21
        WaveformSizeMin = 1
    end

    %% Private Properties ReadOnly
    properties (SetAccess = private)
        % WAVEFORMSIZEMAX Specifies the waveform length must be equal or less than max size.
        % This is number come from R&S®SMBV100A Vector Signal Generator Specifications
        % Page 21
        WaveformSizeMax = 32E6
    end

    %% Private Properties
    properties (Access = private)
        MoreDataPending = false
    end

    %% Property access methods - Read Only
    methods
        %% WAVEFORMSIZEMAX property access methods
        function value = get.WaveformSizeMax(obj)
            % WAVEFORMSIZEMAX Specifies the waveform length must be equal or less than max size.
            % This calculation method comes from R&S®SMBV100A Vector Signal Generator Specifications
            % Page 21
            results = obj.queryInstrument('*OPT?');
            % The max number of waveforms is:
            % without options SMBV-K511
            % 1 sample to 32 Msample in one-sample steps
            if ~contains(results,'SMBV-K511')
                obj.WaveformSizeMax = 32E6;
            end
            % with option SMBV-K511
            % 1 sample to 256 Msample in one-sample steps
            if contains(results,'SMBV-K511')
                obj.WaveformSizeMax = 256E6;
            end
            % with option SMBV-K511 and SMBV-K512
            % 1 sample to 1 Gsample in one-sample steps
            if contains(results,'SMBV-K511') && contains(results,'SMBV-K512')
                obj.WaveformSizeMax = 1E9;
            end
            value = obj.WaveformSizeMax;
        end
    end
    %% Property access methods
    methods
        %% CLOCKFREQUENCY property access methods
        function value = get.ClockFrequency(obj)
            % Gets the sample clock rate for the dual ARB format
            value = str2double(obj.queryInstrument(':SOURce:BB:ARBitrary:CLOCk?'));
        end
        function set.ClockFrequency(obj,newValue)
            % Sets the sample clock rate for the dual ARB format
            obj.sendCmdToInstrument([':SOURce:BB:ARBitrary:CLOCk ', num2str(newValue)]);
        end

        %% TRIGGERSOURCE property access methods
        function value = get.TriggerSource(obj)
            % value = obj.TriggerSource;
            %         Immediate (0)
            %         External  (1)
            %         Software  (2)
            triggerType = obj.queryInstrument(':SOURce:BB:ARBitrary:TRIGger:SEQuence?');
            switch triggerType
                case 'AUTO' % 'Immediate'
                    value = 0;
                case 'SING'
                    triggerSource = obj.queryInstrument(':SOURce:BB:ARBitrary:TRIGger:SOURce?');
                    switch triggerSource
                        case 'EXT' % 'External'
                            value = 1;
                        case 'INT' % 'Software'
                            value = 2;
                    end
            end
        end
        function set.TriggerSource(obj,newValue)
            switch newValue
                case 'Immediate'
                    obj.sendCmdToInstrument(':SOURce:BB:ARBitrary:TRIGger:SEQuence AUTO');
                case 'External'
                    obj.sendCmdToInstrument(':SOURce:BB:ARBitrary:TRIGger:SEQuence SINGle');
                    obj.sendCmdToInstrument(':SOURce:BB:ARBitrary:TRIGger:SOURce EXTernal');
                case 'Software'
                    obj.sendCmdToInstrument(':SOURce:BB:ARBitrary:TRIGger:SEQuence SINGle');
                    obj.sendCmdToInstrument(':SOURce:BB:ARBitrary:TRIGger:SOURce INTernal');
            end
        end

        %% SELECTEDWAVEFORM property access methods
        function value = get.SelectedWaveform(obj)
            waveform = obj.queryInstrument(':SOURce:BB:ARBitrary:WAVeform:SELect?');
            if isempty(waveform)
                value = '';
            else
                value = erase(strip(waveform,'"'),{'/var/user/','.wv'});
            end

        end
        function set.SelectedWaveform(obj,newValue)
            obj.sendCmdToInstrument([':SOURce:BB:ARBitrary:WAVeform:SELect ''/var/user/', newValue, '''']);
        end

        %% BYTEORDER property access methods
        function set.ByteOrder(obj,val)
            % Check if byteOrder is a legacy value and if so then
            % convert to equivalent new values.
            val = instrument.internal.ByteOrderUtility.convertByteOrder(val);

            val = validatestring(val, ["little-endian" "big-endian"]);
            obj.ByteOrder = val;

            % Tell the instrument the byte order for reads
            if strcmpi(obj.ByteOrder, "little-endian")
                obj.sendCmdToInstrument(':FORMat:BORDer NORMal');
            else
                obj.sendCmdToInstrument(':FORMat:BORDer SWAP');
            end
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
            % waveform in the instrument's memory.

            narginchk(5,5)
            fileName = obj.checkScalarStringArg(fileName);
            iWave = obj.checkVectorDoubleArg(iWave);
            qWave = obj.checkVectorDoubleArg(qWave);
            moreDataPending = obj.checkScalarBoolArg(moreDataPending);

            % Refer to the R&S� SMBV100A Vector Signal Generator Operating Manual
            % for more information on downloading waveform.
            % Page 632

            %Interleave the IQ data
            waveform = [iWave;qWave];
            waveform = waveform(:)';

            % Scale to use full range of the DAC
            % Data is now effectively signed short integer values
            waveform = int16(round(waveform * 32767));
            if obj.MoreDataPending
                obj.binblockWrite(waveform, [':MMEMory:DATA:APPend ''/var/user/' fileName ''','],obj.ByteOrder);
            else
                obj.binblockWrite(waveform, [':MMEMory:DATA:UNPRotected ''NVWFM:/var/user/' fileName ''','],obj.ByteOrder);
            end
            obj.MoreDataPending = moreDataPending;
            obj.sendCmdToInstrument(['SOURce1:BB:ARBitrary:WAVeform:CLOCk "/var/user/' fileName '.wv", ' num2str(obj.ClockFrequency)]);
        end

        function SelectArbWaveform(obj,name)
            % SELECTARBWAVEFORM This function sets a named waveform to
            % be the active waveform.  Create arb waveform names using
            % the IviRFSigGen_WriteArbWaveform function.

            narginchk(2,2)
            name = obj.checkScalarStringArg(name);
            obj.sendCmdToInstrument([':SOURce:BB:ARBitrary:WAVeform:SELect ''/var/user/', name, '.wv''']);
            obj.sendCmdToInstrument(':SOURce:BB:ARBitrary:STATe 1');
        end

        function ClearAllArbWaveforms(obj)
            % CLEARALLARBWAVEFORMS This function deletes all the
            % currently defined arb waveforms.
            narginchk(1,1)
            obj.sendCmdToInstrument(':SOURce:BB:ARBitrary:STATe 0');
            obj.sendCmdToInstrument(':SOURce:BB:ARBitrary:WAVeform:DELete:ALL');
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
            % waveform is generated continuously if the trigger source
            % is 'immediate'. Otherwise, the output is triggered.

            narginchk(2,2)
            Source = obj.checkScalarInt32Arg(Source);
            import instrument.internal.udm.rfsiggen.*;
            Source = ArbTriggerSourceEnum.getString (Source);
            obj.TriggerSource = Source;
        end
    end

    methods (Hidden)
        function SetDefaultByteOrder(obj, model)
            % SETDEFAULTBYTEORDER Sets the byte order based on model.

            % Deal with the SMBV100A byte order special case
            if contains(model,'SMBV','IgnoreCase', true)
                obj.ByteOrder = "little-endian";
            else
                obj.ByteOrder = "big-endian";
            end
        end
    end
end
