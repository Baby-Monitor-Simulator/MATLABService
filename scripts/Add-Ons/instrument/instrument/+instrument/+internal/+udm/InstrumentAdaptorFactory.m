classdef (Hidden)InstrumentAdaptorFactory < handle
    %InstrumentAdaptorFactory class for creating instrument objects
    % InstrumentFactory uses chain of responsibility pattern to generate
    % instrument objects based on the instrument type, resource or driver
    % name.
    
    % Copyright 2011-2021 The MathWorks, Inc.
    
    methods(Static)
        
        function [scopeAdaptor, driver] = createAdaptor( varargin)
            %CreateAdaptor method follows the chain of responsbility pattern, it
            %iterates througg each adaper. If an adapter can handle the
            %situation,it will create itself and return. Otherwise it
            %passes the responsibility to the next available adapter.
            %Note: The order of adapters is important and it is specified
            %in the adapters.config file.
            
            scopeAdaptor = [];
            driver = '';

            % function pragma is required to make sure that MATLAB Compiler's dependency analysis detects the functions and include them in the compilation
            %#function instrument.internal.udm.oscilloscope.IvicScopeAdaptor.createByResource instrument.internal.udm.oscilloscope.IEEE4882ScopeAdaptor.createByResource instrument.internal.udm.oscilloscope.ScopeTestAdaptor.createByResource
            %#function instrument.internal.udm.oscilloscope.IvicScopeAdaptor.createByDriverAndResource instrument.internal.udm.oscilloscope.IEEE4882ScopeAdaptor.createByDriverAndResource instrument.internal.udm.oscilloscope.ScopeTestAdaptor.createByDriverAndResource
            %#function instrument.internal.udm.fgen.IvicFgenAdaptor.createByResource instrument.internal.udm.fgen.IEEE4882FgenAdaptor.createByResource instrument.internal.udm.fgen.FgenTestAdaptor.createByResource
            %#function instrument.internal.udm.fgen.IvicFgenAdaptor.createByDriverAndResource instrument.internal.udm.fgen.IEEE4882FgenAdaptor.createByDriverAndResource instrument.internal.udm.fgen.FgenTestAdaptor.createByDriverAndResource
            %#function instrument.internal.udm.rfsiggen.IvicRFSigGenAdaptor.createByResource instrument.internal.udm.rfsiggen.IEEE4882RFSigGenAdaptor.createByResource instrument.internal.udm.rfsiggen.RFSigGenTestAdaptor.createByResource
            %#function instrument.internal.udm.rfsiggen.IvicRFSigGenAdaptor.createByDriverAndResource instrument.internal.udm.rfsiggen.IEEE4882RFSigGenAdaptor.createByDriverAndResource instrument.internal.udm.rfsiggen.RFSigGenTestAdaptor.createByDriverAndResource

            instrumentType = char(varargin{1});
            %get a list of adapters based on given instrument type
            adaptors = instrument.internal.udm.InstrumentUtility.getAdapterList(instrumentType);
            
            narginchk(2,3);
            switch (nargin)
                %create an adapter based on the resource information.
                case 2
                    resource = char(varargin{2});
                    for i = 1: size (adaptors , 2)
                        [scopeAdaptor, driver] = feval(str2func([adaptors{i}.Name '.createByResource']), resource);
                        if ~isempty (scopeAdaptor)
                            break;
                        else
                            continue;
                        end
                    end
                    %create an adapter based on the resource and driver information.
                case 3
                    resource = char(varargin{2});
                    driverName = varargin{3};
                    for i = 1: size (adaptors , 2)
                        [scopeAdaptor, driver] = feval(str2func([adaptors{i}.Name '.createByDriverAndResource']), driverName, resource);
                        if ~isempty (scopeAdaptor)
                            break;
                        else
                            continue;
                        end
                    end
            end
            
        end
        
    end
end