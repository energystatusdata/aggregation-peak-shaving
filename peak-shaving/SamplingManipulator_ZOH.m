classdef SamplingManipulator_ZOH < TimeseriesManipulator
    properties
        window_size_in_seconds
    end
    
    methods
        function obj = SamplingManipulator_ZOH(window_size_in_seconds)
            obj.window_size_in_seconds = window_size_in_seconds;
        end
    end
    
    
    methods
        function [manipulated_ts] = manipulate(obj, inputTimeseries)
             if obj.window_size_in_seconds > 0
                 manipulated_ts = obj.resampleTimeseries(inputTimeseries);
             else
                manipulated_ts = inputTimeseries; 
             end
           
        end
    end
        
    methods (Access = private)
      
        function [output_ts] = resampleTimeseries(obj, inputTimeseries)
            % since movmean only works on arrays, we first upsample to a
            % constant time series distance
            end_of_time = max(inputTimeseries.Time);
            
            % upsample to (in seconds):
            upsample_rate = 1;
            
            % in seconds
            upsampled = resample(inputTimeseries, (0:(1/24/60/60)*upsample_rate:end_of_time));
                        
            % window size in timesteps on upsampled timeseries
            window_size = obj.window_size_in_seconds / upsample_rate;
            
            time_vector = (0:(1/24/60/60)*obj.window_size_in_seconds:end_of_time);
            output_ts = resample(upsampled, time_vector, 'zoh');
        end
    end
end

