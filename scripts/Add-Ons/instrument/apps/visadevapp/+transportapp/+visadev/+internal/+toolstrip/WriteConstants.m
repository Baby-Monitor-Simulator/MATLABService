classdef WriteConstants < transportapp.visadev.internal.toolstrip.ConstantsExtender
    % WRITECONSTANTS Defines constant values used by classes related to the
    % Write section of the VISA Explorer Toolstrip. Extends the Shared
    % Transport App write.Constants class to expose the same properties with
    % some specialization.

    % Copyright 2022-2023 The MathWorks, Inc.

    properties(Constant, Access = protected)
        % Handle to write.Constants so that base constants can be exposed.
        BaseConstants = matlabshared.transportapp.internal.toolstrip.write.Constants
    end

    properties(Constant)
        % Override DataFormatDropDownOptions to add Binblock
        DataFormatDropDownOptions = [matlabshared.transportapp.internal.toolstrip.write.Constants.DataFormatDropDownOptions, "Binblock"]

        % Override DataFormatDropDown to make ASCII-Terminated String the
        % default value
        DataFormatDropDown = struct("Value", matlabshared.transportapp.internal.toolstrip.write.Constants.DataFormatDropDownOptions(2), ...
            "Tag", 'WriteDataFormatDropDown')

        % ASCII-Terminated String will be default Format. Default Type
        % should include only ASCII-Terminated Precision values.
        DataTypeDropDownOptions = matlabshared.transportapp.internal.toolstrip.write.Constants.ASCIITerminatedPrecision
        CustomDataEditField = struct("Description", matlabshared.transportapp.internal.toolstrip.write.Constants.CustomDataTooltip, ...
            "Tag", 'WriteEnterDataEditField', "Editable", true)

        % Common writeread options to include in Data To Write dropdown
        WriteReadDropDownOptions = visalib.internal.TabCompletionHelper.queryOptions

        % Header Label
        HeaderLabel = message("transportapp:visadevapp:HeaderLabel").string
        HeaderTooltip = message("transportapp:visadevapp:HeaderTooltip").string
        HeaderLabelProps = struct("Text", transportapp.visadev.internal.toolstrip.WriteConstants.HeaderLabel, ...
            "Description", transportapp.visadev.internal.toolstrip.WriteConstants.HeaderTooltip)

        % Header Edit Field
        HeaderEditField = struct( ...
            "Description", transportapp.visadev.internal.toolstrip.WriteConstants.HeaderTooltip, ...
            "Tag", 'HeaderEditField', ...
            "Enabled", false ...
            )

        % WriteReadButton properties
        WriteReadButtonLabel = message("transportapp:visadevapp:WriteReadButtonLabel").string
        WriteReadButtonTooltip = message("transportapp:visadevapp:WriteReadButtonTooltip").string
        WriteReadButton = struct("Text", transportapp.visadev.internal.toolstrip.WriteConstants.WriteReadButtonLabel, ...
            "Icon", matlabshared.testmeasapps.internal.themeableiconrepository.IconRepository.getIcon("ict", "WriteRead"), ...
            "Description", transportapp.visadev.internal.toolstrip.WriteConstants.WriteReadButtonTooltip, ...
            "Enabled", true, ...
            "Tag", 'WriteReadButton')

        % Override column spacing to add WriteRead column
        WriteColumn = [matlabshared.transportapp.internal.toolstrip.write.Constants.WriteColumn, ...
            matlabshared.transportapp.internal.toolstrip.Manager.prepareToolstripColumn( ...
                matlabshared.transportapp.internal.toolstrip.Manager.ButtonWidth, ...
                matlabshared.transportapp.internal.toolstrip.Manager.ButtonAlignment)]

        BinaryFormat = transportapp.visadev.internal.toolstrip.WriteConstants.DataFormatDropDownOptions(1)
        ASCIITerminatedStringFormat = transportapp.visadev.internal.toolstrip.WriteConstants.DataFormatDropDownOptions(2)
        BinblockFormat = transportapp.visadev.internal.toolstrip.WriteConstants.DataFormatDropDownOptions(3)
    end
end
