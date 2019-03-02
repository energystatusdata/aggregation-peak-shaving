function combine_result_csvs(targetMaxPeak)
    out_filename = "out/results_" + targetMaxPeak + ".csv";

    if (exist(out_filename))
        disp(out_filename + " already exists. Aborting.");
        return;
    end
    
    fid = fopen(out_filename, 'w');

    header = "day,max_peak,multi,aggregation_interval,aggregation_type," + ...
        "C,C_reference,R,R_rel," + ...
        "q0,q10,q25,q50,q75,q90,q100," + ...
        "mean,std,var," + ...
        "fft1,fft2,fft3,fft4,fft5,fft6,fft7,fft8,fft9,fft10,fft11,fft12," + ...
        "fft1n,fft2n,fft3n,fft4n,fft5n,fft6n,fft7n,fft8n,fft9n,fft10n,fft11n,fft12n";

    fprintf(fid, "%s\n", header);
    fclose(fid);
    
    % combine created .csv files into one result file
    result_csvs = dir("out_" + targetMaxPeak + "/results_*.csv");
    for result_csv = result_csvs'
        partial_data = dlmread(result_csv.folder + "/" + result_csv.name, ",");
        dlmwrite(out_filename, partial_data, '-append');
    end
end