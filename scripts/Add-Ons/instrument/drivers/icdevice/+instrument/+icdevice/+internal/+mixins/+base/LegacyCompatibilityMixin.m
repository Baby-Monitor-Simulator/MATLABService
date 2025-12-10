classdef LegacyCompatibilityMixin < handle
    % LEGACYCOMPATIBILITYMIXIN class is designed to provide compatibility
    % between legacy and new property names. This class allows for the
    % conversion between old and new naming conventions for certain
    % properties.

    % Copyright 2024 The MathWorks, Inc.

    properties (Constant, Hidden)
        % LegacyPropertyNames defines the old naming conventions for
        % properties. These are the original property names used in older
        % versions of the interface.
        LegacyPropertyNames = ["littleEndian", "bigEndian"]

        % NewPropertyNames defines the new naming conventions for
        % properties that were previously known by the names in
        % LegacyPropertyNames.
        NewPropertyNames = ["little-endian", "big-endian"]
    end

    properties (Hidden)
        % IsLegacy indicates whether the interface object passed in to the
        % icdevice constructor for SCPI MDDs is a new interface type (e.g.
        % serialport, tcpclient, visadev, etc) or a legacy interface type
        % (e.g. serial, tcpip, visa)
        IsLegacy (1, 1) logical = false

        % IsSCPI indicates whether the current MDD is a SCPI-based
        % driver.
        % true - SCPI-based driver
        % false - otherwise
        IsSCPI (1, 1) logical = false
    end

    methods
        function setLegacyAndSCPIflags(obj, rsrc, isscpi)
            % IsLegacy and IsSCPI flags determines and sets the legacy and SCPI status
            % based on the provided resource. The resource could either be
            % a logical indicating the legacy status directly, or an object
            % that needs to be checked if it's an instance of
            % 'icinterface'.
            arguments
                obj 
                rsrc
                isscpi (1, 1) logical = false
            end

            if islogical(rsrc)
                obj.IsLegacy = rsrc;
                obj.IsSCPI = isscpi;
            else
                obj.IsLegacy = isa(rsrc, "icinterface");
                obj.IsSCPI = obj.InstrumentDriverType == instrument.icdevice.internal.DriverType.SCPIBasedMDD;
            end
        end

        function text = convertLegacyToNew(obj, text)
            % convertLegacyToNew converts text from legacy to
            % new property names if applicable. This method replaces
            % occurrences of legacy property names in the provided text
            % with their new equivalents, but only if the current
            % operation is not in legacy mode and the interface is SCPI.

            if obj.IsLegacy || ~obj.IsSCPI
                return
            end

            text = instrument.icdevice.internal.utility.TokenReplacer.customReplacement(text, ...
                obj.LegacyPropertyNames, obj.NewPropertyNames);
        end

        function text = convertNewToLegacy(obj, text)
            % convertNewToLegacy converts text from new to
            % legacy property names if applicable. This method replaces
            % occurrences of new property names in the provided text with
            % their legacy equivalents, but only if the current operation
            % is in SCPI mode and not in legacy mode.

            if ~obj.IsSCPI || obj.IsLegacy
                return
            end

            text = instrument.icdevice.internal.utility.TokenReplacer.customReplacement(text, ...
                obj.NewPropertyNames, obj.LegacyPropertyNames);
        end
    end
end