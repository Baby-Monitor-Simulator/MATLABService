function [status, errMsg] = instrumentslcbpreapply(obj, dlg)
%INSTRUMENTSLCBPREAPPLY Apply changes made in the ICT blocks.
%
%    [STATUS, ERRMSG] = INSTRUMENTSLCBPREAPPLY(OBJ, DLG) applies changes 
%    from the dynamic dialog DLG to OBJ, a dialog source object. 
%    Returns a status STATUS of 0 indicating failure or 1 indicating success. 
%    If any errors need to be returned, they are provided in ERRMSG.
%
%    This function is invoked every time the mask is closed. Without it
%    changes made to some of the enumerated drop downs will not be honored.

% Copyright 2007-2023 The MathWorks, Inc.

% Initialize.
status = 1;
errMsg = '';

% Check if the user is operating on the library. If so, the mask is
% disabled so don't apply anything to avoid dirtying the library.
if isDisableDialog(dlg)
    return;
end

% preApplyCallback is a C++ function that returns a status and error 
% message.  For about 3-4 months (late '03), in the M world, it was 
% returning these arguments in a reverse order. This appears to be fixed, 
% but check to make sure.
[status, errMsg] = obj.preApplyCallback(dlg);
if ischar(status)
    warning(message('instrument:instrumentblks:ddgApply'));
    tmp = status;
    status = errMsg;
    errMsg = tmp;
end

% Apply the changes to the actual block.
% Note, when a block parameter is changed, it will trigger a call
% to the S-Function's mdlInitializeSizes routine.

block = class(obj);

switch block
    case 'instrumentdialog.tcpiprb'
        obj.Block.Host = obj.Host;
        obj.Block.Port = obj.Port;
        obj.Block.DataSize = obj.DataSize;
        if (obj.EnableBlockingMode)
            obj.Block.EnableBlockingMode = 'on';
        else
            obj.Block.EnableBlockingMode = 'off';
        end
        obj.Block.DataType = obj.DataType;
        obj.Block.ASCIIFormatting = obj.ASCIIFormatting;
        obj.Block.Terminator = obj.Terminator;
        obj.Block.ByteOrder = obj.ByteOrder;        
        obj.Block.Timeout = obj.Timeout;
        obj.Block.Sampletime = obj.Sampletime;
    case 'instrumentdialog.udprb'
        obj.Block.Host = obj.Host;
        obj.Block.Port = obj.Port;
        obj.Block.LocalPort = obj.LocalPort;
        obj.Block.LocalAddress = obj.LocalAddress;
        obj.Block.DataSize = obj.DataSize;
        if (obj.EnableBlockingMode)
            obj.Block.EnableBlockingMode = 'on';
        else
            obj.Block.EnableBlockingMode = 'off';
        end
        if (obj.EnablePortSharing)
            obj.Block.EnablePortSharing = 'on';
        else
            obj.Block.EnablePortSharing = 'off';
        end
        if (obj.GetLatestData)
            obj.Block.GetLatestData = 'on';
        else
            obj.Block.GetLatestData = 'off';
        end
        obj.Block.DataType = obj.DataType;
        obj.Block.ASCIIFormatting = obj.ASCIIFormatting;
        obj.Block.Terminator = obj.Terminator;
        obj.Block.ByteOrder = obj.ByteOrder;
        obj.Block.Timeout = obj.Timeout;
        obj.Block.SampleTime = obj.Sampletime;
        
    case 'instrumentdialog.tcpipsb'
        obj.Block.Host = obj.Host;
        obj.Block.Port = obj.Port;
        obj.Block.Timeout = obj.Timeout;
        if (obj.EnableBlockingMode)
            obj.Block.EnableBlockingMode = 'on';
        else
            obj.Block.EnableBlockingMode = 'off';
        end
        if (obj.TransferDelay)
            obj.Block.TransferDelay = 'on';
        else
            obj.Block.TransferDelay = 'off';
        end
        obj.Block.ByteOrder = obj.ByteOrder;
    case 'instrumentdialog.udpsb'
        obj.Block.Host = obj.Host;
        obj.Block.Port = obj.Port;
        if (obj.EnableBlockingMode)
            obj.Block.EnableBlockingMode = 'on';
        else
            obj.Block.EnableBlockingMode = 'off';
        end
        if (obj.EnablePortSharing)
            obj.Block.EnablePortSharing = 'on';
        else
            obj.Block.EnablePortSharing = 'off';
        end
        obj.Block.LocalPort = obj.LocalPort;
        obj.Block.ByteOrder = obj.ByteOrder;
        obj.Block.LocalAddress = obj.LocalAddress;
        obj.Block.OutputDatagramPacketSize = obj.OutputDatagramPacketSize;
    case 'instrumentdialog.serialcb'
        obj.Block.ComPortMenu = obj.ComPortMenu;
        obj.Block.ComPort = obj.ComPort;
        obj.Block.ObjConstructor = obj.ObjConstructor;
        obj.Block.BaudRate = obj.BaudRate;
        obj.Block.DataBits = obj.DataBits;
        obj.Block.ByteOrder = obj.ByteOrder;
        obj.Block.Parity = obj.Parity;
        obj.Block.StopBits = obj.StopBits;
        obj.Block.FlowControl = obj.FlowControl;
        obj.Block.Timeout = obj.Timeout;
    case 'instrumentdialog.serialrb'
        obj.Block.ComPortMenu = obj.ComPortMenu;
        obj.Block.ComPort = obj.ComPort;
        obj.Block.ObjConstructor = obj.ObjConstructor;        
        obj.Block.Header = obj.Header;
        obj.Block.Terminator = obj.Terminator;       
        obj.Block.DataSize = obj.DataSize;
        obj.Block.DataType = obj.DataType;
        obj.Block.ActionDataUnavailable = obj.ActionDataUnavailable;
        obj.Block.CustomValue = obj.CustomValue;
        obj.Block.SampleTime = obj.SampleTime;
        if (obj.EnableBlockingMode)
            obj.Block.EnableBlockingMode = 'on';
        else
            obj.Block.EnableBlockingMode = 'off';
        end
        instrumentslgate('privatesladdserialconfig', obj, 'Receive');
    case 'instrumentdialog.serialsb'        
        obj.Block.ComPortMenu = obj.ComPortMenu;
        obj.Block.ComPort = obj.ComPort;
        obj.Block.ObjConstructor = obj.ObjConstructor;
        obj.Block.Header = obj.Header;
        obj.Block.Terminator = obj.Terminator;
        if (obj.EnableBlockingMode)
            obj.Block.EnableBlockingMode = 'on';
        else
            obj.Block.EnableBlockingMode = 'off';
        end
        instrumentslgate('privatesladdserialconfig', obj, 'Send');
    otherwise
        uiwait(errordlg(message('instrument:instrumentblks:invalidBlock').getString, message('instrument:instrumentblks:errorString').getString, 'modal'));
        status = 0;
end
