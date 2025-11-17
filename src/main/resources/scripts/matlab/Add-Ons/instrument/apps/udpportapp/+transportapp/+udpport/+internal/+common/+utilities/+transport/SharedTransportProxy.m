classdef (Abstract) SharedTransportProxy < internal.matlab.inspector.InspectorProxyMixin & ...
        matlabshared.transportapp.internal.utilities.transport.ITransportProxy & ...
        matlabshared.mediator.internal.Publisher & ...
        matlabshared.testmeasapps.internal.dialoghandler.DialogSource

    % SHAREDTRANSPORTPROXY contains all UDP properties
    % common to both byte and datagram communication.
    % Provides getters and setters for the following UDP properties:
    %   -LocalHost
    %   -LocalPort
    %   -IPAddressVersion
    %   -EnablePortSharing
    %   -Timeout
    %   -ByteOrder
    %   -OutputDatagramSize
    %   -EnableBroadcast
    %   -EnableMulticastLoopback
    %   -MulticastGroup

    % Copyright 2021-2023 The MathWorks, Inc.

    %% Abstract Properties
    properties (SetObservable, AbortSet, Hidden)
        % Published for use by the read section (Values Available section).
        ObservableValuesAvailable
    end

    %% Hidden Properties
    properties(Hidden, Constant)
        % Default values for any properties that require pre-populated
        % fields or constant dropdown lists.
        IPAddressVersionValues = ["IPV4", "IPV6"]
        DefaultIPAddress (1, 1) string = ""
        DefaultPortValue (1, 1) string = ""
        EnabledValue (1, 1) string = message("transportapp:udpportapp:Enabled").getString
        DisabledValue (1, 1) string = message("transportapp:udpportapp:Disabled").getString
    end

    properties (SetObservable, Hidden)
        % Publishing these properties allows the MATLABCodeGenerator class
        % to publish comments and code.
        PropertyNameValue
        Comment
        Code
        NewLine

        % These properties hold the true value of the EditableDropDown fields,
        % They are published via the Mediator so the write section controller
        % can use these values to generate write comments & code.
        DestinationAddress (1,1) string
        DestinationPort (1,1) string
    end

    properties (SetObservable, Hidden)
        % Flag that indicates that the server is disconnected. When this
        % flag is set to true, this will initiate the app close procedure.
        % When ServerDisconnected is...:
        %   -true: initiates app close procedure
        %   -false: no action taken
        ServerDisconnected (1, 1) logical = false
    end

    properties(Hidden, Access={?matlabshared.transportapp.internal.utilities.ITestable, ...
            ?transportapp.udpport.internal.common.utilities.transport.SharedTransportProxy})
        % These properties define the lists for the DestinationAddress,
        % DestinationPort, and MulticastGroup dropdowns.
        DestinationAddressList = {}
        DestinationPortList = {}
        MulticastGroupList (1, :) cell = {}

        % TransportProxy provides the underlying functionality
        % and implementation of properties either provided by the Shared-App
        % infrastructure or properties that are specific to only one
        % communication mode. For example, in byte mode this transport proxy
        % provides both "Timeout", shared between both byte and datagram mode,
        % and included in the Shared-App BaseTransportProxy, and "Terminator",
        % used only by the Byte TransportProxy. Because "Timeout" is shared,
        % getters and setters are included in this class. Because "Terminator"
        % is byte-specific, getters and setters are provided in an extension
        % of this classes used when communicating in datagram mode.
        TransportProxy
    end

    properties(Dependent, Hidden)
        % This property is used whenever the numeric value of the
        % DestinationPort is needed. The SharedTransportProxy
        % maintains DestinationPort as a string for consistency using
        % the EditableStringDropDown to display the port value.
        NumericDestinationPort
    end

    properties(Hidden)
        ServerDisconnectedListener
        MulticastPlatformCheckFcn = []
    end

    %% Class Properties to be added to Property Inspector
    properties(Dependent, SetAccess = private)
        % These properties define immutable properties of the udpport
        % object that are set when the udpport is created.
        % NOTE: StringEnumerations are used to display these properties to remove
        % string properties being double quoted in the property inspector.
        % (Type: String -> "value", Type: StringEnumeration -> value).
        LocalHost internal.matlab.editorconverters.datatype.StringEnumeration
        LocalPort
        IPAddressVersion internal.matlab.editorconverters.datatype.StringEnumeration
        EnablePortSharing internal.matlab.editorconverters.datatype.StringEnumeration
    end

    properties(Dependent, SetObservable)
        % These properties are modified by the user to set the UDP objects
        % communication properties.
        Timeout
        ByteOrder internal.matlab.editorconverters.datatype.StringEnumeration
        OutputDatagramSize
        EnableBroadcast logical
        MulticastGroup internal.matlab.editorconverters.datatype.EditableStringEnumeration
        EnableMulticastLoopback logical
    end

    properties(Dependent, SetObservable, AbortSet)
        % Displays Destination Address as a drop down list
        % This avoids double quoting and allows users to switch between
        % previously entered address and ports.
        DestinationAddressDropDown internal.matlab.editorconverters.datatype.EditableStringEnumeration
    end

    properties(Dependent, SetObservable, AbortSet)
        % Displays Destination port as a drop down list
        DestinationPortDropDown  internal.matlab.editorconverters.datatype.EditableStringEnumeration
    end

    %% Lifetime
    methods
        function obj = SharedTransportProxy(mediator, transportProxy, ...
                destinationAddress, destinationPort)
            arguments
                mediator matlabshared.mediator.internal.Mediator
                transportProxy matlabshared.transportapp.internal.utilities.transport.ITransportProxy
                destinationAddress (1,1) string
                destinationPort (1,1) string
            end

            obj@internal.matlab.inspector.InspectorProxyMixin(transportProxy.OriginalObjects);
            obj@matlabshared.mediator.internal.Publisher(mediator);
            obj@matlabshared.testmeasapps.internal.dialoghandler.DialogSource(mediator);

            obj.TransportProxy =  transportProxy;

            % Add properties to groups
            obj.setProxyPropertyGroups();

            % Update property display names
            obj.setPropertyDisplayName("DestinationAddressDropDown", "DestinationAddress");
            obj.setPropertyDisplayName("DestinationPortDropDown", "DestinationPort");

            if ~ispc
                obj.MulticastPlatformCheckFcn = ...
                    @()throwAsCaller(MException(message("transportapp:udpportapp:MulticastNotSupported")));
            end
            obj.DestinationAddress = destinationAddress;
            obj.DestinationPort = destinationPort;

            % Ensure that these values are non-empty when adding to dropdown
            % list: empty values will cause empty fields in the dropdown.
            if destinationAddress ~= ""
                obj.DestinationAddressList{end+1} = destinationAddress;
            end
            if destinationPort ~= ""
                obj.DestinationPortList{end+1} = destinationPort;
            end
        end

        function connect(obj)
            obj.TransportProxy.connect();
            obj.ServerDisconnectedListener = listener(obj.TransportProxy, "ServerDisconnected", "PostSet", ...
                @(src, evt)obj.setServerDisconnected(evt));
        end

        function disconnect(obj)
            if isvalid(obj.ServerDisconnectedListener)
                delete(obj.ServerDisconnectedListener);
            end
            obj.TransportProxy.disconnect();
        end
    end

    %% Getters and Setters
    methods
        %% Getters
        function val = get.ByteOrder(obj)
            val = obj.TransportProxy.ByteOrder;
        end

        function val = get.DestinationAddressDropDown(obj)
            % Constructs a EditableStringEnumeration from the current
            % DestinationAddress and DestinationAddressList.
            val = internal.matlab.editorconverters.datatype.EditableStringEnumeration( ...
                obj.DestinationAddress, obj.DestinationAddressList);
        end

        function val = get.DestinationPortDropDown(obj)
            % Constructs a EditableStringEnumeration from the current
            % DestinationPort and DestinationPortList.
            val = internal.matlab.editorconverters.datatype.EditableStringEnumeration( ...
                num2str(obj.DestinationPort), obj.DestinationPortList);
        end

        function val = get.EnableBroadcast(obj)
            val = obj.OriginalObjects.EnableBroadcast;
        end

        function val = get.EnableMulticastLoopback(obj)
            val = obj.OriginalObjects.EnableMulticastLoopback;
        end

        function val = get.EnablePortSharing(obj)
            val = internal.matlab.editorconverters.datatype.StringEnumeration( ...
                string(obj.OriginalObjects.EnablePortSharing));
        end

        function val = get.IPAddressVersion(obj)
            val = internal.matlab.editorconverters.datatype.StringEnumeration( ...
                obj.OriginalObjects.IPAddressVersion, obj.IPAddressVersionValues);
        end

        function val = get.LocalHost(obj)
            val = internal.matlab.editorconverters.datatype.StringEnumeration( ...
                obj.OriginalObjects.LocalHost);
        end

        function val = get.LocalPort(obj)
            val = obj.OriginalObjects.LocalPort;
        end

        function val = get.MulticastGroup(obj)
            % Returns the current multicast group the udpport object is
            % subscribed to.
            val = internal.matlab.editorconverters.datatype.EditableStringEnumeration( ...
                obj.OriginalObjects.MulticastGroup, obj.MulticastGroupList);
        end

        function val = get.NumericDestinationPort(obj)
            val = str2double(obj.DestinationPort);
        end

        function val = get.OutputDatagramSize(obj)
            % Returns the number of data bytes sent in each datagram.
            val = obj.OriginalObjects.OutputDatagramSize;
        end

        function val = get.Timeout(obj)
            val = obj.TransportProxy.Timeout;
        end

        %% Setters
        function set.ByteOrder(obj, inspectorValue)
            obj.TransportProxy.ByteOrder = inspectorValue;
        end

        function set.DestinationAddressDropDown(obj, inspectorValue)

            import transportapp.udpport.internal.DescriptorValidator

            if obj.InternalPropertySet
                return
            end

            try
                if isa(inspectorValue, "internal.matlab.editorconverters.datatype.EditableStringEnumeration")
                    inspectorValue = inspectorValue.Value;
                end

                [inspectorValue, ex] = DescriptorValidator.validateIPAddress( ...
                    "DestinationAddress", inspectorValue, ...
                    "transportapp:udpportapp:InvalidIPAddress", ...
                    obj.DefaultIPAddress, obj.OriginalObjects.IPAddressVersion);

                if ~isempty(ex)
                    throw(ex);
                end

                % If no error was thrown, set properties used to construct
                % the dropdown list.

                % Need to use cells because EditableStringEnumeration uses
                % cell char array. A single string will get enumerated as
                % individual characters.

                obj.DestinationAddress = inspectorValue;

                % Prevent adding empty text to dropdown
                if inspectorValue ~= "" && ~isempty(inspectorValue)
                    obj.DestinationAddressList{end+1} = string(inspectorValue);
                end
                % notifyPropertiesUpdated() is an internal InspectorProxyMixin
                % method that refreshes the properties list and
                % re-renders the dropdown lists. Without calling this
                % method, the dropdown list in the Property Inspector
                % does not update.
                obj.notifyPropertiesUpdated();
            catch ex
                showErrorDialog(obj, ex);
            end
        end

        function set.DestinationPortDropDown(obj, inspectorValue)

            import transportapp.udpport.internal.DescriptorValidator

            if obj.InternalPropertySet
                return
            end

            try
                if isa(inspectorValue, "internal.matlab.editorconverters.datatype.EditableStringEnumeration")
                    inspectorValue = inspectorValue.Value;
                end
                [inspectorValue, ex] = DescriptorValidator.validatePort( ...
                    "DestinationPort", inspectorValue, ...
                    "transportapp:udpportapp:InvalidPort", ...
                    obj.DefaultPortValue);
                if ~isempty(ex)
                    throw(ex);
                end

                % If no error was thrown, set values for the property
                % inspector.
                obj.DestinationPort = inspectorValue;

                % Prevent the addition of empty text to dropdown.
                if inspectorValue ~= "" && ~isempty(inspectorValue)
                    obj.DestinationPortList{end+1} = string(inspectorValue);
                end
                % notifyPropertiesUpdated() is an internal InspectorProxyMixin
                % method that refreshes the properties list and
                % re-renders the dropdown lists. Without calling this
                % method, the dropdown list in the Property Inspector
                % does not update.
                obj.notifyPropertiesUpdated();
            catch ex
                showErrorDialog(obj, ex);
            end
        end

        function set.EnableBroadcast(obj, inspectorValue)
            % Toggles the EnableBroadcast property of the UDP object.
            if obj.InternalPropertySet
                return
            end
            try
                obj.setPropertyOnOriginalObject("EnableBroadcast", inspectorValue);
            catch ex
                showErrorDialog(obj, ex);
            end
        end

        function set.EnableMulticastLoopback(obj, inspectorValue)
            if obj.InternalPropertySet
                return
            end

            try
                % Check if multicast functionality is supported on the
                % platform.
                obj.MulticastPlatformCheckFcn();
            catch ex
                showErrorDialog(obj, ex);
                return
            end

            % Set via configureMulticast() instead of dot-indexing

            % If object is not subscribed to a multicast group, throw an
            % error informing the user.
            if obj.OriginalObjects.MulticastGroup == ""
                ex = MException(message("transportapp:udpportapp:ToggleEnableMulticastLoopback"));
                showErrorDialog(obj, ex);
            else
                try
                    configureMulticast(obj.OriginalObjects, obj.OriginalObjects.MulticastGroup, inspectorValue);
                    obj.addMulticastOnCodeAndComment(obj.OriginalObjects.MulticastGroup, inspectorValue, ...
                        transportapp.udpport.internal.UdpportApp.TransportInstance);
                catch ex
                    showErrorDialog(obj, ex);
                end
            end
        end

        function set.MulticastGroup(obj, inspectorValue)
            % Subscribes/Unsubscribe the udpport object to a multicast
            % group.
            if obj.InternalPropertySet
                return
            end

            try
                % Check if multicast functionality is supported on the
                % platform.
                obj.MulticastPlatformCheckFcn();

                dropDownList = inspectorValue.EnumeratedValues;
                inspectorValue = inspectorValue.Value;

                if isempty(inspectorValue)
                    inspectorValue = "";
                end

                if ~ischar(inspectorValue) && ~isStringScalar(inspectorValue)
                    throwAsCaller(MException(message("transportapp:udpportapp:MulticastGroupInvalidType")));
                end

                % Having confirmed that the input type is valid, remove
                % extra "" or '' from the inspector value that was input by
                % the user.
                inspectorValue = replace(inspectorValue, ["""", "''"], "");

                % If the user clears this field, unsubscribe from a
                % multicast group with "configureMulticast(u, "off")
                if inspectorValue == ""
                    % Only call method when udpport object was
                    % subscribed to a mulitcast group.

                    if obj.OriginalObjects.MulticastGroup ~= ""
                        oldGroup = obj.OriginalObjects.MulticastGroup;
                        configureMulticast(obj.OriginalObjects, "off");
                        obj.addMulticastOffCodeAndComment(oldGroup, ...
                            transportapp.udpport.internal.UdpportApp.TransportInstance);
                    end
                else
                    % Subscribe the multicast group provided by the
                    % user.
                    multicastLoopback = obj.EnableMulticastLoopback;
                    configureMulticast(obj.OriginalObjects, inspectorValue, ...
                        multicastLoopback);

                    addToMulticastDropdownList(obj, dropDownList);
                    obj.addMulticastOnCodeAndComment(inspectorValue, multicastLoopback, ...
                        transportapp.udpport.internal.UdpportApp.TransportInstance);
                end

                % notifyPropertiesUpdated() is an internal InspectorProxyMixin
                % method that refreshes the properties list and
                % re-renders the dropdown lists. Without calling this
                % method, the dropdown list in the Property Inspector
                % does not update.
                obj.notifyPropertiesUpdated();
            catch ex
                showErrorDialog(obj, ex);
            end

            %% NESTED FUNCTION
            function addToMulticastDropdownList(obj, dropDownList)
                % Add the multicast address on the udpport object to the
                % MulticastGroup dropdown list if not already present.

                value = obj.OriginalObjects.MulticastGroup;
                if ~ismember(value, string(dropDownList))
                    obj.MulticastGroupList{end+1} = value;
                end
            end
        end

        function set.OutputDatagramSize(obj, inspectorValue)
            % Sets the number of data bytes each datagram will carry.
            if obj.InternalPropertySet
                return
            end
            try
                obj.setPropertyOnOriginalObject("OutputDatagramSize", inspectorValue);
            catch ex
                showErrorDialog(obj, ex);
            end
        end

        function set.Timeout(obj, inspectorValue)
            obj.TransportProxy.Timeout = inspectorValue;
        end
    end

    %% Implement Abstract Methods
    methods
        function setProxyPropertyGroups(obj)
            % Create the Connection group to display properties about the
            % udpport object.

            getGroup = @(groupName) message("transportapp:udpportapp:PropertyInspector" + groupName + "Group").string();

            g1 = obj.createGroup(getGroup("Connection"), "", "");
            g1.addProperties("LocalHost", "LocalPort", "IPAddressVersion", "EnablePortSharing");
            g1.Expanded = true;

            %Create the communication group to add communication related
            %properties.

            g2 = obj.createGroup(getGroup("Communication"), "", "");
            g2.addProperties("DestinationAddressDropDown", ...
                "DestinationPortDropDown", "OutputDatagramSize", ...
                "Timeout", "ByteOrder");
            g2.Expanded = true;

            % Create a third group for multicast properties
            g3 = obj.createGroup(getGroup("Multicast"), "", "");
            g3.addProperties("EnableMulticastLoopback", "MulticastGroup");
            g3.Expanded = true;

            % Create a fourth group for broadcast properties
            g4 = obj.createGroup(getGroup("Broadcast"), "", "");
            g4.addProperties("EnableBroadcast");
            g4.Expanded = true;
        end
    end

    %% Helper Methods
    methods(Access = private)
        function setServerDisconnected(obj, evt)
            obj.ServerDisconnected = evt.AffectedObject.ServerDisconnected;
        end
    end

    methods
        function handleServerDisconnected(obj)
            % When the server is disconnected, initiate the app close
            % routine by setting the ServerDisconnected flag to true and
            % clearing the ServerDisconnectedListener (no further data is
            % expected).

            if isvalid(obj.ServerDisconnectedListener)
                delete(obj.ServerDisconnectedListener);
            end

            % Call disconnect before closing the app to immediately
            % remove any active transport listeners.
            obj.disconnect();

            obj.ServerDisconnected = true;
        end

        function setPropertyOnOriginalObject(obj, propertyName, propertyValue)
            % Set the PropertyNameValue property that publishes its value
            % to the MATLABCodeGenerator class for generating MATLAB code
            % for property setters.

            obj.TransportProxy.setPropertyOnOriginalObject(propertyName, propertyValue);
        end

        function addMulticastOnCodeAndComment(obj, group, loopback, transportInstance)
            % Logic for producing the comments and code for when the
            % configureMulticast method is used to subscribe to a multicast
            % group
            arguments
                obj
                group (1,1) string
                loopback logical
                transportInstance (1,1) string
            end

            if loopback
                loopbackCommentString = obj.EnabledValue;
            else
                loopbackCommentString = obj.DisabledValue;
            end

            obj.Comment = string(message("transportapp:udpportapp:ConfigureMulticastCommentOn", ...
                transportInstance, group, lower(loopbackCommentString)).getString());

            obj.Code = string(message("transportapp:udpportapp:ConfigureMulticastCodeOn", ...
                transportInstance, group, string(loopback)).getString());

            obj.NewLine = true;
        end

        function addMulticastOffCodeAndComment(obj, oldAddress, transportInstance)
            % Logic for producing the comments and code for when the
            % configureMulticast method is used to unsubscribe to a multicast
            % group.
            arguments
                obj
                oldAddress (1,1) string
                transportInstance (1,1) string
            end
            obj.Comment = string(message("transportapp:udpportapp:ConfigureMulticastCommentOff", ...
                transportInstance, oldAddress).getString());

            obj.Code = string(message("transportapp:udpportapp:ConfigureMulticastCodeOff", ...
                transportInstance).getString());
            obj.NewLine = true;
        end
    end
end
