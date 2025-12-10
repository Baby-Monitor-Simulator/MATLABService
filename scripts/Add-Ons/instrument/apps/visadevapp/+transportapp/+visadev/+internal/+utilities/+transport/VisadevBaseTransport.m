classdef VisadevBaseTransport < matlabshared.transportapp.internal.utilities.transport.ITransportProxy ...
        & internal.matlab.inspector.InspectorProxyMixin

    %VISADEVBASETRANSPORT Base class for visadev Tranports. Adds EOIMode
    %and overrides setProxyPropertyGroups method to remove
    %NumBytesAvailable

    % Copyright 2022-2023 The MathWorks, Inc.

    properties(Hidden)
        % Handle to shared app BaseTransportProxy implementation, which is
        % treated as the implementation as in a pImpl design pattern. This
        % reuses logic from the shared app implementation, and is
        % replaceable for unit tests.
        TransportProxyImpl
    end

    properties (SetObservable, AbortSet, Hidden)
        % Published via the Publisher (to be used by the read section's
        % Values Available section). Currently unused, but declared to
        % implement ITransportProxy interface
        ObservableValuesAvailable
    end

    properties (SetObservable, AbortSet, Hidden, Dependent)
        % Flag that indicates that the device is disconnected. When this
        % flag is set to true, this will initiate the app close procedure
        % from SharedApp.m.
        ServerDisconnected (1, 1) logical
    end

    properties(Access = private, Hidden)
        % Listener handle for ServerDisconnected property
        ServerDisconnectedListener
    end

    properties
        %% Class Properties To Be Displayed in Property Inspector

        % Identification properties
        % These properties define immutable properties of the visadev
        % object that are set when the visadev is created.
        % NOTE: StringEnumerations are used to display these properties to
        % prevent them being double quoted in the property inspector.
        % (Type: String -> "value", Type: StringEnumeration -> value).
        ResourceName internal.matlab.editorconverters.datatype.StringEnumeration
        Alias internal.matlab.editorconverters.datatype.StringEnumeration
        Type internal.matlab.editorconverters.datatype.StringEnumeration
        Vendor internal.matlab.editorconverters.datatype.StringEnumeration
        Model internal.matlab.editorconverters.datatype.StringEnumeration
        SerialNumber internal.matlab.editorconverters.datatype.StringEnumeration
    end

    properties (SetObservable, Dependent)
        % Communication Properties
        Timeout
        ByteOrder internal.matlab.editorconverters.datatype.StringEnumeration
        Terminator
    end

    methods
        function groupID = getGroupID(~, groupID)
            groupID = message("transportapp:visadevapp:PropertyInspector" + groupID + "GroupID").string;
        end

        function groupName = getGroupName(~, groupName)
            groupName = message("transportapp:visadevapp:PropertyInspector" + groupName + "GroupName").string;
        end
    end

    methods
        function obj = VisadevBaseTransport(transport, mediator)
            obj@internal.matlab.inspector.InspectorProxyMixin(transport);

            % Construct handle to shared TransportProxy impl
            obj.TransportProxyImpl = obj.constructBaseTransportProxy(transport, mediator);

            % Replace TransportAccessor with specialized Visadev accessor
            obj.TransportProxyImpl.TransportAccessor = obj.constructAccessor(transport);

            % Replace CodeGenerator with specialized Visadev CodeGenerator
            obj.TransportProxyImpl.CodeGenerator = obj.constructCodeGenerator(mediator);
            obj.setProxyPropertyGroups();

            % Set up listener for ServerDisconnected
            obj.ServerDisconnectedListener = listener(obj.TransportProxyImpl, "ServerDisconnected", ...
                'PostSet', ...
                @(src,evt)obj.setServerDisconnected(evt.NewValue));
        end

        % Override interface 'connect' method as no setup action is needed
        function connect(~)
        end

        % Override interface 'disconnect' method as no teardown action is
        % needed
        function disconnect(~)
        end

    end

    %% Getters and Setters for displayed properties
    methods
        %% Getters
        function val = get.Timeout(obj)
            val = obj.TransportProxyImpl.Timeout;
        end

        function val = get.ByteOrder(obj)
            val = obj.TransportProxyImpl.ByteOrder;
        end

        function val = get.Terminator(obj)
            val = obj.TransportProxyImpl.Terminator;
        end

        %% Setters
        function set.Terminator(obj, val)
            obj.TransportProxyImpl.Terminator = val;
        end

        function set.Timeout(obj, val)
            obj.TransportProxyImpl.Timeout = val;
        end

        function set.ByteOrder(obj, val)
            obj.TransportProxyImpl.ByteOrder = val;
        end
    end

    methods
        % Override setProxyGroups to define the shared property grouping
        % for all Visadev inspector panels
        function setProxyPropertyGroups(obj)
            % Set the property into the property groups to be displayed in
            % the property inspector section.

            % Identification section
            idGroup = obj.createGroup(obj.getGroupID("Identification"), "", "");
            idGroup.addProperties( ...
                "ResourceName", "Alias", "Type", "Vendor", ...
                "Model", "SerialNumber");
            idGroup.Expanded = true;

            % Communication section
            communicationGroup = obj.createGroup(obj.getGroupID("Communication"), "", "");
            communicationGroup.addEditorGroup("Terminator");
            communicationGroup.addProperties("Timeout", "ByteOrder");
            communicationGroup.Expanded = true;
        end

        % Callback to update ServerDisconnected value
        function setServerDisconnected(obj, val)
            obj.ServerDisconnected = val;
        end

        %% Strategy methods that passthrough to TransportProxyImpl method
        function setPropertyOnOriginalObject(obj, varargin)
            obj.TransportProxyImpl.setPropertyOnOriginalObject(varargin{:});
        end

        function setErrorObjProperty(obj, varargin)
            obj.TransportProxyImpl.showErrorDialog(varargin{:});
        end

        function set.ServerDisconnected(obj, val)
            obj.TransportProxyImpl.ServerDisconnected = val;
        end

        function val = get.ServerDisconnected(obj)
            val = obj.TransportProxyImpl.ServerDisconnected;
        end
    end

    methods(Access = protected)
        function baseTransportProxy = constructBaseTransportProxy(~, varargin)
            baseTransportProxy = matlabshared.transportapp.internal.utilities.transport.BaseTransportProxy(varargin{:});
        end

        function codeGenerator = constructCodeGenerator(~, varargin)
            codeGenerator = transportapp.visadev.internal.utilities.transport.CodeGenerator(varargin{:});
        end

        function accessor = constructAccessor(~, varargin)
            accessor = transportapp.visadev.internal.utilities.transport.VisadevTransportAccessor(varargin{:});
        end
    end
end
