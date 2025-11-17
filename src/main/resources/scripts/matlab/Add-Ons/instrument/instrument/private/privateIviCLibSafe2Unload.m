function safe2Unload = privateIviCLibSafe2Unload(libName)
%PRIVATEIVICLIBSAFE2UNLOAD checks if the IVI-C library safe to unload.
%   PRIVATEIVICLIBSAFE2UNLOAD(LIBNAME) check if the IVI-C shared library  
%   cause problems when it is unload.  

%    This undocumented file may be removed in a future release.

%   Copyright 2010 The MathWorks, Inc.

 badLibraryList = {};
 
 if ismember(libName, badLibraryList)
     safe2Unload = false;
 else
     safe2Unload = true;
 end
     
 