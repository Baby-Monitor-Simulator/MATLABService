classdef  IviDCPwr < instrument.ivic.IviDCPwrSpecification
    %IVIDCPWR IviDCPwr MATLAB wrapper provides programming support
    %for the IVI-C IviDCPwr Class.
    %
    %IVIDCPWR will be removed in a future release. Use <a href="matlab:help ividev">ividev</a> instead.
    %
    %The driver contains all the functionalities required in the IviDCPwr
    %specification defined by the IVI Foundation. This wrapper requires
    %VISA, IVI Compliance Package and an IVI instrument specific driver
    %that is compliant with the IviDCPwr class. The IviDCPwr class wrapper
    %accesses the specific driver using the logical name in the
    %configuration store.
    %
    %   OBJ = instrument.ivic.IviDCPwr() constructs an IVI-C IviDCPwr object.
    %
    %   In order to communicate with the instrument, the device object must be
    %   connected to the instrument with the init() or InitWithOption() function.
    %
    %   Example using a MATLAB IVI-C IviDCPwr class complaint instrument wrapper:
    %
    %       % Construct an IVI-C IviDCPwr object
    %       dcPwrObj = instrument.ivic.IviDCPwr();
    %
    %       % Connect to the instrument via logical name 'myDCPwr'
    %       dcPwrObj.init('myDCPwr', false, false);
    %
    %       % Connect to the instrument via logical name 'myDCPwr' in
    %       simulation mode
    %       dcPwrObj.InitWithOption('myDCPwr', false, false, 'simulate=true');
    %
    %       % Disconnect from the instrument and clean up.
    %       dcPwrObj.close();
    %       delete(dcPwrObj);
    
    % Copyright 2010-2022 The MathWorks, Inc.
    
    %% Construction
    methods
        function obj = IviDCPwr()
            try
                instrument.internal.ICTRemoveFunctionalityHelper(mfilename, "Warn", "Class");
            catch ex
                throwAsCaller(ex);
            end

            narginchk(0,0)
            instrgate ('privateCheckNICPVersion');
            % construct superclass
            obj@instrument.ivic.IviDCPwrSpecification();
            
        end
        
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        
    end
    
    %% methods
    methods
        %override base class's init() method
        function init(obj, LogicalName,IDQuery,ResetDevice)
            obj.init@instrument.ivic.IviDCPwrSpecification(LogicalName,IDQuery,ResetDevice);
            obj.updateLibraryAndSession();
        end
        
        
        %override base class's InitWithOptions() method
        function  InitWithOptions(obj,LogicalName,IDQuery,ResetDevice,OptionString)
            obj.InitWithOptions@instrument.ivic.IviDCPwrSpecification(LogicalName,IDQuery,ResetDevice,OptionString );
            obj.updateLibraryAndSession();
        end
        
        %override base class's close() method
        function close(obj)
            obj.close@instrument.ivic.IviDCPwrSpecification();
            obj.session=[];
            obj.updateLibraryAndSession();
         
        end
        
        %helper function to update driver's session
        function updateLibraryAndSession(obj)
        
            obj.TriggerSubsystem.setLibraryAndSession(obj.libName, obj.session);
            obj.BasicOperation.setLibraryAndSession(obj.libName, obj.session);
            obj.InherentIVIAttributes.setLibraryAndSession(obj.libName, obj.session);
            obj.Utility.setLibraryAndSession(obj.libName, obj.session);
            obj.ActionStatus.setLibraryAndSession(obj.libName, obj.session);
            obj.Configuration.setLibraryAndSession(obj.libName, obj.session);
            
        end
        
    end
end


 
