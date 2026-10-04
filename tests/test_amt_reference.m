% tests/test_amt_reference.m
% Verification script to run the amtoolbox bramslow2004 reference model
% Ensure you have started AMT (e.g., via `amt_start`) before running.

fs = 48000;
t = (0:fs-1)' / fs;
freq = 1000;
insig = sin(2*pi*freq*t); % 1 kHz sine wave, uncalibrated

levels_spl = [30, 50, 65, 80, 100];

disp('======================================================');
disp('=== Bramslow 2004 AMT Loudness Engine Verification ===');
disp('======================================================');
disp(' ');
disp('--- TEST 1: Normal Hearing (0 dB HL) at 1 kHz ---');

for L = levels_spl
    % Setting Cal_RMS=true and Cal_dB=L scales the input sine wave to exactly L dB SPL
    audout = bramslow2004(insig, fs, 'Cal_RMS', true, 'Cal_dB', L, 'no_debug');
    
    % Average loudness across all frames
    total_loudness = mean(audout.Loudness);
    
    fprintf('Input: 1 kHz @ %3d dB SPL -> Total Loudness: %7.3f sones\n', L, total_loudness);
end

disp(' ');
disp('--- TEST 2: Hearing Impaired (50 dB flat loss) at 1 kHz ---');
% AGLoss frequencies are: [125 250 500 750 1000 1500 2000 3000 4000 6000 8000 10000 12500]
loss_profile = 50 * ones(1, 13);

for L = levels_spl
    audout = bramslow2004(insig, fs, 'AGLoss', loss_profile, 'Cal_RMS', true, 'Cal_dB', L, 'no_debug');
    
    total_loudness = mean(audout.Loudness);
    
    fprintf('Input: 1 kHz @ %3d dB SPL -> Total Loudness: %7.3f sones\n', L, total_loudness);
end

disp(' ');
disp('Verification Complete.');
