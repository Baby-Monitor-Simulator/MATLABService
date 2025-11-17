function validateChannelName(validChannelNames, channelName)
%VALIDATECHANNELNAME checks if channelName belongs to the validChannelNames
%subset
% If channelName is a member of validChannelNames then this function
% returns with no output or errors, else it generates an error.

%   Copyright 2013 The MathWorks, Inc.

if ~ismember(channelName, validChannelNames)
    
    %get available channel names
    channelNames = '';
    for idx = 1: size(validChannelNames, 2)
        channelNames = sprintf('%s, %s', channelNames, validChannelNames{idx});
    end
    %remove the space and comma
    channelNames = channelNames(3:end);
    error( message('instrument:qcinstrument:notValidChannelName', channelName, channelNames));
end

end

