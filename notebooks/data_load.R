# "day,max_peak,multi,aggregation_interval,aggregation_type," + ...
#         "C,C_reference,R,R_rel," + ...
#         "q0,q10,q25,q50,q75,q90,q100," + ...
#         "mean,std,var," + ...
#         "fft1,fft2,fft3,fft4,fft5,fft6,fft7,fft8,fft9,fft10,fft11,fft12," + ...
#         "fft1n,fft2n,fft3n,fft4n,fft5n,fft6n,fft7n,fft8n,fft9n,fft10n,fft11n,fft12n"

# quantiles_ts is a vector of 7: 0, 0.1, 0.25, 0.5, 0.75, 0.9, 1
# fftwindows and fftwindows_norm_max are 12 values each

load_result <- function(filename){
    df <- read_csv(filename,
               col_names=T,
               cols(
                   .default = col_double(),
      day = col_integer(),
      max_peak = col_integer(),
      multi = col_integer(),
      aggregation_interval = col_integer(),
      aggregation_type = col_factor()
    )) %>%
    mutate(aggregation_type = fct_recode(aggregation_type,
                                      "average" = "1", "zero-order hold" = "0")
    )
}

load_from_path <- function(path){
    files <- paste0(path, "/", list.files(path = path, pattern = ".csv"))
    bind_rows(lapply(files, load_result))
}