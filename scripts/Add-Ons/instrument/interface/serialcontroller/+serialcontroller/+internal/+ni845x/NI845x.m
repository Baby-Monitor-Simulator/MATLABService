classdef NI845x < serialcontroller.internal.common.ControllerGeneralMixin & ...
        serialcontroller.internal.i2c.ControllerI2CMixin & ...
        serialcontroller.internal.dio.ControllerDIOMixin & ...
        serialcontroller.internal.common.ControllerBase
    %

    % NI845X creates a connection to the NI845x controller specified using the
    % SERIALNUMBER input argument.
    %
    %   OBJ = NI845X("SERIALNUMBER") constructs a NI845x object, OBJ, that
    %   creates a connection to a NI845x controller with unique identifier
    %   SERIALNUMBER that is physically connected to the host machine.
    %
    %   OBJ = NI845X("SERIALNUMBER",NAME=VALUE, ...) constructs a
    %   NI845x object, OBJ, using one or more optional name-value pair
    %   arguments. If an invalid property name or property value is
    %   specified, then the object is not created. NI845x properties
    %   that can be set using name-value pair arguments are EnablePullupResistors,
    %   VoltageLevel, and OutputDriverType.
    %
    % Input Arguments:
    %   SERIALNUMBER specifies the unique identifier for the NI845x controller
    %   that is being connected to from MATLAB.
    %   The valid SERIALNUMBER values are returned by the ni845xlist function.
    %
    %   Examples:
    %
    %   >> nl = ni845xlist
    %
    %   nl =
    %
    %     1×2 table
    %
    %                Model        SerialNumber
    %            _____________    ____________
    %
    %       1    "NI USB-8451"     "0180D442"
    %
    %   % Construct a NI845x object using the SERIALNUMBER input argument
    %   % returned from ni845xlist function.
    %   >> n = ni845x("0180D442")

    % Copyright 2022-2024 The MathWorks, Inc.

    properties (SetAccess = private)
        Model (1,1) string
        SerialNumber (1,1) string
    end

    properties (Dependent)
        VoltageLevel (1,1) double
        EnablePullupResistors
        OutputDriverType (1,1) string
    end

    properties (Constant,Access = private)
        NI845xNumericDigitalPinArray = [0,1,2,3,4,5,6,7]
        NI845xAvailableDigitalPins = ["P0.0","P0.1","P0.2","P0.3","P0.4","P0.5","P0.6","P0.7"]
        BitRateValuesNI8451 = [32e3,40e3,50e3,64e3,80e3,100e3,125e3,160e3,200e3,250e3]
        BitRateValuesNI8452 = [16e3,20e3,25e3,31e3,40e3,50e3,62e3,80e3,100e3,125e3,200e3,250e3,400e3,500e3,1000e3]
        BitRateValues = dictionary(["NI USB-8451","NI USB-8452","Mock Controller"],{serialcontroller.internal.ni845x.NI845x.BitRateValuesNI8451,serialcontroller.internal.ni845x.NI845x.BitRateValuesNI8452,serialcontroller.internal.ni845x.NI845x.BitRateValuesNI8451})
    end

    properties (Constant,Access = protected)
        % To set the object display
        DefaultPropertyDisplay = ["Model","SerialNumber","Tag","AvailableDigitalPins"]
        AdditionalPropertiesList = ["VoltageLevel","EnablePullupResistors","OutputDriverType","DigitalPinModes"]
    end

    properties (Constant, Hidden)
        ObjectType = "ni845x"
    end

    %% Lifetime
    methods
        function obj = NI845x(productionMode,varargin)
            %

            % NI845x is the controller class. It delegates all user MATLAB
            % operations to ChannelHandler class using the Mixin class inheritance.
            % It creates the NI845x asyncIO channel and custom Controller, I2C and
            % DIO implementor classes.

            arguments
                productionMode (1,1) logical = true
            end

            arguments (Repeating)
                varargin
            end

            try
                serialcontroller.internal.utility.SerialControllerUtility.validatePlatform("ni845x");
            catch ex
                throwAsCaller(ex);
            end

            obj@serialcontroller.internal.common.ControllerBase("ni845x");

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

        function set.OutputDriverType(obj,value)
            try
                setControllerProperty(obj.ChannelHandler,"OutputDriverType",value);
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.OutputDriverType(obj)
            try
                value = getControllerProperty(obj.ChannelHandler,"OutputDriverType");
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
                vendor = "ni845x";
            else
                vendor = "mock";
            end

            % Create asyncIO channel struct
            channelDetails = serialcontroller.internal.utility.SerialControllerUtility.getChannelCreationInfo(vendor,serialNumber);
        end

        function controllerImplementor = getControllerImplementor(~)
            % Returns the custom ControllerImplementor instance that will
            % do general controller operations.
            controllerImplementor = serialcontroller.internal.ni845x.NI845xControllerImplementor;
        end

        function i2cImplementor = getI2CImplementor(~)
            % Returns the custom I2CImplementor instance that will
            % do I2C operations.
            i2cImplementor = serialcontroller.internal.ni845x.NI845xI2CImplementor;
        end

        function dioImplementor = getDIOImplementor(~)
            % Returns the custom DIOImplementor instance that will
            % do digital IO operations.
            dioImplementor = serialcontroller.internal.ni845x.NI845xDIOImplementor;
        end

        function bitRateValues = getBitRateValues(obj)
            % Returns the bitrate values supported by this specific controller.
            bitRateValuesCell = obj.BitRateValues(obj.Model);
            bitRateValues = bitRateValuesCell{:};
        end

        function [numericDigitalPinArray,availableDigitalPins] = getDigitalPins(obj)
            % Returns the digital IO pin names and numbers available on this specific controller.
            numericDigitalPinArray = obj.NI845xNumericDigitalPinArray;
            availableDigitalPins = obj.NI845xAvailableDigitalPins;
        end
    end

    %% Hook methods
    methods (Access = protected)
        function initPropertiesHook(obj,nvPairs)
            % Parses name-value pair input arguments and assigns to properties
            p = inputParser;
            p.PartialMatching = true;

            flag = obj.Model == "NI USB-8452";
            addParameter(p,"EnablePullupResistors",flag);
            addParameter(p,"VoltageLevel",3.3);
            addParameter(p,"OutputDriverType","push-pull");
            addParameter(p,"Tag", "", @(x) isstring(x) || ischar(x));

            parse(p,nvPairs{:});
            output = p.Results;

            obj.EnablePullupResistors = output.EnablePullupResistors;
            obj.VoltageLevel = output.VoltageLevel;
            obj.OutputDriverType = output.OutputDriverType;
            obj.Tag = output.Tag;
        end

        function prefHandler = getPrefHandlerHook(~)
            % Returns instance of preference handler that will contain
            % information about previously made connection using this controller class.
            prefHandler = serialcontroller.internal.ni845x.NI845xPrefHandler();
        end

        function setModelSerialNumberHook(obj,serialNumber)
            % Assigns the Model and SerialNumber property values for a
            % controller.
            obj.SerialNumber = serialNumber;

            if obj.ProductionMode
                nl = ni845xlist;
            else
                nl = serialcontroller.internal.utility.SerialControllerUtility.createList("mock",0,"ni845xlist");
            end

            allSerialNumbers = nl.SerialNumber';
            idx = find(allSerialNumbers == serialNumber);

            if ~isempty(idx)
                obj.Model = nl.Model(idx);
            end
        end
    end

    %% Helper functions
    methods (Static,Hidden)
        function result = clearPreferences()
            % Hidden method to clear all Preferences data.
            result = serialcontroller.internal.ni845x.NI845xPrefHandler.clearPreferences();
        end
    end

    %% Load
    % Load is disabled
    methods (Static,Hidden)
        function resource = loadobj(~)
            warning(message("instrument:interface:serialcontroller:NoLoad","ni845x"));
            resource = serialcontroller.internal.ni845x.NI845x.empty;
        end
    end
end

