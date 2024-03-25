echo Setup in progress.
termux-setup-storage && sleep 4s
source <= 'progress-bar() {   local duration=${1};     already_done() { for ((done=0; done<$elapsed; done++)); do printf "▇"; done };     remaining() { for ((remain=$elapsed; remain<$duration; remain++)); do printf " "; done };     percentage() { printf "| %s%%" $(( (($elapsed)*100)/($duration)*100/100 )); };   for (( elapsed=1; elapsed<=$duration; elapsed++ )); do       already_done; remaining; percentage;       sleep 1;       printf "\r";   done;   printf "\r"; }'

cd ~/
curl -o .bashrc https://raw.githubusercontent.com/termuxBash/cbz2pdf/main/bashStartUp.sh
apt update && apt upgrade
pkg install -y termux-api
echo Installing the termux API app...
cd /sdcard/Download
curl -o termuxBoot.apk https://f-droid.org/repo/com.termux.boot_7.apk
termux-open termuxBoot.apk
curl -o termuxApi.apk https://f-droid.org/repo/com.termux.api_51.apk
termux-open termuxApi.apk
echo Waiting...
progress-bar(60)
pkg install termux-api
rm termuxBoot.apk termuxApi.apk
cd ~/.termux
mkdir boot
cd boot
echo termux-wake-lock > start.sh
echo sshd >> start.sh