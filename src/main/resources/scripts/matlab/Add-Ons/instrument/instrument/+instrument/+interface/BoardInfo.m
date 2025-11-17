classdef BoardInfo < handle
% BOARDINFO Retrieve device information.
%
%   The BOARDINFO class contains information pertaining to a specific
%   device. This information includes data needed to 
%   access and use the device.
%

% Copyright 2013 The MathWorks, Inc.


    properties (GetAccess = 'public', SetAccess = 'private') 
        % BoardIndex - The index of the device.
        BoardIndex
        % BoardSerialNumber - The unique identifier of the device provided
        % by the vendor.
        BoardSerialNumber
        % ObjectConstructor - The MATLAB constructor command required to
        % create the interface object for the device.
        ObjectConstructor
    end

    
    methods
        
        function obj = BoardInfo(boardIndex, boardSerNum, objectConst)
        % BOARDINFO Construct an object containing device information.
        %
        %   OBJ = BOARDINFO(BOARDID, BOARDSERNUM, OBJECTCONST)
        %   creates a BOARDINFO object.
        %
        %   Inputs:
        %       BOARDID - Index of the device.
        %       BOARDSERNUM - Serial number of the device.
        %       OBJECTCONST - Constructor call for the device.
        %
        
            % Set the properties.
            obj.BoardIndex = boardIndex;
            obj.BoardSerialNumber = boardSerNum;
            obj.ObjectConstructor = objectConst;
        end        
    end    
end
