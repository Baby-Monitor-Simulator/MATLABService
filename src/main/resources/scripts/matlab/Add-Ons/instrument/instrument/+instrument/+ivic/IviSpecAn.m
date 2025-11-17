classdef  IviSpecAn < instrument.ivic.IviSpecAnSpecification
    %IVISPECAN IviSpecAn MATLAB wrapper provides programming support
    %for the IVI-C SpecAn Class.
    %
    %IVISPECAN will be removed in a future release. Use <a href="matlab:help ividev">ividev</a> instead.
    %
    %The driver contains all the functionalities required in the IviSpecAn
    %specification defined by the IVI Foundation. This wrapper requires
    %VISA, IVI Compliance Package and an IVI instrument specific driver
    %that is compliant with the IviSpecAn class. The IviSpecAn class
    %wrapper accesses the specific driver using the logical name in the
    %configuration store.
    %
    %   OBJ = instrument.ivic.IviSpecAn() constructs an IVI-C SpecAn object.
    %
    %   In order to communicate with the instrument, the device object must be
    %   connected to the instrument with the init() or InitWithOption() function.
    %
    %   Example using a MATLAB IVI-C SpecAn class complaint instrument wrapper:
    %
    %       % Construct an IVI-C SpecAn object
    %       specAnObj = instrument.ivic.IviSpecAn();
    %
    %       % Connect to the instrument via logical name 'mySpecAn'
    %       specAnObj.init('mySpecAn', false, false);
    %
    %       % Connect to the instrument via logical name 'mySpecAn' in
    %       simulation mode
    %       specAnObj.InitWithOption('mySpecAn', false, false, 'simulate=true');
    %
    %       % Disconnect from the instrument and clean up.
    %       specAnObj.close();
    %       delete(specAnObj);
    
    % Copyright 2010-2022 The MathWorks, Inc.
    
    %% Construction
    methods
        function obj = IviSpecAn()
            try
                instrument.internal.ICTRemoveFunctionalityHelper(mfilename, "Warn", "Class");
            catch ex
                throwAsCaller(ex);
            end

            narginchk(0,0)
            instrgate ('privateCheckNICPVersion');
            % construct superclass
            obj@instrument.ivic.IviSpecAnSpecification();
            
        end
        
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        
    end
    
    %% methods
    methods
        %override base class's init() method
        function init(obj, LogicalName,IDQuery,ResetDevice)
            obj.init@instrument.ivic.IviSpecAnSpecification(LogicalName,IDQuery,ResetDevice);
            obj.updateLibraryAndSession();
        end
        
        
        %override base class's InitWithOptions() method
        function  InitWithOptions(obj,LogicalName,IDQuery,ResetDevice,OptionString)
            obj.InitWithOptions@instrument.ivic.IviSpecAnSpecification(LogicalName,IDQuery,ResetDevice,OptionString );
            obj.updateLibraryAndSession();
        end
        
        %override base class's close() method
        function close(obj)
            obj.close@instrument.ivic.IviSpecAnSpecification();
            obj.session=[];
            obj.updateLibraryAndSession();
         
        end
        
        %helper function to update driver's session
        function updateLibraryAndSession(obj)

            obj.ExternalMixing.setLibraryAndSession(obj.libName, obj.session);
            obj.DisplayControl.setLibraryAndSession(obj.libName, obj.session);
            obj.Trigger.setLibraryAndSession(obj.libName, obj.session);
            obj.Markers.setLibraryAndSession(obj.libName, obj.session);
            obj.BasicOperation.setLibraryAndSession(obj.libName, obj.session);
            obj.InherentIVIAttributes.setLibraryAndSession(obj.libName, obj.session);
            obj.UtilityFunctions.setLibraryAndSession(obj.libName, obj.session);
            obj.Measurement.setLibraryAndSession(obj.libName, obj.session);
            obj.ConfigurationFunctions.setLibraryAndSession(obj.libName, obj.session);
        end
        
    end
end


 
