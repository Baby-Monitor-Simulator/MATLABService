classdef (Hidden) DriverGroupBase < handle
    % DRIVERGROUPBASE class for IEEE488.2 based instrument.
    % This class provides common communication functions and capabilities to all
    % interface drivers .

    % Copyright 2011-2023 The MathWorks, Inc.

    properties (Hidden, Access = protected)
        Interface
    end

    methods
        function sendCmdToInstrument(obj, command)
            % SENDCMDTOINSTRUMENT send the SCPI command to instrument.
            fprintf (obj.Interface, command);
            obj.checkErrorImpl();

        end

        function value = queryInstrument (obj, cmd )
            value = query (obj.Interface, cmd);
            value = strtrim( value);
        end

        function binblockWrite (obj, data, fileName, byteOrder)
            % BINBLOCKWRITE Write binblock data to instrument.
            % Make sure the the buffer size is large enough.

            % Check if byteOrder is a legacy value and if so then
            % convert to equivalent new values.
            byteOrder = instrument.internal.ByteOrderUtility.convertByteOrder(byteOrder);

            if obj.Interface.OutputBufferSize < length(data)*3 ||...
                    ~strcmpi(obj.Interface.ByteOrder, byteOrder) ||...
                    obj.Interface.Timeout < 5 * round(length(data)/10000)

                % Suppresses fclose warning.
                warnState = instrument.internal.udm.WarningUtility.disableWarnings();
                c = onCleanup(@()instrument.internal.udm.WarningUtility.restoreWarnState(warnState));

                fclose(obj.Interface);
                obj.Interface.OutputBufferSize = length(data)*3;
                % Set the timeout value based on the data size respecting
                % the VISA max of 1000.
                obj.Interface.Timeout = min(1000,5 * round(length(data)/10000)+5);
                obj.Interface.ByteOrder = byteOrder;
                try
                    % This is not supported by all transports
                    if isa(obj.Interface, "visalib.Resource")
                        configureTerminator(obj.Interface, "LF");
                    end
                catch
                end
                fopen(obj.Interface);
            end

            binblockwrite (obj.Interface, data, 'int16', fileName);
            LF = 10;
            % Write LF to the instrument to finish downloading waveform.            
            fwrite(obj.Interface, LF);
            obj.checkErrorImpl ();
        end

        function value = binblockRead(obj,fileName,byteOrder)
            % Check if byteOrder is a legacy value and if so then
            % convert to equivalent new values.
            byteOrder = instrument.internal.ByteOrderUtility.convertByteOrder(byteOrder);

            if ~strcmpi(obj.Interface.ByteOrder, byteOrder)
                obj.Interface.ByteOrder = byteOrder;
            end
            % BINBLOCKREAD Read binblock data from instrument
            fprintf (obj.Interface, ['MEMory:DATA? "WFM1:' fileName '"']);
            value = binblockread(obj.Interface, 'int16');
            obj.checkErrorImpl ();
        end
    end

    methods (Hidden,  Access = 'protected' )
        function checkErrorImpl(obj)
            % CHECKERRORIMPL Template method design pattern that
            % sub-classes have to override.
            error (message('instrument:ieee4882Driver:needToImplement'));
        end
    end


    methods (Access = protected )

        function result = checkCharArg(obj,newValue) %#ok<*MANU>
            if ~isempty(newValue)
                validateattributes(newValue, {'char'},{'scalar'} );
                result = newValue;
            end
        end

        function result = checkScalarBoolArg(obj,newValue)
            newValue = logical(newValue);
            validateattributes(newValue, {'logical'} ,{'scalar'} );
            result = newValue;
        end


        function result = checkVectorBoolArg(obj,newValue)
            newValue = logical(newValue);
            validateattributes(newValue, {'logical'} ,{'vector'} );
            result = newValue;
        end


        function result = checkDoubleArg(obj,newValue)
            newValue = double(newValue);
            validateattributes(newValue, {'double'} ,  {'scalar'} );
            result = double(newValue);
        end

        function result = checkVectorSingleArg(obj,newValue)
            newValue = single(newValue);
            validateattributes(newValue, {'single'} ,  {'vector'} );
            result = single(newValue);
        end

        function result = checkScalarUint8Arg(obj,newValue)
            newValue = uint8(newValue);
            validateattributes(newValue, {'uint8'}, {'scalar'} );
            result = newValue;
        end

        function result = checkScalarInt16Arg(obj,newValue)
            newValue = int16(newValue);
            validateattributes(newValue, {'int16'}, {'scalar'} );
            result = newValue;
        end

        function result = checkVectorInt16Arg(obj,newValue)
            newValue = int16(newValue);
            validateattributes(newValue, {'int16'}, {'vector'} );
            result = newValue;
        end

        function result = checkScalarInt32Arg(obj,newValue)
            newValue = int32(newValue);
            validateattributes(newValue, {'int32'}, {'scalar'} );
            result = int32(newValue);
        end

        function result = checkInt32Arg(obj,newValue)
            newValue = int32(newValue);
            validateattributes(newValue, {'int32'}, {'vector'} );
            result = int32(newValue);
        end

        function result = checkScalarInt64Arg(obj,newValue)
            newValue = int64(newValue);
            validateattributes(newValue, {'int64'}, {'scalar'} );
            result = newValue;
        end

        function result = checkVectorInt32Arg(obj,newValue)
            newValue = int32(newValue);
            validateattributes(newValue, {'int32'}, {'vector'} );
            result = newValue;
        end

        function result = checkScalarDoubleArg(obj,newValue)
            newValue = double(newValue);
            validateattributes(newValue, {'double'}, {'scalar'} );
            result = newValue;
        end

        function result = checkVectorDoubleArg(obj,newValue)
            newValue = double(newValue);
            validateattributes(newValue, {'double'}, {'vector'} );
            result = newValue;
        end

        function result = checkScalarStringArg(obj,newValue)
            if ~isempty(newValue)
                validateattributes(newValue, {'char'}, {'vector'} );
            end
            result = newValue;
        end

        function result = checkVectorStringArg(obj,newValue)
            if ~isempty(newValue)
                newValue = char(newValue);
                validateattributes(newValue, {'char'}, {'vector'} );
                result = newValue;
            end
        end
    end
end


