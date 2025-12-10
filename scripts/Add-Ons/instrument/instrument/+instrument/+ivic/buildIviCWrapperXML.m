function wrapperXMLString = buildIviCWrapperXML(instrumentType )
%buildIviCWrapperXML Build XML string representation for IVI-C class compliant
%   MATLAB class wrappers.
%   BUILDCLASSFROMINTERFACE(instrumentType) is a
%   builder that walk through the MATLAB class via reflection and stores the 
%   wrapper classes into groups, methods and properties.

% Copyright 2011 The MathWorks, Inc.

narginchk(1,1);

wrapperName = sprintf ('instrument.ivic.%s', instrumentType);

docNode = com.mathworks.xml.XMLUtils.createDocument('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance''',wrapperName );
docRootNode = docNode.getDocumentElement;
docRootNode.setAttribute('xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');

getMATLABClassStructure(wrapperName, docNode, docRootNode);
% in case to write to a XML file
% wrapperStructureFilename = [tempname '.xml'];
% xmlwrite(wrapperStructureFilename,docNode);
wrapperXMLString = xmlwrite(docNode);
end



%% function to build a XML representation of Ivi-C instrument
function  getMATLABClassStructure(classname, docNode, docRootNode)

try
    MATLABClassInfo = meta.class.fromName(classname);
catch e
    newE =  MException ('instrument:getMATLABClassStructure','failed to get MATLAB class information');
    newE = newE.addCause(e);
    newE.throw
end

if isempty (MATLABClassInfo )
    return;
end

% methods list
methods = MATLABClassInfo.Methods;

% methods filter list
filtedMethodNames = {'eq','ne', 'lt' , 'gt' , 'le' , 'ge' ,  'delete'   , 'isvalid',  ...
    'findprop' ,   'notify' , 'notify' , 'addlistener',  'findobj', ...
    'get', 'set', 'getdisp', 'setdisp','disp' , 'getLibraryAndSession', 'setLibraryAndSession', 'checkError'};
ret = {};

% iterate through methods list and build method info
for i = 1:  length (methods )
    %filter out hidden methods
    if methods{i}.Hidden
        continue;
    end
    
    %filter out private and protected  methods ( public method only )
    if ~strcmp (methods{i}.Access ,'public')
        continue;
    end
    
    %filter out the buildin methods
    if  ~ismember ( methods{i}.Name , filtedMethodNames )
        ret {end +1 }= methods{i}.Name; %#ok<AGROW>
        methodXML = buildMethod (docNode, methods{i}, MATLABClassInfo.Name );
        docRootNode.appendChild(methodXML);
    end
end

% propertier that need to be hidden
filtedPropertiesNames = {'libName','session' } ;

% properties list
properties = MATLABClassInfo.Properties;
% iterate through properties list and build property info
for i = 1:  length (properties )
    
    %filter out the properties in the filtered list
    if  ismember ( properties{i}.Name , filtedPropertiesNames )
        continue;
    end
    
    property_name = [classname '.' properties{i}.Name] ;
    property_mcosclass = meta.class.fromName( property_name);
    
    % the property points to another MATLAB class in the same package
    if ~isempty (property_mcosclass)
        groupXML =  buildGroup (docNode, properties{i}.Name  );
        docRootNode.appendChild(groupXML);
        %run recursively
        getMATLABClassStructure(  property_name, docNode , groupXML);
        
    else  % it is a regular property
        propertyXML = buildProperty (docNode, properties{i}, MATLABClassInfo.Name);
        docRootNode.appendChild(propertyXML);
        
    end
end
end



%% build propertyXML which contains access infomation
function propertyXML = buildProperty (docNode, property, className )
propertyElement = docNode.createElement(  property.Name  );
propertyElement.setAttribute('type','2');
if isempty (property.SetMethod)
    propertyElement.setAttribute('access','R');
else
    propertyElement.setAttribute('access','RW');
end
propertyNameElement = docNode.createElement('description');
propertyNameElement.appendChild(docNode.createTextNode( help ([ className '.' property.Name])));

propertyElement.appendChild(propertyNameElement);
propertyXML = propertyElement;
end


%% build methodXML which contain information about input arguments, output
%% arguments
function methodXML = buildMethod (docNode, method , className )
methodElement = docNode.createElement(  method.Name  );
methodElement.setAttribute('type','3');
methodDescElement = docNode.createElement('description');
methodDescElement.appendChild(docNode.createTextNode( help ([ className '.' method.Name])));
methodElement.appendChild(methodDescElement);

outputArgs= '';
inputArgs= '';

if length(method.InputNames) > 1
    % no need for obj
    for i=2: length(method.InputNames)
        inputArgs = [inputArgs  ', '   method.InputNames{i}]; %#ok<AGROW>
    end
    % remmove leading ,
    if inputArgs(1) == ','
        inputArgs =  inputArgs (2:length(inputArgs));
    end
    
    methodInputElement = docNode.createElement('inputArgs');
    methodInputElement.appendChild(docNode.createTextNode(inputArgs ));
    methodElement.appendChild(methodInputElement);
    
end


if ~isempty(method.OutputNames)
    for i=1: length(method.OutputNames)
        outputArgs = [outputArgs ', '  method.OutputNames{i} ]; %#ok<AGROW>
    end
    % remmove leading coma
    if outputArgs(1) == ','
        outputArgs =  outputArgs (2:length(outputArgs));
    end
    
    methodOutputElement = docNode.createElement('outputArgs');
    methodOutputElement.appendChild(docNode.createTextNode(outputArgs ));
    methodElement.appendChild(methodOutputElement);
end

methodXML = methodElement;
end



%% build driver groupXML
function groupXML = buildGroup( docNode, groupName  )

% remove the dot i.e. instrument.ivicom.IviDmm.Resolution => Resolution
index = strfind(groupName,'.');
if ~isempty (index)
    groupName = groupName (index(length(index)) + 1:length(groupName));
end

groupElement = docNode.createElement(groupName);
groupElement.setAttribute('type','1');
groupDescElement = docNode.createElement('description');
groupDescElement.appendChild(docNode.createTextNode('N/A'));
% groupDescElement.appendChild(docNode.createTextNode(help ([ className '.' groupName])));
groupElement.appendChild(groupDescElement);

groupXML = groupElement;

end