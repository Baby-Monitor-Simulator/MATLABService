classdef ResourceInfo
    %RESOURCEINFO Represents the basic information returned about a resource
    
    properties (SetAccess = immutable)
        Name (1, 1) string
        Alias (1, 1) string
        Vendor (1, 1) string
        Model (1, 1) string
        SerialNumber (1, 1) string
        Type (1, 1) visalib.InterfaceType
    end
    
    methods
        function obj = ResourceInfo(info)
            if ~isempty(info)
                obj.Name = info.ResourceName;
                obj.Alias = info.Alias;
                obj.Vendor = info.Vendor;
                obj.Model = info.Model;
                obj.SerialNumber = info.SerialNumber;
                obj.Type = info.Type;
            else
                obj.Type = visalib.InterfaceType.unset;
            end
        end        
    end
    
    methods
        function info = toStruct(obj)
            info.ResourceName = obj.Name;
            info.Alias = obj.Alias;
            info.Vendor = obj.Vendor;
            info.Model = obj.Model;
            info.SerialNumber = obj.SerialNumber;
            info.Type = obj.Type;
        end
    end
end

