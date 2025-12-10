classdef Serial < transportapp.visadev.internal.utilities.transport.VisadevBaseTransport 
    %SERIAL TransportProxy class for VISA-Serial interface. Defines properties
    %that are unique to the Serial interface.

    % Copyright 2022-2023 The MathWorks, Inc.

    properties (Constant, Hidden)
        ID (1, 1) string = "Serial"
    end

    properties(SetObservable)
        Port internal.matlab.editorconverters.datatype.StringEnumeration
        Parity
        FlowControl
        BaudRate internal.matlab.editorconverters.datatype.EditableStringEnumeration
        DataBits
        StopBits
    end

    properties(Hidden)
        DataBitsValues = ["5" "6" "7" "8"]
        StopBitsValues = ["1", "1.5", "2"]
        BaudRateValues = ["1200","2400","4800","9600","14400","19200","38400", ...
            "57600","115200","230400","460800","500000","576000","921600","1000000"]
    end

    methods
        function setProxyPropertyGroups(obj)
            % Invoke superclass method
            setProxyPropertyGroups@transportapp.visadev.internal.utilities.transport.VisadevBaseTransport(obj);

            % Create property group listing for Serial properties

            serialGroup = obj.createGroup(obj.getGroupID(obj.ID), obj.getGroupName(obj.ID), "");
            serialGroup.addProperties("Port", "BaudRate", "DataBits", "StopBits", "Parity", "FlowControl");
            serialGroup.Expanded = true;
        end
    end

    %% Set/Get methods
    methods
        function set.DataBits(obj, inspectorValue)
            if obj.InternalPropertySet
                return
            end

            if isa(inspectorValue, "internal.matlab.editorconverters.datatype.StringEnumeration")
                val = inspectorValue.Value;
            else
                val = inspectorValue;
            end

            if ischar(val) || isstring(val)
                val = str2double(val);
            end

            try
                obj.checkValidStopBitsConfiguration(obj.StopBits, val);
                obj.setPropertyOnOriginalObject("DataBits", val);
            catch ex
                setErrorObjProperty(obj, ex);
            end
        end

        function set.StopBits(obj, inspectorValue)
            if obj.InternalPropertySet
                return
            end

            if isa(inspectorValue, "internal.matlab.editorconverters.datatype.StringEnumeration")
                val = inspectorValue.Value;
            else
                val = inspectorValue;
            end

            if ischar(val) || isstring(val)
                val = str2double(val);
            end

            try
                obj.checkValidStopBitsConfiguration(val, obj.DataBits);
                obj.setPropertyOnOriginalObject("StopBits", val);
            catch ex
                setErrorObjProperty(obj, ex);
            end
        end

        function set.BaudRate(obj, inspectorValue)
            if isa(inspectorValue, "internal.matlab.editorconverters.datatype.EditableStringEnumeration")
                val = inspectorValue.Value;
            else
                val = inspectorValue;
            end

            if ischar(val) || isstring(val)
                val = str2double(val);
            end

            try
                obj.setPropertyOnOriginalObject("BaudRate", val);
            catch ex
                 setErrorObjProperty(obj, ex);
            end
        end

        function set.Parity(obj, val)
            if obj.InternalPropertySet
                return
            end
            try
                obj.setPropertyOnOriginalObject("Parity", val);
            catch ex
                 setErrorObjProperty(obj, ex);
            end
        end

        function set.FlowControl(obj, val)
            if obj.InternalPropertySet
                return
            end
            try
                obj.setPropertyOnOriginalObject("FlowControl", val);
            catch ex
                 setErrorObjProperty(obj, ex);
            end
        end

        function val = get.DataBits(obj)
            val = internal.matlab.editorconverters.datatype.StringEnumeration(...
                string(obj.OriginalObjects.DataBits), obj.DataBitsValues);
        end

        function val = get.StopBits(obj)
            val = internal.matlab.editorconverters.datatype.StringEnumeration(...
                string(obj.OriginalObjects.StopBits), obj.StopBitsValues);
        end

        function val = get.Parity(obj)
            val = obj.OriginalObjects.Parity;
        end

        function val = get.FlowControl(obj)
            val = obj.OriginalObjects.FlowControl;
        end

        function val = get.BaudRate(obj)
            val = internal.matlab.editorconverters.datatype.EditableStringEnumeration(...
                string(obj.OriginalObjects.BaudRate), obj.BaudRateValues);
        end
    end

    methods(Access = protected)
        function checkValidStopBitsConfiguration(~, stopBits, dataBits)
            arguments
                ~
                stopBits (1,1) string
                dataBits (1,1) string
            end
            if any(dataBits == string(6:8))
                % For DataBits = 6,7,8 StopBits can be 1 or 2
                validStopBits = ["1", "2"];

                if ~ismember(stopBits, validStopBits)
                    throwException(validStopBits);
                end

            else
                % For DataBits = 5 StopBits can be 1 or 1.5
                validStopBits = ["1", "1.5"];

                if ~ismember(stopBits, validStopBits)
                    throwException(validStopBits);
                end
            end

            function throwException(validStopBits)
                throw(MException("transportapp:visadevapp:InvalidStopBits", message("transportapp:visadevapp:InvalidStopBits", validStopBits(1), validStopBits(2), string(dataBits)).string));
            end
        end
    end
end
