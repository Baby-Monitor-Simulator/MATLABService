function obj = privateObjectIndexer(objs, index)
%PRIVATEADDGROUPOBJECTS add objects to a group.
%
%    PRIVATEADDGROUPOBJECTS(OBJ, GROUPNAME, SIZE, NAME) adds
%    additional objects to the group, GROUPNAME, after the device
%    object, OBJ, has been constructed. SIZE Is the new size of the
%    group. NAMES is a cell of HwNames for each group object that
%    will be added to the group.
%
%   This function should not be called directly by the user.
%  
 
%   MP 11-06-03
%   Copyright 1999-2004 The MathWorks, Inc. 

obj = objs(index);
