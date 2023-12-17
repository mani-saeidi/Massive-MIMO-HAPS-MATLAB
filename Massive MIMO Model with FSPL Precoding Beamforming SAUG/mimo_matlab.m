% Number of Transmission Antennas
tx_antennas = 16; 

% Number of Receiver Antennas
rx_antennas = 16;

% Altitude of HAPS is 20 km
altitude = 20e3;

% Carrier Frequency = 3 GHz
f = 3E9;

% Free Space Path Loss where d is the distance between the transmitter and
% receiver antenna in km
d = altitude/1000;
L = 20*log(f) + 20*log(d) + 92.4;
% 3GPP
signal_length = 10;
% precoding and beamforming techniques
% 1 MHz
sampling_rate = 1e6; 

% Radius of the coverage area (meters)
coverageRadius = 50e3;

% % Calculate the power loss factor based on the path loss (in dB)
% power_loss_factor = 10^(-L/10);
% 
% % Scale the random signal by the square root of the power loss factor
% scaled_random_signal = sqrt(power_loss_factor) * random_signal;

% Generate the time-domain signal
random_signal = randn(tx_antennas, signal_length);

% Mix the random_signal with Free Space Path Loss
% Note: Since 'L' is in dB, you need to convert it back to a linear scale first
path_loss_linear = 10^(L/20);  % Convert dB to linear scale
tx_signal_with_path_loss = random_signal / path_loss_linear;


% linear scale factor
filtered_signal = random_signal;

% Create a MIMO channel object
channel = comm.MIMOChannel(...
    'SampleRate', sampling_rate, ...
    'PathDelays', [0 1], ... % Path delays in seconds
    'AveragePathGains', [0 -3], ... % Average path gains in dB
    'NormalizePathGains', true, ...
    'MaximumDopplerShift', 0, ... % Maximum Doppler shift in Hz
    'SpatialCorrelationSpecification', 'None', ...
    'NumTransmitAntennas', tx_antennas, ...
    'NumReceiveAntennas', rx_antennas, ...
    'RandomStream', 'mt19937ar with seed', ...
    'Seed', 42, ...
    'PathGainsOutputPort', true, ... % Output path gains
    'FadingDistribution', 'Rician', ... % Specify Rician fading
    'KFactor', 10); % Specify the Rician K-factor (adjust as needed)

channel_output = channel(filtered_signal.');

% Precoding and beamforming techniques

H = channel_output; % Channel matrix

% Precoding and beamforming techniques
% MMSE Precoding
% Calculate the MMSE precoding matrix
SNR_dB = 20; % Adjust the signal-to-noise ratio (SNR) as needed
SNR = 10^(SNR_dB / 10);
W = (H' * H + (1/SNR) * eye(rx_antennas)) \ H';

% Apply MMSE Precoding
precoded_signal = W' * filtered_signal;
% 
% 
% For example, to steer the signal towards a specific angle 'theta', you can define 'B' as follows:
B = exp(-1i * 2 * pi * f * d * sin(0) / 299792458);

% Apply the beamforming matrix
beamformed_signal = B * precoded_signal;


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % OTHER WAY TO GET SNR"
% Assuming you have your beamformed_signal and random_signal
% Calculate the power of the signal and noise
% signal_power = mean(abs(beamformed_signal(:, closest_channel_index)).^2);
% noise_power = mean(abs(random_signal(1, :)).^2);
% 
% % Calculate SNR in dB
% SNR_dB = 10 * log10(signal_power / noise_power);
% 
% % Display the SNR
% fprintf('SNR (dB): %.2f\n', SNR_dB);
% In this code:
% 
% beamformed_signal is the received signal with Rician fading.
% random_signal is the original random signal.
% signal_power is calculated as the mean of the squared magnitude of the received signal samples from beamformed_signal.
% noise_power is calculated as the mean of the squared magnitude of the original random signal samples from random_signal.
% SNR_dB is calculated in dB using the formula.

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% % Calculate the zero-forcing precoding matrix % Zero-Forcing Precoding
% W = inv(H' * H) * H';
% 
% % Apply Zero-Forcing Precoding
% precoded_signal = W.' * filtered_signal;

% Apply beamforming by multiplying with a beamforming matrix
% Define your beamforming matrix 'B' here to direct the signal to a specific angle

% pathGains contains the path gains for each link (channel)

% Define parameters
numUsers = 100; % Number of users
angleThreshold = 30; % Angle threshold for grouping

% Get user positions (random for simplicity, replace with actual positions)
userPositions = rand(numUsers, 3) * 100; % Random positions within a 100x100x100 cube

% Perform SAUG grouping based on spatial angles
userGroups = saugUserGrouping(userPositions, angleThreshold);

% Display the user groups
disp('User Groups:');
for i = 1:length(userGroups)
    if ~isempty(userGroups{i}) % Check if the group is not empty
        fprintf('Group %d: Users %s\n', i, num2str(userGroups{i}));
    end
end

% Calculate the correlation coefficients between each channel in beamformed_signal and random_signal
correlation_coefficients = zeros(1, size(beamformed_signal, 2));
for i = 1:size(beamformed_signal, 2)
    correlation_coefficients(i) = corr(random_signal(1, :)', beamformed_signal(:, i));
end

% Find the channel index with the highest correlation coefficient
[~, closest_channel_index] = max(correlation_coefficients);


% Plot the original and filtered signals
t = (0:(signal_length-1)) / sampling_rate;
figure;
subplot(2, 1, 1);
plot(t, random_signal(1, :));
title('Original Random Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(t, beamformed_signal(:, closest_channel_index));
title('Received Signal with Rician Fading');
xlabel('Time (s)');
ylabel('Amplitude');

% Calculate the impulse response of the MIMO channel for each receive antenna
% impulse_responses = zeros(length(channel_output), rx_antennas);
% for rxAntenna = 1:rx_antennas
%     impulse_responses(:, rxAntenna) = impz(channel_output(:, rxAntenna));
% end
% 
% % Plot the impulse response for each receive antenna
% figure;
% for rxAntenna = 1:rx_antennas
%     subplot(rx_antennas, 1, rxAntenna);
%     stem(impulse_responses(:, rxAntenna));
%     title(['Impulse Response for Receive Antenna ' num2str(rxAntenna)]);
%     xlabel('Sample Index');
%     ylabel('Amplitude');
% end

% Generate random user positions within a coverage area
% userPositions = randi([-coverageRadius, coverageRadius], 2, numUsers);

% Function to calculate spatial angles between two users
function angle_deg = calculateSpatialAngles(user_i, user_j)
    % Calculate the vector between user_i and user_j
    vector_ij = user_j - user_i;
    
    % Normalize the vectors
    vector_i = user_i / norm(user_i);
    vector_j = user_j / norm(user_j);
    
    % Calculate the dot product between the normalized vectors
    dot_product = dot(vector_i, vector_j);
    
    % Calculate the angle in radians using the dot product
    angle_rad = acos(dot_product);
    
    % Convert the angle from radians to degrees
    angle_deg = rad2deg(angle_rad);
end

% Additional code for SAUG user grouping function (saugUserGrouping)
function userGroups = saugUserGrouping(userPositions, angleThreshold)
    numUsers = size(userPositions, 1);
    userGroups = cell(numUsers, 1);
    userAssigned = false(1, numUsers); % Keep track of whether each user is already assigned
    groupAssigned = false(1, numUsers); % Keep track of whether each group is already formed
    
    groupCount = 0; % Counter for created groups
    
    while any(~userAssigned)
        groupCount = groupCount + 1;
        group = []; % Initialize the group
        
        for i = 1:numUsers
            if ~userAssigned(i) && (~groupAssigned(groupCount) || isempty(group))
                user_i = userPositions(i, :);
                group = [group, i]; % Add user_i to the group
                
                for j = 1:numUsers
                    if i ~= j && ~userAssigned(j)
                        user_j = userPositions(j, :);
                        
                        % Calculate the angle between the two users using the provided function
                        angle_deg = calculateSpatialAngles(user_i, user_j);
                        
                        if angle_deg <= angleThreshold
                            group = [group, j]; % Add user_j to the group
                            userAssigned(j) = true; % Mark user j as assigned
                        end
                    end
                end
                
                userAssigned(i) = true; % Mark user i as assigned
                userGroups{groupCount} = group; % Store the user group
                groupAssigned(groupCount) = true; % Mark the group as formed
            end
        end
    end
end









