classdef Controller < transportapp.udpport.internal.common.toolstrip.write.Controller
    % CONTROLLER contains UDP byte-specific properties and methods for
    % the write section of the toolstrip.
    % NOTE: Overrides the following shared-app properties and methods:
    %       - subscribeToMediatorProperties()

    % Copyright 2021 The Mathworks, Inc.

    properties(Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        % Used in the writeline comment to inform the user what terminator is used
        % in a writeline action.
        WriteTerminator (1,1) string = ...
            matlabshared.transportapp.internal.utilities.transport.BaseTransportProxy.DefaultTerminator.WriteTerminator.Value
    end

    %% Implementing Subscriber Abstract Methods
    methods
        function subscribeToMediatorProperties(obj, ~, ~)
            subscribeToMediatorProperties@transportapp.udpport.internal.common.toolstrip.write.Controller(obj);
            obj.subscribe("Terminator", ...
                @(src, event)obj.setWriteTerminator(event));
        end
    end

    %% Subscriber Handlers
    methods
        function setWriteTerminator(obj, event)
            obj.WriteTerminator = event.AffectedObject.Terminator.WriteTerminator;
        end
    end

    %% Overridden Methods
    methods(Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        function createWriteCommentAndCode(obj, value, precision)
            % Generates comment and code for a write or
            % writeline action.

            if obj.getWriteType == obj.WriteLineType
                obj.Comment = message("transportapp:udpportapp:WritelineComment", value, ...
                    obj.TransportInstance, ...
                    obj.DestinationAddress, ...
                    obj.DestinationPort, ...
                    obj.WriteTerminator).getString();

                obj.Code = sprintf("writeline(%s,%s,""%s"",%s);", ...
                    obj.TransportInstance, ...
                    value, ...
                    obj.DestinationAddress, ...
                    obj.DestinationPort);

                obj.NewLine = true;
            else
                createWriteCommentAndCode@transportapp.udpport.internal.common.toolstrip.write.Controller( ...
                    obj, value, precision);
            end
        end
    end
end