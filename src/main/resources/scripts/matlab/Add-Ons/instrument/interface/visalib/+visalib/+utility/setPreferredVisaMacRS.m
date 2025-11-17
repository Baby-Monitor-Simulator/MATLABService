function setPreferredVisaMacRS()
%SETPREFERREDVISAMACRS Sets the users's preferred VISA to RS (on the Mac
%only)

%   Copyright 2020 The MathWorks, Inc.
visalib.utility.setPreferredVisaOnTheMac("RS");
fprintf('%s\n', message('instrument:interface:visa:rsVisaSelectedForTheMac'))
end