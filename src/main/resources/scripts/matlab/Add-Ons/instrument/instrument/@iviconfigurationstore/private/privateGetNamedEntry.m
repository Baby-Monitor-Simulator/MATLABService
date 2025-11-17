function [item, idx] = privateGetNamedEntry(collection, name)
%PRIVATEGETNAMEDENTRY Retrieve an entry from a COM collection by name.
%
%
%   This function should not be called directly by the user. 

%   PE 10-01-03
%   Copyright 1999-2008 The MathWorks, Inc. 

item = [];

idx = [];

for idx = 1:collection.Count
    if (strcmp(collection.Item(idx).Name, name) == 1)
        item = collection.Item(idx);
        return;
    end
end



