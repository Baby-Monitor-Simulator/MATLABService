classdef  IviFgen < instrument.ivic.IviFgenSpecification
    %IVIFGEN IviFgen MATLAB wrapper provides programming support
    %for the IVI-C Fgen Class.
    %
    %IVIFGEN will be removed in a future release. Use <a href="matlab:help ividev">ividev</a> instead.
    %
    %The driver contains all the functionalities required in the IviFgen
    %specification defined by the IVI Foundation. This wrapper requires
    %VISA, IVI Compliance Package and an IVI instrument specific driver
    %that is compliant with the IviFgen class. The IviFgen class wrapper
    %accesses the specific driver using the logical name in the
    %configuration store.
    %
    %   OBJ = instrument.ivic.IviFgen() constructs an IVI-C Fgen object.
    %
    %   In order to communicate with the instrument, the device object must be
    %   connected to the instrument with the init() or InitWithOption() function.
    %
    %   Example using a MATLAB IVI-C Fgen class complaint instrument wrapper:
    %
    %       % Construct an IVI-C Fgen object
    %       fgenObj = instrument.ivic.IviFgen();
    %
    %       % Connect to the instrument via logical name 'myFgen'
    %       fgenObj.init('myFgen', false, false);
    %
    %       % Connect to the instrument via logical name 'myFgen' in
    %       simulation mode
    %       fgenObj.InitWithOption('myFgen', false, false, 'simulate=true');
    %
    %       % Disconnect from the instrument and clean up.
    %       fgenObj.close();
    %       delete(fgenObj);
    
    % Copyright 2010-2022 The MathWorks, Inc.
    
    %% Construction
    methods
        function obj = IviFgen()
            try
                instrument.internal.ICTRemoveFunctionalityHelper(mfilename, "Warn", "Class");
            catch ex
                throwAsCaller(ex);
            end

            narginchk(0,0)
            instrgate ('privateCheckNICPVersion');
            % construct superclass
            obj@instrument.ivic.IviFgenSpecification();
            
        end
        
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        
    end
    
    %% methods
    methods
        %override base class's init() method
        function init(obj, LogicalName,IDQuery,ResetDevice)
            obj.init@instrument.ivic.IviFgenSpecification(LogicalName,IDQuery,ResetDevice);
            obj.updateLibraryAndSession();
        end
        
        
        %override base class's InitWithOptions() method
        function  InitWithOptions(obj,LogicalName,IDQuery,ResetDevice,OptionString)
            obj.InitWithOptions@instrument.ivic.IviFgenSpecification(LogicalName,IDQuery,ResetDevice,OptionString );
            obj.updateLibraryAndSession();
        end
        
        %override base class's close() method
        function close(obj)
            obj.close@instrument.ivic.IviFgenSpecification();
            obj.session=[];
            obj.updateLibraryAndSession();
         
        end
        
        %helper function to update driver's session
        function updateLibraryAndSession(obj)
            obj.AmplitudeModulation.setLibraryAndSession(obj.libName, obj.session);
            obj.FrequencyModulation.setLibraryAndSession(obj.libName, obj.session);
            obj.Burst.setLibraryAndSession(obj.libName, obj.session);
            obj.Triggering.setLibraryAndSession(obj.libName, obj.session);
            obj.ArbitrarySequenceOutput.setLibraryAndSession(obj.libName, obj.session);
            obj.ArbitraryWaveformOutput.setLibraryAndSession(obj.libName, obj.session);
            obj.StandardFunctionOutput.setLibraryAndSession(obj.libName, obj.session);
            obj.BasicOperation.setLibraryAndSession(obj.libName, obj.session);
            obj.InherentIVIAttributes.setLibraryAndSession(obj.libName, obj.session);
            obj.UtilityFunctions.setLibraryAndSession(obj.libName, obj.session);
            obj.ActionStatusFunctions.setLibraryAndSession(obj.libName, obj.session);
            obj.ConfigurationFunctions.setLibraryAndSession(obj.libName, obj.session);

        end
        
    end
end


 
