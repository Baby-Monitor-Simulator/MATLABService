% Instrument Control Toolbox
% Version 24.2 (R2024b) 21-Jun-2024
%
% Interface object construction.
%   instrument/spi         - Construct SPI object.
%
% Instrument device object construction.
%   instrument/icdevice - Construct ICDEVICE (device) object.
%
% IVI configuration store object construction.
%   instrument/iviconfigurationstore - Construct IVICONFIGURATIONSTORE object.
%
% Getting and setting parameters.
%   get                 - Get value of instrument object property.
%   set                 - Set value of instrument object property.
%
% Interface object - state change.
%   fopen               - Connect object to instrument.
%   fclose              - Disconnect object from instrument. 
%   record              - Record data from instrument control session.
%
% Device object - state change.
%   connect             - Connect object to instrument.
%   disconnect          - Disconnect object from instrument. 
%
% INTERFACE functions.
%   binblockread        - Read binblock from instrument.
%   binblockwrite       - Write binblock to instrument.
%   fprintf             - Write text to instrument.
%   fgetl               - Read one line of text from instrument, discard 
%                         terminator.
%   fgets               - Read one line of text from instrument, keep terminator.
%   flushinput          - Remove data from input buffer.
%   flushoutput         - Remove data from output buffer.
%   fread               - Read binary data from instrument.
%   fscanf              - Read data from instrument and format as text.
%   fwrite              - Write binary data to instrument.
%   query               - Write and read formatted data from instrument.
%   readasync           - Read data asynchronously from instrument.
%   scanstr             - Parse formatted data from instrument.
%   stopasync           - Stop asynchronous read and write operation.
%
% ICDEVICE functions.
%   devicereset         - Reset the instrument.
%   geterror            - Check and return error message from instrument.
%   selftest            - Run the instrument self-test.
%   invoke              - Execute function on device object.
%
% GPIB functions.
%   clrdevice           - Clear instrument buffer.
%   spoll               - Perform serial poll.
%   trigger             - Send trigger message to instrument.
%
% TCPIP functions.
%   echotcpip           - Create a TCP/IP echo server.
%   resolvehost         - Return IP address or name of network address.
%
% UDP functions.
%   echoudp             - Create a UDP echo server.
%   resolvehost         - Return IP address or name of network address.
%
% VISA-GPIB functions.
%   clrdevice           - Clear instrument buffer.
%   trigger             - Send Group Execute Trigger message to instrument.
%
% VISA-GPIB-VXI functions.
%   clrdevice           - Clear instrument buffer.
%   memmap              - Map memory for low-level memory read and write.
%   mempeek             - Low-level memory read from VXI register.
%   mempoke             - Low-level memory write to VXI register.
%   memread             - High-level memory read from VXI register.
%   memunmap            - Unmap memory for low-level memory read and write.
%   memwrite            - High-level memory write to VXI register.
%
% VISA-VXI functions.
%   clrdevice           - Clear instrument buffer.
%   memmap              - Map memory for low-level memory read and write.
%   mempeek             - Low-level memory read from VXI register.
%   mempoke             - Low-level memory write to VXI register.
%   memread             - High-level memory read from VXI register.
%   memunmap            - Unmap memory for low-level memory read and write.
%   memwrite            - High-level memory write to VXI register.
%   trigger             - Send a software or hardware trigger to VXI hardware.
%
% VISA-USB functions.
%   clrdevice           - Clear instrument buffer.
%   trigger             - Send Group Execute Trigger message to instrument.
%
% VISA-RSIB functions.
%   clrdevice           - Clear instrument buffer.
%   trigger             - Send Group Execute Trigger message to instrument.
%
% IVI Configuration store functions.
%   add                 - Add a new entry.
%   commit              - Save changes to disk.
%   remove              - Remove and entry.
%   update              - Update an entry.
%
% General.
%   delete              - Remove instrument object from memory.
%   inspect             - Open inspector and inspect instrument object properties.
%   instrid             - Define and retrieve commands used to identify instruments.
%   isvalid             - True for instrument objects that can be connected to 
%                         instrument.
%   obj2mfile           - Convert instrument object to MATLAB code.
%
% Information and Help.
%   propinfo            - Return instrument object property information.
%   instrhelp           - Display instrument object function and property help.
%   instrhwinfo         - Return information on available hardware.
%
% Instrument Control tools.
%   tmtool              - Tool for browsing available instruments, configuring 
%                         instrument communication and communicating with
%                         instrument.
%
% See also GPIB, ICDEVICE, SERIAL, TCPIP, UDP, VISA, BLUETOOTH, I2C, SPI, INSTRUMENT/PROPINFO.

% Interface object construction.
%   instrument/Bluetooth   - Construct Bluetooth object.
%   instrument/tcpip       - Construct TCPIP object.
%   instrument/udp         - Construct UDP object.
%   instrument/gpib        - Construct GPIB object.
%   instrument/visa        - Construct VISA object.
%   matlab/serial/serial   - Construct serial port object.
%   instrument/i2c         - Construct I2C object.
%
% General.
%   instrcallback       - Display event information for the event.
%   instrfind           - Find instrument objects with specified property values.
%   instrfindall        - Find all instrument objects regardless of ObjectVisibility.
%   instrnotify         - Define notification for instrument events.
%   instrreset          - Disconnect and delete all instrument objects.
%
% Serial port functions.
%   serialbreak         - Send break to device.
%
% Instrument Control tools.
%   makemid             - Make MATLAB instrument drivers for VXIplug&play 
%                         and IVI drivers. 
%   midedit             - Edit MATLAB instrument driver file.
%   midtest             - Launch GUI for testing MATLAB instrument driver.

%    Copyright 1999-2022 The MathWorks, Inc.
