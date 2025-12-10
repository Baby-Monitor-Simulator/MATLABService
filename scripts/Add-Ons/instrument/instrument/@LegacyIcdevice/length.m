function out = length(obj)
%LENGTH Length of instrument object array.
%
%   LENGTH(OBJ) returns the length of instrument object array, OBJ. 
%   It is equivalent to MAX(SIZE(OBJ)).  
%    
%   See also ICDEVICE/SIZE, INSTRHELP.
%

%   Copyright 1999-2024 The MathWorks, Inc. 


% The jobject property of the object indicates the number of 
% objects that are concatenated together.
try
   out = builtin('length', obj.jobject);
catch
   out = 1;
end




