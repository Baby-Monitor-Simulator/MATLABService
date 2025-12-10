function  updateParameterVisibility()
% UPDATEPATAMETERVISIBILITY manages the visibility of the parameters
%
% Copyright 2023 The MathWorks, Inc.

% Get the mask object.
maskObj = Simulink.Mask.get(gcbh);

% Retrieve the hardware configuration options parameter from the mask.
hwParam = maskObj.getParameter('HwConfigOptions');
interfaceParam = maskObj.getParameter('Interface');
boardParam = maskObj.getParameter('BoardNumber');
IPAddParam = maskObj.getParameter('IPAddress');
portParam = maskObj.getParameter('Port');
resourceStringParam = maskObj.getParameter('ResourceString');
vendorNameParam = maskObj.getParameter('VendorName');
modelNameParam = maskObj.getParameter('ModelName');
SlNumberParam = maskObj.getParameter('SlNumber');
sendStringParam = maskObj.getParameter('SendString');
executeFunctionParam = maskObj.getParameter('ExecuteFunction');
staticCommandParam = maskObj.getParameter('StaticCommand');
staticBinaryParam = maskObj.getParameter('StaticBinary');
dataTypeParam = maskObj.getParameter('DataType');
binBlockCommandParam = maskObj.getParameter('BinBlockCommand');
headerParam = maskObj.getParameter('Header');
delimiterParam = maskObj.getParameter('delimiter');
numFormatParam = maskObj.getParameter('NumFormat');
customNumericFormatParam = maskObj.getParameter('CustomNumericFormat');
responseHeaderParam = maskObj.getParameter('ResponseHeader');
responseDelimiterParam = maskObj.getParameter('ResponseDelimiter');
customFormatStringParam = maskObj.getParameter('CustomFormatString');
receiveDatatypeParam = maskObj.getParameter('ReceiveDatatype');
sizeParam = maskObj.getParameter('Size');
checkCommandParam = maskObj.getParameter('CheckCommand');
dataBitsParam = maskObj.getParameter('DataBits');
stopBitsParam = maskObj.getParameter('StopBits');
parityParam = maskObj.getParameter('Parity');
flowControlParam = maskObj.getParameter('FlowControl');
eoiModeParam = maskObj.getParameter('EOIMode');
baudRateParam = maskObj.getParameter('BaudRate');
timeOutParam = maskObj.getParameter('TimeOut');
readTerminatorParam = maskObj.getParameter('ReadTerminator');
writeTerminatortParam = maskObj.getParameter('WriteTerminator');
byteOrderParam = maskObj.getParameter('ByteOrder');
outputSizeParam = maskObj.getParameter('OutputSize');
deviceIDParam = maskObj.getParameter('DeviceID');
resourceParam = maskObj.getParameter('ResourceName');
initParam = maskObj.getParameter('InitOptions');
blockModeParam = maskObj.getParameter('BlockMode');
sendCommandParam = maskObj.getParameter('SendCommandType');
rxOptionParam = maskObj.getParameter('RxOption');
stringFormatParam = maskObj.getParameter('FormatString');
checkErrorParam = maskObj.getParameter('Checkerror');
autoSizeParam = maskObj.getParameter('AutoSize');

% This controls the visibility of the parameters. It utilizes
% 'isInactivePropertyImpl', which returns either 'on' or 'off', to
% determine and set whether the parameters are visible or invisible.
interfaceParam.Visible = isInactivePropertyImpl('Interface');
boardParam.Visible = isInactivePropertyImpl('BoardNumber');
IPAddParam.Visible = isInactivePropertyImpl('IPAddress');
portParam.Visible = isInactivePropertyImpl('Port');
deviceIDParam.Visible = isInactivePropertyImpl('DeviceID');
resourceStringParam.Visible = isInactivePropertyImpl('ResourceString');
resourceParam.Visible = isInactivePropertyImpl('ResourceName');
vendorNameParam.Visible = isInactivePropertyImpl('VendorName');
modelNameParam.Visible = isInactivePropertyImpl('ModelName');
SlNumberParam.Visible = isInactivePropertyImpl('SlNumber');
sendStringParam.Visible = isInactivePropertyImpl('SendString');
executeFunctionParam.Visible = isInactivePropertyImpl('ExecuteFunction');
sendCommandParam.Visible = isInactivePropertyImpl('SendCommandType');
staticCommandParam.Visible = isInactivePropertyImpl('StaticCommand');
staticBinaryParam.Visible = isInactivePropertyImpl('StaticBinary');
dataTypeParam.Visible = isInactivePropertyImpl('DataType');
binBlockCommandParam.Visible = isInactivePropertyImpl('BinBlockCommand');
headerParam.Visible = isInactivePropertyImpl('Header');
delimiterParam.Visible = isInactivePropertyImpl('delimiter');
numFormatParam.Visible = isInactivePropertyImpl('NumFormat');
customNumericFormatParam.Visible = isInactivePropertyImpl('CustomNumericFormat');
rxOptionParam.Visible = isInactivePropertyImpl('RxOption');
responseHeaderParam.Visible = isInactivePropertyImpl('ResponseHeader');
responseDelimiterParam.Visible = isInactivePropertyImpl('ResponseDelimiter');
stringFormatParam.Visible = isInactivePropertyImpl('FormatString');
customFormatStringParam.Visible = isInactivePropertyImpl('CustomFormatString');
receiveDatatypeParam.Visible = isInactivePropertyImpl('ReceiveDatatype');
sizeParam.Visible = isInactivePropertyImpl('Size');
checkCommandParam.Visible = isInactivePropertyImpl('CheckCommand');
dataBitsParam.Visible = isInactivePropertyImpl('DataBits');
stopBitsParam.Visible = isInactivePropertyImpl('StopBits');
parityParam.Visible = isInactivePropertyImpl('Parity');
flowControlParam.Visible = isInactivePropertyImpl('FlowControl');
eoiModeParam.Visible = isInactivePropertyImpl('EOIMode');
baudRateParam.Visible = isInactivePropertyImpl('BaudRate');
timeOutParam.Visible = isInactivePropertyImpl('TimeOut');
readTerminatorParam.Visible = isInactivePropertyImpl('ReadTerminator');
writeTerminatortParam.Visible = isInactivePropertyImpl('WriteTerminator');
byteOrderParam.Visible = isInactivePropertyImpl('ByteOrder');
autoSizeParam.Visible = isInactivePropertyImpl('AutoSize');
outputSizeParam.Visible = isInactivePropertyImpl('OutputSize');

    function flag = isInactivePropertyImpl(prop)
        % Set flag based on if property need to be visible or not on the
        % dialog. The below code controls if a parameter has to be visible
        % or invisible on the dialog
        switch prop
            case {'Interface', 'BoardNumber', 'IPAddress'}
                flag = ~strcmpi(hwParam.Value, "Configure new VISA resource");
            case 'Port'
                flag = ~((strcmpi(interfaceParam.Value, "TCP/IP HiSLIP 1") || strcmpi(interfaceParam.Value, "TCP/IP Socket")) && strcmpi(hwParam.Value, "Configure new VISA resource"));
            case 'DeviceID'
                flag = ~((strcmpi(interfaceParam.Value, "TCP/IP HiSLIP 1") || strcmpi(interfaceParam.Value, "TCP/IP VXI-11")) && strcmpi(hwParam.Value, "Configure new VISA resource"));
            case 'ResourceString'
                flag = ~strcmpi(hwParam.Value, "Specify resource name");
            case 'ResourceName'
                flag = ~strcmpi(hwParam.Value, "Select from resource list");
            case {'VendorName', 'ModelName', 'SlNumber'}
                flag = ~(strcmpi(hwParam.Value, "Select from resource list") && ~strcmpi(resourceParam.Value, "<Select a resource name>"));
            case 'SendString'
                flag = ~strcmpi(initParam.Value, "Initialization commands");
            case 'ExecuteFunction'
                flag = ~strcmpi(initParam.Value, "MATLAB Code");
            case 'SendCommandType'
                flag = ~(strcmpi(blockModeParam.Value, "Send command") || strcmpi(blockModeParam.Value, "Query Instrument"));
            case 'StaticCommand'
                flag = ~(strcmpi(sendCommandParam.Value, "SCPI command") && (strcmpi(blockModeParam.Value, "Send command") || strcmpi(blockModeParam.Value, "Query Instrument")));
            case 'StaticBinary'
                flag = ~(strcmpi(sendCommandParam.Value, "Binary") && (strcmpi(blockModeParam.Value, "Send command") || strcmpi(blockModeParam.Value, "Query Instrument")));
            case 'DataType'
                flag = ~((strcmpi(sendCommandParam.Value, "Binary") || strcmpi(sendCommandParam.Value, "Binblock")) && (strcmpi(blockModeParam.Value, "Send command") || strcmpi(blockModeParam.Value, "Query Instrument")));
            case 'BinBlockCommand'
                flag = ~(strcmpi(sendCommandParam.Value, "Binblock") && (strcmpi(blockModeParam.Value, "Send command") || strcmpi(blockModeParam.Value, "Query Instrument")));
            case {'Header', 'delimiter','NumFormat'}
                flag = ~((strcmpi(sendCommandParam.Value, "Compose command from input data") && strcmpi(blockModeParam.Value, "Send command")) || (strcmpi(blockModeParam.Value, "Query Instrument") && strcmpi(sendCommandParam.Value, "Compose command from input data")));
            case 'CustomNumericFormat'
                flag = ~(strcmpi(numFormatParam.Value, "Enter numeric format") && ...
                    ((strcmpi(sendCommandParam.Value, "Compose command from input data") && strcmpi(blockModeParam.Value, "Send command")) || (strcmpi(blockModeParam.Value, "Query Instrument") && strcmpi(sendCommandParam.Value, "Compose command from input data"))));
            case 'RxOption'
                flag = ~(strcmpi(blockModeParam.Value, "Receive response") || strcmpi(blockModeParam.Value, "Query Instrument"));
            case {'ResponseHeader',  'ResponseDelimiter', 'FormatString'}
                flag = ~(strcmpi(rxOptionParam.Value, "Read string response and convert to numeric value") && (strcmpi(blockModeParam.Value, "Receive response") || strcmpi(blockModeParam.Value, "Query Instrument")));
            case 'CustomFormatString'
                flag = ~(strcmpi(stringFormatParam.Value, "Enter numeric format") && ...
                    strcmpi(rxOptionParam.Value, "Read string response and convert to numeric value") && (strcmpi(blockModeParam.Value, "Receive response") || strcmpi(blockModeParam.Value, "Query Instrument")));
            case 'ReceiveDatatype'
                flag = ~((strcmpi(rxOptionParam.Value, "Read numeric data") || strcmpi(rxOptionParam.Value, "Binblock")) && (strcmpi(blockModeParam.Value, "Receive response") || strcmpi(blockModeParam.Value, "Query Instrument")));
            case 'Size'
                flag = ~(strcmpi(rxOptionParam.Value, "Read numeric data") && (strcmpi(blockModeParam.Value, "Receive response") || strcmpi(blockModeParam.Value, "Query Instrument")));
            case 'CheckCommand'
                flag = ~isequal(checkErrorParam.Value, 'on');
            case {'DataBits', 'StopBits', 'Parity', 'FlowControl'}
                flag = ~(strcmpi(hwParam.Value, "Select from resource list") && contains(extractBefore(resourceParam.Value,"::"), "ASRL"));
            case 'EOIMode'
                flag = ~(strcmpi(hwParam.Value, "Select from resource list") && ~(contains(extractBefore(resourceParam.Value,"::"), "ASRL") || strcmpi(resourceParam.Value, "<Select a resource name>"))|| ...
                    strcmpi(hwParam.Value,"Configure new VISA resource"));
            case 'BaudRate'
                flag = ~(strcmpi(hwParam.Value, "Select from resource list") && contains(extractBefore(resourceParam.Value,"::"), "ASRL"));
            case {'TimeOut', 'ReadTerminator', 'WriteTerminator', 'ByteOrder'}
                flag = ~((strcmpi(hwParam.Value, "Select from resource list") && ~strcmpi(resourceParam.Value, "<Select a resource name>")) || strcmpi(hwParam.Value, "Configure new VISA resource") || strcmpi(hwParam.Value, "Specify resource name"));
            case 'AutoSize'
                flag = ~((strcmpi(rxOptionParam.Value, "Read string response and convert to numeric value") || strcmpi(rxOptionParam.Value, "Binblock")) ...
                    && (strcmpi(blockModeParam.Value, "Receive response") || (strcmpi(blockModeParam.Value, "Query Instrument") && (strcmpi(sendCommandParam.Value, "SCPI command") || strcmpi(sendCommandParam.Value, 'Binary') ||  strcmpi(sendCommandParam.Value, 'Binblock')))));
            case 'OutputSize'
                flag = ((strcmpi(blockModeParam.Value, "Query Instrument") && ((strcmpi(sendCommandParam.Value, 'Compose command from input data') || strcmpi(sendCommandParam.Value, 'Send input port data as is')) && (strcmpi(rxOptionParam.Value, "Read string response and output as is") || strcmpi(rxOptionParam.Value, "Read numeric data")) ))) || ~((strcmpi(blockModeParam.Value, "Query Instrument") && (strcmpi(sendCommandParam.Value, 'Compose command from input data') ||  strcmpi(sendCommandParam.Value, 'Send input port data as is'))) || (strcmpi(rxOptionParam.Value, "Read string response and convert to numeric value") || strcmpi(rxOptionParam.Value, "Binblock") ) ...
                    && isequal(autoSizeParam.Value, 'off') && (strcmpi(blockModeParam.Value, "Receive response") || strcmpi(blockModeParam.Value, "Query Instrument")));
            otherwise
                flag = false;
        end
        if flag == 1
            flag = 'off';
        else
            flag = 'on';
        end
    end
end


