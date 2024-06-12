%% Written on Octave version 9.2.0,
%% 
%% Define an existing data path
% Initial data path - Please enter your local data path here
dataPath = '/Users/sophi1/SOFAOctave/data/SCUT';
% Check if the data path exists and is a directory
while exist(dataPath, 'dir') ~= 7
    % Prompt the user to enter the right data path
    dataPath = input(' Enter the data path: ', 's');
    % Check if the provided data path exists and is a directory
    if exist(dataPath, 'dir') ~= 7
        disp('The provided data path does not exist or is not a directory. Try again.');
    end
end

disp(['Data path set to: ', dataPath]);


%% Define the path and filename of the HRTF set
hrtf_set_filename = 'SCUT_KEMAR_radius_all.sofa';
sofa_file_path = fullfile(dataPath, hrtf_set_filename);

% Define the full path to the SOFA file
sofa_file_path = fullfile(dataPath, hrtf_set_filename);

% Check if the SOFA file exists
while ~exist(sofa_file_path, 'file')
    % Prompt the user to enter the name of the SOFA file
    hrtf_set_filename = input('Enter the name of the SOFA file: ', 's');
    sofa_file_path = fullfile(dataPath, hrtf_set_filename);

    % Check if the specified SOFA file exists
    if exist(sofa_file_path, 'file')
        disp('SOFA file exists.');
    else
        disp('SOFA file does not exist at the specified path. Please try again.');
    end
end

%% Extract the sampling rate.
% Load the existing SOFA file
hrtf_data = SOFAload(sofa_file_path);
% Display the sampling rate from the selected file.
fs = hrtf_data.Data.SamplingRate;
disp(['Sampling rate: ' num2str(fs) ' Hz']);


%% Generate Gaussian white noise
% Duration of the noise burst in seconds
duration = 1;
% Generate Gaussian white noise burst
noise_burst = randn(fs * duration, 1);
% Create smooth on/offset ramps of 10 ms
ramp_duration = 0.01;  % Ramp duration in seconds
ramp_samples = round(fs * ramp_duration);
% Hanning window (create a ramp)
ramp = hanning(2 * ramp_samples);
on_ramp = ramp(1:ramp_samples);  % First half of the Hanning window
off_ramp = ramp(ramp_samples + 1:end);  % Second half of the Hanning window
% Apply ramps to the noise burst
noise_burst(1:ramp_samples) = noise_burst(1:ramp_samples) .* on_ramp;
noise_burst(end-ramp_samples+1:end) = noise_burst(end-ramp_samples+1:end) .* off_ramp;

%Plot the WN spectrogram
figure 1;
sgram(noise_burst, fs, 'dynrange', 60);
title('Spectrogram of a Gaussian White Noise Burst');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
% Adjust the position of the y-axis label to avoid being on top of the yaxis values.
ylabel('Frequency (Hz)', 'Units', 'normalized', 'Position', [-0.1, 0.5]);

%%
%% Trajectory 1 : Horizontal clockwise rotation
num_points = 1000;  % Number of points in the trajectory
azi = linspace(0, 360, num_points);  % Azimuth angles from 0 to 360 degrees (varying azimuth)
ele = zeros(1, num_points);  % Elevation angle at 0 degrees
r = ones(1, num_points);  % 1 meter radius

%% Apply the SOFAspat function for Trajectory 1
[out, azi_out, ele_out, r_out, idx] = SOFAspat(noise_burst, hrtf_data, azi, ele, r);

% Plot Trajectory 1
figure 2;

% Global title Trajectory 1
annotation('textbox', [0.1, 0.97, 0.8, 0.03], 'String', 'Horizontal clockwise rotation around the listener (distance of 1 meter)', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'EdgeColor', 'none');

% Left Ear subplot Trajectory 1
subplot(2, 1, 1);
sgram(out(:,1), fs, 'dynrange', 60);  % Plot the spectrogram of the left ear signal
colorbar;
title('Left Ear');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
ylabel('Frequency (Hz)', 'Units', 'normalized', 'Position', [-0.1, 0.5]);

% Right Ear subplot Trajectory 1
subplot(2, 1, 2);
sgram(out(:,2), fs, 'dynrange', 60);  % Plot the spectrogram of the right ear signal
colorbar;
title('Right Ear');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
ylabel('Frequency (Hz)', 'Units', 'normalized', 'Position', [-0.1, 0.5]);


%% Trajectory 2 : approach from left (90° azimuth, 0° elevation, radius decreasing from 1 m to 0.2 m)
%% Define the spatial trajectory for the left ear (approach from the left)
num_points = 1000;  % Number of points in the trajectory
azi_left = linspace(90, 90, num_points);  % Azimuth angle fixed at 90 degrees (approach from the left)
ele_left = zeros(1, num_points);  % Elevation angle fixed at 0 degrees
r_left = linspace(1, 0.2, num_points);  % Distance decreasing from 1 meter to 0.2 meters

%% Apply the SOFAspat function for the left ear (Trajectory 2)
[out_left, azi_out_left, ele_out_left, r_out_left, idx_left] = SOFAspat(noise_burst, hrtf_data, azi_left, ele_left, r_left);

%% Define the spatial trajectory for the right ear (approach from the left)
azi_right = linspace(270, 270, num_points);  % Azimuth angle fixed at 270 degrees (approach from the left
ele_right = zeros(1, num_points);  % Elevation angle fixed at 0 degrees
r_right = linspace(0.2, 1, num_points);  % Distance decreasing from 1 meter to 0.2 meters

%% Apply the SOFAspat function for the right ear (Trajectory 2)
[out_right, azi_out_right, ele_out_right, r_out_right, idx_right] = SOFAspat(noise_burst, hrtf_data, azi_right, ele_right, r_right);
;

%% Plot Trajectory 2
figure 3 ;

% Global title Trajectory 2
annotation('textbox', [0.1, 0.97, 0.8, 0.03], 'String', 'Approach from left with a radius decreasing from 1 m to 0.2 m', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'EdgeColor', 'none');

% Left Ear subplot (Trajectory 2)
subplot(2, 1, 1);
sgram(out_left(:,1), fs, 'dynrange', 60);  % Plot the spectrogram of the left ear signal
colorbar;
title('Left Ear');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
ylabel('Frequency (Hz)', 'Units', 'normalized', 'Position', [-0.1, 0.5]);
% Right Ear subplot (Trajectory 2)
subplot(2, 1, 2);
sgram(out_right(:,1), fs, 'dynrange', 60);  % Plot the spectrogram of the right ear signal
colorbar;
title('Right Ear');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
ylabel('Frequency (Hz)', 'Units', 'normalized', 'Position', [-0.1, 0.5]);


% Trajectory 3: Approach from front
num_points = 1000;  % Number of points in the trajectory
azi = zeros(1, num_points);  % Azimuth angle fixed at 0 degrees
ele = zeros(1, num_points);  % Elevation angle fixed at 0 degrees
r = linspace(0.2, 1, num_points);  % Radius decreasing from 1 m to 0.2 m

% Apply the SOFAspat function for both ears (Trajectory 3)
[out_left, azi_left, ele_left, r_left, idx_left] = SOFAspat(noise_burst, hrtf_data, azi, ele, r);
[out_right, azi_right, ele_right, r_right, idx_right] = SOFAspat(noise_burst, hrtf_data, azi, ele, r);

%% Plot Trajectory 3
figure 4;

% Global title Trajectory 3
annotation('textbox', [0.1, 0.97, 0.8, 0.03], 'String', 'Approach from front with a radius decreasing from 1 m to 0.2 m', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'EdgeColor', 'none');

% Left Ear subplot (Trajectory 3)
subplot(2, 1, 1);
sgram(out_left(:, 1), fs, 'dynrange', 60);
colorbar;
title('Left Ear');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
ylabel('Frequency (Hz)', 'Units', 'normalized', 'Position', [-0.1, 0.5]);

% Right Ear subplot (Trajectory 3)
subplot(2, 1, 2);
sgram(out_right(:, 1), fs, 'dynrange', 60);
colorbar;
title('Right Ear');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
ylabel('Frequency (Hz)', 'Units', 'normalized', 'Position', [-0.1, 0.5]);
