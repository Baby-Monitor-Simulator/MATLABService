function commit(obj, filename)
%COMMIT Save IVI configuration store object.
%
%   COMMIT(OBJ) saves the IVI configuration store object, OBJ, to the 
%   configuration store data file. The configuration store data file is 
%   defined by OBJ's ActualLocation property.
%
%   COMMIT(OBJ, FILE) saves the IVI configuration store object, OBJ, to 
%   the configuration store data file, FILE. No changes are saved to the 
%   configuration store data file that is defined by OBJ's ActualLocation 
%   property.
%
%   The IVI configuration store object, OBJ, can be modified with the ADD,
%   UPDATE and REMOVE functions.
%
%   See also IVICONFIGURATIONSTORE/ADD, IVICONFIGURATIONSTORE/UPDATE,
%   IVICONFIGURATIONSTORE/REMOVE.
%

%   Copyright 1999-2016 The MathWorks, Inc.

narginchk(1, 2);
if (nargin == 1)
    if ~isempty(obj.cobject.ProcessDefaultLocation)
        filename = obj.cobject.ProcessDefaultLocation;
    else
        filename = obj.cobject.MasterLocation;
    end
else
    % convert to char in order to accept string datatype
    filename = instrument.internal.stringConversionHelpers.str2char(filename);
    if (~ischar(filename))
        error(message('instrument:iviconfigurationstore:commit:invalidfile'));
    end
end

try
    Serialize(obj.cobject, filename);
catch aException
    rethrow(aException);
end
