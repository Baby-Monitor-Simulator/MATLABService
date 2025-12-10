function comEntry = privateUpdateEntry(comEntry, storeObject, mEntry)
%PRIVATEUPDATEENTRY Update the IVI Configutation Store COM object
%   PRIVATEUPDATEENTRY(COMENTRY, STOREOBJECT, MENTRY) updates the IVI
%   Configuration Store COM entry, COMENTRY, in the IVI Configuration Store
%   STOREOBJECT, with the user-visible M structure, MENTRY.
%
%   This function should not be called directly by the user. 

%   PE 10-01-03
%   Copyright 1999-2011 The MathWorks, Inc.

% Type is used internally by the object, but is not part of the COM object.

mEntry = rmfield(mEntry, 'Type');

names = fieldnames(mEntry);

% To properly update the COM object values, string names for HardwareAsset,
% SoftwareModule, and Session in the structure must be translated into
% actual COM references in the COM configuration store.  If the string for
% any of those entries is empty, we need to translate to an empty matrix
% which the COM object will interpret as NULL.

% The other translation is 'on' and  'off' in the MATLAB structures to 1
% and 0 for the COM entry.

for idx = 1:length(names)
    switch (names{idx})
        case 'HardwareAsset'
            if (isempty(mEntry.HardwareAsset))
                comEntry.HardwareAsset = [];
                continue;
            end
            
            c = privateGetNamedEntry(storeObject.HardwareAssets, mEntry.HardwareAsset);
            
            if (~isempty(c))
                comEntry.HardwareAsset = c;
            else
                error(message('instrument:iviconfigurationstore:update:invalidArgs', mEntry.HardwareAsset));
            end
        case 'SoftwareModule'
            if (isempty(mEntry.SoftwareModule))
                comEntry.SoftwareModule = [];
                continue;
            end
            
            c = privateGetNamedEntry(storeObject.SoftwareModules, mEntry.SoftwareModule);
            
            if (~isempty(c))
                comEntry.SoftwareModule = c;
            else
                error(message('instrument:iviconfigurationstore:update:invalidArgs', mEntry.HardwareAsset));
            end
        case 'Session'
            if (isempty(mEntry.Session))
                comEntry.Session = [];
                continue;
            end
            
            c = privateGetNamedEntry(storeObject.Sessions, mEntry.Session);

            if (~isempty(c))
                comEntry.Session = c;
            else
                comEntry.Session = [];
            end
        case {'Cache', 'InterchangeCheck', 'QueryInstrStatus', 'RangeCheck', 'RecordCoercions', 'Simulate'}
            value = mEntry.(names{idx});
            
            if (isnumeric(value) || islogical(value))
                comEntry.(names{idx}) = mEntry.(names{idx});
                continue;
            end
            
            if (ischar(value))
                if (strcmpi(mEntry.(names{idx}), 'off'))
                    comEntry.(names{idx}) = 0;
                else
                    comEntry.(names{idx}) = 1;
                end
            end

        case 'VirtualNames'
            
            % Remove any old virtual names.
            
            for idx = comEntry.VirtualNames.Count:-1:1
                comEntry.VirtualNames.Remove(idx);
            end
            
            % Replace with the updated set.
            
            for idx = 1:length(mEntry.VirtualNames)
                vname = actxserver('IviConfigServer.IviVirtualName');
                vname.Name = mEntry.VirtualNames(idx).Name;
                vname.MapTo = mEntry.VirtualNames(idx).MapTo;
                comEntry.VirtualNames.Add(vname);
            end
        otherwise
            % Most fields have the same name and can be directly mapped.
            comEntry.(names{idx}) = mEntry.(names{idx});
    end
end

