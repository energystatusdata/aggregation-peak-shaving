% To replicate a sensible set of max peaks, use
%   targetMaxPeaks = [38 40 20]
% For a broader experiment, use
%   targetMaxPeaks = [38 40 42 45 50]
%
% Since multiplicator behavior is not unexpected for our initial way of
% scaling, we only use multiplicator 1 here to reduce computation time.
%
% aggregation modes are:
%   0 = sampling (zero-order hold),
%   1 = average (movmean)
%
% The first element in samplingSteps is used as the baseline.
% In our experiments, this is 5 seconds.

loaded_data = load('../data/consumption_data.mat');
consumption_data = loaded_data.consumption_data;

efficiency = 0.97;

targetMaxPeaks = [38 40 20];
multiplicators = [1];
aggregation_modes = [0 1];
samplingSteps = [5 10 30 1*60 5*60 15*60 30*60 60*60 ];

for targetMaxPeak=targetMaxPeaks
    for multiplicator=multiplicators
        for aggregation_mode=aggregation_modes
            run_aggregation_experiment(consumption_data, multiplicator, efficiency, aggregation_mode, samplingSteps, targetMaxPeak);
        end
    end
    
    combine_result_csvs(targetMaxPeak);
end