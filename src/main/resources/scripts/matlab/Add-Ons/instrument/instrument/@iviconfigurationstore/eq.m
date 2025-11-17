function iseq = eq(arg1, arg2)
%EQ Overload of == for IVI Configuration Store objects.

%   Copyright 1999-2014 The MathWorks, Inc. 

% Warn appropriately if one of the input arguments is empty.
if isempty(arg1)
    if (length(arg2) == 1)
       iseq = [];
   else
       error(message('instrument:iviconfigurationstore:eq:dimagree'));
   end
   return;
elseif isempty(arg2)
   if (length(arg1) == 1)
       iseq = [];
   else
       error(message('instrument:iviconfigurationstore:eq:dimagree'));
   end
   return;
end

sizeOfArg1 = size(arg1);
sizeOfArg2 = size(arg2);

if (numel(arg1)~=1) && (numel(arg2)~=1)
    if ~(all(sizeOfArg1 == sizeOfArg2))
        error(message('instrument:iviconfigurationstore:eq:dimagree'))
    end
end

if (numel(arg1) == 1)
    if (numel(arg2) == 1)
        iseq = (arg1.cobject == arg2.cobject);
    else
        for idx = 1:numel(arg2)
            iseq(idx) = (arg1.cobject == arg2(idx).cobject);
        end
    end
else
    if (numel(arg2) == 1)
        for idx = 1:numel(arg1)
            iseq(idx) = (arg1(idx).cobject == arg2.cobject);
        end
    else
        for idx = 1:numel(arg1)
            iseq(idx) = (arg1(idx).cobject == arg2(idx).cobject);
        end
    end
end
