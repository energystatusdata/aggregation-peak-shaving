function [results] = run_aggregation_experiment(input_dataset, multiplicator, efficiency, aggregation_type, aggregation_intervals, baseMaxPeak)
    % RUN_AGGREGATION_EXPERIMENT
    % 
    % Runs the aggregation experiment for the
    % given arguments. Results are placed in .csv-Files in the folder
    % out_MP, where MP is the given target maximum peak value.
    %
    % aggregation modes are:
    %   0 = sampling (zero-order hold),
    %   1 = average (movmean)
    %
    % The first element in samplingSteps is used as the baseline.
    
    maxPeak = baseMaxPeak * multiplicator;
    
    experiment_quantiles = [0, 0.1, 0.25, 0.5, 0.75, 0.9, 1];

    if (aggregation_type == 0)
        aggregation_type_string = "zoh";
    else
        aggregation_type_string = "averaging";
    end
    
    out_folder = "out_" + maxPeak;
    if (exist(out_folder, 'dir'))
        disp("Warning, folder " + out_folder + " already exists. Continuing.");
    elseif (exist(out_folder))
        disp(out_folder + " exists, but is not a folder. Exiting.");
        return;
    else
        disp("Creating output folder " + out_folder);
        mkdir(out_folder);
    end
    
    results_filename = out_folder + "/" + join(["results" "maxPeak" maxPeak "multiplicator" multiplicator aggregation_type_string], "_") + ".csv";
    
    results = [];
    for day_index = 1:size(input_dataset, 2) % for each day in the input data set
        ts = input_dataset(day_index);
        
        for steps = 1:size(aggregation_intervals, 2)
            % first value is reference            
            aggregation_interval = aggregation_intervals(steps);

            if (aggregation_type == 0)
                manipulatorSampling = SamplingManipulator_ZOH(aggregation_interval);
            else
                manipulatorSampling = SamplingManipulator_Averaging(aggregation_interval);
            end 
            
            disp(join([...
                "day = " day_index ...
                ", aggregation_interval = " aggregation_interval, ...
                ", aggregation_type = ", aggregation_type_string], ""));

            % apply sampling
            ts_manipulated = manipulatorSampling.manipulate(ts);
            
            % simple scaling: multiplication
            ts_manipulated.Data = ts_manipulated.Data * multiplicator;
            
            % extract features: fft-windows and statistical data.
            fftwindows_ts = fftwindows(ts_manipulated, aggregation_interval);
            fftwindows_ts_norm_max = fftwindows_ts / max(fftwindows_ts);
            
            quantiles_ts = quantile(ts_manipulated.Data, experiment_quantiles);
            mean_ts = mean(ts_manipulated.Data);
            std_ts = std(ts_manipulated.Data);
            var_ts = var(ts_manipulated.Data);
            
            % calculate optimization result
            optimization_result = optimizePeakShaving(ts_manipulated, maxPeak, efficiency);
            C = optimization_result.C;
            if (isempty(C)) % if no solution can be found, write NA to data
                C = NaN;
                disp("No solution found.")
            end

            % first sampling step is used as reference value.
            if (steps == 1)
                C_reference = C;
                R = 0;
                R_rel = 0;
            else
                % if not in the first step, calculate error to reference
                R = C - C_reference;
                if (C == C_reference)
                    R_rel = 0;
                else
                    R_rel = (C / C_reference) - 1;
                end
            end
            
            
            results = [ results; [ day_index maxPeak multiplicator ...
                aggregation_interval aggregation_type ...
                C C_reference R R_rel ...
                quantiles_ts mean_ts std_ts var_ts ...
                fftwindows_ts' ...
                fftwindows_ts_norm_max' ]];
        end
    end
    
    dlmwrite(results_filename, results, 'delimiter', ',', 'precision', 9);
end