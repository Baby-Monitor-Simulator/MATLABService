classdef  IviPwrMeter < instrument.ivic.IviPwrMeterSpecification
    %IVIPWRMETER IviPwrMeter MATLAB wrapper provides programming support
    %for the IVI-C PwrMeter Class.
    %
    %IVIPWRMETER will be removed in a future release. Use <a href="matlab:help ividev">ividev</a> instead.
    %
    %The driver contains all the functionalities required in the
    %IviPwrMeter specification defined by the IVI Foundation. This wrapper
    %requires VISA, IVI Compliance Package and an IVI instrument specific
    %driver that is compliant with the IviPwrMeter class. The IviPwrMeter
    %class wrapper accesses the specific driver using the logical name in
    %the configuration store.
    %
    %   OBJ = instrument.ivic.IviPwrMeter() constructs an IVI-C PwrMeter object.
    %
    %   In order to communicate with the instrument, the device object must be
    %   connected to the instrument with the init() or InitWithOption() function.
    %
    %   Example using a MATLAB IVI-C PwrMeter class complaint instrument wrapper:
    %
    %       % Construct an IVI-C PwrMeter object
    %       pwrMeterObj = instrument.ivic.IviPwrMeter();
    %
    %       % Connect to the instrument via logical name 'myPwrMeter'
    %       pwrMeterObj.init('myPwrMeter', false, false);
    %
    %       % Connect to the instrument via logical name 'myPwrMeter' in
    %       simulation mode
    %       pwrMeterObj.InitWithOption('myPwrMeter', false, false, 'simulate=true');
    %
    %       % Disconnect from the instrument and clean up.
    %       pwrMeterObj.close();
    %       delete(pwrMeterObj);
    
    % Copyright 2010-2022 The MathWorks, Inc.
    
    %% Construction
    methods
        function obj = IviPwrMeter()
            try
                instrument.internal.ICTRemoveFunctionalityHelper(mfilename, "Warn", "Class");
            catch ex
                throwAsCaller(ex);
            end

            narginchk(0,0)
            instrgate ('privateCheckNICPVersion');
            % construct superclass
            obj@instrument.ivic.IviPwrMeterSpecification();
            
        end
        
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        
    end
    
    %% methods
    methods
        %override base class's init() method
        function init(obj, LogicalName,IDQuery,ResetDevice)
            obj.init@instrument.ivic.IviPwrMeterSpecification(LogicalName,IDQuery,ResetDevice);
            obj.updateLibraryAndSession();
        end
        
        
        %override base class's InitWithOptions() method
        function  InitWithOptions(obj,LogicalName,IDQuery,ResetDevice,OptionString)
            obj.InitWithOptions@instrument.ivic.IviPwrMeterSpecification(LogicalName,IDQuery,ResetDevice,OptionString );
            obj.updateLibraryAndSession();
        end
        
        %override base class's close() method
        function close(obj)
            obj.close@instrument.ivic.IviPwrMeterSpecification();
            obj.session=[];
            obj.updateLibraryAndSession();
         
        end
        
        %helper function to update driver's session
        function updateLibraryAndSession(obj)
                    
            obj.ReferenceOscillator.setLibraryAndSession(obj.libName, obj.session);
            obj.AveragingCount.setLibraryAndSession(obj.libName, obj.session);
            obj.DutyCycle.setLibraryAndSession(obj.libName, obj.session);
            obj.Trigger.setLibraryAndSession(obj.libName, obj.session);
            obj.ManualRange.setLibraryAndSession(obj.libName, obj.session);
            obj.BasicOperation.setLibraryAndSession(obj.libName, obj.session);
            obj.InherentIVIAttributes.setLibraryAndSession(obj.libName, obj.session);
            obj.Utility.setLibraryAndSession(obj.libName, obj.session);
            obj.Measurement.setLibraryAndSession(obj.libName, obj.session);
            obj.Calibration.setLibraryAndSession(obj.libName, obj.session);
            obj.Zeroing.setLibraryAndSession(obj.libName, obj.session);
            obj.Configuration.setLibraryAndSession(obj.libName, obj.session);
        end
        
    end
end


 
