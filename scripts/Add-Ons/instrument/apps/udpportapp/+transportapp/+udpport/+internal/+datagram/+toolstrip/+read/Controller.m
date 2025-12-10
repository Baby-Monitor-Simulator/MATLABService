classdef Controller < matlabshared.transportapp.internal.toolstrip.read.Controller
    % CONTROLLER is the controller class for the Read section
    %  This class inherits from the Read Controller of the Shared App
    %  infrastructure and provides a custom constants class for the UDP App
    %  read section when using datagram communication.
    % NOTE: Overrides the following shared-app properties and methods:
    %       - getConstants()
    %       - handleValuesAvailableChanged()
    %       - getValuesAvailableFromBytesAvailable()
    %       - formatReadErrorHook()

    % Copyright 2021-2022 The MathWorks, Inc.

    properties
        NumDatagramsAvailable
    end

    methods (Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        function consts = getConstants(~)
            consts = transportapp.udpport.internal.datagram.toolstrip.read.Constants;
        end

        function handleValuesAvailableChanged(obj, datagramsAvailable)
            obj.NumDatagramsAvailable = datagramsAvailable;
            obj.ViewConfiguration.setViewProperty("ValuesAvailable", "Text", ...
                string(datagramsAvailable));
        end

        function val = getValuesAvailableFromBytesAvailable(obj, ~)
            % Overriding the base class method. The precision value should
            % not affect the values available. Bytes Available, in this
            % case, is Datagrams Available.
            val = string(obj.NumDatagramsAvailable);
        end

        function ex = formatReadErrorHook(~, ex)
            % Overriding the base class hook-method for getting the new
            % error message for read failures in datagram mode.

            switch string(ex.identifier)
                case "transportapp:toolstrip:read:NoData"
                    ex = MException(message("transportapp:udpportapp:NoData"));

                case "transportapp:toolstrip:read:NotEnoughData"
                    ex = MException(message("transportapp:udpportapp:NotEnoughData"));

                case "transportapp:toolstrip:read:NumValuesToReadInvalidType"
                    ex = MException(message("transportapp:udpportapp:NumDatagramsToReadInvalidType"));
            end
        end

        function newEx = getInvalidNumValuesToReadExceptionHook(~, ex)
            newEx = MException(ex.identifier, ...
                message("transportapp:udpportapp:NumDatagramsToReadInvalidType").string);
        end
    end
end