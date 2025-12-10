classdef ReadConstants < transportapp.visadev.internal.toolstrip.ConstantsExtender
    %READCONSTANTS Constants class for VISA Explorer toolstrip Read
    %section. Overrides properties in Shared Transport App toolstrip
    %read.Constants class to add Binblock support and to use
    %ASCII-Terminated String as default DataFormat.

    % Copyright 2022 The MathWorks, Inc.

    properties(Constant, Access = protected)
        BaseConstants = matlabshared.transportapp.internal.toolstrip.read.Constants
    end

    properties(Constant)
        % Add Binblock as DataFormat option
        DataFormatDropDownOptions = [matlabshared.transportapp.internal.toolstrip.read.Constants.DataFormatDropDownOptions, ...
            "Binblock"]

        % Override DataFormatDropDown to use ASCII-Terminated String as
        % default value
        DataFormatDropDown = struct("Value", matlabshared.transportapp.internal.toolstrip.read.Constants.DataFormatDropDownOptions(2), ...
            "Tag", 'ReadDataFormatDropDown')

        % ASCII-Terminated String will be default Format. Default Type
        % should include only ASCII-Terminated Precision values.
        DataTypeDropDownOptions = matlabshared.transportapp.internal.toolstrip.read.Constants.StringPrecision
        DataTypeDropDown = struct("Value", matlabshared.transportapp.internal.toolstrip.read.Constants.StringPrecision, ...
            "Description", matlabshared.transportapp.internal.toolstrip.read.Constants.DataTypeTooltip, ...
            "Tag", 'ReadDataTypeDropDown')
    end
end
