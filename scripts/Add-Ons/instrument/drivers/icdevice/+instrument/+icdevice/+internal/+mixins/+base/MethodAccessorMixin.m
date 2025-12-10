classdef MethodAccessorMixin < handle
    %METHODACCESSORMIXIN allows for getting and displaying all methods for
    %a Driver or Group class.

    %   Copyright 2022-2023 The MathWorks, Inc.

    properties (Abstract, Hidden, Constant)
        LocalMethodNames
    end

    properties (Abstract, Hidden)
        MDDMethodNames
    end

    properties (Constant, Hidden)
        MethodBufferSize = 4
        NumMethodsInLine = 6
    end

    methods
        function varargout = methods(obj)
            arguments
                obj
            end
            nargoutchk(0, 1);

            if ~isscalar(obj)
                obj = obj(1);
            end

            allClassMethods = sort(obj.LocalMethodNames);
            mddMethods = sort(obj.MDDMethodNames);

            if ~obj.ProductionMode
                methodList = [allClassMethods, mddMethods];
                propObj = instrument.icdevice.internal.forms.ProductionModeForm.empty;
                props = "methodList";
                for p = props
                    val = eval(p);

                    % Capitalize the first letter of p to access the
                    % ProductionModeForm properties correctly. Here, we
                    % are doing a 1-to-1 transfer of a local variables
                    % to class-level properties which hold different naming
                    % conventions for capitalization. This adjusts for
                    % the differences between the two.
                    p = upper(extractBefore(p,2)) + extractAfter(p,1);
                    propObj(1).(p) = val;
                end
                setPropertyToTest(obj, propObj);
            end

            if nargout == 0
                displayAllMethods(obj);
            else
                varargout{1} = cellstr(sort([allClassMethods, mddMethods]))';
            end

            %% NESTED FUNCTION
            function displayAllMethods(obj)
                disp(" ");
                disp(string(message("instrument_icdevice:driver:classMethods")));
                displayMethod(obj, allClassMethods);
                disp(" ");
                disp(string(message("instrument_icdevice:driver:driverMethods")));
                displayMethod(obj, mddMethods);
                disp(" ");

                %% NESTED FUNCTION
                function displayMethod(obj, methodNames)
                    mNames = string.empty;
                    maxLength = max(strlength(methodNames)) + obj.MethodBufferSize;
                    displayed = false;
                    for i = 1 : length(methodNames)

                        displayed = false;
                        methName = methodNames(i);
                        mLength = strlength(methName);
                        numSpaces = maxLength - mLength;
                        spaces = join(repmat(" ", 1, numSpaces), "");
                        methodDisplayStr = methName + spaces;

                        mNames = [mNames, methodDisplayStr];
                        if rem(i, obj.NumMethodsInLine) == 0
                            disp(join(mNames, ""));
                            mNames = string.empty;
                            displayed = true;
                        end
                    end

                    if ~displayed && ~isempty(mNames)
                        disp(join(mNames, ""));
                    end
                end
            end
        end
    end
end
