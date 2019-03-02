classdef (Abstract) TimeseriesManipulator
     % TIMESERIESMANIPULATOR
     %
     % base class for methods of disturbing a time series.
     % most notably, we use aggregation.
     %
     % See also SamplingManipulator_Averaging, SamplingManipulator_ZOH
     methods(Abstract)      
            [manipulated_ts] = manipulate(obj, inputTimeseries)           
     end    
end

