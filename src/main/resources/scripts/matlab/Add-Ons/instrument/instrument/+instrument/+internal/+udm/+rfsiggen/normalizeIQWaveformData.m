function [iData, qData] = normalizeIQWaveformData(waveformDataArray)
% NORMALIZEIQWAVEFORMDATA is a helper function that normalizes real and
% imaginary data values of an rfsiggen waveform.

% Copyright 2021 The MathWorks, Inc.

% Calculate the maximum real or imaginary value possible for normalizing
% the waveform signal.
maxData = max(max(abs(real(waveformDataArray))), max(abs(imag(waveformDataArray))));

% Normalize the data if it is not normalized.
if maxData > 1
    waveformDataArray = waveformDataArray/maxData;
end

% Parse the real and imaginary data from the normalized waveform array.
iData = real(waveformDataArray);
qData = imag(waveformDataArray);
end