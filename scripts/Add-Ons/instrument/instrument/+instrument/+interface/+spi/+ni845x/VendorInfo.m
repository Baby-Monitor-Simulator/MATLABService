classdef (Hidden) VendorInfo < instrument.interface.VendorInfo
    % VENDORINFO Retrieve NI-845x device information.
    %
    %   This class contains information on NI-845x devices. It also
    %   contains child classes for each identified SPI device.
   
    % Copyright 2013 The MathWorks, Inc.
    
    methods
        function obj = VendorInfo()
            % VENDORINFO Construct an object containing information on Vector devices.
            
            % Set the name of the vendor.
            vendorName = 'ni845x';
            
            % Set the driver interface description.
            vendorDriverDescription = 'National Instruments';
            
            defaultVendorLibraryName = 'Ni845x.dll';
            
            % Get the full pathname of the vendor DLL
            vendorLibraryName = which(defaultVendorLibraryName);
            
            % If the full pathname is empty then default to just the vendor
            % DLL name
            if (isempty(vendorLibraryName))
                vendorLibraryName = defaultVendorLibraryName;
            end
            
            % Initialize BoardInfo as empty
            boards = instrument.interface.BoardInfo.empty();            
            
            % Find all the vendor devices connected
            [numDevices, ports, serials] = instrument.interface.spi.ni845x.Utility.findDevices();
            
            % Loop through each connected device
            for i = 1 : numDevices
                boards(end+1) = instrument.interface.BoardInfo(...
                    ports(i),...
                    serials{i},...
                    sprintf('spi(''ni845x'', %d, 0)',ports(i))); %#ok<*AGROW>            
            end            
            
            % Call the superclass constructor.
            obj@instrument.interface.VendorInfo(...
                vendorName,...
                vendorDriverDescription,...
                vendorLibraryName,...
                boards);
        end        
    end
    
    methods(Static)
        function installed = isVendorInstalled()
            % isVendorInstalled Verifies that the current vendor libraries
            % are installed and can be used to identify the connected
            % devices.
            
            % Call the findDevices on the vendor library, if the value
            % returned is < 0 then the library is not found. IF the
            % value returned is >= 0 then the library is found.
            numDevicesFound = instrument.interface.spi.ni845x.Utility.findDevices();
            if (numDevicesFound < 0)
                installed = false;
            else
                installed = true;
            end
        end
    end
end
