echo Setup in progress.
termux-setup-storage && sleep 4s
cd /sdcard
mkdir cbz2pdf
cd cbz2pdf
mkdir -p www/safe
curl -O https://raw.githubusercontent.com/termuxBash/cbz2pdf/main/cbz2pdf.sh
cd ~/
curl -o .bashrc https://raw.githubusercontent.com/termuxBash/cbz2pdf/main/bashStartUp.sh
apt update && apt upgrade
pkg install -y imagemagick
pkg install -y pdftk
pkg install -y megacmd
pkg install -y termux-api
echo Installing the termux API app...
cd /sdcard/Download
curl -o termuxApi.apk https://f-droid.org/repo/com.termux.api_51.apk
termux-open termuxApi.apk
