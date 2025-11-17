classdef(Abstract) IDIOImplementor < handle
    % IDIOIMPLEMENTOR is an interface that provides digital IO methods that
    % should be implemented by a controller that wants to support DIO
    % functionalities.

    % Copyright 2022 The MathWorks, Inc.

    methods (Abstract)
        % Should set the mode of digital pins of a controller.
        varargout = configureDigitalPin(obj,channel,varargin)

        % Should write out digital data using digital pins of a controller.
        writeDigitalPin(obj,channel,pin,data)

        % Should read in digital data using digital pins of a controller.
        data = readDigitalPin(obj,channel,pin)
    end
end

