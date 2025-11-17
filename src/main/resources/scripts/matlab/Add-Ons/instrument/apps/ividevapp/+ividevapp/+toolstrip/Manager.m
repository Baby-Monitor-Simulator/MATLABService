classdef Manager < handle
    %MANAGER creates and maintains lifetime of the different toolstrip
    % section managers- AnalyzeSectionManager, ExportSectionManager and
    % HelpSectionManager.

    % Copyright 2023-2024 The MathWorks, Inc.

    properties
        AnalyzeSectionManager
        ExportSectionManager
        HelpSectionManager
    end

    methods
        function obj = Manager(mediator, form)
            % Create Analyze Section Manager.
            obj.AnalyzeSectionManager = ividevapp.toolstrip.analyze.Manager(mediator, form);

            % Create Export Section Manager.
            obj.ExportSectionManager = ividevapp.toolstrip.export.Manager(mediator, form);

            % Create Help Section Manager.
            obj.HelpSectionManager = ividevapp.toolstrip.help.Manager(mediator, form);
        end
    end

    methods
        function setToolstripVendorDriver(obj, vendorDriver)
            setHelpSectionVendorDriver(obj.HelpSectionManager, vendorDriver);
        end
    end
end