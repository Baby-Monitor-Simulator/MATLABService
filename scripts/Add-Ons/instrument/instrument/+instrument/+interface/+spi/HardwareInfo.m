classdef(Hidden) HardwareInfo < instrument.interface.HardwareInfo
    % HARDWAREINFO Retrieve information on available SPI devices.
    %
    %   This class is the top level storage class for Instrument Control
    %   Toolbox and available SPI device information. It contains child classes
    %   storing information about vendor specific interface devices.
    
    % Copyright 2013 The MathWorks, Inc.
    
    properties (Hidden, Constant)
        % SupportedVendors - All the supported vendors
        SupportedVendors = {'aardvark', 'ni845x'}
    end
    
    properties (Hidden)
        % InstalledVendors - All the installed vendors
        InstalledVendors
    end
    
    methods        
        function obj = HardwareInfo()
            % HARDWAREINFO Construct an object containing SPI device
            % information.
            
            % Initialize VendorInfo as empty
            obj.Vendors = instrument.interface.VendorInfo.empty();
            
            % Loop through each supported vendor
            for num = 1 : numel(obj.SupportedVendors)                
                % Check to see if the vendor is installed
                if(feval(sprintf('instrument.interface.spi.%s.VendorInfo.isVendorInstalled', obj.SupportedVendors{num})))
                    
                    % Add the vendor name to the InstalledVendors
                    obj.InstalledVendors{end + 1} = obj.SupportedVendors{num};
                    
                    % Create and save the corresponding VendorInfo object
                    obj.Vendors(end + 1) = feval(sprintf('instrument.interface.spi.%s.VendorInfo', obj.SupportedVendors{num}));
                end
            end
        end
        
        function disp(obj)
            % DISP Tabular display of the supported and installed vendors
            
            % Print supported vendors
            fprintf(message("instrument:spi:supportedVendorsDisp", obj.cell2str(obj.SupportedVendors)).getString);
            
            % Print installed vendors
            fprintf(message("instrument:spi:installedVendorsDisp", obj.cell2str(obj.InstalledVendors)).getString);            
                        
            % g938363 - Avoid displaying empty table
            deviceDetected = false;
            
            % Check the number of vendors found.
            if ~isempty(obj.Vendors)
                
                % Make a display table for device information.
                SpiInfoTable = internal.DispTable();
                SpiInfoTable.Indent = 2;
                SpiInfoTable.ColumnSeparator = ' | ';
                SpiInfoTable.addColumn('Vendor');
                SpiInfoTable.addColumn('Board Ids');
                SpiInfoTable.addColumn('Serial Number');
                SpiInfoTable.addColumn('Constructor');
                
                % Loop through each vendor.
                for vendorIndex = 1:numel(obj.Vendors)
                    % Loop through the board for each vendor.
                    for boardIndex = 1:numel(obj.Vendors(vendorIndex).Boards)
                        deviceDetected = true;
                        SpiInfoTable.addRow( ...
                            obj.Vendors(vendorIndex).VendorName, ...
                            obj.Vendors(vendorIndex).Boards(boardIndex).BoardIndex, ...
                            obj.Vendors(vendorIndex).Boards(boardIndex).BoardSerialNumber, ...
                            obj.Vendors(vendorIndex).Boards(boardIndex).ObjectConstructor);
                    end
                end
            end
            
            if (deviceDetected)
                % Display a header.
                fprintf(message("instrument:spi:devicesDetected").getString);
                
                % Show the table on the screen.
                disp(SpiInfoTable);
            else
                % Display a not found message for no vendors.
                fprintf(message("instrument:spi:noDevicesDetected").getString);
            end
            
            if matlab.internal.display.isHot
                fprintf(message("instrument:spi:devicesDetectedFooter").getString);
            end
            
        end
        
        function str = cell2str(~, cellStr)
            
            if (~isempty(cellStr))
                % Add ', ' after each string.
                cellStr= cellfun(@(x){[x ', ']},cellStr);
                
                % Convert to string
                str = cat(2,cellStr{:});
                
                % Remove last ','
                str(end-1: end) = [];
            else
                str = '';
            end
        end 
    end
end



