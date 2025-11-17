function enum = getEnumerationFromString(enumValue, enumName )
% GETENUMERATIONFROMSTRING This function retrieves the enumerated value
% from the string enum value provided.

%   Copyright 2013 The MathWorks, Inc.

% Validate the arguments
validateattributes(enumValue,{'char'}, {'nonempty'})
validateattributes(enumName,{'char'}, {'nonempty'})

% Get the enum member values and names 
[enumMembers, enumMemberNames] = enumeration(enumName);

% Validate the enum value is part of enum member names
enumMemberName = validatestring(enumValue, enumMemberNames);

% Find and return the enum member value
for i = 1:numel(enumMembers)
    if(strcmpi(enumMemberName, char(enumMembers(i))))
        enum = enumMembers(i);
        return;
    end
end
end

