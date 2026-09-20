# cbz2pdf

Tools for converting CBZ/CBR comic files to PDF.

This repository provides **two ways** to convert comics:

* **Bash/Termux version** — designed for Android/Termux and can download files directly from Mega.
* **Python version** — converts existing CBZ/CBR/ZIP/RAR files on a Linux/Unix-like system.

---

# Option 1 — Bash / Termux

The Bash version is designed to run in **Termux** and can download comic files directly from `mega.io`.

## Prerequisites

* Installed and running version of [Termux](https://f-droid.org/en/packages/com.termux/).
* [Termux:API](https://f-droid.org/en/packages/com.termux.api/) — recommended.

### Installation

#### Setup file (Recommended)

```sh
bash <(curl -s https://raw.githubusercontent.com/termuxBash/cbz2pdf/main/setup.sh)
```

#### Git

```sh
pkg install git
git clone https://github.com/ag23sharp/cbz2pdf.git
cd cbz2pdf
bash cbz2pdf.sh
```

#### Curl

```sh
curl -O https://raw.githubusercontent.com/termuxBash/cbz2pdf/main/cbz2pdf.sh
bash cbz2pdf.sh
```

### Dependencies

Install the required packages:

```sh
pkg install git
pkg install imagemagick
pkg install pdftk
pkg install megacmd
pkg install termux-api
```

### Usage

1. Run the script:

   ```sh
   bash cbz2pdf.sh
   ```

   If installed using the setup script, you can also run:

   ```sh
   cbz
   ```

2. Use the **Add List** function to add the corresponding passwords and URLs.

3. Run the script again and select the option to **Download** and then **Convert** the files.

4. The converted PDF files are saved in the `.huge` folder.

---

# Option 2 — Python

The Python version is intended for converting **existing comic archives** on Linux/Unix-like systems.

It does not download files from Mega.

## Supported input formats

* `.cbz`
* `.zip`
* `.cbr`
* `.rar`

Output:

* `.pdf`

## Prerequisites

Python 3 is required.

Install the Python dependencies:

```sh
pip3 install Pillow img2pdf
```

The following system utilities are also required:

* `unzip`
* `7z`
* `ls`

On Debian/Ubuntu:

```sh
sudo apt install unzip p7zip-full
```

`ls` is normally already installed on standard Linux systems.

## Usage

Put the Python script in a directory containing your comic archives:

```text
comics/
├── comic1.cbz
├── comic2.cbr
├── comic3.zip
└── comic4.rar
```

Run:

```sh
python3 comic2pdf.py
```

The script will process the archives and create PDF files in the same directory.

## Image Processing

The Python version:

1. Resizes images to a maximum width of **1100 px**.
2. Detects whether an image is grayscale or color.
3. Converts images to JPEG.
4. Uses different JPEG quality settings for grayscale and color images.
5. Combines the processed images into a PDF.

The main compression settings can be changed in the script:

```python
MAX_WIDTH = 1100
BW_QUALITY = 38
COLOR_QUALITY = 55
```

## Temporary Storage

Archives with an uncompressed size of up to **500 MB** are extracted to:

```text
../ram500mb
```

Larger ZIP archives are extracted to:

```text
Teemp
```

Temporary files and directories are cleaned after conversion.

---

# Which version should I use?

| Feature                   | Bash / Termux | Python                               |
| ------------------------- | ------------- | ------------------------------------ |
| Android / Termux          | ✅             | Possible, but not the primary target |
| Linux                     | ❌/Limited     | ✅                                    |
| CBZ                       | ✅             | ✅                                    |
| CBR                       | ✅             | ✅                                    |
| ZIP                       | —             | ✅                                    |
| RAR                       | —             | ✅                                    |
| Download from Mega        | ✅             | ❌                                    |
| Image compression         | ImageMagick   | Pillow                               |
| PDF creation              | pdftk         | img2pdf                              |
| Interactive download list | ✅             | ❌                                    |

**Use the Bash version** if you want the Termux workflow and Mega downloads.

**Use the Python version** if you already have comic archives and want a standalone archive-to-PDF converter.
