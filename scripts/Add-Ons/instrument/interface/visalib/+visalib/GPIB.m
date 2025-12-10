classdef GPIB < visalib.Resource & visalib.EOIModeSupport
    %GPIB Class representing a VISA GPIB instrument resource
    
    % Copyright 2020-2022 The MathWorks, Inc.
    
    properties (SetAccess = private)
        % GPIB board index
        BoardIndex (1, 1) double {mustBeInteger} = 0
        
        % GPIB primary address
        PrimaryAddress (1, 1) double {mustBeInteger} = 0
        
        % GPIB secondary address
        SecondaryAddress (1, 1) double {mustBeInteger} = 0
    end
    
    methods (Hidden)
        function obj = GPIB(resourceInfo, synchronousRead)
            visalib.Resource.checkResourceType(resourceInfo.Type, visalib.InterfaceType.gpib);
            obj@visalib.Resource(resourceInfo, synchronousRead);
        end
    end
    
    %% VISA methods
    methods
        function visatrigger(obj)
            %VISATRIGGER Send trigger message to GPIB instruments on the
            %same GPIB bus.
            %
            %   VISATRIGGER(OBJ) sends trigger message.
            %
            % Example:
            %      % Send trigger message to all GPIB instruments on the
            %      % same bus as gpibVisaDevice.
            %      visatrigger(gpibVisaDevice);
            
            arguments
                obj (1, 1) visalib.GPIB
            end            
          
            try
                assertTrigger(obj.Client, obj.ResourceName);
            catch ex
                throwAsCaller(ex);
            end
        end        
    end 
    
    %% Overrides
    
    %%% Resource
    methods (Access = protected)
        function initResourceHook(obj)
            % Initialize properties prior to asking the client to connect.
            attrBoardIndex = visalib.internal.VISAAttribute.INTF_NUM;
            attrPrimaryAddress = visalib.internal.VISAAttribute.GPIB_PRIMARY_ADDR;
            attrSecondaryAddress = visalib.internal.VISAAttribute.GPIB_SECONDARY_ADDR;
            
            obj.BoardIndex = obj.getAttributeByType(attrBoardIndex);
            obj.PrimaryAddress = obj.getAttributeByType(attrPrimaryAddress);
            obj.SecondaryAddress = obj.getAttributeByType(attrSecondaryAddress);
        end 

        function postConnectHook(obj)
            obj.EOIMode = matlab.lang.OnOffSwitchState.on;
            obj.configureTerminator("off", "LF");
        end

        function adjustGroupListHook(obj)
            obj.InterfaceSpecificProperties = ["BoardIndex", "PrimaryAddress", "SecondaryAddress"];
            obj.SharedProperties(end+1) = "EOIMode";
        end
    end

    %%% EOIMode
    methods (Access = protected)
        function valueOut = setAndReturnAttribute(obj, attribute, valueIn)
            valueOut = obj.setAndVerifyAttributeValue(attribute, valueIn);
        end        
    end
end


