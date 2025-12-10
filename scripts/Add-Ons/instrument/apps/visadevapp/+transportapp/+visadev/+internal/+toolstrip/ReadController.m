classdef ReadController < matlabshared.transportapp.internal.toolstrip.read.Controller
    %READCONTROLLER Controller class for VISA Explorer toolstrip Read
    %section. Specializes shared transport app read.Controller class to add
    %support for Binblock operations and remove checks of NumBytesAvailable
    %field.

    % Copyright 2022 The MathWorks, Inc.

    properties(Constant, Access = private)
        ReadType = "Read"
        ReadLineType = "ReadLine"
        ReadBinblockType = "ReadBinblock"
    end

    methods
        function obj = ReadController(varargin)
            obj@matlabshared.transportapp.internal.toolstrip.read.Controller(varargin{:});

            % Disable NumValuesToRead since default Format is
            % ASCII-Terminated String (g2715820)
            obj.ViewConfiguration.setViewProperty("NumValuesToRead", "Enabled", false);
        end

        function subscribeToMediatorProperties(obj, ~,~)
            subscribeToMediatorProperties@matlabshared.transportapp.internal.toolstrip.read.Controller(obj);

            % Disable ReadButton when WriteRead operation begins
            obj.subscribe("WriteReadButtonPressed", ...
                @(src,evt) obj.handleReadButtonState(false));

            % Enable ReadButton when WriteRead operation completes
            obj.subscribe("QueryComplete", ...
                @(src,evt) obj.handleReadButtonState(true));
        end
    end

    methods(Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        function consts = getConstants(~)
            consts = transportapp.visadev.internal.toolstrip.ReadConstants;
        end

        function type = getReadType(obj)
            dataFormatValue = string(obj.ViewConfiguration.getViewProperty("DataFormat", "Value"));
            if dataFormatValue == obj.DataFormatDropDownOptions(3) % Binblock
                type = obj.ReadBinblockType;
            else
                % Use base class method to handle shared read types
                type = getReadType@matlabshared.transportapp.internal.toolstrip.read.Controller(obj);
            end
        end

        function performDataFormatChangeOperations(obj, newDataFormat)
            % Override superclass implementaion to skip NumBytesAvailable
            % field and to handle Binblock data format

            % Perform the specific operations when the read data format is
            % changed.
            % If format = Binary
            %       1. Enable "Num Values to Read"
            %       2. Update the Data Type list and value
            %
            % If format = ASCII-Terminated String
            %       1. Disable "Num Values to Read"
            %       2. Update the Data Type list and value to string
            %
            % If format = Binblock
            %       1. Disable "Num Values to Read"
            %       2. Update the Data Type list and value

            switch string(newDataFormat)
                case obj.DataFormatDropDownOptions(1) % Binary

                    % 1. Enable "Num Values To Read" edit field.
                    obj.ViewConfiguration.setViewProperty("NumValuesToRead", "Enabled", true);

                    % 2. Update the data type dropdown list and select the
                    % first item of the dropdown list to be the selected
                    % data type.
                    dropdownValue = obj.Constants.AllPrecision;
                    obj.ViewConfiguration.addItemsToDropDownList("DataType", dropdownValue);
                    obj.ViewConfiguration.setViewProperty("DataType", "Value", dropdownValue(1));

                case obj.DataFormatDropDownOptions(2) % ASCII-Terminated String

                    % 1. Disable "Num Values To Read" edit field.
                    obj.ViewConfiguration.setViewProperty("NumValuesToRead", "Enabled", false);

                    % 2. Update both the data type dropdown list and
                    % selected value to "string"
                    dropdownValue = obj.Constants.StringPrecision;
                    obj.ViewConfiguration.addItemsToDropDownList("DataType", dropdownValue);
                    obj.ViewConfiguration.setViewProperty("DataType", "Value", dropdownValue(1));

                case obj.DataFormatDropDownOptions(3) % Binblock

                    % 1. Disable "Num Values To Read" edit field.
                    obj.ViewConfiguration.setViewProperty("NumValuesToRead", "Enabled", false);

                    % 2. Update both the data type dropdown list and
                    % selected value to Byte
                    dropdownValue = obj.Constants.AllPrecision;
                    obj.ViewConfiguration.addItemsToDropDownList("DataType", dropdownValue);
                    obj.ViewConfiguration.setViewProperty("DataType", "Value", dropdownValue(1));
            end
        end

        function dataTypeValueChanged(~, ~, ~)
            % Override superclass implementation. Normally this method
            % updates ValuesAvailable field to match selected Data Type,
            % but this view will have no ValuesAvailable field.
        end

        function handleValuesAvailableChanged(~, ~)
            % Override superclass method to ignore any mediator updates
            % about ValuesAvailable
        end
    end

    methods(Access = protected)
        % Override function to ignore Values Available
        function val = formatNumValuesToRead(obj)
            % Get "Num Values to Read" value.

            val = [];
            format = ...
                string(obj.ViewConfiguration.getViewProperty("DataFormat", "Value"));

            % For ASCII-Terminated String and Binblock Operations,
            % there is no Num Values to Read.
            if format ~= obj.DataFormatDropDownOptions(1)
                return
            end

            numValuesToRead = ...
                string(obj.ViewConfiguration.getViewProperty("NumValuesToRead", "Value"));

            try
                val = str2double(numValuesToRead);
                if isnan(val)
                    % Value is empty or entered value is not a number
                    throw(MException(message("transportapp:toolstrip:read:NumValuesToReadInvalidType")));
                end
                validateattributes(val, "numeric", ["nonnegative", "integer", "scalar", "positive", "nonzero"]);
            catch ex
                % Error occurred validating "Num Values to Read". Clear
                % value since there is no knowledge of values
                % available to default to.
                obj.ViewConfiguration.setViewProperty("NumValuesToRead", "Value", "");

                newEx = getInvalidNumValuesToReadExceptionHook(obj, ex);
                throw(newEx);
            end
        end
    end
end