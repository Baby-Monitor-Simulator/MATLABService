function out = privateIviComDriverHelper(action, obj, varargin)
%PRIVATEIVICOMDRIVERHELPER Helper function used by IVI-COM device objects.
%
%   PRIVATEIVICOMDRIVERHELPER helper function used by IVI-COM device
%   objects.
%
%   This function should not be called directly by the user.

%   PE 09-03-03
%   Copyright 1999-2008 The MathWorks, Inc. 

out = {};

if (isempty(action) || isempty(obj))
    return;
end

switch (action)
    case 'open'
        % Get the initialization option from the java ICDevice object
        jobject = igetfield(varargin{2}, 'jobject');
        invoke(obj, 'Initialize', varargin{1}, false, false, jobject.OptionString);
        out{1} = get(obj, 'Initialized');
    case 'close'
        status = get(obj, 'Initialized');
        if (status == true)
            invoke(obj, 'Close');
        end
    case 'status'
        status = get(obj, 'Initialized');
        out{1} = status;
    case 'error'
        driverop = get(obj, 'DriverOperation');
        if (get(driverop, 'QueryInstrumentStatus') == false)
            warning(message('instrument:icdevice:icdevice:invalidStateError'));
        end
        util = get(obj, 'Utility');
        [ErrorCode, theMessage] = invoke(util, 'ErrorQuery', 0, '');
        out{1} = theMessage;
    case 'reset'
        util = get(obj, 'Utility');
        invoke(util, 'Reset');
    case 'selftest'
        util = get(obj, 'Utility');
        [unusedhr, unusedid, theMessage] = invoke(util, 'SelfTest', 0, '');
        out{1} = theMessage;
    case 'model'
        ident = get(obj, 'Identity');
        out{1} = [get(ident, 'InstrumentManufacturer') ' ' get(ident, 'InstrumentModel')];
    case 'group'
        try 
            comobj = varargin{1};
            newSize = comobj.Count;
            collectionname = varargin{2};
            groupname = instrgate ('privateGetCollectionItemName', collectionname);
            group = get(obj, groupname);
            oldSize = length(group);
            if (oldSize < newSize);
                names = {cell(1,newSize)};
                for idx = oldSize:newSize
                    names{idx-oldSize + 1} = [groupname num2str(idx)];
                end
                privateAddGroupObjects(obj, groupname, newSize, names);
            end
        catch aException
            fprintf('%s\n', aException.message);
            throwAsCaller(aException);
        end
    case 'nestedgroup'
        try
            newSize = varargin{1}.Count;
            groupname = varargin{3};
            if(newSize > 0)
                names = {cell(1,newSize)};
                for idx = 1:newSize
                    names{idx} = [groupname num2str(idx)];
                end
                privateAddGroupObjects(obj, groupname, newSize, names);
            end
        catch aException
            fprintf('%s\n', aException.message);
            throwAsCaller(aException);
        end
end

 
