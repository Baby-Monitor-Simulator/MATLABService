classdef(Abstract) ControllerDIOMixin < handle
    % CONTROLLERDIOMIXIN class exposes the DIO methods such as
    % configureDigitalPin, writeDigitalPin, readDigitalPin methods for the
    % customer facing controller class.

    % Copyright 2022 The MathWorks, Inc.

    methods
        % Sets the mode of digital pins of a controller.
        function varargout = configureDigitalPin(obj,varargin) %#ok<STOUT> 
            try
                try
                    narginchk(3,3);
                    nargoutchk(0,0);
                catch
                    throw(MException(message("instrument:interface:serialcontroller:InvalidSyntaxConfigureDigitalPin")));
                end
                configureDigitalPin(obj.ChannelHandler,varargin{:}); %#ok<MCNPN>
            catch ex
                throwAsCaller(ex);
            end
        end

        % Writes out digital data using digital pins of a controller.
        function writeDigitalPin(obj,pin,data,varargin)
            try
                try
                    narginchk(3,3);
                catch
                    throw(MException(message("instrument:interface:serialcontroller:InvalidSyntaxWriteDigitalPin")));
                end
                writeDigitalPin(obj.ChannelHandler,pin,data); %#ok<MCNPN>
            catch ex
                throwAsCaller(ex);
            end
        end

        % Reads in digital data using digital pins of a controller.
        function data = readDigitalPin(obj,pin,varargin)
            try
                try
                    narginchk(2,2);
                catch
                    throw(MException(message("instrument:interface:serialcontroller:InvalidSyntaxReadDigitalPin")));
                end
                data = readDigitalPin(obj.ChannelHandler,pin); %#ok<MCNPN>
            catch ex
                throwAsCaller(ex);
            end
        end
    end
end

