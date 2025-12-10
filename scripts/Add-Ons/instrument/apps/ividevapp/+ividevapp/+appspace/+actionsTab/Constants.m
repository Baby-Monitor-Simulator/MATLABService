classdef Constants
    %CONSTANTS contains View constant properties for the appspace Actions
    % Tab panel.

    % Copyright 2023 The MathWorks, Inc.

    %% UI element constants
    properties (Constant)
        FunctionPropertyLayout = matlabshared.transportapp.internal.utilities.forms.AppSpaceGridLayout(1, 2)
        FunctionProperty = struct("Title", message("ividevapp:ividevapp:ActionsTabTitle").string, ...
            "TitlePosition", "lefttop", ...
            "FontSize", 12, ...
            "FontWeight", "bold");

        GetButtonText = message("ividevapp:ividevapp:GetButtonText").string
        GetterLabel = message("ividevapp:ividevapp:GetterLabel").string
        SetButtonText = message("ividevapp:ividevapp:SetButtonText").string
        SetterLabel = message("ividevapp:ividevapp:SetterLabel").string
        ExecuteButtonText = message("ividevapp:ividevapp:ExecuteButtonText").string
        ActionsTabEmptyText = message("ividevapp:ividevapp:ActionsTabEmptyText").string
        RepCapID = message("ividevapp:ividevapp:RepCapID").string
    end
end