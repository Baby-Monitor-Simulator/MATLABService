classdef WriteView < matlabshared.transportapp.internal.toolstrip.write.View
    %WRITEVIEW View class for VISA Explorer app Toolstrip Write section.
    %Overrides the Shared Transport App base View class to add a WriteRead
    %button.

    % Copyright 2022-2023 The MathWorks, Inc.
 
    properties(Constant, Access = private)
        UIFactory = matlabshared.transportapp.internal.utilities.factories.ToolstripElementsFactory

        % Column number and the row number within the column of Custom Data
        % field element in the Write toolstrip. Used to replace this
        % element with dropdown.
        CustomDataPosition = [6 2]

        WriteSectionLabelIndex = 5
        HeaderPosition = 1
    end

    properties(Access = {?matlabshared.transportapp.internal.utilities.viewconfiguration.IViewConfiguration})
        WriteReadButton
        HeaderLabel
        HeaderEditField
    end

    events
        WriteReadButtonPressed
    end

    methods
        % Override getConstants function to use specialized constants class
        function consts = getConstants(~)
            consts = transportapp.visadev.internal.toolstrip.WriteConstants;
        end
    end
 
    %% Overriding Hook methods
    methods(Access = protected)
        % Override base method to add WriteRead button and change Data To Write
        % field to an editable dropdown.
        function createView(obj)
            % Create the write section view UI elements. The order of
            % creation of columns matters as the createAndAddColumn adds
            % the new column to the right of the current column with the
            % contained UI elements.
            import matlabshared.transportapp.internal.utilities.factories.ToolstripElementsFactory

            createView@matlabshared.transportapp.internal.toolstrip.write.View(obj);

            %% Create and add the Header label
            obj.HeaderLabel = ToolstripElementsFactory.createLabel(obj.Constants.HeaderLabelProps);
            labelColumn = obj.WriteSection.getChildByIndex(obj.WriteSectionLabelIndex);
            labelColumn.add(obj.HeaderLabel, obj.HeaderPosition);

            %% Modify the Data Entry column (containing Data to Write and Workspace Variable)
            % Create and add the Header Edit Field
            obj.HeaderEditField = ToolstripElementsFactory.createEditField(obj.Constants.HeaderEditField);
            customDataCol = obj.WriteSection.getChildByIndex(obj.CustomDataPosition(1));
            customDataCol.add(obj.HeaderEditField, obj.HeaderPosition);

            % Replace Custom Data field with editable dropdown
            customDataCol.remove(obj.CustomDataEditField);

            obj.CustomDataEditField = ...
                ToolstripElementsFactory.createDropDown(obj.Constants.WriteReadDropDownOptions, obj.Constants.CustomDataEditField);
            customDataCol.add(obj.CustomDataEditField, obj.CustomDataPosition(2));

            %% Add WriteRead button
            obj.WriteReadButton = obj.UIFactory.createPushButton(obj.Constants.WriteReadButton);
            
            ToolstripElementsFactory.createAndAddColumn...
                (obj.WriteSection, obj.Constants.WriteColumn(6), obj.WriteReadButton);
       end
    
       function setupEvents(obj)
          % Call the base class setupEvents method.
          setupEvents@matlabshared.transportapp.internal.toolstrip.write.View(obj);
           
          % Add events for WriteRead button
          obj.WriteReadButton.ButtonPushedFcn = @(~,~)obj.notify("WriteReadButtonPressed");
       end
    end
    
end
