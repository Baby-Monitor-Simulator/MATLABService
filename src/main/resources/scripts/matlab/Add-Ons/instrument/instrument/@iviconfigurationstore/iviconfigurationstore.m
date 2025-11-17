classdef iviconfigurationstore
    %IVICONFIGURATIONSTORE Construct IVI configuration store object.
    %
    %   OBJ=IVICONFIGURATIONSTORE constructs an IVI configuration store object,
    %   OBJ, and establishes a connection to the IVI Configuration Server. The
    %   data in the default configuration store is used.
    %
    %   OBJ=IVICONFIGURATIONSTORE(FILE) constructs an IVI configuration store
    %   object, OBJ, and establishes a connection to the IVI Configuration
    %   Server. The data in the configuration store, FILE, is used. If FILE
    %   cannot be found or is not a valid configuration store, an error is
    %   returned.
    %
    % IVICONFIGURATIONSTORE Functions
    % IVICONFIGURATIONSTORE object construction.
    %   iviconfigurationstore - Construct IVI configuration store object.
    %
    % Getting and setting parameters.
    %   get                   - Get value of IVI configuration store object
    %                           property.
    %   set                   - Set value of IVI configuration store object
    %                           property.
    %
    % Updating IVI Configuration Store parameters.
    %   add                   - Add entry to IVI configuration store object.
    %   commit                - Save IVI configuration store object.
    %   remove                - Remove entry from IVI configuration store object.
    %   update                - Update entry in IVI configuration store object.
    %
    % IVICONFIGURATIONSTORE Properties
    %   ActualLocation        - Configuration store file used by IVI
    %                           configuration store object.
    %   DriverSessions        - Collection of driver sessions contained
    %                           in configuration store.
    %   HardwareAssets        - Collection of hardware assets contained
    %                           in configuration store.
    %   LogicalNames          - Collection of logical names contained in
    %                           configuration store.
    %   DefaultLocation       - Full pathname of default configuration store
    %                           file.
    %   Name                  - Name of IVI Configuration Server.
    %   ProcessLocation       - Configuration store file to be used by this
    %                           process, if not the default store.
    %   PublishedAPIs         - Collection of published APIS contained in
    %                           configuration store.
    %   Revision              - IVI Configuration Server version.
    %   ServerDescription     - IVI Configuration Server description.
    %   Sessions              - Collection of driver sessions contained in
    %                           configuration store.
    %   SoftwareModules       - Collection of software modules contained
    %                           in configuration store.
    %   SpecificationVersion  - Version of IVI Configuration Server
    %                           specification to which this revision complies.
    %   Vendor                - IVI Configuration Server vendor.
    %
    %   See also IVICONFIGURATIONSTORE/ADD, IVICONFIGURATIONSTORE/COMMIT,
    %   IVICONFIGURATIONSTORE/REMOVE.
    %
    
    %   Copyright 1999-2022 The MathWorks, Inc.
    
    properties (Hidden, SetAccess = 'public', GetAccess = 'public')
        cobject
        location
    end

    methods
        function obj = iviconfigurationstore(varargin)
            % convert to char in order to accept string datatype
            varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
            
            narginchk(0, 1);
            if nargin == 0
                try
                    h = actxserver('IviConfigServer.IviConfigStore');
                    h.ProcessDefaultLocation = '';
                catch %#ok<CTCH>
                    error(message('instrument:iviconfigurationstore:iviconfigurationstore:loadfailedAccess'));
                end
                
                try
                    Deserialize(h, h.MasterLocation);
                catch %#ok<CTCH>
                    error(message('instrument:iviconfigurationstore:iviconfigurationstore:loadfailed'));
                end
                obj.cobject = h;
                obj.location = h.ActualLocation;
            elseif isa(varargin{1},'iviconfigurationstore')
                obj = varargin{1};
            elseif ischar(varargin{1})
                try
                    h = actxserver('IviConfigServer.IviConfigStore');
                catch %#ok<CTCH>
                    error(message('instrument:iviconfigurationstore:iviconfigurationstore:loadfailedAccess'));
                end
                h.ProcessDefaultLocation = varargin{1};
                try
                    Deserialize(h, h.ProcessDefaultLocation);
                catch %#ok<CTCH>
                    error(message('instrument:iviconfigurationstore:iviconfigurationstore:loadfailedInvalid', varargin{ 1 }));
                end
                obj.cobject = h;
                obj.location = h.ActualLocation;
                
            else
                error(message('instrument:iviconfigurationstore:iviconfigurationstore:loadfailedString'));
            end
        end
        
    end

    methods (Hidden)
        function p = properties(obj)
            % properties - Returns the properties of the iviconfigurationstore object.
            p = fieldnames(obj);
        end
    end 
end
