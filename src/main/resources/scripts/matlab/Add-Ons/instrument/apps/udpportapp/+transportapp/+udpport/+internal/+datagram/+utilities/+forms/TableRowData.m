classdef TableRowData
    % TABLEROWDATA class contains row information data for the Communication
    % Log table for the udpport app in datagram mode. Includes the same fields
    % as the Shared-App TableRowData, with the additional AddressAndPort field.

    % Copyright 2021 The MathWorks, Inc.

    properties
        % The type of action being performed.
        Action string {matlabshared.transportapp.internal.utilities.TransportDataValidator.validateAction(Action)} = string.empty

        % The address and port of the device that the data originated from.
        AddressAndPort string = string.empty

        % The actual data written/read
        Data

        % The size of the data written/read
        Size (1, 2) double

        % The associated data type selected for the read/write operations.
        DataType string {matlabshared.transportapp.internal.utilities.TransportDataValidator.validateDataType(DataType)} = string.empty

        % The time (in string) when the transport action was performed.
        Time (1, 1) string

        % Flag to show whether there was an error associated with the
        % transport action, and to show an "ERROR" text for the
        % corresponding table row.
        ErrorRow (1, 1) logical = false
    end

    properties (Constant)
        TimeTableHeader = {'Action', 'AddressAndPort', 'Data', 'Size', 'DataType'}

        AllProperties = [...
            string( transportapp.udpport.internal.datagram.utilities.forms.TableRowData.TimeTableHeader), ...
            "Time"...
            ]

        % If the data to be displayed in the table is a 1xN numeric value
        RowDelimiter = matlabshared.transportapp.internal.utilities.forms.TableRowData.RowDelimiter

        % If the data to be displayed in the table is a Nx1 numeric value
        ColumnDelimiter = matlabshared.transportapp.internal.utilities.forms.TableRowData.ColumnDelimiter

        % For really large data values, the maximum data length that shows
        % up when users hover over the row data. If the data exceeds
        % MaxDataLength, the table display chops off the remaining data and
        % replaces it with "..."
        MaxDataLength = matlabshared.transportapp.internal.utilities.forms.TableRowData.MaxDataLength

        % The value for the "Size" field of the table for an error
        % operation.
        ErrorSize = matlabshared.transportapp.internal.utilities.forms.TableRowData.ErrorSize
    end

    methods (Static)
        function tableVal = convertFormToTable(formVal)
            % Convert the arrays of TableRowData values (formVal) into a table
            % format to be displayed in the Communication Log table.

            arguments
                formVal (1, :) transportapp.udpport.internal.datagram.utilities.forms.TableRowData
            end

            import transportapp.udpport.internal.datagram.utilities.forms.TableRowData

            action = string.empty;
            addressAndPort = string.empty;
            data = string.empty;
            size = string.empty;
            datatype = string.empty;
            time = string.empty;
            for form = formVal
                if form.ErrorRow
                    size(end+1) = TableRowData.ErrorSize;
                else
                    size(end+1) = compose("%d x %d", form.Size);
                end
                action(end+1) = form.Action;
                addressAndPort(end+1) = form.AddressAndPort;

                % Use the Shared-App's TableRowData to parse data.
                data(end+1) = matlabshared.transportapp.internal.utilities.forms.TableRowData.parseData(form.Data);

                datatype(end+1) = form.DataType;
                time(end+1) = form.Time;
            end

            % Create the final table.
            tableVal = table(action(:), addressAndPort(:), data(:), size(:), datatype(:), time(:), ...
                'VariableNames', cellstr(TableRowData.AllProperties));
        end

        function timeTableData = convertFormToTimeTable(formVal)
            % Convert the arrays of TableRowData values (formVal) into a
            % timetable to be exported.

            arguments
                formVal (1, :) transportapp.udpport.internal.datagram.utilities.forms.TableRowData
            end

            import transportapp.udpport.internal.datagram.utilities.forms.TableRowData

            timeArr = datetime.empty;
            dataArr = cell.empty;
            actionArr = string.empty;
            addressAndPortArr = string.empty;
            sizeArr = cell.empty;
            dataTypeArr = string.empty;
            for form = formVal
                timeArr(end+1) = datetime(form.Time);
                actionArr(end+1) = form.Action;
                addressAndPortArr(end+1) = form.AddressAndPort;
                dataArr{end+1} = form.Data;
                sizeArr{end+1} = form.Size;
                dataTypeArr(end+1) = form.DataType;
            end

            % Create the final time table.
            timeTableData = timetable(timeArr(:), actionArr(:), addressAndPortArr(:), dataArr(:), sizeArr(:), dataTypeArr(:), ...
                'VariableNames', TableRowData.TimeTableHeader);
        end
    end

    %% Data conversion methods
    methods (Static)
        % These methods use the Shared-App TableRowData conversion methods, as they
        % only operate on the data field of the form.

        function newForm = convertToBinary(formVal)
            % When the "Display" dropdown in the Toolstrip Communication
            % Log section is changed to "Binary", convert the data for the
            % TableRowData array "formVal" into a binary format. The converted
            % formVal is returned back as a new TableRowData array "newForm".

            newForm = matlabshared.transportapp.internal.utilities.forms.TableRowData.convertToBinary(formVal);
        end

        function newForm = convertToASCII(formVal)
            % When the "Display" dropdown in the Toolstrip Communication
            % Log section is changed to "ASCII", convert the original data
            % for the TableRowData array "formVal" into an ASCII format. The
            % converted formVal is returned back as a new TableRowData array
            % "newForm".

            newForm = matlabshared.transportapp.internal.utilities.forms.TableRowData.convertToASCII(formVal);
        end

        function newForm = convertToHex(formVal)
            % When the "Display" dropdown in the Toolstrip Communication
            % Log section is changed to "Hexadecimal", convert the data for
            % the TableRowData array "formVal" into a hex format. The
            % converted formVal is returned back as a new TableRowData array
            % "newForm".

            newForm = matlabshared.transportapp.internal.utilities.forms.TableRowData.convertToHex(formVal);
        end
    end
end