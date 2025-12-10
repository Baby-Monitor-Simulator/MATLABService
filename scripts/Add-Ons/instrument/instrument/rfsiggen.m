function obj = rfsiggen(varargin)
% RFSIGGEN Construct a RF signal generator object.
%
%   rf = RFSIGGEN() creates a RF signal generator to communicate
%   with a RF signal generator instrument.
%
%     rf = RFSIGGEN()
%     rf = RFSIGGEN(Resource)
%     rf = RFSIGGEN(Resource, Driver)
%
%   Arguments:
%     Resource - Resource string for the instrument you wish to communicate
%                with. This parameter is optional and can be used if you
%                know the resource string for your instrument.
%     Driver   - The underlying driver to use with the instrument. This
%                string parameter is optional, if it is not specified the
%                driver will be auto-detected.
%
%   If Resource or Resource and Driver are passed in, the connect function
%   will automatically be called and your rfsiggen object will be ready to use.
%
%   Example 1:
%
%       % Create RF signal generator object and connect using the specified
%       % resource string.
%       rf = rfsiggen('TCPIP0::172.28.22.99::inst0::INSTR')
%
%       % Delete rfsiggen object. If a connection to the instrument still
%       % exists it will be disconnected.
%       clear rf;
%
%   Example 2:
%
%       % Create RF signal generator object and connect using the specified
%       % resource string and driver.
%       rf = rfsiggen('TCPIP0::172.28.22.99::inst0::INSTR','AgRfSigGen')
%
%       % Delete rfsiggen object. If a connection to the instrument still
%       % exists it will be disconnected.
%       clear rf;
%
%   Example 3:
%
%       % Create RF signal generator object.
%       rf = rfsiggen()
%
%       % Get available targets.
%       targets = resources(rf)
%
%       % Set RF signal generator resource.
%       rf.Resource =  'TCPIP0::172.28.22.99::inst0::INSTR';
%
%       % Connect to the RF signal generator.
%       connect(rf);
%
%       % Disconnect from the RF signal generator and clean up.
%       disconnect(rf);
%       clear rf;

%   Copyright 2017-2023 The MathWorks, Inc.

try
    % This function throws only for maca64 platform.
    instrument.internal.errorMessagesHelpers.throwMacaNoSupportError(mfilename);

    obj = instrument.RFSigGen(varargin{:});
catch ex
    throwAsCaller(ex);
end


