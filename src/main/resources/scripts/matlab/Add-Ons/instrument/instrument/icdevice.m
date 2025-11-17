function obj = icdevice(varargin)
% ICDEVICE is a factory function which handles construction of an icdevice
% object using either the LegacyIcdevice constructor or the Driver
% constructor.
%
% This function is designed to construct an icdevice object, with the
% type—either a legacy icdevice object or a driver-based icdevice
% object—determined by the input arguments provided.
%
% The function checks if it should directly create a legacy icdevice object
% without performing any additional checks. This can happen in two
% scenarios:
%
%     - If the shortCircuitToLegacy function returns true, indicating that
%     the legacy object should be created regardless of other conditions.
%
%     - If there is exactly one input argument and it is a Java object,
%     which suggests that the call is coming from legacy code that expects
%     a legacy icdevice object.
%
% If the legacy short circuit does not apply, the function proceeds to
% populate driver details from the input arguments. It processes the
% arguments to extract name-value pairs and other required parameters.
%
% The LegacyMode flag of the DriverDetails instance signifies whether we
% create a Driver instance (for LegacyMode = false) or LegacyIcdevice
% instance (for LegacyMode = true [default]).
%
% Before creating the driver-based object, the function checks for any
% invalid or unsupported name-value pairs in the driver details. It ensures
% that only valid and supported arguments are passed to the driver
% constructor.
%
% For legacy implementation, we remove all instances of any new NV pairs
% added for the Driver class before forwarding varargin to the
% LegacyIcdevice class.

% Copyright 2024 The MathWorks, Inc.

if nargin == 0
    error(message('instrument:icdevice:icdevice:toofewargs'));
end

narginchk(1, inf);

% Create the legacy icdevice object if needed. It is needed for the
% following cases -
%
% a. Short circuited - Needed to override all checks and call the legacy
% icdevice object. Needed (internally) for gradual code migration to use
% "Driver" instead of "LegacyIcdevice".
%
% b. If the icdevice factory is called by the legacy icdevice code (or any
% code using legacy icdevice object, e.g. instrfind and instrreset). For
% this case, the object passed in as an input argument to the icdevice
% factory function is the legacy icdevice java handle, or the legacy
% icdevice UDD class instance.
%
% The conditional check (nargin == 1 && isJavaObject(varargin{1})) is
% necessary to handle cases where "instrfind" for a legacy icdevice object
% returns a raw Java handle. In such cases, this raw Java handle is passed
% to the icdevice constructor to create a MATLAB icdevice object that wraps
% the raw Java handle. This ensures that the icdevice factory function
% can correctly reconstruct legacy icdevice objects from their associated
% Java handles, maintaining compatibility with the existing codebase.
if shortCircuitToLegacy(varargin{:}) || (nargin == 1 && isJavaObject(varargin{1}))
    obj = LegacyIcdevice(varargin{:});
    return
end

% Identify indices of varargin that contain NV Pairs. The identification is
% essential to extract the NV pairs from other required or positional input
% arguments. populateDriverDetailsFromInput returns an instance of
% instrument.icdevice.internal.forms.DriverDetails. This contains parsed
% information from NV Pairs
%
% 1. NV Pairs supported by the Driver interface
%
% 2. Legacy NV Pairs that are no longer supported by the Driver interface
%
% 3. NV Pairs (like "foo", "var") that are not valid for the Driver object
driverDetails = instrument.icdevice.internal.utility.DriverUtility.populateDriverDetailsFromInput(varargin{:});
useLegacy = driverDetails.NVPairs.LegacyMode;

if ~useLegacy
    % parseUnmatched checks the driverDetails object for any invalid or
    % legacy name-value pairs (NV pairs). It throws an error for any
    % invalid NV pairs that are not recognized by the driver details. For
    % legacy NV pairs that are no longer supported, it issues a warning
    % indicating that these pairs have been deprecated.
    instrument.icdevice.internal.utility.DriverUtility.parseUnmatched(driverDetails);
    try
        obj = instrument.icdevice.internal.Driver(driverDetails);
    catch ex
        throwAsCaller(ex);
    end
    return
end

% Get indices of all NV pairs that are not currently supported by legacy
% icdevice. These need to be removed from varargin before moving them along
% to legacy icdevice.
toRemoveIdx = getNVPairIndicesUnsupportedByLegacy(varargin{:});
varargin(toRemoveIdx) = [];

try
    obj = LegacyIcdevice(varargin{:});
catch ex
    throwAsCaller(ex);
end

%% NESTED FUNCTION
function idx = getNVPairIndicesUnsupportedByLegacy(varargin)
% Get the indices of names and values from varargin that are
% currently supported by the driver infrastructure, but not by legacy
% icdevice.

allInputs = string.empty;

% "Legacy", "product" are shortened names for "LegacyMode",
% "ProductionMode" NV Pair names. These are new NV Pairs added to the
% Driver interface, that needs to be removed from the varargin list before
% varargin is forwarded to the LegacyIcdevice constructor
allNVPairNamesUnsupported = ["Legacy", "product"];

% Replace all non-char or non-string instances of the varargin with a
% custom string token. This is needed to convert all input arguments to
% string, which will later be fed to an index finder to do a string compare
% and find the NV pair name indices. The actual value of the string object
% does not matter for finding the indices as long as the type is string.
%
% e.g. if varargin is {["tktds1k2k"], [1x1 visadevObject],
% ["optionstring"], ["simulate=true"]},
%
% the new list will now be
%
% {["tktds1k2k"], ["MW_ICT_TOKEN"], ["optionstring"], ["simulate=true"]}
for i = 1:length(varargin)
    if ischar(varargin{i}) || isstring(varargin{i})
        allInputs(end+1) = string(varargin{i}); %#ok<*AGROW>
    else
        allInputs(end+1) = "MW_ICT_TOKEN";
    end
end

idx = [];

for name = allNVPairNamesUnsupported
    % The NV Pair "name" index.

    currIdx = findIndexOfNVPair(allInputs, name);

    if ~isempty(currIdx)
        idx(end+1) = currIdx;

        % The NV Pair "value" index.
        idx(end+1) = currIdx + 1;
    end
end

    %% NESTED FUNCTION
    function idx = findIndexOfNVPair(list, matchingText)
        idx = find(startsWith(list, matchingText, IgnoreCase=true));

        % NV Pair not found. Return index = [].
        if isempty(idx)
            idx = [];
            return
        end

        idx = idx(end);

        % NV Pairs cannot be the first input argument.
        if idx == 1
            throw(MException(message("instrument_icdevice:icdevice_factory:driverNameFirstInput")));
        end
    end
end

    %% NESTED FUNCTION
    function flag = isJavaObject(val)
        % Returns true if val is either
        %
        % a. A legacy icdevice object, or
        %
        % b. A java instance, or
        %
        % c. A UDD object instance.
        %
        % Return false otherwise.
        flag = contains(class(val), "javahandle") || (isa(val, "icdevice") && ~isa(val, "instrument.icdevice.internal.Driver")) || ...
            ~(isstring(val) || ischar(val));
    end

    %% NESTED FUNCTION
    function flag = shortCircuitToLegacy(varargin)
        % Function needed to bypass all checks and call the legacy icdevice
        % constructor. This is needed (internally) for gradual migration
        % from legacy icdevice to Driver.
        %
        % If the flag is true, the legacy object is created at the start,
        % making the useLegacy flag inaccessible. Therefore, it's set to
        % false to ensure the legacy object is created after checking the
        % useLegacy flag.
        flag = false;
    end
end