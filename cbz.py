#!/usr/bin/python3
import os
import sys
import shutil
import re
import subprocess
from PIL import Image
import img2pdf

failed = False

def nlog_info(msg, out=open("comic2pdf_log.txt", "a")):
    print("patool:", msg, file=out)

def olog_info(msg, out=sys.stdout):
    print("patool:", msg, file=out)


# =========================
# TUNABLE SETTINGS
# =========================
MAX_WIDTH = 1100
BW_QUALITY = 38
COLOR_QUALITY = 55


def toPDF2(filename, newdir, ii, move_back=False):

    result = subprocess.run(
        ['ls', '-v', newdir],
        capture_output=True,
        text=True
    )

    ffiles = result.stdout.splitlines()

    image_files = []

    for image in ffiles:

        if not image.lower().endswith(('.jpg', '.jpeg', '.png')):
            continue

        image_path = os.path.join(newdir, image)

        try:
            im = Image.open(image_path)

            # -------------------------
            # resize early (big win)
            # -------------------------
            if im.width > MAX_WIDTH:
                ratio = MAX_WIDTH / im.width
                im = im.resize(
                    (MAX_WIDTH, int(im.height * ratio)),
                    Image.Resampling.LANCZOS
                )

            rgb = im.convert("RGB")

            # -------------------------
            # better grayscale detection
            # -------------------------
            sample = list(rgb.getdata())[::1000]

            is_bw = all(
                abs(r - g) < 10 and abs(g - b) < 10
                for r, g, b in sample
            )

            # -------------------------
            # choose compression mode
            # -------------------------
            if is_bw:
                im = rgb.convert("L")
                quality = BW_QUALITY
            else:
                im = rgb
                quality = COLOR_QUALITY

            temp_file = os.path.join(
                newdir,
                f"{os.path.splitext(image)[0]}_c.jpg"
            )

            im.save(
                temp_file,
                "JPEG",
                quality=quality,
                optimize=True,
                progressive=True
            )

            image_files.append(temp_file)

            os.remove(image_path)

        except Exception as e:
            print(f"Error processing {image}: {e}")

    image_files.sort()

    if image_files:
        with open(filename, "wb") as f:
            f.write(img2pdf.convert(image_files))

    for f in image_files:
        try:
            os.remove(f)
        except:
            pass

    cleanDir(newdir)

    if move_back:
        move_to_original(filename)


def move_to_original(file_path):
    try:
        original_dir = os.path.dirname(file_path)

        if os.path.exists(file_path):
            dest = os.path.join(original_dir, os.path.basename(file_path))
            shutil.move(file_path, dest)
            print(f"Moved '{file_path}' back to original folder.")
        else:
            print(f"File {file_path} does not exist.")
    except Exception as e:
        print(f"Error moving file: {e}")


def cleanDir(dir):
    try:
        for file in os.listdir(dir):
            file_path = os.path.join(dir, file)

            if os.path.isdir(file_path):
                shutil.rmtree(file_path)
            else:
                os.remove(file_path)

    except Exception as e:
        print(f"Error cleaning directory: {e}")


def move_to_completed(file_path):
    completed_dir = os.path.join(os.getcwd(), "completed")
    os.makedirs(completed_dir, exist_ok=True)

    try:
        if os.path.exists(file_path):
            dest = os.path.join(completed_dir, os.path.basename(file_path))
            shutil.move(file_path, dest)
            print(f"Moved '{file_path}' to completed folder.")
    except Exception as e:
        print(f"Error moving file: {e}")


def opendir(directory):

    nlog_info(
        subprocess.run(['ls', '-lah'], capture_output=True, text=True).stdout
    )

    for file in os.listdir(directory):

        if file.endswith('.cbz') or file.endswith('.zip'):
            handlezip(file)
            os.remove(file)

        elif file.endswith('.cbr') or file.endswith('.rar'):
            handlerar2(file)


def handlezip(filein):

    tmp_dir = os.path.join(os.getcwd(), "Teemp")
    ram_dir = os.path.join(os.getcwd(), "../ram500mb")

    os.makedirs(tmp_dir, exist_ok=True)
    os.makedirs(ram_dir, exist_ok=True)

    result = subprocess.run(
        ["unzip", "-l", filein],
        capture_output=True,
        text=True
    )

    extracted_size = 0

    for line in result.stdout.splitlines():
        match = re.match(r"\s*(\d+)\s+\d+\s+\d+\s+(.*)", line)
        if match:
            extracted_size += int(match.group(1))

    if extracted_size <= 500 * 1024 * 1024:
        extract_dir = ram_dir
        move_back = True
    else:
        extract_dir = tmp_dir
        move_back = False

    subprocess.run(
        ["unzip", "-j", "-q", filein, "-d", extract_dir]
    )

    print(f"Unzip done to {extract_dir}")

    newfile = filein.replace(filein[-4:], ".pdf")
    toPDF2(newfile, extract_dir, 0, move_back)

    cleanDir(tmp_dir)
    cleanDir(ram_dir)

    print(f"'{newfile[:-4]}' successfully converted!")


def handlerar2(filein):

    tmp_dir = os.path.join(os.getcwd(), "Teemp")
    ram_dir = os.path.join(os.getcwd(), "../ram500mb")

    os.makedirs(tmp_dir, exist_ok=True)
    os.makedirs(ram_dir, exist_ok=True)

    subprocess.run(
        ["7z", "e", filein, f"-o{ram_dir}", "-aoa", "-y"],
        capture_output=True
    )

    newfile = filein.replace(filein[-4:], ".pdf")
    toPDF2(newfile, ram_dir, 0, True)

    cleanDir(tmp_dir)
    cleanDir(ram_dir)

    print(f"'{newfile[:-4]}' successfully converted!")


if __name__ == "__main__":
    script_dir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(script_dir)
    opendir(os.getcwd())