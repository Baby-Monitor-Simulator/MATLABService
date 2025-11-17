function vendor = getInternalVendorName(vendor)

%GETINTERNALVENDORNAME Returns the old vendor name for all vendors.
%
%   OUT = GETINTERNALVENDORNAME returns the older vendor names
%   for vendors that have undergone a name change. If the vendor name is unchanged,
%   it returns the current vendor name.

%   Copyright 2017 The MathWorks, Inc.

if strcmpi(vendor,'keysight')
   vendor = 'agilent';
end
end