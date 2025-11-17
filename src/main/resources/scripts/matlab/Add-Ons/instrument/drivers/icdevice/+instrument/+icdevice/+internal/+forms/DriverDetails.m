classdef DriverDetails
%DRIVERDETAILS form class contains information about the driver,
%including NV pair names and default values for the icdevice
%constructor.

%   Copyright 2023-2024 The MathWorks, Inc.

    properties
        DriverName (1, 1) string
        DriverFullPath (1, 1) string
        DriverFound (1, 1) logical = false
        DriverResourceName

        NVPairs (1, 1) struct = instrument.icdevice.internal.forms.DriverDetails.NVPairDetails
        NVPairsLegacy (1, 1) struct = instrument.icdevice.internal.forms.DriverDetails.NVPairLegacyDetails
        UseErrorProxy (1, 1) logical = true
    end

    properties (Constant)
        % Properties that are no longer supported as NV pairs for the
        % icdevice function using the Driver interface. Setting any of
        % these properties as NV pairs and changing the default value will
        % result in a warning, and will be a NO-OP.
        UnsupportedNVPair (1, :) string = ["ObjectVisibility", "Name", "ConfirmationFcn"]

        % Properties that are supported as NV pairs for the icdevice
        % function using the Driver interface.
        SupportedNVPair (1, :) string = ["UserData", "Tag", "ProductionMode", "OptionString", "LegacyMode", "Timeout"]
    end

    properties (Constant, Access = private)
        % Default values for all NV Pairs (supported or unsupported)
        NVPairDefaultValues = dictionary( ...
            "UserData",{[]}, ...
            "Tag", {""}, ...
            "ProductionMode", {true}, ...
            "OptionString", {""}, ...
            "LegacyMode", {true}, ...
            "Timeout", {10}, ...
            "ObjectVisibility", {"on"}, ...
            "Name", {""}, ...
            "ConfirmationFcn", {''} ...
                                        )

        NVPairDetails (1, 1) struct = instrument.icdevice.internal.forms.DriverDetails.getNVPairStruct("supported")
        NVPairLegacyDetails (1, 1) struct = instrument.icdevice.internal.forms.DriverDetails.getNVPairStruct("unsupported")
    end

    methods (Static)
        function val = getDefaultNVPairValue(propName)
        % Returns the default value for each valid NV pair, supported
        % or unsupported.
            arguments
                propName (1, 1) string
            end

            val = instrument.icdevice.internal.forms.DriverDetails.NVPairDefaultValues(propName);
            val = val{:};
        end
    end

    methods (Static, Access = ?icdevice.accessor.UnitTest)

        function val = getNVPairStruct(type)
        % Creates and returns a struct containing the NV pairs names as
        % struct fields and their default values as the field values.

            arguments
                type (1, 1) string {mustBeMember(type, ["supported", "unsupported"])}
            end

            if type == "supported"
                fields = instrument.icdevice.internal.forms.DriverDetails.SupportedNVPair;
            else
                fields = instrument.icdevice.internal.forms.DriverDetails.UnsupportedNVPair;
            end

            val = struct;
            for f = fields
                val.(f) = instrument.icdevice.internal.forms.DriverDetails.getDefaultNVPairValue(f);
            end
        end
    end
end
