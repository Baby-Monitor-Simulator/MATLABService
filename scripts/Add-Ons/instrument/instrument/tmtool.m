function tmtool
%TMTOOL open the Test & Measurement Tool.
%   TMTOOL will be removed in a future release. Use <a href="matlab:help serialExplorer">serialExplorer</a>,
%   <a href="matlab:help tcpipExplorer">tcpipExplorer</a>, <a href="matlab:help udpExplorer">udpExplorer</a>, or <a href="matlab:help visaExplorer">visaExplorer</a> instead.
%
%   The Test & Measurement Tool displays the resources (hardware, drivers,     
%   interfaces, etc.) accessible to the toolboxes that support the tool, and    
%   enables you to configure and communicate with those resources.
%
%   To view the tools associated with each toolbox, navigate through the 
%   nodes under each Toolbox tree node.
%

%   Copyright 1999-2022 The MathWorks, Inc.

instrument.internal.ICTRemoveFunctionalityHelper(mfilename, "Warn", "Function");
awtinvoke('com.mathworks.toolbox.instrument.browser.ICTBrowserDesktop','openDesktop');
