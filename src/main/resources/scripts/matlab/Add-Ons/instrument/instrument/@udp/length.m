function out = length(obj)
%LENGTH Length of instrument object array.
%
%   LENGTH(OBJ) returns the length of instrument object array,
%   OBJ. It is equivalent to MAX(SIZE(OBJ)).  
%   
%   See also UDP/SIZE, INSTRHELP.
%

%   MP 7-27-99
%   Copyright 1999-2004 The MathWorks, Inc. 


% The jobject property of the object indicates the number of 
% objects that are concatenated together.
out = builtin('length', obj.jobject);





