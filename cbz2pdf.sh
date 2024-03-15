#!/bin/bash
#set -e
echo "The script will fail if any error is thrown."
echo "Make sure that all your inputs are correct."
sleep 1s
cd /sdcard/cbz2pdf/www/safe
mkdir -p .huge
cd .huge
cmd=(dialog --radiolist "Select options:" 22 76 16)
options=(1 "Add list" on   #any option can be set to default to "on"
         2 "Download" off
         3 "Convert" off
         4 "Merge 2 files" off
         5 "Add to single file" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
case $choice in
1) #Add list
    read -p "Enter a name (optional):" name
	read -p "Enter the password:" pwd
    while read -p "Enter the URL:" url && [ ! -z "$url" ]; do 
     urls=("${urls[@]}" $url)
    done
    JSON_STRING=$( jq -n \
    --arg name "$name" \
    --arg pass "$pwd" \
    --argjson lk $(jq -c -n '$ARGS.positional' --args "${urls[@]}")\
    '{name: $name, password: $pass, links: $lk}' )
    echo $JSON_STRING > url.meg;
    ;;
2) #Download
if [[ ! -f "url.meg" ]]; then echo "Warning url.meg doesn't exist!"; exit; fi
    echo "Downloading the files in url.meg"
jq -c '.links[]' 'url.meg' | while read link; do
    mega-get $link --password=$(jq -c '.password' 'url.meg')
    echo "Download complete..."    
done
    for file in *.cbz
    do
    cbzName="${file%.*}"
    val="${cbzName##*v}"
    val="${val%%(*}"
    val="${val//[[:blank:]]/}"
    cbzNewName="${val}.${file##*.}"
    mv "$file" "$cbzNewName"
    done
    rm url.meg
    echo "Download and rename complete."
    termux-wifi-enable false
    am start -n "com.huawei.android.launcher/com.huawei.android.launcher.drawer.DrawerLauncher" &> /dev/null
    exit;
    ;;
3) #Convert
if [[ ! $(unzip -l '*.cbz') ]]; then echo "No files to convert."; exit; fi
for cbzFile in *.cbz
    do
    echo "Converting now."
    fileIn=$cbzFile
    filename="${fileIn%.*}"
    extension="${filename##*.}"
    unzip $fileIn -d $filename
    cd $filename
    clear
    
    for file in *.*
    do
    picName="${file%.*}"
    val="${picName##*p}"
    val="${val%%[*}"
    val="${val//[[:blank:]]/}"
    mv "$file" "${val}.${file##*.}"
    done
    
    for f in *.*;
    do
    count="${f%.*}"
    count=$(expr $count + 0)
    if (( $count % 5 == 0)) ; then
    echo -n '#'
    fi
    convert "$f" "${f%.*}.pdf" #|| {echo "Convert has failed"; exit 1 }
    #If the above line fails your data will be deleted by rm below
    rm $f
    trap 'printf "%s\n" "tr + C"; cd ..; mv $filename .trash; exit 2' SIGINT SIGTERM
    done
    pdftk *.pdf cat output "combined.pdf"
    cd ..
    mv "${filename}/combined.pdf" "${filename}.temp"
    rm -r $filename ;
    filenameWithoutZero=$(expr $filename + 0)
    mv "${filename}.temp" "${filenameWithoutZero}"
    rm $cbzFile
done;
    am start -n "com.huawei.android.launcher/com.huawei.android.launcher.drawer.DrawerLauncher" &> /dev/null
    exit;
    ;;
4) #Merge
   echo "Merge files"
   read -p "Name of first file:" file1
   read -p "Name of second file:" file2
if [[ ! -f $file1 ]] || [[ ! -f $file2 ]]; then echo "The files do not exist." ; exit; fi
   pdftk $file1 $file2 cat output "${file1}n${file2}"
   echo "Done"
   rm $file1 $file2
   echo "Command to zip folder (to be used from upper folder not foldername itself!)"
   echo "zip -r -j my.zip foldername";
   ;;
5) #Add to one file
   echo "Add to single file."
   read -p "Name of the super file (in .huge folder):" supFile
   viewFile=$(unzip -l $supFile)
   dialog --title "Files in ${supFile}" \
   --backtitle "Many to one function" \
   --yesno "Continue? ${viewFile}" 30 60
      response=$?
   case $response in
   0) 
   unzip $supFile -d "${supFile}temp"
   mv "${supFile}" "${supFile}.tempstore"
   read -p "Name of files to add to ${supFile} (in .huge folder):" multiFile
   mv $multiFile "${supFile}temp"
   zip -r -j $supFile "${supFile}temp"
   mv "${supFile}.zip" "${supFile}"
   echo "Processes complete and ${supFile} renamed to ${supFile}.tempstore."
   echo "Note the differenes for your reference."
   ;;
   1) echo "No work done.";;
   esac
   ;;
esac
done;
