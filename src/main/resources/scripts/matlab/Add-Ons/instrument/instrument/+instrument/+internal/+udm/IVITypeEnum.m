classdef  IVITypeEnum < handle
    %IVITypeEnum Represents possible instrument IVI technology type
    %Note: A driver could be an IVIC driver , IVICOM driver or both.
    
    % Copyright 2011 The MathWorks, Inc.
    
    properties (Constant )
        IVIC =  1 ;
        IVICOM = 2;
    end

end

 