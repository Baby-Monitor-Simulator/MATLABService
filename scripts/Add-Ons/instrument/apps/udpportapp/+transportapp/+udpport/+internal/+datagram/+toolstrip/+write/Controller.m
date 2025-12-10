classdef Controller < transportapp.udpport.internal.common.toolstrip.write.Controller
    % CONTROLLER contains UDP datagram-specific properties and methods for
    % the write section of the toolstrip.
    % NOTE: Overrides the following shared-app properties and methods:
    %       - getConstants()
    %       - resetWorkspaceVariableList()

    % Copyright 2021 The Mathworks, Inc.

    %% Hook Method Implementations
    methods(Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        function consts = getConstants(~)
            consts = transportapp.udpport.internal.datagram.toolstrip.write.Constants;
        end
    end

    %% Helper Methods
    methods(Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        function resetWorkspaceVariableList(obj)
            % Override Shared-App method to handle one key-value pair.
            keySet = obj.DataFormatDropDownOptions{1};
            valueSet = string.empty;
            obj.WorkspaceVariableList = containers.Map();
            obj.WorkspaceVariableList(keySet) = valueSet;
        end
    end
end