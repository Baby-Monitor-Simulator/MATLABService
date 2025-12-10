function mStruct = privateFillStruct(mStruct, varargin)
%PRIVATEFILLSTRUCT Fill a configuration store structure with FV pairs.
%
%   PRIVATEFILLSTRUCT(MSTRUCT, F1, V1, F2, V2, ...) updates field values
%   in the user-visible configuration store structure, MSTRUCT.
%
%   This function should not be called directly by the user.

%   PE 10-01-03
%   Copyright 1999-2011 The MathWorks, Inc.

% Apply any field/value pairs.

if (~isempty(varargin))
    
    % Verify field/values arguments are pairs.
    
    if (mod(nargin - 1, 2) == 1)
        error(message('instrument:iviconfigurationstore:invalidArgsPVPair'));
    end

    mStruct = localApplyFieldValuePairs(mStruct, varargin{:});
end

% ------------------------------------------------------------------------------
% Given a set of field value pairs, update a struct.
% ------------------------------------------------------------------------------
function mStruct = localApplyFieldValuePairs(mStruct, varargin)

validFields = localValidFieldNames(mStruct.Type);

if (isempty(validFields))
    return;
end

for idx = 1:2:length(varargin)
    if any(strcmp(varargin{idx}, validFields))
        mStruct.(varargin{idx}) = varargin{idx + 1};
    else
        error(message('instrument:iviconfigurationstore:invalidArgs', varargin{ idx }, mStruct.Type, localValidFieldNameList( mStruct.Type )));
    end
end

% ------------------------------------------------------------------------------
% Return a list of valid field names for updating for each collection type.
% ------------------------------------------------------------------------------
function out = localValidFieldNames(type)

out = [];

switch type
    case 'HardwareAsset'
        out = {'Description', 'IOResourceDescriptor'};
    case 'DriverSession'
        out = {'Description', 'HardwareAsset', 'SoftwareModule', 'VirtualNames', 'Cache', 'QueryInstrStatus', 'InterchangeCheck', 'RangeCheck', 'DriverSetup', 'RecordCoercions', 'Simulate'};
    case 'LogicalName'
        out = {'Description', 'Session'};
end

% ------------------------------------------------------------------------------
% Return a comma separated list of field names appropriate for display as
% part of an error message.
% ------------------------------------------------------------------------------
function out = localValidFieldNameList(type)

switch type
    case 'HardwareAsset'
        out = 'Description and IOResourceDescriptor';
    case 'DriverSession'
        out = sprintf('\tDescription, HardwareAsset, SoftwareModule, VirtualNames, Cache, QueryInstrStatus,\n\tInterchangeCheck, RangeCheck, DriverSetup, RecordCoercions, and Simulate');
    case 'LogicalName'
        out = sprintf('\tDescription and Session');
end
