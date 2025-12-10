classdef Tekbase < instrument.ieee4882.DriverGroupBase
    %Tekbase class implements the error checking mechanism for Tektronix oscilloscope
    
    % Copyright 2011-2013 The MathWorks, Inc.
    methods (Hidden,  Access = 'protected' )
        
        % tek specific error checking
        function checkErrorImpl(obj)
            
            % error checking
            instrmsg = obj.queryInstrument ( '*ESR?');
            value = str2double(instrmsg);
            
            % error conditions
            if ~isnan (value ) &&  (value ~= 0 ) 
                
                % reading the instrument error stack. Note that this
                % message will not be displayed to the user though
                msg = obj.queryInstrument('ALLEV?');
                error(message('instrument:ieee4882Driver:instrumentError'));
            end
            
        end
    end
end


 
