function instrreset
%INSTRRESET Disconnect and delete all instrument objects.
%
%   INSTRRESET will be removed in a future release. For serialport,
%   tcpclient, tcpserver, udpport, visadev, aardvark, and ni845x objects,
%   use delete(serialportfind), delete(tcpclientfind),
%   delete(tcpserverfind), delete(udpportfind), delete(visadevfind),
%   delete(aardvarkfind), and delete(ni845xfind) instead.
%
%   INSTRRESET disconnects and deletes all instrument objects. If data 
%   is being written or read asynchronously, the asynchronous operation
%   is stopped.
%
%   An instrument object cannot be reconnected to the instrument after 
%   it has been deleted and should be removed from the workspace with
%   CLEAR.
%
%   See also ICINTERFACE/STOPASYNC, ICINTERFACE/FCLOSE,
%   ICINTERFACE/DELETE, ICDEVICE/DISCONNECT.
%

%   Copyright 1999-2023 The MathWorks, Inc.

try
    instrument.internal.ICTRemoveFunctionalityHelper(mfilename, "Warn", "Function");
catch ex
    throwAsCaller(ex);
end
 
% Delete all instrument objects
try
    instrument.internal.udm.InstrumentManager.getInstance.reset;
catch e
end

% Clear the list of Bluetooth devices on which instrhwinfo has been called.
try
    tempout = com.mathworks.toolbox.instrument.BluetoothDiscovery.clearInstrhwinofCalledOnceList();
catch e
end

% delete IVI-C class complaint objects created via TMTOOL
try
    com.mathworks.toolbox.instrument.browser.ivicWrapper.IviCInstrumentObjectStore.dispose();
catch e
end

try
   % Find all objects.  Return if none were found.   
   obj = instrfind;
   if isempty(obj)
      return;
   end
   
   delete(obj);
catch aException
   rethrow(aException);     
end



 
