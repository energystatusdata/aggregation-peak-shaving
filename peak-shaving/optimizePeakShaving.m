function [result] = optimizePeakShaving(inputTimeseries, maxPeak, efficiency)
    % OPTIMIZEPEAKSHAVING
    %
    % Solves the optimization problem for peak shaving
    
    L = squeeze(inputTimeseries.data);
    dt = (inputTimeseries.Time(2) - inputTimeseries.Time(1)) * 24;
    
    powerprob = optimproblem('ObjectiveSense', 'min');

    T = numel(L);
    
    % the index used for the constraints (all t, except for t = 1).
    allButFirstT = 2:T;

    C   = optimvar('C', 1, 'LowerBound', 0);
    
    P_c = optimvar('P_c', T, 1, 'LowerBound', 0);
    P_d = optimvar('P_d', T, 1, 'LowerBound', 0);
    b   = optimvar('b',   T, 1, 'LowerBound', 0);
    
    powerprob.Objective = C;

    powerprob.Constraints.ChargeStateStart = b(1) == C;
    powerprob.Constraints.ChargeStateEnd   = b(T) == C;
    powerprob.Constraints.ChargeStateMax   = b <= C;
    
    powerprob.Constraints.ChargeState      = b(allButFirstT) == b(allButFirstT - 1) + P_c(allButFirstT - 1) * efficiency * dt ...
                                                                                    - P_d(allButFirstT - 1) * (1/efficiency) * dt;
 
    powerprob.Constraints.NoChargingAtT    = P_c(T) == 0;
    powerprob.Constraints.NoDischargingAtT = P_d(T) == 0;

    powerprob.Constraints.ChargeLimit      = P_c * efficiency * dt <= C - b;
    powerprob.Constraints.DischargeLimit   = P_d * (1/efficiency) * dt <= b;
    
    powerprob.Constraints.ChargeLimit2     = P_c <= max(maxPeak - L, 0);
    powerprob.Constraints.DischargeLimit2  = P_d == max(L - maxPeak, 0);
    
    options = optimoptions('linprog');
    options.Display = 'off';
    result = solve(powerprob, 'options', options);
end