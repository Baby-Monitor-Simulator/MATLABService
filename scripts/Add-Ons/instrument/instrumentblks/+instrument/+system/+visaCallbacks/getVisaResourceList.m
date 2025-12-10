function list =  getVisaResourceList()
% GETVISARESOURCELIST returns the list of resources that are available.
%
% Copyright 2023 The MathWorks, Inc.

% Construct the list of resource names from visadevlist()
try
    list = ["<Select a resource name>", visadevlist("Timeout", 30).ResourceName'];
catch
    list = "<Select a resource name>";
end

end

