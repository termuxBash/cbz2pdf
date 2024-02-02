# cbz2pdf
Used to convert cbz to pdf files in termux.

Can download the files directly from mega.io 

# Prerequisites
* Installed and running version of [Termux app](https://f-droid.org/en/packages/com.termux/).

### Installation

## Setup file (Recommended)
```
bash <(curl -s https://raw.githubusercontent.com/termuxBash/cbz2pdf/main/setup.sh)
```

## Git
```sh
$ git clone https://github.com/ag23sharp/cbz2pdf.git
$ cd cbz2pdf
$ bash cbz2pdf.sh
```
## Curl
```sh
$ curl -O https://raw.githubusercontent.com/termuxBash/cbz2pdf/main/cbz2pdf.sh
$ bash cbz2pdf.sh
```
Run the following commands,
* `pkg install git`
* `pkg install imagemagick`
* `pkg install pdftk`
* `pkg install megacmd`

### Usage
1. Run the script using `bash cbz2pdf.sh` and Add list fuction to add the corresponding password and urls.
   > Or run the script using `cbz` if installed via the [Setup file method](https://github.com/termuxBash/cbz2pdf/tree/main#via-setup-file-recommended)
3. Retun the script and Convert the files.
4. The output files are saved in `.huge` folder.
