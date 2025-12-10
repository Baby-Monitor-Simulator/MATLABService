classdef Manager < matlabshared.transportapp.internal.appspace.propertyinspector.Manager
    % MANAGER contains the property inspector section and manages all
    % transport interactions for write and writeline for the app.
    % Overrides the following methods form the Shared-App property inspector manager:
    %   - writeHook()
    %   - writelineHook()

    % Copyright 2021 The MathWorks, Inc.

    %% HOOK METHODS for TRANSPORT COMMUNICATION (read, write, etc.)
    methods
        function writeHook(obj, transportData, errorRow)
            % Overrides the writeHook method of the Shared-App property inspector manager.

            % Destination Address and Port are validate first in the
            % TransportProxy. They are then checked in the Write controller to
            % ensure that they are not empty. Both checks occur before
            % attempting to write any data.

            try
                destinationAddress = obj.PropertyInspector.InspectedObjects.DestinationAddress;
                destinationPort = obj.PropertyInspector.InspectedObjects.NumericDestinationPort;

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

        function writelineHook(obj, transportData, errorRow)
            % Overrides the writelineHook method of the Shared-App property inspector manager.

            try
                destinationAddress = obj.PropertyInspector.InspectedObjects.DestinationAddress;
                destinationPort = obj.PropertyInspector.InspectedObjects.NumericDestinationPort;

                writeline(obj.Transport, transportData.Value, ...
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
end
