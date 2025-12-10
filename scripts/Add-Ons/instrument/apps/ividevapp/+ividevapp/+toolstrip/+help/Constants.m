classdef Constants
    %CONSTANTS contains View constant properties for the toolstrip Help
    % section.

    % Copyright 2024 The MathWorks, Inc.

    properties (Constant)
        Position = matlabshared.transportapp.internal.utilities.forms.ToolstripColumn(50, "center")
        HelpSectionName = message("ividevapp:ividevapp:HelpSectionName").string
        DriverDocButtonProps = struct("Text",  message("ividevapp:ividevapp:DriverDocButtonLabel").string,...
            "Icon", "documentation", ...
            "Description", message("ividevapp:ividevapp:DriverDocButtonTooltip").string, ...
            "Enabled", true, ...
            "Tag", 'DriverDocButton')
    end
end