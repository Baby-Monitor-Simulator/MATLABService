classdef VXI < visalib.Resource & visalib.EOIModeSupport
    %VXI Class representing a VISA VXI instrument resource
    
    % Copyright 2020-2022 The MathWorks, Inc.
    
    properties (SetAccess = private)
        % The index number of the VXI chassis
        ChassisIndex (1, 1) double {mustBeNonnegative, mustBeFinite} = 0
        
        % The logical address of the VXI instrument
        LogicalAddress (1, 1) double {mustBeNonnegative, mustBeFinite} = 7
        
        % The slot location of the VXI instrument
        Slot (1, 1) double {mustBeNonnegative, mustBeFinite} = 0      
    end
   
    methods (Hidden)
        function obj = VXI(resourceInfo, synchronousRead)
            visalib.Resource.checkResourceType(resourceInfo.Type, visalib.InterfaceType.vxi);
            obj@visalib.Resource(resourceInfo, synchronousRead);
        end
    end
    
    %% VISA methods
    methods
        function visatrigger(obj)
            %VISATRIGGER Send trigger message to VXI instruments on the
            %same VXI chassis.
            %
            %   VISATRIGGER(OBJ) sends trigger message.
            %
            % Example:
            %      % Send trigger message to all VXI instruments in the
            %      % same chassis as vxiVisaDevice
            %      visatrigger(vxiVisaDevice);            
            
            arguments
                obj (1, 1) visalib.VXI
            end            
          
            try
                assertTrigger(obj.Client, obj.ResourceName);
            catch ex
                throwAsCaller(ex);
            end
        end        
    end  
    
    %% Overridden methods
    methods (Access = protected)
        function initResourceHook(obj)
            % Initialize properties prior to asking the client to connect.
            attrChassisIndex = visalib.internal.VISAAttribute.PXI_CHASSIS;
            attrLogicalAddress = visalib.internal.VISAAttribute.VXI_LA;
            
            obj.ChassisIndex = obj.getAttributeByType(attrChassisIndex);
            obj.LogicalAddress = obj.getAttributeByType(attrLogicalAddress);
        end

        function postConnectHook(obj)
            attrSlot = visalib.internal.VISAAttribute.SLOT;
            obj.Slot = obj.getAttributeByType(attrSlot);
            
            obj.EOIMode = matlab.lang.OnOffSwitchState.on;
            obj.configureTerminator("off", "LF");
        end
        
        function adjustGroupListHook(obj) 
            obj.SupplementalInterfaceProperties = ...
                ["ChassisIndex", "LogicalAddress", "Slot"];
            
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


