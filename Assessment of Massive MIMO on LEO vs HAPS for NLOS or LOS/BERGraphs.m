clear all
close all 

% UNCOMMENT FOR LOS:
Nr = 16:8:128; % Number of receiving antennas from 16 to 128 in multiples of 8

% NLOS:
% Nr = 2:2:40; % Number of receiving antennas from 2 to 40 in multiples of 2

for j=1:length(Nr)  % from 1 to total number of multiples of Nr
    N=Nr(j); % Picking current value of Nr

    for k=1:20000 % # of Trials
%         UNCOMMENT ONE OF THE FOLLOWING:
        BERCalcLOSLEO; % BERCalc.m Program
%         BERCalcLOSHAPS; % BERCalc.m Program
%           BERCalcNLOSLEO; % BERCalc.m Program
%         BERCalcNLOSHAPS; % BERCalcNLOS.m Program

        BER_mmse_vec(k)=ber_from_mmse; % Putting MMSE BER in Vector
        BER_zf_vec(k)=ber_from_zf; % Putting ZF BER in Vector

        BER_mmse_vec2(k)=ber_from_mmse2; % Putting MMSE BER in Vector
        BER_zf_vec2(k)=ber_from_zf2; % Putting ZF BER in Vector

        BER_mmse_vec5(k)=ber_from_mmse5; % Putting MMSE BER in Vector
        BER_zf_vec5(k)=ber_from_zf5; % Putting ZF BER in Vector

        BER_mmse_vec10(k)=ber_from_mmse10; % Putting MMSE BER in Vector
        BER_zf_vec10(k)=ber_from_zf10; % Putting ZF BER in Vector
    end

    BER_total_mmse(j)=mean(BER_mmse_vec) % Calculating the mean BER for each N
    BER_total_mmse2(j)=mean(BER_mmse_vec2) % Calculating the mean BER for each N
    BER_total_mmse5(j)=mean(BER_mmse_vec5) % Calculating the mean BER for each N
    BER_total_mmse10(j)=mean(BER_mmse_vec10) % Calculating the mean BER for each N
    BER_total_zf(j)=mean(BER_zf_vec) % Calculating the mean BER for each N
    BER_total_zf2(j)=mean(BER_zf_vec2) % Calculating the mean BER for each N
    BER_total_zf5(j)=mean(BER_zf_vec5) % Calculating the mean BER for each N
    BER_total_zf10(j)=mean(BER_zf_vec10) % Calculating the mean BER for each N
end

semilogy(Nr, BER_total_mmse,"o-") % Logarithmic Scale Plot of BER MMSE
xlabel("Receive Array Size(N)") % x-axis
ylabel("BER") % y-axis
hold on 
grid on 
semilogy(Nr, BER_total_mmse2,"--+") % Logarithmic Scale Plot of BER MMSE
hold on 
semilogy(Nr, BER_total_mmse5,"--x") % Logarithmic Scale Plot of BER MMSE
hold on 
semilogy(Nr, BER_total_mmse10,"*-") % Logarithmic Scale Plot of BER MMSE
hold on 
semilogy(Nr, BER_total_zf,".-") % Logarithmic Scale Plot of BER MMSE
hold on 
semilogy(Nr, BER_total_zf2,"v-") % Logarithmic Scale Plot of BER MMSE
hold on 
semilogy(Nr, BER_total_zf5,"diamond-") % Logarithmic Scale Plot of BER MMSE
hold on 
semilogy(Nr, BER_total_zf10,"square-") % Logarithmic Scale Plot of BER MMSE
hold on 

legend('MMSE Precoding with Eb/No 1','MMSE Precoding with Eb/No of 2','MMSE Precoding with Eb/No of 5','MMSE Precoding with Eb/No of 10','Zero-Force Precoding with Eb/No of 1','Zero-Force Precoding with Eb/No of 2','Zero-Force Precoding with Eb/No of 5','Zero-Force Precoding with Eb/No of 10')
title('BER vs. # of Rx Antennas - Massive MIMO on LEO with ZF & MMSE Precoding - LOS')
