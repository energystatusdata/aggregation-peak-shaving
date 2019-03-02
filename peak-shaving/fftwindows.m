function [windows] = fftwindows(ts, samplingPeriod)
    % FFTWINDOWS
    %
    % Extracts 12 values fom the single-sided amplitude spectrum of the
    % timeseries as features fo the prediction (see Section 3.3).
    
    T = samplingPeriod;  % Sampling period       
    Fs = 1/T;            % Sampling frequency                    

    L = 24*60*60 * Fs;   % Length of signal
    
    if (length(ts.Time) == L - 1)
        if (max(ts.Time) == 1)
            error("Cannot add entry to time series");
        end
        d = ts.Data;
        last_entry = d(end);
        ts = addsample(ts, 'Data', last_entry, 'Time', 1.0);
    end
    
    if (L ~= length(ts.Time))
        error(join(["Length of time series " length(ts.Time) " expected to be " L], ""))
    end

    X = ts.Data;

    % adapted from the MATLAB reference page of the fft method
    % takes the single-sided amplitude spectrum of the signal
    % and slices it into 12 equal-width windows
    Y = fft(X);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    % Create 12 windows over the data
    P_withoutZero = P1;
    P_withoutZero(1) = 0;
    nwindows = 12;
    windowsize = ceil(length(P_withoutZero) / nwindows);
    means = movmean(P_withoutZero, [0 windowsize-1]);
    windows = means(1:windowsize:end);
    windows(13) = 0; % to ensure 12 values
    windows = windows(1:12);
end

