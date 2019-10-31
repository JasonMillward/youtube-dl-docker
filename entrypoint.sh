#!/bin/sh

printf " =========================================\n"
printf " =========================================\n"
printf " ========== YOUTUBE-DL CONTAINER =========\n"
printf " =========================================\n"
printf " =========================================\n"
printf " == by github.com/qdm12 - Quentin McGaw ==\n\n"

exitOnError(){
  # $1 must be set to $?
  status=$1
  message=$2
  [ "$message" != "" ] || message="Error!"
  if [ $status != 0 ]; then
    printf "$message (status $status)\n"
    exit $status
  fi
}

youtube-dl -U
YTDL_VERSION=$(youtube-dl --version)
PYTHON_VERSION=$(python --version 2>&1 | cut -d " " -f 2)
FFMPEG_VERSION=$(ffmpeg -version | head -n 1 | grep -oE 'version [0-9]+\.[0-9]+\.[0-9]+' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')

printf "Youtube-dl version: $YTDL_VERSION"
printf "\nPython version: $PYTHON_VERSION"
printf "\nFFMPEG version: $FFMPEG_VERSION"
printf "\n\n"

test -w "/downloads"
exitOnError $? "/downloads is not writable, please fix its ownership and/or permissions"

while [ true ]
do
  youtube-dl --config-location /config/youtube-dl.conf 2>&1 | tee downloads/log.txt

  pcregrep -o1 -o2 -o3 -i '(youtube)\](\s)([a-zA-Z0-9]{5,})\:' /downloads/log.txt >> /config/youtube-dl-archive.txt

  sort -u -o /downloads/youtube-dl-archive.txt /downloads/youtube-dl-archive.txt

  sleep 21600
done

