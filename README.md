# Experiments for the Effect of Aggregation on Battery Sizing 

## Overview

This repository holds code and data to run experiments for the effect of time series aggregation on a battery sizing algorithm for peak shaving.

The input data can be found in `data/consumption_data.mat`. It consists of 281 consumption curves from an industrial manufacturing site. This data set has been published as the HIPE dataset. For more details on the data set, please refer to the [companion website](https://www.energystatusdata.kit.edu/hipe.php), or the [https://doi.org/10.1145/3208903.3210278](paper). Note that the data set contained in this repository covers more days than the original publication, but only provides consumption data from the main terminal.

The experiments are provided as MATLAB code and can be found in `peak-shaving`.
`peak-shaving/example_peak_shaving_figure.m` is an example for applying our optimization on non-aggregated data.
The entry point for the experiment series is `peak-shaving/run_all_experiments.m`.
When experiments have been run, their results are exported as CSV files in the folder `peak-shaving/out`.

Further data analysis code can be found as [Jupyter notebooks](https://jupyter.org/) in the folder `notebooks`. The input data for the notebooks is to be placed in `data`. If you want to re-run the experiments, please note that you need to copy the results of the MATLAB experiments manually to `data`.

## Licencing
We licence the code and the data provided in this repository separately, as described below.

If you use this code or data set in your scientific work, please reference the companion paper.

### Code
All code provided in this repository is licenced under the MIT License. See LICENSE_CODE for details.

Here, code is: R code (\*.R), Jupyter notebook descriptions (\*.ipynb), and MATLAB code (\*.m).

### Data
The data provided in this repository is licensed under the Creative Commons Attribution 4.0 International License. A copy of this licence is provided with the repository (see LICENCE_DATA). To view a copy of this license, you can also visit http://creativecommons.org/licenses/by/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

Here, data is: the used consumption data (data/consumption_data.mat) and derived results (\*.csv).
