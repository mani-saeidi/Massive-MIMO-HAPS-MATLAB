% Parameters:
f0 = 159e6; % Carrier frequency suitable for satellite communication
c = 3e8; % Speed of light
l = c / f0; % Wavelength
d = l / 2; % Spacing in Rx Array
M = 16; % Tx Antenna Array Size
theta = 2 * pi * (rand(1, M)); % Random angular separation of users
EbNo = 1; % Normalized SNR: energy per bit to noise power spectral density ratio
EbNo2 = 2; % Normalized SNR: energy per bit to noise power spectral density ratio
EbNo5 = 5; % Normalized SNR: energy per bit to noise power spectral density ratio
EbNo10 = 10; % Normalized SNR: energy per bit to noise power spectral density ratio
sigma = 1 / sqrt(2 * EbNo); % Noise standard deviation 
sigma2 = 1 / sqrt(2 * EbNo2); % Noise standard deviation 
sigma5 = 1 / sqrt(2 * EbNo5); % Noise standard deviation 
sigma10 = 1 / sqrt(2 * EbNo10); % Noise standard deviation 
v_sat = 2; % Satellite velocity in km/s
f_doppler = v_sat * f0 / c; % Doppler shift frequency

n = 1:N; % From 1 to maximum number of receiving Antennas
n = transpose(n); % Transposing row to column vector

% Receiver signal model (linear) with free space path loss and doppler shift
s=2*(round(rand(M,1))-0.5);           %BPSK signal of length M

% FOR NLOS % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
path_loss = 20 * log10(4 * pi * 100000 * f_doppler / c); % Free space path loss
H = (1 / sqrt(2)) * (randn(N, M) + 1i * randn(N, M)) * 10^(-path_loss / 20);
wn = sigma * (randn(N, 1) + 1i * randn(N, 1)); % AWGN noise of length N
wn2 = sigma2 * (randn(N, 1) + 1i * randn(N, 1)); % AWGN noise of length N
wn5 = sigma5 * (randn(N, 1) + 1i * randn(N, 1)); % AWGN noise of length N
wn10 = sigma10 * (randn(N, 1) + 1i * randn(N, 1)); % AWGN noise of length N
x = H * s + wn; % Receive vector of length N
x2 = H * s + wn2; % Receive vector of length N
x5 = H * s + wn5; % Receive vector of length N
x10 = H * s + wn10; % Receive vector of length N
%%%%%%%%%%%%%%%%%%%
% Precoding Methods
% MMSE Precoding
y = (H' * H + (2 * sigma^2) * eye([M, M]))^(-1) * (H') * x;
y2 = (H' * H + (2 * sigma2^2) * eye([M, M]))^(-1) * (H') * x2;
y3 = (H' * H + (2 * sigma5^2) * eye([M, M]))^(-1) * (H') * x5;
y4 = (H' * H + (2 * sigma10^2) * eye([M, M]))^(-1) * (H') * x10;
% ZF Precoding
W = pinv(H);
output = W * x;
output2 = W * x2;
output5 = W * x5;
output10 = W * x10;
%%%%%%%%%%%%%%%%%%%

% Demodulation + Calculating BER
demod_mmse = sign(real(y)); % Demodulating
ber_from_mmse = sum(s ~= demod_mmse) / length(s); % BER calculation

% Demodulation + Calculating BER
demod_mmse2 = sign(real(y2)); % Demodulating
ber_from_mmse2 = sum(s ~= demod_mmse2) / length(s); % BER calculation

% Demodulation + Calculating BER
demod_mmse5 = sign(real(y3)); % Demodulating
ber_from_mmse5 = sum(s ~= demod_mmse5) / length(s); % BER calculation

% Demodulation + Calculating BER
demod_mmse10 = sign(real(y4)); % Demodulating
ber_from_mmse10 = sum(s ~= demod_mmse10) / length(s); % BER calculation

demod_zf = sign(real(output)); % Demodulating
ber_from_zf = sum(s ~= demod_zf) / length(s); % BER calculation

demod_zf2 = sign(real(output2)); % Demodulating
ber_from_zf2 = sum(s ~= demod_zf2) / length(s); % BER calculation

demod_zf5 = sign(real(output5)); % Demodulating
ber_from_zf5 = sum(s ~= demod_zf5) / length(s); % BER calculation

demod_zf10 = sign(real(output10)); % Demodulating
ber_from_zf10 = sum(s ~= demod_zf10) / length(s); % BER calculation

%% BER Vector Results
BER_mmse_vec(k) = ber_from_mmse; % Putting BER in Vector
BER_zf_vec(k) = ber_from_zf; % Putting BER in Vector

BER_mmse_vec2(k) = ber_from_mmse2; % Putting BER in Vector
BER_zf_vec2(k) = ber_from_zf2; % Putting BER in Vector

BER_mmse_vec5(k) = ber_from_mmse5; % Putting BER in Vector
BER_zf_vec5(k) = ber_from_zf5; % Putting BER in Vector

BER_mmse_vec10(k) = ber_from_mmse10; % Putting BER in Vector
BER_zf_vec10(k) = ber_from_zf10; % Putting BER in Vector
