function close(varargin) 
%CLOSE Close figure.
%
%   CLOSE(H) closes the window with handle H.
%   CLOSE, by itself, closes the current figure window.
%  
%   CLOSE('name') closes the named window.
%  
%   CLOSE ALL  closes all the open figure windows.
%   CLOSE ALL HIDDEN  closes hidden windows as well.
%     
%   STATUS = CLOSE(...) returns 1 if the specified windows were closed
%   and 0 otherwise.
%  
%   See also DELETE.

%   Copyright 1999-2024 The MathWorks, Inc. 

error(message('instrument:icdevice:close:unsupportedFcn'));
