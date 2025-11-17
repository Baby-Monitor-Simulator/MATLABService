classdef (Hidden) RFSigGen < instrument.ieee4882.DriverBase
    % IEEE488.2 based rfsiggen class
    
    % Copyright 2017 The MathWorks, Inc.
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        % ACTIONFUNCTIONS This class contains functions and
        % sub-classes that initiate instrument operations and report
        % their status.  Read Only.
        ActionFunctions
        
        % UTILITYFUNCTIONS This class contains functions and
        % sub-classes that control common instrument operations.
        % These functions include many of functions that VXIplug&play
        % require, such as reset, self-test, revision query, error
        % query, and error message.  This class also contains
        % functions that access IVI error infomation, lock the
        % session, and perform instrument I/O.  Read Only.
        UtilityFunctions
        
        % RF This class contains all of the fundamental attributes
        % for the IviRFSigGen. Read Only.
        RF
        
        
        % IQ This class supports RFSigGens that can apply IQ
        % (vector) modulation to. Read Only.
        IQ
        
        % ARBGENERATOR This class contains the attributes to control
        % the internal arbitrary generator Read Only.
        ARBGenerator
        
        % MEMORY This class contains the functions to control
        % the internal memory Read Only.
        Memory
    end
    
    
    %% Constructor
    methods
        % Constructor
        function obj = RFSigGen(varargin)
            narginchk(1,2) ;
            obj.IntrumentType = 'rfsiggen';
            resource = varargin{1};
            switch (nargin)
                % Resource info only
                case 1
                    obj.DriverName = instrument.ieee4882.DriverUtility.getDriver(resource, obj.IntrumentType);
                case 2
                    instrument.ieee4882.DriverUtility.validateDriverName(varargin{2}, obj.IntrumentType);
                    obj.DriverName =  varargin{2};
            end
            
            if isempty ( obj.DriverName)
                error (message('instrument:ieee4882Driver:invalidDriver'));
            end
            obj.Interface = instrument.ieee4882.DriverUtility.createInterface (resource);
            
            % Initialize properties
            try
                obj.ActionFunctions = feval(str2func (['instrument.ieee4882.rfsiggen.', obj.DriverName , '.ActionFunctions']), obj.Interface);
                obj.UtilityFunctions = feval(str2func (['instrument.ieee4882.rfsiggen.', obj.DriverName , '.UtilityFunctions']), obj.Interface);
                obj.RF = feval(str2func (['instrument.ieee4882.rfsiggen.', obj.DriverName , '.RF']), obj.Interface);
                obj.IQ = feval(str2func (['instrument.ieee4882.rfsiggen.', obj.DriverName , '.IQ']), obj.Interface);
                obj.ARBGenerator = feval(str2func (['instrument.ieee4882.rfsiggen.', obj.DriverName , '.ARBGenerator']), obj.Interface);
                obj.Memory = feval(str2func (['instrument.ieee4882.rfsiggen.', obj.DriverName , '.Memory']), obj.Interface);
            catch myException
                getReport(myException)
            end
        end
        
        
        function resources = getResources (obj) %#ok<MANU>
            resources =  instrument.ieee4882.DriverUtility.getResources();
        end
        
        function delete(obj)
            obj.ActionFunctions = [];
            obj.UtilityFunctions = [];
            obj.RF = [];
            obj.IQ = [];
            obj.ARBGenerator = [];
            obj.Memory = [];
            delete(obj.Interface);
            obj.Interface = [];
        end
    end
    
    methods (Access = protected)
        function postConnectionHook(obj)
            % Clear instrument error and status queues to prevent existing
            % status messages from feeding through
            fprintf (obj.Interface, '*CLS');
            
            % Set the instruments default byte order for binblock
            % read/write based on the model.
            model = obj.UtilityFunctions.Model;            
            obj.ARBGenerator.SetDefaultByteOrder(model);
        end
    end
    
    
    %% Property access methods
    methods
        %% ActionFunctions property access methods
        function value = get.ActionFunctions(obj)
            if isempty(obj.ActionFunctions)
                obj.ActionFunctions = feval(str2func (['instrument.ieee4882.rfsiggen.', obj.DriverName , '.ActionFunctions']), obj.Interface);
            end
            value = obj.ActionFunctions;
        end
        
        %% UtilityFunctions property access methods
        function value = get.UtilityFunctions(obj)
            if isempty(obj.UtilityFunctions)
                obj.UtilityFunctions = feval(str2func (['instrument.ieee4882.rfsiggen.', obj.DriverName , '.UtilityFunctions']), obj.Interface);
            end
            value = obj.UtilityFunctions;
        end
        
        %% RF property access methods
        function value = get.RF(obj)
            if isempty(obj.RF)
                obj.RF = feval(str2func (['instrument.ieee4882.rfsiggen.', obj.DriverName , '.RF']), obj.Interface);
            end
            value = obj.RF;
        end
        
        
        %% IQ property access methods
        function value = get.IQ(obj)
            if isempty(obj.IQ)
                obj.IQ = feval(str2func (['instrument.ieee4882.rfsiggen.', obj.DriverName , '.IQ']), obj.Interface);
            end
            value = obj.IQ;
        end
        
        %% ARBGenerator property access methods
        function value = get.ARBGenerator(obj)
            if isempty(obj.ARBGenerator)
                obj.ARBGenerator = feval(str2func (['instrument.ieee4882.rfsiggen.', obj.DriverName , '.ARBGenerator']), obj.Interface);
            end
            value = obj.ARBGenerator;
        end
        
        %% Memory property access methods
        function value = get.Memory(obj)
            if isempty(obj.Memory)
                obj.Memory = feval(str2func (['instrument.ieee4882.rfsiggen.', obj.DriverName , '.Memory']), obj.Interface);
            end
            value = obj.Memory;
        end
    end
end
