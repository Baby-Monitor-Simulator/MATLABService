classdef WaveformSubsystem < instrument.ieee4882.fgen.WaveformSubsystem & instrument.ieee4882.fgen.Agilent332x0_SCPI.Agilentbase
    %WAVEFORM Class provides an implementation for Agilent fgen for
    %the abstract methods defined in its abstract parent class.
    
    % Copyright 2012 The MathWorks, Inc.
   
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = WaveformSubsystem(interface)
            obj.Interface = interface;
        end
    end
    
    
    methods
        function value = getFMEnabled(obj)
            % Is FM enabled?
            value = str2double(obj.queryInstrument('FM:STAT?'));
        end
        
        function value = getAMEnabled(obj)
            % Is AM enabled?
            value = str2double(obj.queryInstrument('AM:STAT?'));
        end
        
        function value = getBurstMode(obj)
            % Is Burst mode enabled?
            value = str2double(obj.queryInstrument('BURSt:STAT?'));
        end
        
        function setBurstEnabled(obj, value)
            % Enable or disable Burst mode
            switch(value)
                case false
                    value = 0;
                case true
                    value = 1;
            end
            obj.sendCmdToInstrument(['BURSt:STAT ' num2str(value)]);
        end
        
        function setAMEnabled(obj, value)
            % Enable or disable AM modulation
            switch(value)
                case false
                    value = 0;
                case true
                    value = 1;
            end
            obj.sendCmdToInstrument(['AM:STAT ' num2str(value)]);
        end
        
        function setFMEnabled(obj, value)
            % Enable or disable FM modulation
            switch(value)
                case false
                    value = 0;
                case true
                    value = 1;
            end
            obj.sendCmdToInstrument(['FM:STAT ' num2str(value)]);
        end
        
        function value = getAMWaveform(obj)
            % Get the AM modulation waveform
            value = obj.queryInstrument('AM:INT:FUNC?');
            if strncmpi(value,'sin',3)
                value = 1;
            elseif strncmpi(value,'squ',3)
                value = 2;
            elseif strncmpi(value,'tri',3)
                value = 3;
            elseif strncmpi(value,'ramp',4)
                value = 4;
            elseif strncmpi(value,'nram',4)
                value = 5;
            else
                % do nothing so an error is displayed
            end
        end
        
        function setAMWaveform(obj, value)
            % Set the AM modulation waveform
            if strncmpi(char(value),'sin',3)
                value = 'SINusoid';
            elseif strncmpi(char(value),'squ',3)
                value = 'SQUare';
            elseif strncmpi(char(value),'tri',3)
                value = 'TRIangle';
            elseif strncmpi(char(value),'rampu',5)
                value = 'RAMP';
            elseif strncmpi(char(value),'rampd',5)
                value = 'NRAMP';
            end
            obj.sendCmdToInstrument(['AM:INT:FUNC ' value]);
        end
        
        function value = getFMWaveform(obj)
            % Get the FM modulation waveform
            value = obj.queryInstrument('FM:INT:FUNC?');
            if strncmpi(value,'sin',3)
                value = 1;
            elseif strncmpi(value,'squ',3)
                value = 2;
            elseif strncmpi(value,'tri',3)
                value = 3;
            elseif strncmpi(value,'ramp',4)
                value = 4;
            elseif strncmpi(value,'nram',4)
                value = 5;
            end
        end
        
        function setFMWaveform(obj, value)
            % Set the FM modulation waveform
            if strncmpi(char(value),'sin',3)
                value = 'SINusoid';
            elseif strncmpi(char(value),'squ',3)
                value = 'SQUare';
            elseif strncmpi(char(value),'tri',3)
                value = 'TRIangle';
            elseif strncmpi(char(value),'rampu',5)
                value = 'RAMP';
            elseif strncmpi(char(value),'rampd',5)
                value = 'NRAMP';
            end
            obj.sendCmdToInstrument(['FM:INT:FUNC ' value]);
        end
        
        function value = getOffset(obj)
            % Get the voltage offset
            value = str2double(obj.queryInstrument('VOLTage:OFFSet?'));
        end
        
        function setOffset(obj, value)
            % Set the voltage offset
            obj.sendCmdToInstrument(['VOLTAGE:OFFSET ' num2str(value)]);
        end
        
        function value = getAMModulationSource(obj)
            % Gets the AM source and assigns return value accordingly
            value = obj.queryInstrument('AM:SOURce?');
            if strncmpi(value,'ext',3)
                value = 1;
            elseif strncmpi(value,'int',3)
                value = 0;
            end
        end
        
        function setAMModulationSource(obj,value)
            % Sets the AM source
            if strncmpi(char(value),'int',3)
                value = 'INT';
            elseif strncmpi(char(value),'ext',3)
                value = 'EXT';
            end
            obj.sendCmdToInstrument(['AM:SOURce ' char(value)]);
        end
        
        function value = getFMModulationSource(obj)
            % Gets the FM source and assigns return value accordingly
            value = obj.queryInstrument('FM:SOURce?');
            if strncmpi(char(value),'ext',3)
                value = 1;
            elseif strncmpi(value,'int',3)
                value = 0;
            end
        end
        
        function setFMModulationSource(obj,value)
            % Sets the FM source
            if strncmpi(char(value),'int',3)
                value = 'INT';
            elseif strncmpi(char(value),'ext',3)
                value = 'EXT';
            end
            obj.sendCmdToInstrument(['FM:SOURce ' char(value)]);
        end
        
        function value = getAMDepth(obj)
            % Sets the AM depth
            value = str2double(obj.queryInstrument('AM:DEPTh?'));
        end
        
        function setAMDepth(obj, value)
            % Sets the AM depth
            obj.sendCmdToInstrument(['AM:DEPTh ' num2str(value)]);
        end
        
        function value = getFMDeviation(obj)
            % Gets the FM deviation
            value = str2double(obj.queryInstrument('FM:DEViation?'));
        end
        
        function setFMDeviation(obj,value)
            % Sets the FM deviation
            obj.sendCmdToInstrument(['FM:DEViation ' num2str(value)]);
        end
        
        function value = getAMInternalFrequency(obj)
            % Gets the AM frequency
            value = str2double(obj.queryInstrument('AM:INTernal:FREQuency?'));
        end
        
        function setAMInternalFrequency(obj, value)
            % Sets the AM frequency
            obj.sendCmdToInstrument(['AM:INTernal:FREQuency ' num2str(value)]);
        end
        
        function value = getFMInternalFrequency(obj)
            % Gets the FM frequency
            value = str2double(obj.queryInstrument('FM:INTernal:FREQuency?'));
        end
        
        function setFMInternalFrequency(obj, value)
            % Sets the FM frequency
            obj.sendCmdToInstrument(['FM:INTernal:FREQuency ' num2str(value)]);
        end
        
        function value = getStartPhase(obj)
            % Gets the phase of the waveform in burst mode
            obj.sendCmdToInstrument('UNIT:ANGLe DEG');
            value = str2double(obj.queryInstrument('BURSt:PHASe?'));
        end
        
        function setStartPhase(obj,value)
            % Sets the phase of the waveform in burst mode
            obj.sendCmdToInstrument('UNIT:ANGLe DEG');
            obj.sendCmdToInstrument(['BURSt:PHASe ' num2str(value)]);
        end
        
        function value = getWaveform(obj)
            % Gets the waveform being generated on the instrument
            instrumentValue = obj.queryInstrument('FUNCTION:SHAPE?');
            import instrument.internal.udm.fgen.*;
            if strncmpi(instrumentValue,'sin',3)
                value = WaveformEnum.Sine;
            elseif strncmpi(instrumentValue,'squ',3)
                value = WaveformEnum.Square;
            elseif strncmpi(instrumentValue,'ramp',4)
                symmetry = str2double(obj.queryInstrument('FUNCTION:RAMP:SYMMETRY?'));
                if isequal(symmetry,100)
                    value= WaveformEnum.RampUp;
                elseif isequal(symmetry,50)
                    value = WaveformEnum.Triangle;
                else
                    value = WaveformEnum.RampDown;
                end
            elseif strncmpi(instrumentValue,'dc',2)
                value = WaveformEnum.DC;
            elseif strncmpi(instrumentValue,'user',4)
                value = WaveformEnum.Arb;
            else
                error(message('instrument:fgen:notValidWaveform',instrumentValue));
            end
        end
        
        function setWaveform(obj,value)
            % Sets the waveform being generated on the instrument
            import instrument.internal.udm.fgen.*;
            if value == WaveformEnum.Sine
                obj.sendCmdToInstrument('FUNCTION:SHAPE SINusoid');
            elseif value == WaveformEnum.Square
                obj.sendCmdToInstrument('FUNCTION:SHAPE SQUare');
            elseif value == WaveformEnum.Triangle
                obj.sendCmdToInstrument('FUNCTION:SHAPE TRIangle');
            elseif value == WaveformEnum.RampUp
                obj.sendCmdToInstrument('FUNCTION:SHAPE RAMP');
                obj.sendCmdToInstrument('FUNCTION:RAMP:SYMMETRY 100');
            elseif value == WaveformEnum.RampDown
                obj.sendCmdToInstrument('FUNCTION:SHAPE RAMP');
                obj.sendCmdToInstrument('FUNCTION:RAMP:SYMMETRY 0');
            elseif value == WaveformEnum.DC
                obj.sendCmdToInstrument('APPLY:DC');
            elseif value == WaveformEnum.Arb
                obj.sendCmdToInstrument('FUNCTION:SHAPE USER');
            else
                error(message('instrument:fgen:notValidWaveform',instrumentValue));
            end
        end
        
        function value = getFrequency(obj)
            % Gets the frequency of the arbitrary waveform generator
            value = str2double(obj.queryInstrument('FREQuency?'));
        end
        
        function setFrequency(obj,value)
            % Sets the frequency of the arbitrary waveform generator
            obj.sendCmdToInstrument(['FREQuency ' num2str(value)]);
        end
        
        function clearArbWaveform(obj, value)
            % Removes the waveform, QCFGEN<n>, where <n> is the waveform handle,
            % from the non-volatile memory of the instrument
            availableWaveforms = obj.queryInstrument('DATA:CATALOG?');
            if ~isempty(strfind(availableWaveforms,sprintf('QCFGEN%d',value)))
                if isequal(obj.queryInstrument('FUNC:USER?'),sprintf('QCFGEN%d',value))
                    obj.sendCmdToInstrument('FUNC:USER VOLATILE');
                end
                obj.sendCmdToInstrument(['DATA:DELete QCFGEN' num2str(value)]);
            else
                error(message('instrument:fgen:needWaveformHandle'));
            end
        end
        
        function selectArbWaveform(obj, value)
            % Selects the waveform, QCFGEN<n>, where <n> is the waveform handle,
            % from the non-volatile memory of the instrument
            availableWaveforms = obj.queryInstrument('DATA:CATALOG?');
            if ~isempty(strfind(availableWaveforms,sprintf('"QCFGEN%d"',value)))
                obj.sendCmdToInstrument(['FUNC:USER QCFGEN' num2str(value)]);
            else
                error(message('instrument:fgen:needWaveformHandle'));
            end
        end
        
        function waveformHandle = createArbWaveform(obj, dataArray)
            % Downloads the waveform to the non-volatile memory of the instrument
            % Check size to ensure it is within the bounds of the
            % instrument capabilities
            if numel(dataArray)<8 || numel(dataArray)>65536
                error(message('instrument:fgen:wrongWaveformSize',8,65536));
            end
            % Normalize the waveform so values are between -1 to + 1
            if  max (abs(dataArray)) ~= 0
                dataArray = (dataArray./max(dataArray))';
            end
            % Find the number of free memory slots available on the
            % instrument
            availableMemorySlots = str2double(obj.queryInstrument('DATA:NVOLatile:FREE?'));
            if availableMemorySlots>0
                availableWaveforms = obj.queryInstrument('DATA:CATALOG?');
                % Find number of waveforms that begin with QCFGEN and
                % calculate what the next waveform handle is. The waveform
                % is stored on the instrument as QCFGEN<n> where <n> is the
                % waveform handle
                numberQCWaveforms = strfind(availableWaveforms,'"QCFGEN');
                waveformHandle = length(numberQCWaveforms) + 1;
                while ~isempty(strfind(availableWaveforms,sprintf('"QCFGEN%d',waveformHandle)))
                    waveformHandle = waveformHandle + 1;
                end
                obj.sendCmdToInstrument(sprintf('%s%s%f','DATA VOLATILE, ',sprintf('%f, ',dataArray(1:end-1)), dataArray(end)));
                obj.sendCmdToInstrument(sprintf('DATA:COPY QCFGEN%d, VOLATILE',waveformHandle));
            else
                error(message ('instrument:fgen:noMemorySpace'));
            end
        end
        
        
    end
end

