classdef  IviScope < instrument.ivic.IviScopeSpecification
    %IVISCOPE IviScope MATLAB wrapper provides programming support
    %for the IVI-C Scope Class.
    %
    %IVISCOPE will be removed in a future release. Use <a href="matlab:help ividev">ividev</a> instead.
    %
    %The driver contains all the functionalities required in the IviScope
    %specification defined by the IVI Foundation. This wrapper requires
    %VISA, IVI Compliance Package and an IVI instrument specific driver
    %that is compliant with the IviScope class. The IviScope class wrapper
    %accesses the specific driver using the logical name in the
    %configuration store.
    %
    %   OBJ = instrument.ivic.IviScope() constructs an IVI-C Scope object.
    %
    %   In order to communicate with the instrument, the device object must be
    %   connected to the instrument with the init() or InitWithOption() function.
    %
    %   Example using a MATLAB IVI-C Scope class complaint instrument wrapper:
    %
    %       % Construct an IVI-C Scope object
    %       scopeObj = instrument.ivic.IviScope();
    %
    %       % Connect to the instrument via logical name 'myscope'
    %       scopeObj.init('myscope', false, false);
    %
    %       % Connect to the instrument via logical name 'myscope' in
    %       simulation mode
    %       scopeObj.InitWithOption('myscope', false, false, 'simulate=true');
    %
    %       % Disconnect from the instrument and clean up.
    %       scopeObj.close();
    %       delete(scopeObj);
    
    % Copyright 2010-2022 The MathWorks, Inc.
    
    %% Construction
    methods
        function obj = IviScope()
            try
                instrument.internal.ICTRemoveFunctionalityHelper(mfilename, "Warn", "Class");
            catch ex
                throwAsCaller(ex);
            end

            narginchk(0,0)
            instrgate ('privateCheckNICPVersion');
            % construct superclass
            obj@instrument.ivic.IviScopeSpecification();
            
        end
        
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        
    end
    
    %% methods
    methods
        %override base class's init() method
        function init(obj, LogicalName,IDQuery,ResetDevice)
            obj.init@instrument.ivic.IviScopeSpecification(LogicalName,IDQuery,ResetDevice);
            obj.WaveformMeasurementWM.setLibraryAndSession(obj.libName, obj.session);
            obj.TriggerSubsystem.setLibraryAndSession(obj.libName, obj.session);
            obj.ChannelSubsystem.setLibraryAndSession(obj.libName, obj.session);
            obj.Acquisition.setLibraryAndSession(obj.libName, obj.session);
            obj.InherentIVIAttributes.setLibraryAndSession(obj.libName, obj.session);
            obj.Utility.setLibraryAndSession(obj.libName, obj.session);
            obj.WaveformAcquisition.setLibraryAndSession(obj.libName, obj.session);
            obj.Configuration.setLibraryAndSession(obj.libName, obj.session);
        end
        
        
        %override base class's InitWithOptions() method
        function  InitWithOptions(obj,LogicalName,IDQuery,ResetDevice,OptionString)
            obj.InitWithOptions@instrument.ivic.IviScopeSpecification(LogicalName,IDQuery,ResetDevice,OptionString );
            obj.WaveformMeasurementWM.setLibraryAndSession(obj.libName, obj.session);
            obj.TriggerSubsystem.setLibraryAndSession(obj.libName, obj.session);
            obj.ChannelSubsystem.setLibraryAndSession(obj.libName, obj.session);
            obj.Acquisition.setLibraryAndSession(obj.libName, obj.session);
            obj.InherentIVIAttributes.setLibraryAndSession(obj.libName, obj.session);
            obj.Utility.setLibraryAndSession(obj.libName, obj.session);
            obj.WaveformAcquisition.setLibraryAndSession(obj.libName, obj.session);
            obj.Configuration.setLibraryAndSession(obj.libName, obj.session);
        end
        
        %override base class's close() method
        function close(obj)
            obj.close@instrument.ivic.IviScopeSpecification();
            obj.session=[];
            obj.WaveformMeasurementWM.setLibraryAndSession(obj.libName, obj.session);
            obj.TriggerSubsystem.setLibraryAndSession(obj.libName, obj.session);
            obj.ChannelSubsystem.setLibraryAndSession(obj.libName, obj.session);
            obj.Acquisition.setLibraryAndSession(obj.libName, obj.session);
            obj.InherentIVIAttributes.setLibraryAndSession(obj.libName, obj.session);
            obj.Utility.setLibraryAndSession(obj.libName, obj.session);
            obj.WaveformAcquisition.setLibraryAndSession(obj.libName, obj.session);
            obj.Configuration.setLibraryAndSession(obj.libName, obj.session);
        end
        
    end
end
