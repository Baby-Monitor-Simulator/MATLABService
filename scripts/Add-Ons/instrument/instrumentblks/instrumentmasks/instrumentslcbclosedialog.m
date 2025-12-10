function instrumentslcbclosedialog(obj, dlg)
%INSTRUMENTSLCBCLOSEDIALOG Callback to handle the dialog close request.
%
%    INSTRUMENTSLCBCLOSEDIALOG(OBJ, DLG) performs the close callback request using 
%    the dynamic dialog object DLG and the dialog's source object OBJ.
%
%    This function is invoked every time the mask is closed, regardless
%    what action was taken.

%    SS 03-03-07
%    Copyright 2007 The MathWorks, Inc.

% Destroy an ICT objects created before closing the mask.

% Close the DDG dialog.
closeCallback(obj, dlg);