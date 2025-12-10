classdef DescriptorProperties
    % DESCRIPTORPROPERTIES contains properties for creating an instance of
    % DeviceParamsDescriptor.

    % Copyright 2021-2023 The MathWorks, Inc.

    properties(Constant)
        % Name of product Map file.
        MapFile (1,1) string = "instrument"

        % The topic ID for the CSH page shown in hardware manager while the
        % user is entering parameters
        TopicID (1,1) string = "udpportappcsh"

        % Enable or disable the descriptor button.
        Enabled (1, 1) logical = true

        % The tooltip text shown when the descriptor button is disabled.
        % This can be used to provide information to the user as to why the
        % button is disabled.
        TooltipText (1, 1) string = message("transportapp:udpportapp:TooltipText").getString()
    end
end
