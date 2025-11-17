function checkSetValue(setValue, realValue) 
%CHECKSETVALUE function checks if instrument value is the
%same as user set value.

% Copyright 2013 The MathWorks, Inc.

% For comparing two doubles it is recommended to find the abs
% of the difference rather than an isequal comparison.
if (abs(setValue-realValue)>1e-10)
    setValueInString = num2str(setValue, '%10.5e\n');
    realValueInString = num2str(realValue, '%10.5e\n');
    warning off backtrace
    warning(message('instrument:qcinstrument:realValueIsDifferent', setValueInString, realValueInString ));
    warning on backtrace
end

end