classdef ProductionModeForm
    %PRODUCTIONMODEFORM Contains fields for PropertyToTest output in
    %production mode.

    %   Copyright 2023 The MathWorks, Inc.

    properties
        % "MWICT" stands for MathWorks Instrument Control Toolbox and is
        % included for the sole reason of avoiding name clashing. There is
        % no other meaning associated with the property name.
        HeaderMWICTCode
        BodyMWICTCode
        InputArgsMWICTCode
        OutputArgsMWICTCode
        Nargout
        Nargin
        PropInfo
        MethodInfo
        MethodList
    end
end

