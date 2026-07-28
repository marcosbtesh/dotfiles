MODEL_PATH="$HOME/.whisper-cpp/models/ggml-base.bin"
TEMP_FILE_DIRECTORY="/tmp"

if [ $# -eq 0 ]; then 
  echo "Usage: transcribe [file_path_to_transcribe]"
  exit 1
fi

FILE_TO_TRANSCRIBE=$1
LANG="${2:-es}"
shift

if [[ "$FILE_TO_TRANSCRIBE" == *.opus ]]; then
  ffmpeg -i "$FILE_TO_TRANSCRIBE" "$TEMP_FILE_DIRECTORY/${FILE_TO_TRANSCRIBE%.*}.mp3"
  whisper-cli -m "$MODEL_PATH" -l "$LANG" -f  "$TEMP_FILE_DIRECTORY/${FILE_TO_TRANSCRIBE%.*}.mp3"
  rm "$TEMP_FILE_DIRECTORY/${FILE_TO_TRANSCRIBE%.*}.mp3"
else
  whisper-cli -m "$MODEL_PATH" -l "$LANG" -f "$FILE_TO_TRANSCRIBE"
fi
  
