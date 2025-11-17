classdef Manager < matlabshared.transportapp.internal.appspace.propertyinspector.Manager
    % MANAGER contains the property inspector section and manages all
    % transport interactions like read and write for the app.
    % Overrides the following methods from the Shared-App property inspector manager:
    %   - readHook()
    %   - writeHook()
    %   - getCommunicationLogData()
    %   - createTableRowData()

    % Copyright 2021 The MathWorks, Inc.

    %% Endpoint Properties
    properties(Hidden, SetAccess=private)
        EndpointAddress
        EndpointPort
    end

    %% HOOK METHODS for TRANSPORT COMMUNICATION (read, write, etc.)
    methods
        function readHook(obj, transportData, errorRow)
            try
                % Read available datagrams
                datagrams = read(obj.Transport, transportData.Value, transportData.DataType);

                % Loop through datagrams and add each one to the
                % table in an individual row.
                for datagram = datagrams
                    % Save the endpoint information. This is used later to generate the address and
                    % port string used to populate the tableRowDataForm.
                    obj.setEndpointInfo(datagram.SenderAddress, datagram.SenderPort);
                    obj.CommunicationLogData = getCommunicationLogData(obj, transportData.Action, datagram.Data, ...
                        transportData.DataType, errorRow);
                end
            catch ex
                handleError(obj, ex, transportData.Action);
            end
        end

        function writeHook(obj, transportData, errorRow)
            % Destination Address and Port are validated first in the
            % TransportProxy. They are then checked in the Write controller
            % to ensure that they are not empty. Both checks occur before
            % attempting to write any data.

            try
                destinationAddress = obj.PropertyInspector.InspectedObjects.DestinationAddress;
                destinationPort = obj.PropertyInspector.InspectedObjects.NumericDestinationPort;

                % Save the endpoint information. This is used later to generate the address and
                % port string used to populate the tableRowDataForm.
                obj.setEndpointInfo(destinationAddress, destinationPort);

                write(obj.Transport, transportData.Value, transportData.DataType, ...
                    destinationAddress, destinationPort);

                writeData = getWriteData(obj, transportData.Value, ...
                    transportData.DataType);
                obj.CommunicationLogData = getCommunicationLogData(obj, ...
                    transportData.Action, writeData, ...
                    transportData.DataType, errorRow);
            catch ex
                handleError(obj, ex, transportData.Action);
            end
        end
    end

    %% Subscriber Handler Methods
    methods (Access = {?matlabshared.transportapp.internal.utilities.ITestable})

        function tableRowData = getCommunicationLogData(obj, action, data, dataType, errorRow)
            % Create a communication log table entry form based on the
            % transport action performed.

            import transportapp.udpport.internal.datagram.appspace.propertyinspector.Manager

            % Clears EndpointAddress and EndpointPort after this method completes. 
            % Ensures that each address-port pair is used only once for each row in 
            % the communication log.
            cleanup = onCleanup(@()obj.resetEndpointInfo());

            addressAndPort = obj.getAddressAndPortString();

            % Use the Shared-App getCommunicationLogData to help populate
            % the tableRowData form.
            tableRowDataHelper = ...
                getCommunicationLogData@matlabshared.transportapp.internal.appspace.propertyinspector.Manager(...
                obj, action, data, dataType, errorRow);

            tableRowData = ...
                Manager.createTableRowData( ...
                tableRowDataHelper.Action, ...
                addressAndPort, ...
                tableRowDataHelper.Data, ...
                tableRowDataHelper.Size, ...
                tableRowDataHelper.DataType, ...
                tableRowDataHelper.Time, ...
                tableRowDataHelper.ErrorRow);
        end
    end

    %% Factory method for creating and populating a TableRowData.
    methods (Static)
        function tableRowData = createTableRowData(action, addressAndPort, data, sizeData, dataType, time, errorRow)
            % Create a TableRowData instance that contains the transport
            % action details. This instance will be used to populate the
            % communication log table.

            tableRowData = transportapp.udpport.internal.datagram.utilities.forms.TableRowData;
            tableRowData.Action = action;
            tableRowData.AddressAndPort = addressAndPort;
            tableRowData.Data = data;
            tableRowData.Size = sizeData;
            tableRowData.DataType = dataType;
            tableRowData.Time = time;
            tableRowData.ErrorRow = errorRow;
        end
    end

    %% Helper Methods
    methods
        function addressPortString = getAddressAndPortString(obj)
            % Combines the address and port into a single string for the
            % Address and Port column in the communication log.
            % IPV4 address should be formatted as "address:port",
            % IPV6 address should be formatted as "[address]:port".

            address = obj.EndpointAddress;
            port = obj.EndpointPort;
            ipAddressVersion = obj.PropertyInspector.InspectedObjects.IPAddressVersion.Value;

            if isempty(port) || address == ""
                addressPortString = "";
                return
            end

            if ipAddressVersion == "IPV4"
                addressPortString = sprintf("%s:%d", address, port);
            else
                addressPortString = sprintf("[%s]:%d", address, port);
            end
        end

        function setEndpointInfo(obj, endpointAddress, endpointPort)
            % Sets the current read/write action Endpoint info.
            obj.EndpointAddress = endpointAddress;
            obj.EndpointPort = endpointPort;
        end

        function resetEndpointInfo(obj)
            % Clears the current read/write action endpoint info.
            obj.EndpointAddress = "";
            obj.EndpointPort = [];
        end
    end
end