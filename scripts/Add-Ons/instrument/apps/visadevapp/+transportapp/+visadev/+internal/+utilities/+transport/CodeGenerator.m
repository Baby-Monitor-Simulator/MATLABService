classdef CodeGenerator < matlabshared.transportapp.internal.utilities.transport.CodeGenerator
    %MATLABCODEGENERATOR publishes requests for generating MATLAB code for
    %the Code Log Section of the app for any property setters. Specializes
    %the Shared App CodeGenerator class to add support for EOIMode. Used by
    %TransportProxy classes to publish edits to transport properties.

    % Copyright 2022 The MathWorks, Inc.

    methods
        function generatePropertySetterCode(obj, transport, propertyName)
            switch propertyName
                case "EOIMode"
                    % Cast EOIMode value from matlab.lang.OnOffSwitchState so that
                    % generated code will be valid.
                    % OnOffSwitchState -> v.EOIMode = off; % Invalid code
                    % logical -> v.EOIMode = false; % Valid code
                    obj.PropertyNameValue = {propertyName, logical(transport.EOIMode)};

                case {"FlowControl", "Parity"}
                    % FlowControl and Parity are enumerations and need to
                    % be cast to string for code generation.
                    obj.PropertyNameValue = {propertyName, string(transport.(propertyName))};

                otherwise
                    generatePropertySetterCode@matlabshared.transportapp.internal.utilities.transport.CodeGenerator(obj, transport, propertyName);
                    
            end
        end
    end
end