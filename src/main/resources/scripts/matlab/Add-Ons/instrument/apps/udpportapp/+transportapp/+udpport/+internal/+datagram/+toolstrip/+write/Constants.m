classdef Constants
    % CONSTANTS Contains constants for udpport write view
    % Additional fields in udpport app write section when using datagram
    % communication.

    % Copyright 2021-2024 The MathWorks, Inc.

    properties (Constant)
        %% Columns
        % In general, a toolstrip column contains toolstrip UI elements
        % that are displayed one below the other (stacked vertically).

        % These column properties contain the width and alignment
        % information for each toolstrip column, which affects the
        % underlying UI elements' width and alignment.

        EmptyColumn = ...
            matlabshared.transportapp.internal.toolstrip.Manager.prepareEmptyToolstripColumn()

        BufferColumn = ...
            matlabshared.transportapp.internal.toolstrip.Manager.prepareToolstripColumn(4, "left")

        % Column two is larger than in the shared-app infrastructure so the
        % entire string "Datagram" is displayed.
        WriteColumn = [...
            matlabshared.transportapp.internal.toolstrip.Manager.prepareToolstripColumn(70, "right"), ...
            matlabshared.transportapp.internal.toolstrip.Manager.prepareToolstripColumn(90, "center"), ...
            matlabshared.transportapp.internal.toolstrip.Manager.prepareToolstripColumn(100, "left"), ...
            matlabshared.transportapp.internal.toolstrip.Manager.prepareToolstripColumn(200, "left"), ...
            matlabshared.transportapp.internal.toolstrip.Manager.prepareToolstripColumn(30, "center")
            ]

        %% Precision Constants
        NumericPrecision = ["uint8", "int8", "uint16", "int16", "uint32", "int32", "uint64", "int64", "single", "double"]
        ASCIITerminatedPrecision = "string"
        AllPrecision = [transportapp.udpport.internal.datagram.toolstrip.write.Constants.NumericPrecision, ...
            "char", ...
            transportapp.udpport.internal.datagram.toolstrip.write.Constants.ASCIITerminatedPrecision]

        %% Section Names
        WriteSectionName = message("transportapp:toolstrip:write:WriteSectionName").getString

        %% Label Names
        DataFormatLabel = message("transportapp:toolstrip:write:DataFormatLabel").getString
        DataTypeLabel = message("transportapp:toolstrip:write:DataTypeLabel").getString
        CustomDataLabel = message("transportapp:toolstrip:write:CustomDataLabel").getString
        WorkspaceVariableLabel = message("transportapp:toolstrip:write:WorkspaceVariableLabel").getString
        WriteButtonLabel = message("transportapp:toolstrip:write:WriteButtonLabel").getString

        %% Tooltip Messages
        DataFormatTooltip = message("transportapp:toolstrip:write:DataFormatTooltip").getString
        DataTypeTooltip = message("transportapp:toolstrip:write:DataTypeTooltip").getString
        CustomDataTooltip = message("transportapp:udpportapp:CustomDataTooltip").getString
        WorkspaceVariableTooltip = message("transportapp:toolstrip:write:WorkspaceVariableTooltip").getString
        WriteButtonTooltip = message("transportapp:toolstrip:write:WriteButtonTooltip").getString

        %% Column1 Elements
        DataFormatLabelProps = struct("Text", transportapp.udpport.internal.datagram.toolstrip.write.Constants.DataFormatLabel, ...
            "Description", transportapp.udpport.internal.datagram.toolstrip.write.Constants.DataFormatTooltip)

        DataTypeLabelProps = struct("Text", transportapp.udpport.internal.datagram.toolstrip.write.Constants.DataTypeLabel, ...
            "Description", transportapp.udpport.internal.datagram.toolstrip.write.Constants.DataTypeTooltip)

        %% Column2 Elements
        % Instead of byte/ascii, the data format option is "Datagram".
        DataFormatDropDownOptions = "Datagram";
        DataFormatDropDown = struct("Value", transportapp.udpport.internal.datagram.toolstrip.write.Constants.DataFormatDropDownOptions, ...
            "Tag", 'WriteDataFormatDropDown')

        DataTypeDropDownOptions = transportapp.udpport.internal.datagram.toolstrip.write.Constants.AllPrecision;
        DataTypeDropDown = struct("Value", transportapp.udpport.internal.datagram.toolstrip.write.Constants.DataTypeDropDownOptions(1), ...
            "Description", transportapp.udpport.internal.datagram.toolstrip.write.Constants.DataTypeTooltip, ...
            "Tag", 'WriteDataTypeDropDown')

        %% Column3 Elements
        CustomDataButton = struct("Text", transportapp.udpport.internal.datagram.toolstrip.write.Constants.CustomDataLabel, ...
            "Value", true, ...
            "Description", transportapp.udpport.internal.datagram.toolstrip.write.Constants.CustomDataTooltip, ...
            "Tag", 'WriteEnterDataButton')

        WorkspaceVariableButton = struct("Text", transportapp.udpport.internal.datagram.toolstrip.write.Constants.WorkspaceVariableLabel, ...
            "Value", false, ...
            "Description", transportapp.udpport.internal.datagram.toolstrip.write.Constants.WorkspaceVariableTooltip, ...
            "Tag", 'WriteWorkspaceVarButton')

        %% Column4 Elements
        CustomDataEditField = struct("Description", transportapp.udpport.internal.datagram.toolstrip.write.Constants.CustomDataTooltip, ...
            "Tag", 'WriteEnterDataEditField')

        WorkspaceVariableDropdown = struct("Enabled", false, ...
            "Description", transportapp.udpport.internal.datagram.toolstrip.write.Constants.WorkspaceVariableTooltip, ...
            "Tag", 'WriteWorkspaceVarDropDown');
        WorkspaceVariableDropdownTypes = {["Char", "String", "Numeric"], ["Char", "String"]}

        %% Column5 Elements
        WriteButton = struct("Text", transportapp.udpport.internal.datagram.toolstrip.write.Constants.WriteButtonLabel, ...
            "Icon", matlabshared.testmeasapps.internal.themeableiconrepository.IconRepository.getIcon("ict", "Write"), ...
            "Description", transportapp.udpport.internal.datagram.toolstrip.write.Constants.WriteButtonTooltip, ...
            "Enabled", true, ...
            "Tag", 'WriteButton')

        %% Other Constants
        WorkspaceCleared = "WORKSPACE_CLEARED"
        VariableDeleted = "VARIABLE_DELETED"
        VariableChanged = "VARIABLE_CHANGED"
        VariableAdded = "VARIABLE_ADDED"
    end
end
