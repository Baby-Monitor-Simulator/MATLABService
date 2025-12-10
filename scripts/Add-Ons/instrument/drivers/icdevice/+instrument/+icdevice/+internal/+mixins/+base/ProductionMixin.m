classdef ProductionMixin < handle
    %PRODUCTIONMIXIN sets the Driver and Group classes in production mode
    %or unit test mode.

    %   Copyright 2022-2023 The MathWorks, Inc.

    properties (Hidden)
        ProductionMode (1, 1) logical = true

        % PropertyToTest saves the existing property values as a cell array
        % of (1x2) values. The first value is the variable name and the
        % second value is the current variable value.
        %
        % E.g.
        % >> dev = Driver("AgInfiniiVision.mdd", "foo", "Simulate=true", false);
        % >> dev.PropertyToTest
        %
        % ans =
        %
        %   1×6 cell array
        %
        %     {1×2 cell}    {1×2 cell}    {1×2 cell}    {1×2 cell}    {1×2 cell}    {1×2 cell}
        %
        % >> dev.PropertyToTest{1}
        %
        % ans =
        %
        %   1×2 cell array
        %
        %     {["headerMWICTCode"]}    {["function init(obj)"]}
        %
        % >> dev.PropertyToTest{2}
        %
        % ans =
        %
        %   1×2 cell array
        %
        %     {["bodyMWICTCode"]}    {["% This function is called after the object is created…"]}
        %
        % >> dev.PropertyToTest{3}
        %
        % ans =
        %
        %   1×2 cell array
        %
        %     {["inputArgsMWICTCode"]}    {["obj"]}
        PropertyToTest = instrument.icdevice.internal.forms.ProductionModeForm.empty
    end

    methods (Hidden)
        function setPropertyToTest(obj, propObj)
            obj.PropertyToTest(end+1) = propObj;
        end
    end

    methods (Hidden)
        function resetPropertyToTest(obj)
            obj.PropertyToTest = [instrument.icdevice.internal.forms.ProductionModeForm.empty];
        end
    end
end
