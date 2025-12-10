classdef NI845xControllerImplementor < serialcontroller.internal.common.CommonControllerImplementor
    % NI845XCONTROLLERIMPLEMENTOR overrides hook methods to configure
    % NI845x specific controller properties. It uses the asyncIO channel to
    % complete controller operations.

    % Copyright 2022 The MathWorks, Inc.

    properties
        % NI845x controller properties
        VoltageLevel (1,1) double = 3.3
        OutputDriverType (1,1) string = "push-pull"
    end

    properties (Constant,Hidden)
        OutputDriverTypes = ["push-pull","open-drain"]
        VoltageLevelValues =  [1.2,1.5,1.8,2.5,3.3]
    end

    %% Setter/Getter Helpers
    methods (Access = protected)
        function setPropertyHook(obj,channel,propName,value)
            % This function is called when a NI845x specific property has to be set.
            try
                switch propName
                    case "VoltageLevel"
                        setVoltageLevel(obj,channel,value);
                    case "OutputDriverType"
                        setOutputDriverType(obj,channel,value);
                end
            catch ex
                throwAsCaller(ex);
            end
        end
    end

    methods
        function value = getProperty(obj,~,propName)
            value = obj.(propName);
        end
    end

    %% Setters
    methods (Access = private)
        function setVoltageLevel(obj,channel,value)
            try
                validateattributes(value,"numeric","nonempty");
                try
                    mustBeMember(value,obj.VoltageLevelValues);
                catch ex
                    msg = replace(ex.message,"Value","VoltageLevel");
                    throw(MException("instrument:interface:serialcontroller:InvalidVoltageLevel",msg));
                end
                options.VoltLevel = value;
                channel.execute("SetVoltageLevel",options);
                obj.VoltageLevel = value;
            catch ex
                throw(MException("instrument:interface:serialcontroller:InvalidVoltageLevel",ex.message));
            end
        end

        function setOutputDriverType(obj,channel,value)
            try
                value = validatestring(value,obj.OutputDriverTypes,"","OutputDriverType");
                options.OutputDriver = value;
                channel.execute("SetOutputDriverType",options);
                obj.OutputDriverType = value;
            catch ex
                throw(MException("instrument:interface:serialcontroller:InvalidOutputDriverType",ex.message));
            end
        end
    end
end

