classdef TableDataManager < matlabshared.mediator.internal.Publisher & ...
        matlabshared.mediator.internal.Subscriber
    %TABLEDATAMANAGER manages the Activity Log table and handles operations
    % such as injecting data into the table and clearing table data.

    % Copyright 2023 The MathWorks, Inc.

    properties (SetObservable)
        TableData
    end

    properties
        TableDetails
    end

    %% Lifetime
    methods
        function obj = TableDataManager(mediator)
            arguments
                mediator matlabshared.mediator.internal.Mediator
            end

            obj@matlabshared.mediator.internal.Publisher(mediator);
            obj@matlabshared.mediator.internal.Subscriber(mediator);
        end
    end

    %% Implement matlabshared.mediator.internal.Subscriber abstract methods
    methods
        function subscribeToMediatorProperties(obj, ~, ~)
            obj.subscribe("ClearTableDetails", ...
                @(src, event)obj.clearTableDetails());

            obj.subscribe("ActivityLogTableData", ...
                @(src, event)obj.injectRawTableData(event.AffectedObject.ActivityLogTableData));
        end
    end

    %% Subscriber Handler Functions
    methods
        function clearTableDetails(obj)
            obj.TableDetails = [];
        end

        function injectRawTableData(obj, src)
            obj.addTableDetails(src{1}, src{2}, src{3}, src{4}, src{5});
        end
    end

    %% Helper Functions
    methods (Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        function addTableDetails(obj, name, inputNames, inputValues, outputNames, outputValues)
            % Store data values as TableDetails and add to stored array of
            % TableDetails.

            tableDetails = ividevapp.utilities.forms.TableDetails;
            tableDetails.FcnOrPropName = name;
            tableDetails.InputArgs.Names = inputNames;
            tableDetails.InputArgs.Values = inputValues;
            tableDetails.OutputArgs.Names = outputNames;
            tableDetails.OutputArgs.Values = outputValues;
            obj.TableDetails = [obj.TableDetails, tableDetails];

            obj.setTableData();
        end

        function setTableData(obj)
            obj.TableData = obj.TableDetails;
        end
    end
end
