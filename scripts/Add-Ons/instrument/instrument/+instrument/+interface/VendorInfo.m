classdef VendorInfo < matlab.mixin.Heterogeneous 
% VENDORINFO Retrieve vendor specific SPI device information.
%
%   The VendorInfo class contains information on interface devices on a per
%   vendor basis. This class contains child classes for storing information
%   about vendor board physically connected.
%

% Copyright 2013 The MathWorks, Inc.


    properties (GetAccess = 'public', SetAccess = 'private') 
        % VendorName - The name of the device vendor.
        VendorName
        % VendorDescription - The description of the device vendor.
        VendorDescription
        % VendorDLLName - The name of the interface API or
        %   library used to connect with the vendor's devices.
        VendorLibraryName
        % Boards - Stores information on available boards. Collection of
        % BOARDINFO objects.
        Boards
    end
    
    methods
        
        function obj = VendorInfo(name, vendorDesc, vendorLibraryName, boards)
        % VENDORINFO Construct an object containing vendor information.
        %
        %   OBJ = VendorInfo(NAME, VENDORDESC, VENDORLIBRARYNAME, BOARDS)
        %   creates a VendorInfo object.
        %
        %   Inputs:
        %       NAME - Name of the vendor.
        %       VENDORDESC - Description of the vendor.
        %       VENDORLIBRARYNAME - Name of the vendor's driver.
        %       BOARDS - Vector of BOARDINFO objects.
        
            % Set the properties.
            obj.VendorName = name;
            obj.VendorDescription = vendorDesc;
            obj.VendorLibraryName = vendorLibraryName;
            obj.Boards = boards;
        end        
    end
    
    methods (Static, Sealed, Access = 'protected')

        function defaultObject = getDefaultScalarElement()
        % GETDEFAULTSCALARELEMENT Return a base object of the class type.
        %
        %   This method is used for heterogeneous arrays. Is creates a
        %   blank version of the class to be used for array manipulation.
        
            defaultObject = instrument.interface.VendorInfo();
        end        
    end    
end
