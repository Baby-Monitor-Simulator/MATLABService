function instrumentslcallback(dialog, value, tag)
%INSTRUMENTSLCALLBACK Calls the private callback function associated with a widget
%
%    INSTRUMENTSLCALLBACK(DIALOG, VALUE, TAG) calls the private function
%    (callback) associated with the widget specified in TAG. 

%    Copyright 2007-2023 The MathWorks, Inc.

% Get all the tags associated with the block. 
widgetTags = instrumentslgate('privateinstrumentslstring', 'alltags');

% Call the appropriate callback.
switch tag
    case {widgetTags.Host widgetTags.LocalAddress}
        instrumentslgate('privateslcbhost', dialog);
    case {widgetTags.LocalPort widgetTags.Port}
        instrumentslgate('privateslcbport', dialog, tag, value);
    case widgetTags.CheckValidity
        instrumentslgate('privateslcbcheck',dialog);        
    case widgetTags.DataSize
        instrumentslgate('privateslcbdatasize',dialog, tag, value);
    case {widgetTags.EnableBlockingMode, widgetTags.EnablePortSharing, widgetTags.GetLatestData, widgetTags.TransferDelay}
        dialog.refresh();
    case widgetTags.Timeout
        instrumentslgate('privateslcbtimeout',dialog, tag, value);
    case widgetTags.SampleTime
        instrumentslgate('privateslcbsampletime', dialog, tag, value);
    case widgetTags.ComPortMenu
        instrumentslgate('privateslcbcomportchanged', dialog);
    case widgetTags.DataBits
        instrumentslgate('privateslcbdatabits', dialog, value);        
    case widgetTags.BaudRate
        instrumentslgate('privateslcbbaudrate', dialog, tag, value);
    case {widgetTags.Header, widgetTags.Terminator}
        instrumentslgate('privateslcbheadterm', dialog, tag, value);
    case widgetTags.CustomValue
        instrumentslgate('privateslcbcustomvalue', dialog, tag, value);
    case widgetTags.OutputDatagramPacketSize
        instrumentslgate('privateslcbopdatagrampacketsize',dialog, tag, value);
    case widgetTags.ASCIIFormatting
        instrumentslgate('privateslcbasciiformatstring',dialog, tag, value);
    case {widgetTags.DataType, ...
          widgetTags.Parity, widgetTags.StopBits, ... 
          widgetTags.FlowControl, widgetTags.ByteOrder, ...
          widgetTags.ActionDataUnavailable}
        % Do nothing.
    otherwise
        % Error out - Invalid widget tag.
        uiwait(errordlg(message('instrument:instrumentblks:invalidWidgetTag').getString,'','modal'));
end
