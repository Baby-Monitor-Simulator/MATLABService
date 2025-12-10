classdef ReadView < matlabshared.transportapp.internal.toolstrip.read.View ...
    %READVIEW View class for VISA Explorer toolstrip Read section.
    %Creates UI elements for the toolstrip Read section.
    %
    %Specializes Shared Tranpsport App read.View class remove
    %NumBytesAvailable field.

    % Copyright 2022 The MathWorks, Inc.

    properties(Access = private, Constant)
        % Column number and the row number within the column of "Num Bytes
        % Available" label and field elements in the Read toolstrip. Use
        % this to remove these elements.
        BytesAvailableLabelPosition = [5 2]
        BytesAvailableFieldPosition = [7 2]
    end

    methods(Access = protected)
        % Override getConstants method to use specialized constants class
        function consts = getConstants(~)
            consts = transportapp.visadev.internal.toolstrip.ReadConstants;
        end

        function createView(obj)
            % Same as superclass createView method, but removing
            % NumBytesAvailable field.

            createView@matlabshared.transportapp.internal.toolstrip.read.View(obj);

            % Remove the "Values Available" Label
            column = removeElementFromToolstrip(obj, obj.BytesAvailableLabelPosition);
            column.addEmptyControl();
            
            
            % Remove the "Values Available" value label
            column = removeElementFromToolstrip(obj, obj.BytesAvailableFieldPosition);
            column.addEmptyControl();

            function [column] = removeElementFromToolstrip(obj, position)
    
                % Column Handle
                column = obj.ReadSection.getChildByIndex(position(1));
    
                % Get the element you want to remove
                element = column.getChildByIndex(position(2));
    
                % Remove the Values Available Label from the column
                column.remove(element);
            end
        end
    end
    
end