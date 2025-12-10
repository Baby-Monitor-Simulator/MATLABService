function privatesladdserialconfig(obj, blockType)
%PRIVATESLADDSERIALCONFIG Checks and adds a serial configuration block. 
%
%    PRIVATESLADDSERIALCONFIG(OBJ, BLOCKTYPE) Gives an option to the user to
%    add a serial configuration block to the model, if none found already
%    with a selected serial port specified in the object, OBJ.
%
%    BLOCKTYPE is a string with values: 'Receive' or 'Send'.

%    SS 10-01-07
%    Copyright 2007-2018 The MathWorks, Inc.

% Get the error strings.
strings = privateinstrumentslstring('errorstrings');

% Check if the current port is not a valid port. 
if strcmpi(obj.ComPort, strings.SelectPortString)
    return;
end

% Find the block names with the specific serial port.
blockNames = find_system(bdroot, 'MaskType', 'Serial Configuration', ...
                         'ComPortMenu', obj.ComPortMenu);

% Display a message to user if not found.
if isempty(blockNames)
    % Display the question dialog to user.
    question = sprintf(strings.AddSerialConfigBlock, blockType, obj.ComPort);
    userSelection = ...
        questdlg(question, strings.QuestDlgTitle, 'Yes', 'No', 'Yes');
    
    if strcmpi(userSelection, 'Yes') % If user selects Yes.
        block = get(obj, 'Block');
        destination = sprintf('%s/Serial Configuration', block.Path);
        %Find the position to add the block in the model. 
        position = tamslgate('privateslfreespace', 'instrumentlib/Serial Configuration', ...
                                       block.Path);
        % Add the block with the specified Serial port.  
        add_block('instrumentlib/Serial Configuration',destination, ...
                  'MakeNameUnique', 'on', ...
                  'Position', position, ...
                  'ComPortMenu', obj.ComPortMenu, ...
                  'ComPort', obj.ComPort, ...
                  'ObjConstructor', obj.ObjConstructor);
    end
end