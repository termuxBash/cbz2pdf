# Comic to PDF Converter

A simple Python script that converts `.cbz`, `.zip`, `.cbr`, and `.rar` comic archives into compressed PDF files.

## Requirements

### Python

Python 3 is required.

Install the Python dependencies:

```bash
pip3 install Pillow img2pdf
```

### System packages

The script also requires these command-line tools:

* `unzip` — extracts `.cbz` / `.zip` files
* `7z` — extracts `.cbr` / `.rar` files
* `ls` — used to list files

On Debian/Ubuntu:

```bash
sudo apt install unzip p7zip-full
```

`ls` is normally already included with the standard system utilities.

## Usage

Place the script in a directory containing your comic archives:

```text
comics/
├── comic1.cbz
├── comic2.cbr
├── comic3.zip
└── comic4.rar
```

Run:

```bash
python3 comic2pdf.py
```

The script will convert the archives into PDF files.

## Supported formats

### Input

* `.cbz`
* `.zip`
* `.cbr`
* `.rar`

### Output

* `.pdf`

## Image Processing

Images are:

1. Resized to a maximum width of **1100 px**
2. Converted to JPEG
3. Automatically detected as grayscale or color
4. Compressed using different JPEG quality settings:

   * Black & white: `38`
   * Color: `55`
5. Combined into a PDF using `img2pdf`

These settings can be changed at the top of the script:

```python
MAX_WIDTH = 1100
BW_QUALITY = 38
COLOR_QUALITY = 55
```

## RAM Extraction

Archives up to **500 MB uncompressed** are extracted into:

```text
../ram500mb
```

Larger ZIP archives are extracted into:

```text
Teemp
```

The temporary directories are cleaned after processing.

## Notes

The script uses external commands (`unzip`, `7z`, and `ls`), so these must be available in `$PATH`.

The script is intended primarily for Linux/Unix-like systems.
