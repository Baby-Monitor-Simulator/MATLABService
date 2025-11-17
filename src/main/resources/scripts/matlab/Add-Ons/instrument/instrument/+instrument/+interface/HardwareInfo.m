classdef(Hidden) HardwareInfo < handle
    % HARDWAREINFO Retrieve information on available interface devices.
    %
    %   This class is the top level storage class for Instrument Control
    %   Toolbox and available device information. It contains child classes
    %   storing information about vendor specific interface devices.
    
    % Copyright 2013 The MathWorks, Inc.
        
    properties (Hidden, Abstract, Constant)
        % SupportedVendors - All the supported vendors
        SupportedVendors
    end
    
    properties (Hidden, Abstract)
        % InstalledVendors - All the installed vendors
        InstalledVendors
    end
    
    properties (SetAccess = 'protected')
        % Vendors - Stores information on supported device vendors.
        % Collection of VENDORINFO objects
        Vendors
    end
    
    methods
        
        function out = instrhwinfoDisplay(obj)
            % INSTRHWINFODISPLAY displays all the supported and installed
            % vendors as required by instrhwinfo
            
            out.SupportedVendors = obj.SupportedVendors;
            out.InstalledVendors = obj.InstalledVendors;
        end
        
        function out = instrhwinfoDisplayByVendor(obj, vendorName)
            % INSTRHWINFODISPLAYBYVENDOR displays the information regarding
            % a specific vendor as required by instrhwinfo
            
            out = {};
            
            % Loop through each vendor.
            for vendorIndex = 1: numel(obj.Vendors)
                if(strcmpi(obj.Vendors(vendorIndex).VendorName, vendorName))
                    out.VendorName = obj.Vendors(vendorIndex).VendorName;
                    out.VendorDescription = obj.Vendors(vendorIndex).VendorDescription;
                    out.VendorLibraryName= obj.Vendors(vendorIndex).VendorLibraryName;
                    out.InstalledBoardIds = cell(1, numel(obj.Vendors(vendorIndex).Boards));
                    out.BoardSerialNumbers = cell(1, numel(obj.Vendors(vendorIndex).Boards));
                    out.ObjectConstructors = cell(1, numel(obj.Vendors(vendorIndex).Boards));
                    
                    % Loop through each board found.
                    for boardIndex = 1: numel(obj.Vendors(vendorIndex).Boards)
                        out.InstalledBoardIds{boardIndex} = obj.Vendors(vendorIndex).Boards(boardIndex).BoardIndex;
                        out.BoardSerialNumbers{boardIndex} = obj.Vendors(vendorIndex).Boards(boardIndex).BoardSerialNumber;
                        out.ObjectConstructors{boardIndex} = obj.Vendors(vendorIndex).Boards(boardIndex).ObjectConstructor;
                    end
                end
            end
        end
    end
end

