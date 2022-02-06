# Rstudio Server Docker Image for UMA MEC

This Docker image is intended for use by students of the subject 'Métodos Estadísticos para la Computación' (Statistical Methods for Computing) at the University of Málaga.

This Rstudio Server image provides a ready-to-use environment designed to immediately start working with R and the Tidyverse without installation or configuration.

To that end, the image is shipped with all the dependencies and configurations necessary for the correct operation of R, Tidyverse and Rstudio. It also includes some useful extra packages. All this trying to keep the image as slim and light as possible.

## Usage
First create a new directory that will be used to store projects data and settings. Then, notice that the `source=` field is empty in the following command. Copy the path to the new directory and fill in the `source=` field (leave no spaces).

```sh
docker run --mount type=bind,source=,target=/home/rstudio --rm -it -p 8787:8787 pvalders/mec-rstudio
```

Run the command and access the server at `localhost:8787`.

Once you are done working, click the shutdown button in the upper right corner of the Rstudio interface and enter ctrl+c in the console to shut down the container.

### Example
In this example I created a new directory in my desktop and copied its path: `/Users/pvalders/Desktop/rstudio`.
Therefore, my command should look like this:

```sh
docker run --mount type=bind,source=/Users/pvalders/Desktop/rstudio,target=/home/rstudio --rm -it -p 8787:8787 pvalders/mec-rstudio
```

## Versions
Ubuntu version: 20.04  
R version: 4.1.1  
Rstudio Server version: 2021.09.1-372

## Installed Packages
- Tidyverse
- Rmarkdown
- Styler
- Renv
- Tinytext

## Supported platforms
This image is compatible with all platforms that support docker with x86 architecture. Support for ARM architecture (e.g. Apple M1) is still a work in progress.
