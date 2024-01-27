mkdir .huge
cd .huge
cmd=(dialog --radiolist "Select options:" 22 76 16)
options=(1 "Add list" off   #any option can be set to default to "on"
         2 "Download" off
         3 "Convert" on
         4 "Merge 2 files" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
case $choice in
1)
	read -p "Enter the password:" pwd
    while read -p "Enter the URL:" url && [ ! -z "$url" ]; do 
     urls=("${urls[@]}" $url)
    done
    JSON_STRING=$( jq -n \
    --arg pass "$pwd" \
    --argjson lk $(jq -c -n '$ARGS.positional' --args "${urls[@]}")\
    '{password: $pass, links: $lk}' )
    echo $JSON_STRING > url.meg;
    ;;
2)
    echo "Downloading the files in url.meg"
jq -c '.links[]' 'url.meg' | while read link; do
    echo $link
    mega-get $link --password=$(jq -c '.password' 'url.meg')
    echo "Download complete..."
    for file in *.cbz
    do
    cbzName="${file%.*}"
    val="${cbzName##*v}"
    val="${val%%(*}"
    val="${val//[[:blank:]]/}"
    cbzNewName="${val}.${file##*.}"
    mv "$file" "$cbzNewName"
    done
    
done
    rm url.meg
    echo "Download and rename complete.";
    ;;
3)
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
    convert "$f" "${f%.*}.pdf"
    rm $f
    done
    
    pdftk *.pdf cat output "combined.pdf"
    cd ..
    mv "${filename}/combined.pdf" "${filename}.temp"
    rm -r $filename ;
    mv "${filename}.temp" "${filename}"
    rm $cbzFile
done;
    ;;
4)
   echo "Merge files"
   read -p "Name of first file:" file1
   read -p "Name of second file:" file2
   pdftk $file1 $file2 cat output "${file1}n${file2}"
   echo "Done"
   echo "Command to zip folder (to be used from upper folder not foldername itself!)"
   echo "zip -r -j my.zip foldername";
   ;;
esac
done
