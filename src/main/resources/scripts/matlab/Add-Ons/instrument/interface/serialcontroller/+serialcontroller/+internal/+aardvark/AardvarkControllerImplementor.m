classdef AardvarkControllerImplementor < serialcontroller.internal.common.CommonControllerImplementor
    % AARDVARKCONTROLLERIMPLEMENTOR overrides hook methods to configure
    % Aardvark specific controller properties. It uses the asyncIO channel to
    % complete controller operations.

    % Copyright 2022 The MathWorks, Inc.

    properties
        % Aardvark controller properties
        VoltageLevel (1,1) double = 3.3
        EnableTargetPower (1,1) logical = true
    end

    %% Setter/Getter Helpers
    methods (Access = protected)
        function setPropertyHook(obj,channel,propName,value)
            % This function is called when an Aardvark specific property
            % has to be set.
            try
                switch propName
                    case "VoltageLevel"
                        setVoltageLevel(obj);
                    case "EnableTargetPower"
                        setEnableTargetPower(obj,channel,value);
                end
            catch ex
                throwAsCaller(ex);
            end
        end
    end

    methods
        function value = getProperty(obj,channel,propName)
            % This function is called when an Aardvark specific property
            % has to be retrieved.
            switch propName
                case "EnablePullupResistors"
                    value = getEnablePullupResistors(obj,channel);
                case "EnableTargetPower"
                    value = getEnableTargetPower(obj,channel);
                case "VoltageLevel"
                    value = getVoltageLevel(obj);
            end
        end
    end

    %% Setters/ Getters
    methods (Access = private)
        function setVoltageLevel(~)
            try
                throw(MException(message("instrument:interface:serialcontroller:ReadOnlyVoltageLevel")));
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = getVoltageLevel(obj)
            value = obj.VoltageLevel;
        end

        function setEnableTargetPower(obj,channel,value)
            try
                validateattributes(value,["logical","double"],["nonempty","scalar","finite","integer","nonnegative"],"","EnableTargetPower");
                try
                    mustBeMember(value,[true,false,1,0]);
                catch
                    throw(MException(message("instrument:interface:serialcontroller:InvalidValueEnableTargetPower")));
                end
                options.TargetPower = double(value);
                channel.execute("SetTargetPower",options);
                obj.EnableTargetPower = value;
            catch ex
                throw(MException("instrument:interface:serialcontroller:InvalidValueEnableTargetPower",ex.message));
            end
        end

        function value = getEnableTargetPower(~,channel)
            try
                channel.execute("GetTargetPower");
                returnData = channel.ReturnData;
                value = returnData == 1;
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = getEnablePullupResistors(~,channel)
            try
                channel.execute("GetPullupResistors");
                returnData = channel.ReturnData;
                value = returnData == 1;
            catch ex
                throwAsCaller(ex);
            end
        end
    end
end

