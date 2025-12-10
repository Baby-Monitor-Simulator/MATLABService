classdef SpecializedBaseTransportProxy < internal.matlab.inspector.InspectorProxyMixin & ...
        matlabshared.transportapp.internal.utilities.transport.ITransportProxy & ...
        matlabshared.mediator.internal.Publisher & ...
        matlabshared.testmeasapps.internal.dialoghandler.DialogSource

    % SPECIALIZEDBASETRANSPORTPROXY is a parallel to the Shared App BaseTransportProxy
    % for Datagram transport proxy. It provides access to the transport
    % object via the TransportAccessor. Provides getters and setters for
    % the following properties:
    %   - Timeout
    %   - ByteOrder
    %   - NumDatagramsAvailable

    % Copyright 2021-2023 The MathWorks, Inc.

    properties(Hidden)
        % The handle to the TransportAccessor instance. Used for getting and
        % setting properties on the transport.
        TransportAccessor

        % The handle to the CodeGenerator instance. Used for generating
        % MATLAB code for property setters.
        CodeGenerator

        % Listener for the TransportAccessor's NumDataAvailable property.
        DataAvailableListener
    end

    %% Abstract Properties
    properties (SetObservable, AbortSet, Hidden)
        % Published via the Publisher (to be used by the read section's
        % Values Available section)
        ObservableValuesAvailable
    end

    %% Other Hidden Properties
    properties (Hidden, Constant)
        % Default values for property getters.
        DefaultNumericValue = 0
        DefaultByteOrder = "little-endian"
    end

    properties (SetObservable, Hidden)
        % Flag that indicates that the server is disconnected. When this
        % flag is set to true, this will initiate the app close procedure
        % from the main app class.
        ServerDisconnected (1, 1) logical = false
    end

    %% Class Properties To Be Displayed in Property Inspector
    properties (Dependent, GetObservable, SetAccess = private)
        NumDatagramsAvailable
    end

    properties (Dependent, SetObservable)
        Timeout
        ByteOrder internal.matlab.editorconverters.datatype.StringEnumeration
    end

    %% Lifetime
    methods
        function obj = SpecializedBaseTransportProxy(transport, mediator)
            arguments
                transport
                mediator matlabshared.mediator.internal.Mediator
            end
            obj@internal.matlab.inspector.InspectorProxyMixin(transport);
            obj@matlabshared.mediator.internal.Publisher(mediator);
            obj@matlabshared.testmeasapps.internal.dialoghandler.DialogSource(mediator);


            obj.TransportAccessor = matlabshared.transportapp.internal.utilities.transport.TransportAccessor(transport, ...
                "NumDatagramsAvailable");
            obj.CodeGenerator = matlabshared.transportapp.internal.utilities.transport.CodeGenerator(mediator);
            obj.setProxyPropertyGroups();
        end

        function connect(obj)
            % Create the listener handle for whenever a "get" happens on
            % NumDatagramsAvailable

            obj.TransportAccessor.connect();
            obj.DataAvailableListener = listener(obj.TransportAccessor, "ObservableDataAvailable", "PostSet", ...
                @(src, evt)obj.handlePropertyEvents(src, evt));

            % Attempt a get on the NumDataAvailable property. This will
            % fire the listener and will update ValuesAvailable on the read
            % section controller.
            obj.NumDatagramsAvailable;
        end

        function disconnect(obj)
            % Perform actions before the SpecializedBaseTransportProxy class is
            % deleted.

            if isvalid(obj.DataAvailableListener)
                delete(obj.DataAvailableListener);
            end

            obj.TransportAccessor.disconnect();
        end

        function delete(obj)
            obj.CodeGenerator = [];
            obj.TransportAccessor = [];
        end
    end

    %% Getters and Setters
    methods
        %% Getters
        function val = get.ByteOrder(obj)
            val = transportapp.udpport.internal.datagram.utilities.transport.SpecializedBaseTransportProxy.DefaultByteOrder;
            try
                if isvalid(obj) && ~obj.ServerDisconnected
                    val = obj.TransportAccessor.ByteOrder;
                end
            catch
                obj.handleServerDisconnected();
            end
        end

        function val = get.NumDatagramsAvailable(obj)
            val = transportapp.udpport.internal.datagram.utilities.transport.SpecializedBaseTransportProxy.DefaultNumericValue;
            try
                if isvalid(obj) && ~obj.ServerDisconnected
                    val = obj.TransportAccessor.NumDataAvailable;
                end
            catch
                obj.handleServerDisconnected();
            end
        end

        function val = get.Timeout(obj)
            val = transportapp.udpport.internal.datagram.utilities.transport.SpecializedBaseTransportProxy.DefaultNumericValue;
            try
                if isvalid(obj) && ~obj.ServerDisconnected
                    val = obj.TransportAccessor.Timeout;
                end
            catch
                obj.handleServerDisconnected();
            end
        end

        %% Setters
        function set.ByteOrder(obj, val)
            if obj.InternalPropertySet
                return
            end
            try
                setPropertyOnOriginalObject(obj, "ByteOrder", val);
            catch ex
                showErrorDialog(obj, ex);
            end
        end

        function set.Timeout(obj, val)
            if obj.InternalPropertySet
                return
            end
            try
                setPropertyOnOriginalObject(obj, "Timeout", val);
            catch ex
                showErrorDialog(obj, ex);
            end
        end
    end

    methods (Access = private)
        function handlePropertyEvents(obj, ~, ~)
            % Set the published ObservableNumDatagramsAvailable

            obj.ObservableValuesAvailable = obj.OriginalObjects.NumDatagramsAvailable;
        end
    end

    %% Helper Methods
    methods
        function setPropertyOnOriginalObject(obj, propertyName, propertyValue)
            arguments
                obj
                propertyName (1,1) string
                propertyValue
            end

            obj.TransportAccessor.setPropertyOnOriginalObject(propertyName, propertyValue);
            obj.CodeGenerator.generatePropertySetterCode(obj.OriginalObjects, propertyName);
        end

        function handleServerDisconnected(obj)
            % When the server is disconnected, initiate the app close
            % routine by setting the ServerDisconnected flag to true and
            % calling disconnect on the TransportAccessor.

            obj.TransportAccessor.disconnect();
            obj.ServerDisconnected = true;
        end
    end

    %% Abstract Method Implementation
    methods
        function setProxyPropertyGroups(obj)
            % This method needs to be implemented for this class to be an
            % ITransportProxy. Adds the class transport properties to the
            % property inspector.

            getGroupName = @(groupName) message("transportapp:udpportapp:PropertyInspector" + groupName + "Group").string();

            g2 = obj.createGroup(getGroupName("Communication"), "", "");
            g2.addProperties("NumDatagramsAvailable", "ByteOrder", "Timeout");
            g2.Expanded = true;
        end
    end
end
