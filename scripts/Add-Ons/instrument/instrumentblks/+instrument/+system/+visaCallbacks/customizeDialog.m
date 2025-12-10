function customizeDialog(parameter)
% CUSTOMIZEDIALOG is used for dialog customization
%
%   CUSTOMIZEDIALOG() controls the visibility of non system object
%   parameters that are present on the mask. This include containers and
%   'help text'. This function will be parameter callbacks for parameters
%   that control its associated parameters visibility.

% Copyright 2023 The MathWorks, Inc.

% Get the mask object.
maskObj = Simulink.Mask.get(gcb);

% Get dialog control for required parameters.
connectConfigContainer = maskObj.getDialogControl("CtConnectConfig");
resourceStringHelp = maskObj.getDialogControl("HlRscString");
sendCommandContainer = maskObj.getDialogControl("CtSendCommand");
receiveResponseContainer = maskObj.getDialogControl("CtReceiveResponse");
numericFormatHelp = maskObj.getDialogControl("HlnumericFormat");

switch parameter
    case 'ResourceName'
        if strcmpi(get_param(gcb, "HwConfigOptions"), "Select from resource list") ...
                && strcmpi(get_param(gcb, "ResourceName"), "<Select a resource name>")
            connectConfigContainer.Visible = "off";
        else
            connectConfigContainer.Visible = "on";
        end

    case 'HwConfigOptions'
        % Set the visibility of 'Connection configuration' container.
        if strcmpi(get_param(gcb, "HwConfigOptions"), "Select from resource list") ...
                && strcmpi(get_param(gcb, "ResourceName"), "<Select a resource name>")
            connectConfigContainer.Visible = "off";
        else
            connectConfigContainer.Visible = "on";
        end
        % Set the visibility of 'Resource string format' help text.
        if strcmpi(get_param(gcb, "HwConfigOptions"), "Configure new VISA resource")
            resourceStringHelp.Visible = "on";
        else
            resourceStringHelp.Visible = "off";
        end

    case 'BlockMode'
        % Set the visibility of 'Send command' container.
        if strcmpi(get_param(gcb, "BlockMode"), "Receive response")
            sendCommandContainer.Visible = "off";
        else
            sendCommandContainer.Visible = "on";
        end
        % Set the visibility of 'Receive response' container.
        if strcmpi(get_param(gcb, "BlockMode"), "Send command")
            receiveResponseContainer.Visible = "off";
        else
            receiveResponseContainer.Visible = "on";
        end

    case 'SendCommandType'
        % Set the visibility of 'Numeric format' help text.
        if strcmpi(get_param(gcb, "SendCommandType"), "Compose command from input data")
            numericFormatHelp.Visible = "on";
        else
            numericFormatHelp.Visible = "off";
        end
end
end

