# CNN-Stroke-Event-Detection-Pilot
This repository contains the working code for the pilot experiments of [CNN-Stroke-Event-Detection](https://github.com/RyanWoodward132/CNN-Stroke-Event-Detection).

## Overview
The goal of this project is to build a Convolutional Neural Network (CNN) that predicts four stroke events in elite level freestyle (Entry, Catch, Pull, Push). This pilot experiment will use 3-axis accelerometer data and derived features. The full experiment wil extend this to also include gyroscopic and magnetometer data as well. 

## Status
| Stage | Status |
|---|---|
| Data collection | Complete |
| Data processing | In progress |
| Model building and training | Pending |
| Model evaluation | Pending |

## Methods
Participants wore a sensor on their upper back (between the shoulder blades) while swimming. The accelerometer recorded movement along three axes — Vertical, Lateral, and Sagittal — at 100 Hz. Stroke events were manually labelled by reviewing synchronised video recordings and exported as timestamped event files.

### Raw Data Processing (`Raw Processing/RW.R`)
The R script handles the following steps:

1. **Time conversion** — absolute timestamps are converted to elapsed time in seconds from the start of the recording.
2. **Event file synchronisation** — each participant's session is split across multiple event files (named by their approximate position in the recording). These files are not automatically aligned; synchronisation is done by hand using shared reference events visible in the video.
3. **Artifact removal** — entries flagged as `[0x0 double]` or `Sync` are removed, and event timestamps are coerced to numeric.
4. **Event merging** — the cleaned and synced event files are combined into a single dataframe for use with the model.

## Data

```
Data/
└── Raw/
    ├── Accel/          # Processed accelerometer data (elapsed time in seconds)
    │   └── RW.csv
    └── Temp/
        ├── Accel/      # Raw accelerometer data (absolute timestamps)
        │   ├── AC.csv
        │   ├── IR.csv
        │   ├── JD.csv
        │   ├── JH.csv
        │   ├── KE.csv
        │   └── RW.csv
        └── Events/     # Raw stroke event files (timestamps, unsynchronised)
            ├── RW_5.csv
            ├── RW_15.csv
            ├── RW_25.csv
            ├── RW_35.csv
            └── RW_45.csv
```

**Accelerometer files** contain four columns: `Time`, `Vertical`, `Lateral`, `Sagittal`.

**Event files** contain stroke event timestamps that must be manually synchronised to the corresponding accelerometer recording before use.

> **Note:** The data used here measures only 3-axis accelerometer data. The full experiment will also record 3-axis gyroscopic and 3-axis magnetometer data.



## Dependencies
The processing scripts are written in R. The following packages are required:

- [`readr`](https://readr.tidyverse.org/)
- [`lubridate`](https://lubridate.tidyverse.org/)
- [`tidyverse`](https://www.tidyverse.org/)
- [`ggplot2`](https://ggplot2.tidyverse.org/)
- [`patchwork`](https://patchwork.data-imaginist.com/)
- [`stringr`](https://stringr.tidyverse.org/)

Install all at once with:
```r
install.packages(c("readr", "lubridate", "tidyverse", "ggplot2", "patchwork", "stringr"))
```
