function out = privateDataExporterHelper(action, obj, varargin)
%PRIVATEDATAEXPORTERHELPER helper function used by TMTOOL.
%
%   PRIVATEDATAEXPORTERHELPER helper function used by TMTOOL
%   TMTOOL to export data to:
%      1. the MATLAB workspace
%      2. MATLAB figure window
%      3. MAT-file
%      4. MATLAB Variable Editor.
%   
%   This function should not be called directly be the user.
%  
%   See also TMTOOL.
%
 
%   MP 9-08-03
%   Copyright 1999-2008 The MathWorks, Inc. 

% Initialize output.
out = '';

switch action
case 'figure'
    % Parse the input.
    selectedVariables = obj;
    % If there is no data return.
    if isempty(selectedVariables)
        return;
    end
   
    % Initialize variables.
    variableNames = {selectedVariables.size-1/2};
    count = 1;
    
    % Loop through and assign each object to the user-specified variable name.
    for i=0:2:selectedVariables.size-1
        varName = char(selectedVariables.elementAt(i));
        variableNames{count} = varName;
        eval([variableNames{count} ' = varargin{1}.get(char(selectedVariables.elementAt(i+1)));'])
        count = count+1;
    end

    % Get the default colors and plot each variable.
    colorOrder = get(gca, 'ColorOrder');
        
    for i=1:length(variableNames)
        if isempty(eval(variableNames{i})) == 1
            continue;
        end;
        plot(eval(variableNames{i}), 'Color', colorOrder(rem(i, length(colorOrder))+1,:));
        hold on;
    end
    
    % Create a legend.
    legend(variableNames{:});
    hold off;
case 'workspace'
    % Parse the input.
    selectedVariables = obj;
    variables = varargin{1};

    % If there is no data return.
    if isempty(selectedVariables)
        return;
    end
    
    % Export data to workspace.
    for i=0:2:selectedVariables.size-1;
        varName = char(selectedVariables.elementAt(i));
        lookupName = char(selectedVariables.elementAt(i+1));
        data = variables.get(lookupName);
        %Check if data is a java string array, return as a cell array of
        %strings
        if isa(data, 'java.lang.String[]')
            data = cellstr(char(data)); 
        end
        assignin('base', varName, data);
    end
case 'mat-file'
    % Parse the input.
    filename = obj;
    selectedVariables = varargin{1};
    
    % If there is no data return.
    if isempty(selectedVariables)
        return;
    end
    
    % Initialize variables.
    variableNames = {selectedVariables.size-1/2};
    count = 1;
    
    % Loop through and assign each object to the user-specified variable name.
    for i=0:2:selectedVariables.size-1
        varName = char(selectedVariables.elementAt(i));
        variableNames{count} = varName;
        eval([variableNames{count} ' = varargin{2}.get(char(selectedVariables.elementAt(i+1)));'])
        count = count+1;
    end

    % Save the variables to the MAT-file.
    save(filename, variableNames{:});

case 'arrayeditor'
    % Parse the input.
    selectedVariables = obj;
    variables = varargin{1};

    for i=0:2:selectedVariables.size-1;
        lookupName = char(selectedVariables.elementAt(i+1));
        varName = char(selectedVariables.elementAt(i));
        data = variables.get(lookupName);
        assignin('base', varName, data);
        openvar(varName);
    end
end
