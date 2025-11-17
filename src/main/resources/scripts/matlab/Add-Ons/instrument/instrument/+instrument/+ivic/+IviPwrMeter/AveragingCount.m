classdef AveragingCount < instrument.ivic.IviGroupBase
    %AVERAGINGCOUNT Averaging Count
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %AVERAGE_COUNT_AVG This channel-based attribute specifies
        %the average count that the instrument uses in manual
        %averaging mode. When the
        %IVIPWRMETER_ATTR_AVERAGING_AUTO_ENABLED attribute is set to
        %FALSE, the driver filters the input signal by averaging it
        %the number of times specified by this attribute.
        Average_Count_AVG
    end
    
    %% Property access methods
    methods
        %% Average_Count_AVG property access methods
        function value = get.Average_Count_AVG(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250301);
        end
        function set.Average_Count_AVG(obj,newValue)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarInt32Arg(newValue);
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250301, newValue);
        end
    end
end
