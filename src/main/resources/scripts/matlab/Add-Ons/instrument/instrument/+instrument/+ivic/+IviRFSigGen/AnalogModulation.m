classdef AnalogModulation < instrument.ivic.IviGroupBase
    %ANALOGMODULATION This group contains all of the Analog
    %Modulation attributes.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = AnalogModulation()
            %% Initialize properties
            obj.AM = instrument.ivic.IviRFSigGen.AnalogModulation.AM();
            obj.FM = instrument.ivic.IviRFSigGen.AnalogModulation.FM();
            obj.PM = instrument.ivic.IviRFSigGen.AnalogModulation.PM();
            obj.Source = instrument.ivic.IviRFSigGen.AnalogModulation.Source();
        end
        
        function delete(obj)
            obj.Source = [];
            obj.PM = [];
            obj.FM = [];
            obj.AM = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.Source.setLibraryAndSession(libName, session);
            obj.PM.setLibraryAndSession(libName, session);
            obj.FM.setLibraryAndSession(libName, session);
            obj.AM.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %AM This group contains attributes for RF Signal Generators
        %that can apply  Read Only.
        AM
        
        %FM This group contains attributes for RF Signal Generators
        %that can apply  Read Only.
        FM
        
        %PM This group contains attributes for RF Signal Generators
        %that can apply  Read Only.
        PM
        
        %SOURCE This group contains the repeated attributes for RF
        %Signal Generators that can  Read Only.
        Source
    end
    
    %% Property access methods
    methods
        %% AM property access methods
        function value = get.AM(obj)
            if isempty(obj.AM)
                obj.AM = instrument.ivic.IviRFSigGen.AnalogModulation.AM();
            end
            value = obj.AM;
        end
        
        %% FM property access methods
        function value = get.FM(obj)
            if isempty(obj.FM)
                obj.FM = instrument.ivic.IviRFSigGen.AnalogModulation.FM();
            end
            value = obj.FM;
        end
        
        %% PM property access methods
        function value = get.PM(obj)
            if isempty(obj.PM)
                obj.PM = instrument.ivic.IviRFSigGen.AnalogModulation.PM();
            end
            value = obj.PM;
        end
        
        %% Source property access methods
        function value = get.Source(obj)
            if isempty(obj.Source)
                obj.Source = instrument.ivic.IviRFSigGen.AnalogModulation.Source();
            end
            value = obj.Source;
        end
    end
end
