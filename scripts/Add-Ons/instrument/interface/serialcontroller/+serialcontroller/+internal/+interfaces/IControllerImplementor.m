classdef(Abstract) IControllerImplementor < handle
    % ICONTROLLERIMPLEMENTOR is an interface that provides general
    % controller methods that should be implemented by a controller.

    % Copyright 2022 The MathWorks, Inc.

    methods (Abstract)
        % Should create a peripheral device of type "I2C" using the
        % controller object as input.
        obj = device(obj,controllerObj,varargin)

        % Should set properties for a controller.
        setProperty(obj,channel,propName,value)
    end
end

