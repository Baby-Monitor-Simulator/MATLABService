function varargout = icbgate(command, varargin)
%ICBGATE Helper function for toolbox blocks.
%
%   ICBGATE handles S-function callback from the block and java callbacks
%   from the mask.
%
%   This function should not be called directly by the user.
%  

%   PE 01-06-03
%   Copyright 2003-2023 The MathWorks, Inc.

persistent blockList;

mlock;

switch (lower(command))
    case 'open'
        blockH = get_param(gcbh, 'Handle');

        % If the dialog for this block already exists, use it.
        if ~isempty(blockList)
            idx = find([blockList.blockHandle] == blockH);
            if ~isempty(idx)
                [params, values] = localGetMaskValues(blockH);
                if (~blockList(idx).data.frame.isVisible())
                    localUpdateJavaDialog(blockList(idx), params, values);
                end
                if (~blockList(idx).data.frame.isVisible())
                    blockList(idx).data.frame.setDirty(false);
                    blockList(idx).data.frame.makeVisible();
                end
                return;
            end
        end

        % If the dialog does not already exist, create it.
        switch (varargin{1})
            case 'query'
                frame = handle(com.mathworks.toolbox.instrument.icb.QueryFrame);
            case 'send'
                frame = handle(com.mathworks.toolbox.instrument.icb.SendFrame);
        end

        frame.setDefaultCloseOperation(javax.swing.WindowConstants.HIDE_ON_CLOSE);
        frame.setTitle(message("instrument:instrumentblks:blockParam", get_param(blockH, 'Name')).getString);
        data.frame = frame;
        
        [params, values] = localGetMaskValues(blockH);

        blockList(end + 1).blockHandle = blockH;
        blockList(end).data = data;
        blockList(end).lastValues = values;

        localUpdateJavaDialog(blockList(end), params, values);

        % If the user opens the model while the simulation is running/paused, 
        % or if the user opens inside the library we need to make
        % sure the non-tunable parameters are disabled.
        if ( any(strcmpi(get_param(localGetModel(blockH), 'SimulationStatus'), {'running' 'paused'}) == 1) ...
            || (strcmpi(get_param(localGetModel(blockH), 'LibraryType'), 'BlockLibrary') == 1) )
            frame.disableComponents;
        end

        frame.setDirty(false);
        frame.makeVisible();

    case 'delete'
        blockH = get_param(gcbh, 'Handle');

        if ~isempty(blockList)
            idx = find([blockList.blockHandle] == blockH);
            if ~isempty(idx)
                blockList(idx).data.frame.hide;
                blockList(idx) = [];
            end
        end

    case 'start'
        blockH = get_param(gcbh, 'Handle');

        if ~isempty(blockList)
            idx = find([blockList.blockHandle] == blockH);
            if ~isempty(idx)
                if (blockList(idx).data.frame.isDirty)
                    error(message('instrument:instrumentblks:unappliedChanges'));
                end
                blockList(idx).data.frame.disableComponents;
            end
        end

    case 'stop'
        blockH = get_param(gcbh, 'Handle');

        if ~isempty(blockList)
            idx = find([blockList.blockHandle] == blockH);
            if ~isempty(idx)
                blockList(idx).data.frame.enableComponents;
            end
        end

    case 'namechange'
        blockH = get_param(gcbh, 'Handle');

        if ~isempty(blockList)
            idx = find([blockList.blockHandle] == blockH);
            if ~isempty(idx)
                blockList(idx).data.frame.setTitle(message("instrument:instrumentblks:blockParam", get_param(blockH, 'Name')).getString);
            end
        end

    case 'getblockdata'
        if ~isempty(blockList)
            idx = find([blockList.blockHandle] == varargin{1});
            if ~isempty(idx)
                varargout(1) = {blockList(idx)};
            else
                varargout{1} = {[]};
            end
        else
            varargout(1) = {[]};
        end

    case 'setblockdata'
        if ~isempty(blockList)
            idx = find([blockList.blockHandle] == varargin{1});
            if ~isempty(idx)
                blockList(idx).lastValues = varargin{2};
            end
        end

    case 'ok'
        localOkCallback(varargin{1});
    case 'cancel'
        localCancelCallback(varargin{1});
    case 'help'
        localHelpCallback(varargin{1});
    case 'apply'
        localApplyCallback(varargin{1});
        
    otherwise
        error(message('instrument:instrumentblks:unknownCallback', command));
end

%-------------------------------------------------------------------------------
% localUpdateJavaDialog
function localUpdateJavaDialog(blockData, params, values)

blockData.data.frame.setHandle(blockData.blockHandle);
blockData.data.frame.setParameterValues(params, values);

%-------------------------------------------------------------------------------
%   localApplyCallback
function localApplyCallback(blockH)

localApply(blockH);

%-------------------------------------------------------------------------------
%   localCancelCallback
function localCancelCallback(blockH)

params = localGetMaskValues(blockH);

blockData = icbgate('getblockData', blockH);

if ~isempty(blockData)
    blockData.data.frame.hide;
    localUpdateJavaDialog(blockData, params, blockData.lastValues);
end


%-------------------------------------------------------------------------------
%   localHelpCallback
function localHelpCallback(blockH)

% Opens an appropriate help window for the given block
helpview(fullfile(docroot, 'toolbox', 'instrument', 'instrument.map'), icbhelp(blockH));

%-------------------------------------------------------------------------------
%   localOKCallback
function localOkCallback(blockH)

blockData = icbgate('getblockData', blockH);

if ~isempty(blockData)
    if (blockData.data.frame.isDirty)
        localApply(blockH);
    end
    blockData.data.frame.hide;
end

%-------------------------------------------------------------------------------
%   localGetMaskValues
function  [params, values] = localGetMaskValues(blk)

params = {};
values = {};

if( strcmp( get_param( blk,'Type' ), 'block' ) )

    if(strcmp(get_param(blk, 'Mask' ), 'on' ))
        params  = get_param(blk, 'MaskNames');
        values  = get_param(blk, 'MaskValues');

        visible = find(~strcmp(get_param(blk, 'MaskVisibilities'),'off'));

        params = params(visible);
        values = values(visible);
    end
end

%-------------------------------------------------------------------------------
%   localApply
function blockData = localApply(blockH)

blockData = icbgate('getblockData', blockH);

if ~isempty(blockData)
    PV = blockData.data.frame.getParameterValues;
    params = cell(PV(1));
    values = cell(PV(2));
    A = reshape({params{:}; values{:}}, length(params) * 2, 1);
    try
        set_param(blockH, A{:});
        icbgate('setblockdata', blockH, values);
        blockData.data.frame.setDirty(false);
    catch aException
        % There was a problem with one of the parameters specified.
        throw(aException);
    end
end

%-------------------------------------------------------------------------------
% localGetModel
function parent = localGetModel(blk)

parent = get_param(blk, 'Parent');

while (strcmpi(get_param(parent, 'Type'), 'block_diagram') ~= 1)
    model = parent;
    parent = get_param(model, 'Parent');
end
