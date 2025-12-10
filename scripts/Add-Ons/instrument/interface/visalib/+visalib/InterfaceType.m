classdef InterfaceType
    %INTERFACETYPE Enumeration for instrument interface types specified by
    %VISA
    
    % Copyright 2020 The MathWorks, Inc.
   
   enumeration
       % These should be lower-case (do not change to upper-case)
       gpib
       vxi
       serial
       pxi
       tcpip
       usb
       socket % not an instrument type
       unset
   end
    
   methods
       % Must have a method for looking these up because the type of
       % "socket" is the same as the type for "tcpip"
       function visaInterfaceType = visaInterfaceType(obj)
           switch obj
               case visalib.InterfaceType.gpib
                   visaInterfaceType = 1;
               case visalib.InterfaceType.vxi
                   visaInterfaceType = 2;
               case visalib.InterfaceType.serial
                   visaInterfaceType = 4;
               case visalib.InterfaceType.pxi
                   visaInterfaceType = 5;
               case {visalib.InterfaceType.tcpip,...
                     visalib.InterfaceType.socket}  
                   visaInterfaceType = 6;
               case visalib.InterfaceType.usb
                   visaInterfaceType = 7;
               otherwise
                   visaInterfaceType = intmax('uint16'); 
           end
           
           visaInterfaceType = uint16(visaInterfaceType);
        end
   end
end