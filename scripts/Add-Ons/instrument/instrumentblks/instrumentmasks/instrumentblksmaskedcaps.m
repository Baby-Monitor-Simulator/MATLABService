function cap = instrumentblksmaskedcaps(~)
% INSTRUMENTBLKSMASKEDCAPS defines the capabilities for the ICT blocks.

% Copyright 2019-2021 The MathWorks, Inc.

if contains(gcb,'TCP//IP Send') || contains(gcb,'TCP//IP Receive')
    cs_c = CapStruct('codegen', 'yes', '');
    cs_p = CapStruct('production', 'no', '');
else
    cs_c = CapStruct('codegen', 'no', '');
    cs_p = CapStruct('production', 'no', '');
end


cset = CapSet(cs_c, cs_p);
cap = Capabilities(cset);

end

