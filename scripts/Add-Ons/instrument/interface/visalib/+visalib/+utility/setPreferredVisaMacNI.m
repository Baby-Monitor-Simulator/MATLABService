function setPreferredVisaMacNI()
%SETPREFERREDVISAMACNI Sets the users's preferred VISA to NI (on the Mac
%only)

%   Copyright 2020 The MathWorks, Inc.
visalib.utility.setPreferredVisaOnTheMac("NI");
fprintf('%s\n', message('instrument:interface:visa:niVisaSelectedForTheMac'))
end