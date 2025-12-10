function obj = fgen(varargin)
% FGEN Construct a function generator object.
%
%   f = FGEN() creates a function generator to communicate
%   with a function generator instrument.
%
%     f = FGEN()
%     f = FGEN(Resource)
%     f = FGEN(Resource,Driver)
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
%   will automatically be called and your fgen object will be ready to use.
%
%   Example 1:
%
%       % Create function generator object and connect using the specified
%       % resource string.
%       f = fgen('TCPIP0::172.31.57.100::inst0::INSTR')
%
%       % Delete fgen object. If a connection to the instrument still
%       % exists it will be disconnected.
%       delete(f);
%
%   Example 2:
%
%       % Create function generator object and connect using the specified
%       % resource string and driver.
%       f = fgen('GPIB::ics::0::10','Agilent332x0_SCPI')
%
%       % Delete fgen object. If a connection to the instrument still
%       % exists it will be disconnected.
%       delete(f);
%
%   Example 3:
%
%       % Create function generator object.
%       f = fgen()
%
%       % Get available targets.
%       targets = resources(f)
%
%       % Set function generator resource.
%       f.Resource =  'TCPIP0::172.31.57.100::inst0::INSTR';
%
%       % Connect to the function generator.
%       connect(f);
%
%       % Disconnect from the function generator and clean up.
%       disconnect(f);
%       delete(f);

%   Copyright 2011-2023 The MathWorks, Inc.

try
    % This function throws only for maca64 platform.
    instrument.internal.errorMessagesHelpers.throwMacaNoSupportError(mfilename);

    obj = instrument.FGen(varargin{:});
catch ex
    throwAsCaller(ex);
end

