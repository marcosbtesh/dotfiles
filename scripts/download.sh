if [ $# -eq 0]; then
  echo "Usage: download '[Artist Name Song Name]' [mp3,mp4] [best,ultra,high,medium,low,worst]"
  exit 1
fi

QUERY=$1
FORMAT=$2
QUALITY=$3

URL_REGEX=

shift

if [ $# -eq 1]; then
  echo "Missing Query: '[Artist Name Song Name]' Argument!"
  exit 1
fi

if [ $# -eq 2]; then
  echo "Missing Format: [mp3,mp4] Argument!"
  exit 1
fi
if [ $# -eq 3]; then
  echo "Missing Quality: [best,ultra,high,medium,low,worst] Argument!"
  exit 1
fi


