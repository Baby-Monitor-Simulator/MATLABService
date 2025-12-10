function collectionItemName = privateGetCollectionItemName(collectionName)
%PRIVATEGETCOLLECTIONTITEMNAME helper function figure out the collection's
%sub item name given a collection name.
%
%
%   This function should not be called directly by the user.
%
%   Example:
%       channel = privateGetCollectionItemName('channels');
%       channel2 = privateGetCollectionItemName('channels2');
%
%   YW 05-09-08
%   Copyright 2008 The MathWorks, Inc.
collectionItemName='';
for idx = length(collectionName):-1:1
    if isempty(str2num(collectionName(idx)))
        break;
    end
end
if (ne(idx, length(collectionName)) && collectionName(idx )== 's')
    collectionItemName = strcat (collectionName(1:idx -1) , collectionName(length(collectionName)));
end

if (collectionName(length(collectionName)) =='s')
    collectionItemName = collectionName(1:length(collectionName) -1);
end
