classdef (Abstract) DriverLegacyMethodsMixin < handle
    %DRIVERLEGACYMETHODSMIXIN provides implementation for the 3 legacy
    %methods for a Driver class -
    % 1. selftest
    % 2. geterror
    % 3. devicereset
    % 4. isa
    % 5. class

    %   Copyright 2022-2024 The MathWorks, Inc.

    methods
        function obj = DriverLegacyMethodsMixin()
            mustBeA(obj, "instrument.icdevice.internal.Driver");
        end
    end

    methods
        function devicereset(obj)

            % Check if the obj is valid
            instrument.icdevice.internal.utility.ValidateFunctions.isObjValid(obj, "Devicereset", 2);

            % Check if the obj is scalar
            instrument.icdevice.internal.utility.ValidateFunctions.validateObjectSize(obj, "Devicereset", 1);
            validateConnected(obj, "Devicereset", 3);

            if any(obj.InstrumentDriverType == ["IVI_C", "VXI_PNP"]) %#ok<*MCNPN>
                type = instrument.icdevice.internal.ExistingMethodCodeType.DeviceReset;
                obj.performIVICVXIPnPOperation(type);
            else
                obj.performSCPIOperation("Reset", "fprintf");
            end
        end

        function varargout = geterror(obj)

            % Check if the obj is valid
            instrument.icdevice.internal.utility.ValidateFunctions.isObjValid(obj, "geterror", 7);

            % Check if the obj is scalar
            instrument.icdevice.internal.utility.ValidateFunctions.validateObjectSize(obj, "geterror", 2);
            validateConnected(obj, "geterror", 4);

            if any(obj.InstrumentDriverType == ["IVI_C", "VXI_PNP"])
                type = instrument.icdevice.internal.ExistingMethodCodeType.GetError;
                varargout = {obj.performIVICVXIPnPOperation(type)};
            else
                varargout = {obj.performSCPIOperation("Error", "query")};
            end
        end

        function out = selftest(obj)

            % Check if the obj is valid
            instrument.icdevice.internal.utility.ValidateFunctions.isObjValid(obj, "selftest", 8);

            % Check if the obj is scalar
            instrument.icdevice.internal.utility.ValidateFunctions.validateObjectSize(obj, "selftest", 4);
            validateConnected(obj, "selftest", 5);

            if any(obj.InstrumentDriverType == ["IVI_C", "VXI_PNP"])
                type = instrument.icdevice.internal.ExistingMethodCodeType.SelfTest;
                out = replace(obj.performIVICVXIPnPOperation(type), ' ', '');
            else
                out = obj.performSCPIOperation("Selftest", "query");
                try
                    out = logical(str2double(out));
                catch
                end
            end
        end

        function result = isa(arg1, arg2)
            % Checks to see if arg1 is of class type "arg2". Override
            % provides special functionality if user is looking for
            % "icdevice" or "instrument" type.

            arguments
                arg1
                arg2
            end

            % convert to char in order to accept string datatype
            arg2 = instrument.internal.stringConversionHelpers.str2char(arg2);

            % Error checking.
            if ~ischar(arg2)
                error(message('instrument:icdevice:isa:badopt'));
            end

            % If user is checking for an array of icdevice or instrument
            % object, return true.
            if ~isscalar(arg1)
                classOfArg1 = class(arg1);
                result = classOfArg1 == string(arg2);
            else
                % If user is checking for an icdevice or instrument object,
                % return true.
                result = any(arg2 == ["instrument", "icdevice", "instrument.icdevice.internal.Driver"]);
            end
        end

        function val = class(obj, varargin)
            % Gives the class type of obj. It expects to return 'icdevice'
            % for a 1-by-1 device object and 'instrument' for an array of
            % device objects.

            if isscalar(obj)
                val = 'icdevice';
            else
                val = 'instrument';
            end
        end
    end

    %% Methods that are not supported
    methods (Hidden)
        function close(varargin)
            % Implemented this function to maintain maintain backward
            % compatibility with LegacyIcDevice for error ids.
            ep = instrument.icdevice.internal.mixins.base.ErrorProxyMixin;
            throw(ep.getMException(MException(message("instrument:icdevice:close:unsupportedFcn"))));
        end

        function open(varargin)
            % Implemented this function maintain backward compatibility
            % with LegacyIcDevice for error ids.
            ep = instrument.icdevice.internal.mixins.base.ErrorProxyMixin;
            throw(ep.getMException(MException(message("instrument:icdevice:open:unsupportedFcn"))));
        end
    end

    methods(Hidden)
        function out = isequal(varargin)
            % isequal is a custom implementation to compare multiple input
            % arguments for equality. This function checks whether all
            % input arguments are of the same size and content.
            if nargin < 2
                ep = instrument.icdevice.internal.mixins.base.ErrorProxyMixin;
                throw(ep.getMException(MException(message("instrument:isequal:minrhs"))));
            end

            out = instrument.icdevice.internal.utility.DriverUtility.checkInequality(varargin{:});
        end
    end

    methods (Access = private)
        function val = performSCPIOperation(obj, xmlTag, operation)
            % Perform SCPI calls using string terminated write calls
            % (fprintf, query). Used for legacy driver method calls -
            % devicereset(), selftest(), and geterror().

            arguments
                obj
                xmlTag (1, 1) string {mustBeMember(xmlTag, ["Reset", "Error", "Selftest"])}
                operation (1, 1) string {mustBeMember(operation, ["query", "fprintf"])}
            end

            val = [];
            code = obj.MDDDriverStruct.(xmlTag);
            if isempty(code) || code == ""
                throw(obj.getMException(MException(message("instrument_icdevice:driver:unsupportedMethod", xmlTag))));
            end

            if ~obj.ProductionMode
                % Name of variables in "getSCPIEvaluatedCommands" that need
                % to be tested.
                bodyMWICTCode = code;
                propObj = instrument.icdevice.internal.forms.ProductionModeForm.empty;
                props = "bodyMWICTCode";
                for p = props
                    val = eval(p);

                    % Capitalize the first letter of p to access the
                    % ProductionModeForm properties correctly. Here, we are
                    % doing a 1-to-1 transfer of a local variables to
                    % class-level properties which hold different naming
                    % conventions for capitalization. This adjusts for the
                    % differences between the two.
                    p = upper(extractBefore(p,2)) + extractAfter(p,1);
                    propObj(1).(p) = val;
                end
                setPropertyToTest(obj, propObj);
                return
            end

            interface = get(obj, "Interface");
            if operation == "query"
                val = char(replace(query(interface, code), newline, ""));
            else
                fprintf(interface, code);
            end
        end

        function varargout = performIVICVXIPnPOperation(obj, codeTag)
            % Perform IVI-C or VXI-PnP calls for the legacy driver method
            % calls - devicereset(), selftest(), and geterror().

            arguments
                obj
                codeTag (1, 1) instrument.icdevice.internal.ExistingMethodCodeType
            end

            import instrument.icdevice.internal.utility.CodeEvaluator
            code = CodeEvaluator.getKnownMATLABCode(codeTag, obj.DriverName);
            temp = CodeEvaluator.runLegacyFunction(obj, code);

            if obj.ProductionMode
                % When the output from temp is {' '}, the value is actually
                % a NULL character that gets visualized as an empty space
                % ' '. To handle this correctly, we check if the output from
                % temp is a NULL character '0'. If it is, we convert
                % varargout to a single space character '32' (Refer to
                % ASCII table for character values).

                if ~isempty(temp)
                    val = temp{1};
                end

                if isempty(val)
                    varargout{1} = [];
                    return
                end

                if double(val{1}) == 0 % NULL character in the ASCII table
                    val = {char(32)}; % Space character in the ASCII table
                end
                varargout = val;
            else
                varargout{1} = [];
            end
        end
    end
end
