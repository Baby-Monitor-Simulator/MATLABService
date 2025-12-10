function obj = oscilloscope(varargin)
% OSCILLOSCOPE Construct an oscilloscope object.
%
%   o = OSCILLOSCOPE() creates an oscilloscope to communicate
%   with a oscilloscope instrument.
%
%     o = OSCILLOSCOPE()
%     o = OSCILLOSCOPE(Resource)
%     o = OSCILLOSCOPE(Resource,Driver)
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
%   will automatically be called and your oscilloscope object will be ready
%   to use.
%
%   Example 1:
%
%       % Create oscilloscope object and connect using the specified
%       % resource string.
%       o = oscilloscope('TCPIP0::a-m6104a-004598::INSTR')
%
%       % Delete oscilloscope object. If a connection to the instrument
%       % still exists it will be disconnected.
%       delete(o);
%
%   Example 2:
%
%       % Create oscilloscope object and connect using the specified
%       % resource string and driver.
%       o = oscilloscope('GPIBO::AGILENT::7::10','tektronix')
%
%       % Delete oscilloscope object. If a connection to the instrument
%       % still exists it will be disconnected.
%       delete(o);
%
%   Example 3:
%
%       % Create oscilloscope object
%       o = oscilloscope()
%
%       % Get available targets
%       targets = resources (o)
%
%       % Set oscilloscope resource
%       o.Resource = 'TCPIP0::a-m6104a-004598::INSTR');
%
%       % Connect to the oscilloscope.
%       connect(o);
%
%       % Disconnect from the oscilloscope and clean up.
%       disconnect(o);
%       delete(o);

%   Copyright 2011-2023 The MathWorks, Inc.

try
    % This function throws only for maca64 platform.
    instrument.internal.errorMessagesHelpers.throwMacaNoSupportError(mfilename);

    obj = instrument.Oscilloscope(varargin{:});
catch ex
    throwAsCaller(ex);
end

