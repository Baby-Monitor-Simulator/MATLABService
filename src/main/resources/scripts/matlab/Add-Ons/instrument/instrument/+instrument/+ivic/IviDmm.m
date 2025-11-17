classdef  IviDmm < instrument.ivic.IviDmmSpecification
    %IVIDMM IviDmm MATLAB wrapper provides programming support
    %for the IVI-C Dmm Class.
    %
    %IVIDMM will be removed in a future release. Use <a href="matlab:help ividev">ividev</a> instead.
    %
    %The driver contains all the functionalities required in the IviDmm
    %specification defined by the IVI Foundation. This wrapper requires
    %VISA, IVI Compliance Package and an IVI instrument specific driver
    %that is compliant with the IviDmm class. The IviDmm class wrapper
    %accesses the specific driver using the logical name in the
    %configuration store.
    %
    %   OBJ = instrument.ivic.IviDmm() constructs an IVI-C Dmm object.
    %
    %   In order to communicate with the instrument, the device object must be
    %   connected to the instrument with the init() or InitWithOption() function.
    %
    %   Example using a MATLAB IVI-C Dmm class complaint instrument wrapper:
    %
    %       % Construct an IVI-C Dmm object
    %       dmmObj = instrument.ivic.IviDmm();
    %
    %       % Connect to the instrument via logical name 'myDmm'
    %       dmmObj.init('myDmm', false, false);
    %
    %       % Connect to the instrument via logical name 'myDmm' in
    %       simulation mode
    %       dmmObj.InitWithOption('myDmm', false, false, 'simulate=true');
    %
    %       % Disconnect from the instrument and clean up.
    %       dmmObj.close();
    %       delete(dmmObj);
    
    % Copyright 2010-2022 The MathWorks, Inc.
    
    %% Construction
    methods
        function obj = IviDmm()
            try
                instrument.internal.ICTRemoveFunctionalityHelper(mfilename, "Warn", "Class");
            catch ex
                throwAsCaller(ex);
            end

            narginchk(0,0)
            instrgate ('privateCheckNICPVersion');
            % construct superclass
            obj@instrument.ivic.IviDmmSpecification();
            
        end
        
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        
    end
    
    %% methods
    methods
        %override base class's init() method
        function init(obj, LogicalName,IDQuery,ResetDevice)
            obj.init@instrument.ivic.IviDmmSpecification(LogicalName,IDQuery,ResetDevice);
            obj.updateLibraryAndSession();
        end
        
        
        %override base class's InitWithOptions() method
        function  InitWithOptions(obj,LogicalName,IDQuery,ResetDevice,OptionString)
            obj.InitWithOptions@instrument.ivic.IviDmmSpecification(LogicalName,IDQuery,ResetDevice,OptionString );
            obj.updateLibraryAndSession();
        end
        
        %override base class's close() method
        function close(obj)
            obj.close@instrument.ivic.IviDmmSpecification();
            obj.session=[];
            obj.updateLibraryAndSession();
         
        end
        
        %helper function to update driver's session
        function updateLibraryAndSession(obj)
            
            obj.MeasurementOperationOptions.setLibraryAndSession(obj.libName, obj.session);
            obj.ConfigurationInformation.setLibraryAndSession(obj.libName, obj.session);
            obj.MultiPointAcquisition.setLibraryAndSession(obj.libName, obj.session);
            obj.TemperatureMeasurements.setLibraryAndSession(obj.libName, obj.session);
            obj.FrequencyMeasurements.setLibraryAndSession(obj.libName, obj.session);
            obj.ACMeasurements.setLibraryAndSession(obj.libName, obj.session);
            obj.Trigger.setLibraryAndSession(obj.libName, obj.session);
            obj.BasicOperation.setLibraryAndSession(obj.libName, obj.session);
            obj.InherentIVIAttributes.setLibraryAndSession(obj.libName, obj.session);
            obj.Utility.setLibraryAndSession(obj.libName, obj.session);
            obj.Measurement.setLibraryAndSession(obj.libName, obj.session);
            obj.Configuration.setLibraryAndSession(obj.libName, obj.session);
        end
        
    end
end


 
