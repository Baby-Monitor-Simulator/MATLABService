function isneq = ne(arg1, arg2)
%NE Overload of ~= for IVI Configuration Store objects.

%   Copyright 1999-2014 The MathWorks, Inc. 

% Warn appropriately if one of the input arguments is empty.
if isempty(arg1)
    if (length(arg2) == 1)
       isneq = [];
   else
       error(message('instrument:iviconfigurationstore:ne:dimagree'));
   end
   return;
elseif isempty(arg2)
   if (length(arg1) == 1)
       isneq = [];
   else
       error(message('instrument:iviconfigurationstore:ne:dimagree'));
   end
   return;
end

% Get size of objects.
sizeOfArg1 = size(arg1);
sizeOfArg2 = size(arg2);

% Error if both the objects have a length greater than 1 and have
% different sizes.
if (numel(arg1)~=1) && (numel(arg2)~=1)
    if ~(all(sizeOfArg1 == sizeOfArg2))
        error(message('instrument:iviconfigurationstore:ne:dimagree'))
    end
end

if (numel(arg1) == 1)
    if (numel(arg2) == 1)
        % Both have length of one.
        isneq = (arg1.cobject ~= arg2.cobject);
    else
        % First object has a length of one. Compare to each object
        % in the second argument.
        for idx = 1:numel(arg2)
            isneq(idx) = (arg1.cobject ~= arg2(idx).cobject);
        end
    end
else
    if (numel(arg2) == 1)
        % Second object has a length of one. Compare to each
        % object in the first argumetn.
        for idx = 1:numel(arg1)
            isneq(idx) = (arg1(idx).cobject ~= arg2.cobject);
        end
    else
        for idx = 1:numel(arg1)
            isneq(idx) = (arg1(idx).cobject ~= arg2(idx).cobject);
        end
    end
end
