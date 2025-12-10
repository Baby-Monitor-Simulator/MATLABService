classdef Controller < matlabshared.transportapp.internal.appspace.communicationlog.Controller
    % CONTROLLER is the Appspace Communication Log Controller Class used
    % when communicating in datagram mode.

    % Copyright 2021 The MathWorks, Inc.

    %% Hook Methods
    methods
        function constants = getConstants(~)
            % Provide a custom constants class to the CommunicationLog
            % controller.
            constants = transportapp.udpport.internal.datagram.appspace.communicationlog.Constants;
        end

        function tableRowData = getTableRowData(~)
            % Provide a custom TableRowData class to the CommunicationLog
            % controller.
            tableRowData = transportapp.udpport.internal.datagram.utilities.forms.TableRowData;
        end
    end
end
