function info = spiinfo()
%SPIINFO returns information on available SPI devices
%
%   INFO = SPIINFO() returns information about devices and displays
%   the information on a per vendor basis. 
%
%   Example:
%       info = spiinfo()
% 
%   See also SPI.

%   Copyright 2013 The MathWorks, Inc.

info = instrument.interface.spi.HardwareInfo();
end

