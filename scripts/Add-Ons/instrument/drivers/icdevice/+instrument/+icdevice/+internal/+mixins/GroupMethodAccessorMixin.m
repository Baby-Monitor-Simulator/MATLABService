classdef (Abstract) GroupMethodAccessorMixin < instrument.icdevice.internal.mixins.base.MethodAccessorMixin
    %GROUPMETHODACCESSORMIXIN allows case insensitive matching for Group
    %method names passed into the invoke() function.

    %   Copyright 2022-2024 The MathWorks, Inc.

    methods (Hidden)
        function m = getAssociatedMethodName(obj, methodName)
            arguments
                obj (1, 1) instrument.icdevice.internal.Group
                methodName (1, 1) string
            end

            idx = strcmpi(methodName, obj.MDDMethodNames); %#ok<*MCNPN>
            if any(idx)
                m = obj.MDDMethodNames(idx);
            else
                throw(obj.getMException(MException(message("instrument_icdevice:driver:nonexistentMethod", methodName))));
            end
        end
    end
end
