classdef Aardvark < serialcontroller.internal.common.ControllerGeneralMixin & ...
        serialcontroller.internal.i2c.ControllerI2CMixin & ...
        serialcontroller.internal.dio.ControllerDIOMixin & ...
        serialcontroller.internal.common.ControllerBase
    %

    % AARDVARK creates a connection to the Aardvark controller specified
    % using the SERIALNUMBER input argument.
    %
    %   OBJ = AARDVARK("SERIALNUMBER") constructs an Aardvark object, OBJ,
    %   that creates a connection to an Aardvark controller with unique
    %   identifier SERIALNUMBER that is physically connected to the host machine.
    %
    %   OBJ = AARDVARK("SERIALNUMBER",NAME=VALUE, ...) constructs an
    %   Aardvark object, OBJ, using one or more optional name-value pair
    %   arguments. If an invalid property name or property value is
    %   specified, then the object is not created. Aardvark properties
    %   that can be set using name-value pair arguments are EnablePullupResistors,
    %   VoltageLevel, and EnableTargetPower.
    %
    % Input Arguments:
    %   SERIALNUMBER specifies the unique identifier for the Aardvark controller
    %   that is being connected to from MATLAB.
    %   The valid SERIALNUMBER values are returned by the aardvarklist function.
    %
    %   Examples:
    %
    %   >> al = aardvarklist
    %
    %   al =
    %
    %     1×2 table
    %
    %                    Model             SerialNumber
    %            ______________________    ____________
    %
    %       1    "Total Phase Aardvark"    "2237718007"
    %
    %   % Construct an Aardvark object using the SERIALNUMBER input argument
    %   % returned from aardvarklist function.
    %   >> a = aardvark("2237718007")

    % Copyright 2022-2024 The MathWorks, Inc.

    properties (SetAccess = private)
        Model (1,1) string
        SerialNumber (1,1) string
    end

    properties (Dependent)
        VoltageLevel (1,1) double
        EnablePullupResistors
        EnableTargetPower
    end

    properties (Constant,Access = private)
        AardvarkNumericDigitalPinArray = [1,3,5,7,8,9]
        AardvarkAvailableDigitalPins = ["Pin1","Pin3","Pin5","Pin7","Pin8","Pin9"]
        BitRateValuesAardvark = [1e3,10e3,20e3,30e3,40e3,50e3,80e3,100e3,125e3,200e3,250e3,400e3,500e3,800e3]
    end

    properties (Constant,Access = protected)
        % To set the object display
        DefaultPropertyDisplay = ["Model","SerialNumber","Tag","AvailableDigitalPins"]
        AdditionalPropertiesList = ["VoltageLevel","EnablePullupResistors","EnableTargetPower","DigitalPinModes"]
    end

    properties (Constant, Hidden)
        ObjectType = "aardvark"
    end

    %% Lifetime
    methods
        function obj = Aardvark(productionMode,varargin)
            %

            % Aardvark is the controller class. It delegates all user MATLAB
            % operations to ChannelHandler class using the Mixin class inheritance.
            % It creates the Aardvark asyncIO channel and custom Controller, I2C and
            % DIO implementor classes.

            arguments
                productionMode (1,1) logical = true
            end

            arguments (Repeating)
                varargin
            end

            try
                serialcontroller.internal.utility.SerialControllerUtility.validatePlatform("aardvark");
            catch ex
                throwAsCaller(ex);
            end

            obj@serialcontroller.internal.common.ControllerBase("aardvark");

            % Flag that uses either vendor asyncIO implementation or mock
            % asyncIO implementation.
            obj.ProductionMode = productionMode;

            % Connects to controller using connection logic in ControllerBase.
            connect(obj,varargin{:});
        end
    end

    %% Setters/Getters
    methods
        function set.EnablePullupResistors(obj,value)
            try
                setControllerProperty(obj.ChannelHandler,"EnablePullupResistors",value);
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.EnablePullupResistors(obj)
            try
                value = getControllerProperty(obj.ChannelHandler,"EnablePullupResistors");
            catch ex
                throwAsCaller(ex);
            end
        end

        function set.VoltageLevel(obj,value)
            try
                setControllerProperty(obj.ChannelHandler,"VoltageLevel",value);
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.VoltageLevel(obj)
            try
                value = getControllerProperty(obj.ChannelHandler,"VoltageLevel");
            catch ex
                throwAsCaller(ex);
            end
        end

        function set.EnableTargetPower(obj,value)
            try
                setControllerProperty(obj.ChannelHandler,"EnableTargetPower",value);
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.EnableTargetPower(obj)
            try
                value = getControllerProperty(obj.ChannelHandler,"EnableTargetPower");
            catch ex
                throwAsCaller(ex);
            end
        end
    end

    %% Abstract method Implementations
    methods (Access = protected)
        function channelDetails = getChannelImpl(obj,serialNumber)
            % Returns information about asyncIO channel and its options as
            % a struct.

            % Choose production mode asyncIO or mock asyncIO.
            if obj.ProductionMode
                vendor = "aardvark";
            else
                vendor = "mock";
            end

            % Create asyncIO channel struct
            channelDetails = serialcontroller.internal.utility.SerialControllerUtility.getChannelCreationInfo(vendor,serialNumber);
        end

        function controllerImplementor = getControllerImplementor(~)
            % Returns the custom ControllerImplementor instance that will
            % do general controller operations.
            controllerImplementor = serialcontroller.internal.aardvark.AardvarkControllerImplementor;
        end

        function i2cImplementor = getI2CImplementor(~)
            % Returns the custom I2CImplementor instance that will
            % do I2C operations.
            i2cImplementor = serialcontroller.internal.aardvark.AardvarkI2CImplementor;
        end

        function dioImplementor = getDIOImplementor(~)
            % Returns the custom DIOImplementor instance that will
            % do digital IO operations.
            dioImplementor = serialcontroller.internal.aardvark.AardvarkDIOImplementor;
        end

        function bitRateValues = getBitRateValues(~)
            % Returns the bitrate values supported by this specific controller.
            bitRateValues = serialcontroller.internal.aardvark.Aardvark.BitRateValuesAardvark;
        end

        function [numericDigitalPinArray,availableDigitalPins] = getDigitalPins(obj)
            % Returns the digital IO pin names and numbers available on this specific controller.
            numericDigitalPinArray = obj.AardvarkNumericDigitalPinArray;
            availableDigitalPins = obj.AardvarkAvailableDigitalPins;
        end
    end

    %% Hook methods
    methods (Access = protected)
        function initPropertiesHook(obj,nvPairs)
            % Parses name-value pair input arguments and assigns to properties
            p = inputParser;
            p.PartialMatching = true;

            addParameter(p,"EnablePullupResistors",true);
            addParameter(p,"EnableTargetPower",false);
            addParameter(p,"VoltageLevel",[]);
            addParameter(p,"Tag","", @(x) isstring(x) || ischar(x));

            parse(p,nvPairs{:});
            output = p.Results;

            obj.EnablePullupResistors = output.EnablePullupResistors;
            obj.EnableTargetPower = output.EnableTargetPower;
            if ~isempty(output.VoltageLevel)
                obj.VoltageLevel = output.VoltageLevel;
            end
            obj.Tag = output.Tag;
        end

        function prefHandler = getPrefHandlerHook(~)
            % Returns instance of preference handler that will contain
            % information about previously made connection using this controller class.
            prefHandler = serialcontroller.internal.aardvark.AardvarkPrefHandler();
        end

        function setModelSerialNumberHook(obj,serialNumber)
            % Assigns the Model and SerialNumber property values for a
            % controller.
            obj.SerialNumber = serialNumber;

            if obj.ProductionMode
                al = aardvarklist;
            else
                al = serialcontroller.internal.utility.SerialControllerUtility.createList("mock",0,"aardvarklist");
            end

            allSerialNumbers = al.SerialNumber';
            idx = find(allSerialNumbers == serialNumber);

            if ~isempty(idx)
                obj.Model = al.Model(idx);
            end
        end
    end

    %% Helper functions
    methods (Static,Hidden)
        function result = clearPreferences()
            % Hidden method to clear all Preferences data.
            result = serialcontroller.internal.aardvark.AardvarkPrefHandler.clearPreferences();
        end
    end

    %% Load
    % Load is disabled
    methods (Static,Hidden)
        function resource = loadobj(~)
            warning(message("instrument:interface:serialcontroller:NoLoad","aardvark"));
            resource = serialcontroller.internal.aardvark.Aardvark.empty;
        end
    end
end

