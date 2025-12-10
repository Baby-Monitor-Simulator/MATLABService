classdef (Hidden) IviGroupBase < instrument.ivic.IviBase
    %GROUPBASE base class for IVI-C driver functional groups.
    %   This class provides common functions and capabilities to all
    %   IVI-C driver functional groups. It also store Repeated Capability 
    %   Identifier for each group. This property may need to be set before
    %   accessing the repeated capability functionality.
    
    % Copyright 2010-2023 The MathWorks, Inc.
    
    properties
        RepCapIdentifier ='';
    end
    
    properties (Access = protected)
        libName ;
        session;
    end
    
    methods
        
        function  setLibraryAndSession(obj, libName, session)
            obj.libName = libName;
            obj.session = session ;
        end
        
        function [libName, session] = getLibraryAndSession (obj )

            if isempty(obj.session)
                 error(message('instrument:ivic:notValidSession'));
            end
            session = obj.session;
            
             if isempty(obj.libName)
                 error(message('instrument:ivic:notValidLibrary'));
            end
            libName =  obj.libName;
        end
        
        
        function checkError(obj, status)
            
            if status ==0 
                return;
            end
            errStatus = status;
            errorMessage = libpointer('int8Ptr', zeros(1, 1024));
            [libname , sessionID ]  =   obj.getLibraryAndSession();
            status  = calllib(libname, [libname '_error_message'], sessionID, status, errorMessage);
            if (status < 0)
                error(message('instrument:ivic:cannotInterpretError'));
            end
            if isnumeric(errorMessage.Value)
                errorMessage = message('instrument:ivic:errorCode', num2str(errStatus)).getString;
            else
                errorMessage = strtrim(char(errorMessage.Value));
            end
            error(message('instrument:ivic:failedToExecute', errorMessage));
        end
        
       
        function value = get.RepCapIdentifier(obj)
            value = obj.RepCapIdentifier ;
        end
        
        function set.RepCapIdentifier(obj, value)
            obj.checkScalarStringArg(value);
            obj.RepCapIdentifier = value;
        end
        
    end

end


