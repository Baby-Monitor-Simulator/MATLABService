classdef PXI < visalib.Resource & visalib.EOIModeSupport
    %PXI Class representing a VISA PXI instrument resource
    
    % Copyright 2020-2021 The MathWorks, Inc.
    
    properties (SetAccess = private)
        % PCI bus number for the device
        Bus (1, 1) double {mustBeNonnegative, mustBeFinite} = 0
        
        % PXI device number for the device
        DeviceIndex (1, 1) double {mustBeNonnegative, mustBeFinite} = 1
        
        % PXI function number for the device; all normal devices have
        % function 0 (multifunction devices may support other function
        % numbers).
        FunctionIndex (1, 1) double {mustBeNonnegative, mustBeFinite} = 2
        
        % The index number of the PXI chassis
        ChassisIndex (1, 1) double {mustBeNonnegative, mustBeFinite} = 0        
        
        % The slot location of the PXI instrument
        Slot (1, 1) double {mustBeNonnegative, mustBeFinite} = 0
    end
   
    methods (Hidden)
        function obj = PXI(resourceInfo, synchronousRead)
            visalib.Resource.checkResourceType(resourceInfo.Type, visalib.InterfaceType.pxi);
            obj@visalib.Resource(resourceInfo, synchronousRead);
        end
    end
    
    %% Overridden methods
    methods (Access = protected)
        function postConnectHook(obj)
            attrSlot = visalib.internal.VISAAttribute.SLOT;
            obj.Slot = obj.getAttributeByType(attrSlot);
            
            obj.EOIMode = matlab.lang.OnOffSwitchState.on;
        end
        
        function adjustGroupListHook(obj) 
            obj.SupplementalInterfaceProperties = ...
                ["Bus", "DeviceIndex", "FunctionIndex", "Slot"];
            
            obj.SharedProperties(end+1) = "EOIMode";
        end
        
        function initResourceHook(obj)
            % Initialize properties prior to asking the client to connect.            
            attrBus = visalib.internal.VISAAttribute.PXI_BUS_NUM;
            attrDeviceIndex = visalib.internal.VISAAttribute.PXI_DEV_NUM;
            attrFunctionIndex = visalib.internal.VISAAttribute.PXI_FUNC_NUM;
            attrChassisIndex = visalib.internal.VISAAttribute.PXI_CHASSIS;
            
            obj.Bus = obj.getAttributeByType(attrBus);
            obj.DeviceIndex = obj.getAttributeByType(attrDeviceIndex);
            obj.FunctionIndex = obj.getAttributeByType(attrFunctionIndex);
            obj.ChassisIndex = obj.getAttributeByType(attrChassisIndex);
        end
    end
    
    %%% EOIMode
    methods (Access = protected)
        function valueOut = setAndReturnAttribute(obj, attribute, valueIn)
            valueOut = obj.setAndVerifyAttributeValue(attribute, valueIn);
        end        
    end    
end