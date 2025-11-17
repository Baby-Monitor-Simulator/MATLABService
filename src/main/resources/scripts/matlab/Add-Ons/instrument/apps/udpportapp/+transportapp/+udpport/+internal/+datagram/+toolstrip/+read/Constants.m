classdef Constants
    % CONSTANTS contains constant properties for the Read Section View and
    % Controller classes for the UDP App when in Datagram mode.

    % Copyright 2021-2023 The MathWorks, Inc.

    properties(Constant)
        %% Columns
        % In general, a toolstrip column contains toolstrip UI elements
        % that are displayed one below the other (stacked vertically).

        % These column properties contain the width and alignment
        % information for each toolstrip column, which affects the
        % underlying UI elements' width and alignment.

        %% Columns
        EmptyColumn = ...
            matlabshared.transportapp.internal.toolstrip.Manager.prepareEmptyToolstripColumn()

        BufferColumn = ...
            matlabshared.transportapp.internal.toolstrip.Manager.prepareToolstripColumn(4, "left")

        % The second column is slightly larger than the shared-app infrastructure
        % to display the entire string "Datagram".
         ReadColumn = [ ...
            matlabshared.transportapp.internal.toolstrip.Manager.prepareToolstripColumn(70, "right"), ... % Column 1 
            matlabshared.transportapp.internal.toolstrip.Manager.prepareToolstripColumn(80, "left"), ... % Column 2 
            matlabshared.transportapp.internal.toolstrip.Manager.prepareToolstripColumn(70, "right"), ... % Column 3
            matlabshared.transportapp.internal.toolstrip.Manager.prepareToolstripColumn(70, "left"), ... % Column 4
            matlabshared.transportapp.internal.toolstrip.Manager.prepareToolstripColumn( ... % Column 5
                matlabshared.transportapp.internal.toolstrip.Manager.ButtonWidth, ...
                matlabshared.transportapp.internal.toolstrip.Manager.ButtonAlignment), ...
            matlabshared.transportapp.internal.toolstrip.Manager.prepareToolstripColumn( ... % Column 6
                matlabshared.transportapp.internal.toolstrip.Manager.ButtonWidth, ...
                matlabshared.transportapp.internal.toolstrip.Manager.ButtonAlignment)
            ]

        %% Section Names
        ReadSectionName = message("transportapp:toolstrip:read:ReadSectionName").getString

        %% Label Names
        DataFormatLabel = message("transportapp:toolstrip:read:DataFormatLabel").getString
        DataTypeLabel = message("transportapp:toolstrip:read:DataTypeLabel").getString
        NumValuesToReadLabel = message("transportapp:udpportapp:NumDatagramsToReadLabel").getString
        ValuesAvailableLabel = message("transportapp:udpportapp:DatagramsAvailableLabel").getString
        ReadButtonLabel = message("transportapp:toolstrip:read:ReadButtonLabel").getString
        FlushButtonLabel = message("transportapp:toolstrip:read:FlushButtonLabel").getString

        %% Tooltip Messages
        DataFormatTooltip = message("transportapp:toolstrip:read:DataFormatTooltip").getString
        DataTypeTooltip = message("transportapp:toolstrip:read:DataTypeTooltip").getString
        NumValuesToReadTooltip = message("transportapp:udpportapp:NumDatagramsToReadTooltip").getString
        ValuesAvailableTooltip = message("transportapp:udpportapp:DatagramsAvailableTooltip").getString
        ReadButtonTooltip = message("transportapp:toolstrip:read:ReadButtonTooltip").getString
        FlushButtonTooltip = message("transportapp:toolstrip:read:FlushButtonTooltip").getString

        %% Column1 Elements
        DataFormatLabelProps = struct("Text", matlabshared.transportapp.internal.toolstrip.read.Constants.DataFormatLabel, ...
            "Description", matlabshared.transportapp.internal.toolstrip.read.Constants.DataFormatTooltip)
        DataTypeLabelProps = struct("Text", matlabshared.transportapp.internal.toolstrip.read.Constants.DataTypeLabel, ...
            "Description", matlabshared.transportapp.internal.toolstrip.read.Constants.DataTypeTooltip)

        %% Column2 Elements
        % Instead of binary/ascii the only data format option is "Datagram".
        DataFormatDropDownOptions = "Datagram";

        DataFormatDropDown = struct("Value", transportapp.udpport.internal.datagram.toolstrip.read.Constants.DataFormatDropDownOptions, ...
            "Tag", 'ReadDataFormatDropDown')

        DataTypeDropDownOptions = matlabshared.transportapp.internal.toolstrip.read.Constants.AllPrecision
        DataTypeDropDown = struct("Value", matlabshared.transportapp.internal.toolstrip.read.Constants.DataTypeDropDownOptions(1), ...
            "Description", matlabshared.transportapp.internal.toolstrip.read.Constants.DataTypeTooltip, ...
            "Tag", 'ReadDataTypeDropDown')

        %% Column3 Elements
        NumValuesToReadLabelProps = struct("Text", transportapp.udpport.internal.datagram.toolstrip.read.Constants.NumValuesToReadLabel, ...
            "Description",  transportapp.udpport.internal.datagram.toolstrip.read.Constants.NumValuesToReadTooltip ...
            )

        ValuesAvailableLabelProps = struct("Text", transportapp.udpport.internal.datagram.toolstrip.read.Constants.ValuesAvailableLabel, ...
            "Description", transportapp.udpport.internal.datagram.toolstrip.read.Constants.ValuesAvailableTooltip ...
            )

        %% Column4 Elements
        NumValuesToRead = struct("Description", transportapp.udpport.internal.datagram.toolstrip.read.Constants.NumValuesToReadTooltip, ...
            "Tag", 'NumValToRead')
        ValuesAvailable = struct("Description",transportapp.udpport.internal.datagram.toolstrip.read.Constants.ValuesAvailableTooltip, ...
            "Text", "0", ...
            "Tag", 'ValuesAvailable');

        %% Column5 Elements
        ReadButton = struct("Text", matlabshared.transportapp.internal.toolstrip.read.Constants.ReadButtonLabel,...
            "Icon", matlabshared.testmeasapps.internal.themeableiconrepository.IconRepository.getIcon("ict", "Read"), ...
            "Description", matlabshared.transportapp.internal.toolstrip.read.Constants.ReadButtonTooltip, ...
            "Enabled", true, ...
            "Tag", 'ReadButton')

        %% Column6 Elements
        FlushButton = struct("Text", matlabshared.transportapp.internal.toolstrip.read.Constants.FlushButtonLabel,...
            "Icon", matlabshared.testmeasapps.internal.themeableiconrepository.IconRepository.getIcon("ict", "Flush"), ...
            "Description", matlabshared.transportapp.internal.toolstrip.read.Constants.FlushButtonTooltip, ...
            "Enabled", true, ...
            "Tag", 'FlushButton')

        %% Other constants
        NumericPrecision = ["uint8", "int8", "uint16", "int16", "uint32", "int32", "uint64", "int64", "single", "double"]
        AllPrecision = [matlabshared.transportapp.internal.toolstrip.read.Constants.NumericPrecision,...
            "char", "string"]
        StringPrecision = "string"
        DataTypeSize = matlabshared.transportapp.internal.toolstrip.read.Constants.getPrecisionByteSize()
        ValuesAvailableASCIITerminatedString = "N/A"
    end
end
