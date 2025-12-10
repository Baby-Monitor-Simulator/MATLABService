classdef CommonControllerImplementor < serialcontroller.internal.interfaces.IControllerImplementor
    % COMMONCONTROLLERIMPLEMENTOR contains a factory method device that can
    % create an I2CDevice object. It contains methods to configure common
    % controller properties. It uses the asyncIO channel to complete
    % controller operations.

    % Copyright 2022 The MathWorks, Inc.

    properties
        % Common controller properties
        EnablePullupResistors (1,1) logical = true
    end

    properties (Constant,Access = private)
        % Required NV pair options
        DeviceParameterOptions = "I2CAddress"
    end

    %% Hook methods
    methods (Access = protected)
        function setPropertyHook(~,~,~,~)
            % implemented by derived classes
        end
    end

    %% Setter helper function
    methods
        function setProperty(obj,channel,propName,value)
            switch propName
                case "EnablePullupResistors"
                    setEnablePullupResistors(obj,channel,value);
                otherwise
                    setPropertyHook(obj,channel,propName,value);
            end
        end
    end

    %% Setters
    methods (Access = private)
        function setEnablePullupResistors(obj,channel,value)
            try
                validateattributes(value,["logical","double"],["nonempty","scalar","finite","integer","nonnegative"],"","EnablePullupResistors");
                try
                    mustBeMember(value,[true,false,1,0]);
                catch
                    throw(MException(message("instrument:interface:serialcontroller:InvalidValueEnablePullupResistors")));
                end

                options.PullupVal = double(value);
                channel.execute("SetPullupResistors",options);
                obj.EnablePullupResistors = value;
            catch ex
                throw(MException("instrument:interface:serialcontroller:InvalidValueEnablePullupResistors",ex.message));
            end
        end
    end

    %% API
    methods
        function dev = device(obj,controllerObj,varargin)
            % Creates peripheral device objects.
            % Only I2C device object creation is supported now.
            try
                str = convertCharsToStrings(varargin{1});
                if ~isStringScalar(str) || iscell(varargin{1})
                    throw(MException(message("instrument:interface:serialcontroller:RequiredNVPairOptions")));
                end

                isMatching = matches(obj.DeviceParameterOptions,str,IgnoreCase=true);
                if ~any(isMatching)
                    throw(MException(message("instrument:interface:serialcontroller:RequiredNVPairOptions")));
                end

                dev = [];
                switch obj.DeviceParameterOptions(isMatching)
                    case "I2CAddress"
                        dev = serialcontroller.internal.i2c.I2CDevice(controllerObj,varargin{:});
                end
            catch ex
                throwAsCaller(ex);
            end
        end
    end
end
