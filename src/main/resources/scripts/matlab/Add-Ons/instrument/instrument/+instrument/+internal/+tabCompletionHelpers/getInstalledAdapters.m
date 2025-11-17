function Installedadapters = getInstalledAdapters(interfaceType)
% INSTALLEDADAPTERS(INTERFACETYPE) take interface type as the input and
% return a cell array of installed adapters as the output. The valid
% interface type can be 'visa', 'spi', 'i2c' or 'gpib'.

% Copyright 2016-2021 The MathWorks, Inc.

% Suppress warn phase warnings
originalWarningState = warning;
cleanup = onCleanup(@()warning(originalWarningState));
warning('off',"instrument:instrhwinfo:FunctionToBeRemoved");

switch lower(interfaceType)
    case 'spi'
        fnHandle = @(x) x.InstalledVendors;
    case {'gpib', 'visa'}
        fnHandle = @(x) updateVendorList(x.InstalledAdaptors, 'agilent');
    otherwise
        fnHandle = @(x) x.InstalledAdaptors;
        
end
Installedadapters = fnHandle(instrhwinfo(interfaceType));

    % Updates the vendor list to remove unwanted/repeated vendors.
    function vendorList = updateVendorList(vendorList, toRemove)
        index = strcmpi(vendorList, toRemove);
        vendorList(index) = [];
    end
end



