classdef (Hidden) VendorInfo < instrument.interface.VendorInfo
    % VENDORINFO Retrieve Vector specific CAN device information.
    %
    %   This class contains information on Vector CAN devices. It also
    %   contains child classes for each identified CAN device channel.
   
    % Copyright 2013 The MathWorks, Inc.
    
    methods
        function obj = VendorInfo()
            % VENDORINFO Construct an object containing information on Vector devices.
            
            % Set the name of the vendor.
            vendorName = 'aardvark';
            
            % Set the driver interface description.
            vendorDriverDescription = 'Total Phase I2C/SPI Driver';
            
            if ispc                
                defaultVendorLibraryName = 'aardvark.dll';
            else
                defaultVendorLibraryName = 'aardvark.so';
            end
            
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
            [numDevices, ports, serials] = instrument.interface.spi.aardvark.Utility.findDevices();
            
            % Loop through each connected device
            for i = 1 : numDevices
                
                % Check if the device is being used
                if (ports(i) < instrument.interface.spi.aardvark.Utility.BoardNotFree)
                    boards(end+1) = instrument.interface.BoardInfo(...
                        ports(i),...
                        num2str(serials(i)),...
                        sprintf('spi(''aardvark'', %d, 0)',ports(i))); %#ok<*AGROW>
                else
                    boards(end+1) = instrument.interface.BoardInfo(...
                        ports(i) - instrument.interface.spi.aardvark.Utility.BoardNotFree,...
                        num2str(serials(i)),...
                        'in-use');
                end                
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
            numDevicesFound = instrument.interface.spi.aardvark.Utility.findDevices();
            if (numDevicesFound < 0)
                installed = false;
            else
                installed = true;
            end
        end
    end
end
