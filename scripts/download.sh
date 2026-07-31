#!/usr/bin/env bash
# download - thin yt-dlp wrapper
# Usage: download '[Artist Name Song Name]' [mp3,mp4] [best,ultra,high,medium,low,worst] [file_path]

set -eo pipefail

usage() {
  echo "Usage: download '[Artist Name Song Name]' [mp3,mp4] [best,ultra,high,medium,low,worst] [file_path]" >&2
}

die() {
  echo "$1" >&2
  exit 1
}

if [ "$#" -eq 0 ]; then
  usage
  exit 1
fi

QUERY=${1-}
FORMAT=${2-}
QUALITY=${3-}
FILE_NAME=${4-}

command -v yt-dlp >/dev/null 2>&1 || die "yt-dlp is not installed or not on PATH."
command -v ffmpeg >/dev/null 2>&1 || die "ffmpeg is required for extraction/merging but was not found."

[ "$QUERY" != "" ]   || die "Missing Query: '[Artist Name Song Name]' Argument!"
[ "$FORMAT" != "" ]  || die "Missing Format: [mp3,mp4] Argument!"
[ "$QUALITY" != "" ] || die "Missing Quality: [best,ultra,high,medium,low,worst] Argument!"

# ------------------------------------------------------------------
# Search term vs. direct URL
# ------------------------------------------------------------------
URL_REGEX='^https?://[^[:space:]/$.?#].[^[:space:]]*$'

if [[ $QUERY =~ $URL_REGEX ]]; then
  QUERY_ARG=$QUERY
else
  QUERY_ARG="ytsearch1:${QUERY}"
fi

# ------------------------------------------------------------------
# Container / codec selection
# ------------------------------------------------------------------
case "$FORMAT" in
  mp3)
    FORMAT_ARG=(-f "ba/b" -x --audio-format mp3)
    ;;
  mp4)
    FORMAT_ARG=(-f "bv*+ba/b" --merge-output-format mp4)
    ;;
  *)
    die "Format Argument does not match expected options: [mp3,mp4]"
    ;;
esac

# ------------------------------------------------------------------
# Quality: resolution sort for video, VBR level for audio
# ------------------------------------------------------------------
case "$QUALITY" in
  worst)  SORT="+res,+br"; ABR=9 ;;
  low)    SORT="res:480";  ABR=7 ;;
  medium) SORT="res:720";  ABR=5 ;;
  high)   SORT="res:1080"; ABR=2 ;;
  ultra)  SORT="res:2160"; ABR=0 ;;
  best)   SORT="res,br";   ABR=0 ;;
  *)
    die "Quality Argument does not match expected options: [best,ultra,high,medium,low,worst]"
    ;;
esac

if [ "$FORMAT" = "mp3" ]; then
  QUALITY_ARG=(--audio-quality "$ABR")
else
  QUALITY_ARG=(-S "$SORT")
fi

# ------------------------------------------------------------------
# Optional output path
# ------------------------------------------------------------------
OUTPUT_ARG=()
if [ "$FILE_NAME" != "" ]; then
  if [ -d "$FILE_NAME" ]; then
    # a directory: keep the default title-based name inside it
    OUTPUT_ARG=(-o "${FILE_NAME%/}/%(title)s.%(ext)s")
  else
    BASE=${FILE_NAME##*/}
    if [[ $BASE == *.* ]]; then
      OUTPUT_ARG=(-o "$FILE_NAME")
    else
      # no extension given: let yt-dlp fill it in
      OUTPUT_ARG=(-o "${FILE_NAME}.%(ext)s")
    fi
  fi
fi

# ------------------------------------------------------------------
# Run
# ------------------------------------------------------------------
yt-dlp "${FORMAT_ARG[@]}" "${QUALITY_ARG[@]}" "${OUTPUT_ARG[@]+"${OUTPUT_ARG[@]}"}" -- "$QUERY_ARG"
