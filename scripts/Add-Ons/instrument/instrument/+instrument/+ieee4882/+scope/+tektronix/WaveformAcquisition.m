classdef WaveformAcquisition < instrument.ieee4882.scope.WaveformAcquisition & instrument.ieee4882.scope.tektronix.Tekbase
    %WAVEFORMACQUISITION Class provides an implementation for Tektronix Oscilloscope for
    %the abstract methods defined in its abstract parent class.

    % Copyright 2011-2022 The MathWorks, Inc.

    properties (Hidden, Access = 'protected')
        Precision
        ByteOrder
    end

    %% Construction/Clean up
    methods
        function obj = WaveformAcquisition(interface)
            obj.Interface = interface;
        end

    end


    %% Public Methods
    methods

        function set.ByteOrder(obj, value)
            % Check if byteOrder is a legacy value and if so then
            % convert to equivalent new values.
            value = instrument.internal.ByteOrderUtility.convertByteOrder(value);

            if strcmpi(value, "big-endian")
                value = 'MSB' ;
            else
                value = 'LSB' ;
            end

            % Tektronix 1K/2K/3K/4K oscilloscopes use the WFMPre:BYT_Or
            % command to set the byte order. the 5K/7K/70K oscilloscopes
            % use the WFMOutPre:BYT_Or command for the same. This code
            % figures out which command to use, the first time we need to
            % use it, and uses that in the future.

            % Create a persistent variable to hold the commandset to be
            % used
            persistent CommandSet

            if isempty(CommandSet)
                % Read what the current value is
                ret = obj.queryInstrument('WFMPre:BYT_Or?');
                % We're starting off with MSB
                if strcmpi(ret,'MSB')
                    % Try to flip the byte order using the legacy commands
                    obj.sendCmdToInstrument('WFMPre:BYT_Or LSB');
                    ret = obj.queryInstrument('WFMPre:BYT_Or?');
                    % If it worked, then we can use the legacy commands
                    if strcmpi(ret,'LSB')
                        CommandSet = 'legacy';
                        % Else we need to use the commands used by the high
                        % performance oscilloscopes
                    else
                        CommandSet = 'highperformance';
                    end
                    % Same thing as above, but we started out with the
                    % oscilloscope in LSB
                elseif strcmpi(ret,'LSB')
                    obj.sendCmdToInstrument('WFMPre:BYT_Or MSB')
                    ret = obj.queryInstrument('WFMPre:BYT_Or?');
                    if strcmpi(ret,'MSB')
                        CommandSet = 'legacy';
                    else
                        CommandSet = 'highperformance';
                    end
                end
            end

            if strcmpi(CommandSet,'legacy')
                cmd = sprintf('WFMPre:BYT_Or %s', value);
            else
                cmd = sprintf('WFMOutPre:BYT_Or %s', value);
            end
            obj.sendCmdToInstrument(cmd);
        end

        function byteOrder = get.ByteOrder(obj)
            ret = obj.queryInstrument( 'WFMPre:BYT_Or?');
            if strcmpi (ret , 'MSB')
                byteOrder = "big-endian";
            else
                byteOrder = "little-endian";
            end
        end

        function set.Precision(obj, propertyValue)

            order = obj.ByteOrder ;    %#ok<*MCSUP>
            % Only an S differentiates the two commands(RIBinary and SRIBinary)
            % for signed integers. The S will be added to the command if the byte
            % order is LSB
            byteOrder ='';
            if strcmpi(order,'LSB')
                byteOrder = 'S';
            end

            % Set the width
            if any(strcmpi(propertyValue,{'int8','uint8'}))
                fprintf(obj.Interface,'DATA:WIDTH 1');
            elseif any(strcmpi(propertyValue,{'int16','uint16'}))
                fprintf(obj.Interface,'DATA:WIDTH 2');
            else
                fprintf(obj.Interface,'DATA:WIDTH 1');
            end

            % Specify format
            if strcmpi(propertyValue,'ascii')
                fprintf(obj.Interface,'DATA:ENCdg ASCIi');
                %setting data:enc to ASCII reset Byte_Or to MSB, which is unnecessary.
                %this sets it back to what is was previously.
                obj.ByteOrder = order;
            elseif any(strcmpi(propertyValue,{'int8','int16'}))
                fprintf(obj.Interface,sprintf('DATA:ENCdg %sRIBinary', byteOrder ));
            elseif any(strcmpi(propertyValue,{'uint8','uint16'}))
                fprintf(obj.Interface,sprintf('DATA:ENCdg %sRPBinary', byteOrder ));
            end
        end


        function propertyValue = get.Precision(obj)

            width = obj.queryInstrument('DATA:WIDTH?');
            width  = str2double(strtrim(width));

            % Check the data format
            encoding = obj.queryInstrument( 'DATA:ENCdg?');
            encoding = strtrim(encoding);

            % define propertyValue with the right value
            if any(strcmpi(encoding,{'RIBinary','SRIbinary'}))
                propertyValue = sprintf('int%s',  num2str(8*width));
            elseif any(strcmpi(encoding,{'RPBinary','SRPbinary'}))
                propertyValue = sprintf ('uint%s', num2str(8*width));
            else
                propertyValue = 'ascii';
            end

        end




        function [WaveformArray] = fetchWaveform(obj,channelName)

            oldPrecision = obj.Precision ;
            oldByteOrder = obj.ByteOrder ;

            obj.Precision = 'int16';
            obj.ByteOrder = "little-endian";

            try
                % Specify source
                cmd = sprintf('DATA:SOURCE %s', channelName);
                obj.sendCmdToInstrument(cmd);

                % starting point
                obj.sendCmdToInstrument('DATA:START 1');

                % ending point
                recordLength = obj.queryInstrument('HORizontal:RECOrdlength?' );
                cmd = sprintf ('DATA:STOP %s', recordLength);
                obj.sendCmdToInstrument(cmd);

                % Issue the curve transfer command. can't use
                % sendCmdToInstrument here ( query status will interrupt
                % the binblockread
                fprintf( obj.Interface, 'CURVE?');
                % make sure that instrument finishes transferring data
                %               pause(1);
                raw = binblockread(obj.Interface, 'int16')';

                % Tektronix scopes send and extra terminator after the binblock.
                fread(obj.Interface, 1);
            catch e
                obj.Precision =  oldPrecision;
                obj.ByteOrder =  oldByteOrder;
                throwAsCaller(e);
            end

            if (isempty(raw))
                obj.Precision =  oldPrecision;
                obj.ByteOrder =  oldByteOrder;
                me = MException('instrument:ieee4882Scope:failedToGetWaveform', message('instrument:ieee4882Driver:failedToGetWaveform').getString);
                throw(me);
            end

            % waveform offset
            yoffs = str2double(obj.queryInstrument( 'WFMPre:YOFF?'));

            %vertical scale factor
            ymult = str2double(obj.queryInstrument('WFMPre:YMULT?'));

            %waveform conversion factor
            yzero = str2double(obj.queryInstrument( 'WFMPre:YZERO?'));

            WaveformArray = ((raw - yoffs) .* ymult) + yzero;

            % restore values
            obj.Precision =  oldPrecision;
            obj.ByteOrder =  oldByteOrder;
        end

        function [WaveformArray] = readWaveform(obj,channelName, MaximumTime)
            %READWAVEFORM This function initiates an acquisition on all
            %channels that are enabled.

            %Starts oscilloscope acquisitions
            obj.sendCmdToInstrument('ACQuire:STATE ON');
            tStart = tic;
            while (true )
                ret = str2double (obj.queryInstrument('*OPC?'));
                if toc (tStart ) > MaximumTime
                    error(message('instrument:ieee4882Driver:failedToreadWaveform'));
                end
                if  ret == 1
                    break;
                end
            end


            WaveformArray = obj.fetchWaveform (channelName);

        end

    end
end
