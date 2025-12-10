function obj = instrumentcreatedialog(h,className)
%INSTRUMENTCREATEDIALOG Instantiates a instrument control dynamic dialog object.
%
%    OBJ = INSTRUMENTCREATEDIALOG returns OBJ, a instrument control dynamic 
%    dialog object.

%    SS 03-01-07
%    Copyright 2007 The MathWorks, Inc.

obj = instrumentdialog.(className{1})(h);
