function ref = icbhelp(varargin)
%ICBHELP Return help file for the selected instrument control block.
%
%   REF = ICBHELP returns the url of the block reference page file to pass to
%   the WEB or HELPVIEW functions.  If docroot is not available, a default error
%   page is returned.
%
%   This function should not be called directly by the user.
%  

%   PE 1-21-05
%   Copyright 2005-2007 The MathWorks, Inc. 

narginchk(0,1);

d = docroot;

if (isempty(d))
    ref = localGetErrorFile;
else
    if (nargin == 0)
        % Called from the contextual menu or some other mechanism where the
        % desired block is known to be selected in the model.
        blockhelpname = get_param(gcb, 'MaskType');
    else
        % Called from the help button in a Java dialog mask or some other
        % location where the help request is for a block that is not necessarily
        % the one currently selected in the model.  Use the block provided
        % instead.
        blockhelpname = get_param(varargin{1}, 'MaskType');
    end
    
    if (isempty(blockhelpname))
        ref = localGetErrorFile;
        return;
    end
    
    switch blockhelpname
        case 'queryinstrument'
            ref = 'ICT_queryinstrument_Block';
        case 'toinstrument'
            ref = 'ICT_toinstrument_Block';
        otherwise
            % Do nothing.
            ref = localGetErrorFile;
    end
end


% ------------------------------------------------------------------------------
% Return a generic documentation not found message.
function errfile = localGetErrorFile

errfile = ['file:///' matlabroot '/toolbox/instrument/instrumentblks/instrumentblks/icberr.html'];
