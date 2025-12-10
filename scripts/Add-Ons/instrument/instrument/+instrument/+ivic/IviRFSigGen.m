classdef  IviRFSigGen < instrument.ivic.IviRFSigGenSpecification
    %IVIRFSIGGEN IviRFSigGen MATLAB wrapper provides programming support
    %for the IVI-C RFSigGen Class.
    %
    %IVIRFSIGGEN will be removed in a future release. Use <a href="matlab:help ividev">ividev</a> instead.
    %
    %The driver contains all the functionalities required in the
    %IviRFSigGen specification defined by the IVI Foundation. This wrapper
    %requires VISA, IVI Compliance Package and an IVI instrument specific
    %driver that is compliant with the IviRFSigGen class. The IviRFSigGen
    %class wrapper accesses the specific driver using the logical name in
    %the configuration store.
    %
    %   OBJ = instrument.ivic.IviRFSigGen() constructs an IVI-C RFSigGen object.
    %
    %   In order to communicate with the instrument, the device object must be
    %   connected to the instrument with the init() or InitWithOption() function.
    %
    %   Example using a MATLAB IVI-C RFSigGen class complaint instrument wrapper:
    %
    %       % Construct an IVI-C RFSigGen object
    %       rfSigGenObj = instrument.ivic.IviRFSigGen();
    %
    %       % Connect to the instrument via logical name 'myRFSigGen'
    %       rfSigGenObj.init('myRFSigGen', false, false);
    %
    %       % Connect to the instrument via logical name 'myRFSigGen' in
    %       simulation mode
    %       rfSigGenObj.InitWithOption('myRFSigGen', false, false, 'simulate=true');
    %
    %       % Disconnect from the instrument and clean up.
    %       rfSigGenObj.close();
    %       delete(rfSigGenObj);
    
    % Copyright 2010-2022 The MathWorks, Inc.
    
    %% Construction
    methods
        function obj = IviRFSigGen()
            try
                instrument.internal.ICTRemoveFunctionalityHelper(mfilename, "Warn", "Class");
            catch ex
                throwAsCaller(ex);
            end

            narginchk(0,0)
            instrgate ('privateCheckNICPVersion');
            % construct superclass
            obj@instrument.ivic.IviRFSigGenSpecification();
            
        end
        
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        
    end
    
    %% methods
    methods
        %override base class's init() method
        function init(obj, LogicalName,IDQuery,ResetDevice)
            obj.init@instrument.ivic.IviRFSigGenSpecification(LogicalName,IDQuery,ResetDevice);
            obj.updateLibraryAndSession();
        end
        
        
        %override base class's InitWithOptions() method
        function  InitWithOptions(obj,LogicalName,IDQuery,ResetDevice,OptionString)
            obj.InitWithOptions@instrument.ivic.IviRFSigGenSpecification(LogicalName,IDQuery,ResetDevice,OptionString );
            obj.updateLibraryAndSession();
        end
        
        %override base class's close() method
        function close(obj)
            obj.close@instrument.ivic.IviRFSigGenSpecification();
            obj.session=[];
            obj.updateLibraryAndSession();
         
        end
        
        %helper function to update driver's session
        function updateLibraryAndSession(obj)
            
            obj.TDMA.setLibraryAndSession(obj.libName, obj.session);
            obj.CDMA.setLibraryAndSession(obj.libName, obj.session);
            obj.DigitalModulation.setLibraryAndSession(obj.libName, obj.session);
            obj.ARBGenerator.setLibraryAndSession(obj.libName, obj.session);
            obj.IQ.setLibraryAndSession(obj.libName, obj.session);
            obj.ReferenceOscillator.setLibraryAndSession(obj.libName, obj.session);
            obj.ALC.setLibraryAndSession(obj.libName, obj.session);
            obj.Sweep.setLibraryAndSession(obj.libName, obj.session);
            obj.PulseGenerator.setLibraryAndSession(obj.libName, obj.session);
            obj.LFGenerator.setLibraryAndSession(obj.libName, obj.session);
            obj.PulseModulation.setLibraryAndSession(obj.libName, obj.session);
            obj.AnalogModulation.setLibraryAndSession(obj.libName, obj.session);
            obj.RF.setLibraryAndSession(obj.libName, obj.session);
            obj.InherentIVIProperties.setLibraryAndSession(obj.libName, obj.session);
            obj.UtilityFunctions.setLibraryAndSession(obj.libName, obj.session);
            obj.ActionFunctions.setLibraryAndSession(obj.libName, obj.session);
            obj.ConfigurationFunctions.setLibraryAndSession(obj.libName, obj.session);
        end
        
    end
end


 
