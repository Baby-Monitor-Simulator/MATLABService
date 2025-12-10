function out = privateImportDriverDialogHelper
%PRIVATEIMPORTDRIVERDIALOGHELPER helper function for MIDEDIT import dialog.
%
%   PRIVATEIMPORTDRIVERDIALOGHELPER helper function used by the MATLAB 
%   Instrument Driver Editor (MIDEDIT) to:
%      1. Find the available VXIplug&play drivers
%      2. Find the available IVI logical names.
%
%   This function should not be called directly by the user.
%  
 
%   Copyright 1999-2016 The MathWorks, Inc. 

vxipnp = instrhwinfo('vxipnp');
ivi    = instrhwinfo('ivi');

out = {vxipnp.InstalledDrivers, ivi.LogicalNames, ivi.Modules, privateGetVXIPNPPath, ivi.IVIRootPath};
