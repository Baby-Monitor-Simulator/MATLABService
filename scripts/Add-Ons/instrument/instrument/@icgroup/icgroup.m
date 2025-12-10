classdef icgroup
    %ICGROUP Construct device group object.
    %
    %   ICGROUP construct a device group object.
    %
    %   If the device object supports a group, then an array of device group
    %   objects are created when the device object is created. The group objects
    %   can be accessed through a property of the device object. The property
    %   will have the same name as the group.
    %
    %   This constructor should not be called directly by users.
    %
    % ICGROUP Functions
    % ICGROUP object construction.
    %   icgroup      - Construct icgroup (device group) object.
    %
    % Getting and setting parameters.
    %   get          - Get value of device group object property.
    %   set          - Set value of device group object property.
    %
    % General.
    %   inspect      - Open inspector and inspect group object properties.
    %   invoke       - Execute function on device group object.
    %   isvalid      - True for device group objects that can be connected to
    %                  instrument.
    %
    % Information and Help.
    %   propinfo     - Return device group object property information.
    %
    % ICGROUP Properties
    %   HwIndex      - Indicates the hardware index of a device group object.
    %   HwName       - Indicates the hardware name of a group object.
    %   Name         - Descriptive name of the device group object.
    %   Parent       - Indicates the parent (device object) of a device
    %                  group object.
    %   Type         - Object type.
    %
    %   See also ICDEVICE.

    % General.
    %   instrfind    - Find device igroup objects with specified property values.
    %   instrfindall - Find all device group objects regardless of ObjectVisibility.
    %   instrnotify  - Define notification for device group object events.
    %
    % Information and Help.
    %   instrhelp    - Display device group object function and property help.
    %
    
    
    %   Copyright 1999-2021 The MathWorks, Inc.
    
    properties (Hidden, SetAccess = 'public', GetAccess = 'public')
        % Reference to the Java class
        jobject;
        type;
        store = {};
    end
    
    
    methods
        function obj = icgroup(jobj)
            
            if (nargin ~= 1)
                error(message('instrument:icgroup:icgroup:invalidArg'));
            end
            
            if (isa(jobj, 'com.mathworks.toolbox.instrument.device.DeviceChild[]') || ...
                    isa(jobj, 'com.mathworks.toolbox.instrument.device.DeviceChild'))
                
                % Assign the first java object to the jobject array.
                obj.jobject = handle(jobj(1));
                
                % Assign the type.
                obj.type    = {'icgroup'};
                
                % Location to store information when saving the object.
                obj.store   = [];
                
                % Assign the remaining java objects to the jobject array.
                for i = 2:length(jobj)
                    obj.jobject = [obj.jobject handle(jobj(i))];
                    obj.type    = {obj.type{:} 'icgroup'};
                end
                
                % If only one object, the type field should not be a cell array.
                if length(jobj) == 1
                    obj.type = obj.type{:};
                end
                
            elseif isa(jobj, 'javahandle.com.mathworks.toolbox.instrument.device.icdevice.ICDeviceChild')
                obj.jobject = jobj;
                obj.type    = {'icgroup'};
                obj.store   = [];
            elseif (findstr('ICGroup', class(jobj)))
                obj.jobject = jobj;
                obj.type    = {'icgroup'};
                obj.store   = [];
            else
                error(message('instrument:icgroup:icgroup:invalidArg'));
            end
        end
    end
    
    % Separate Files
    methods(Static = true, Hidden = true)
        obj = loadobj(B)
    end
    
end
