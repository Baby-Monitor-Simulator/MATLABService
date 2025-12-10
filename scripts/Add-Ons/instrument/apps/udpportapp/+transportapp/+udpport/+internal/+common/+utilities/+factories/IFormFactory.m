classdef (Abstract) IFormFactory
    % IFORMFACTORY is the interface that all FormFactory classes need to implement.
    % It contains abstract methods that these implementing classes need to provide
    % an implementation for.

    % Copyright 2021 The MathWorks, Inc.

    methods(Abstract, Static)
        toolstripForm = createToolstripForm(transportName, transportInstance, ...
            destinationAddress, destinationPort)

        appSpaceForm = createAppSpaceForm()
    end
end

