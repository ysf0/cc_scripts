c_media_file_remove_metadata_HELP_ONLY() {

   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" Image-ExifTool)/exiftool"
   ___print_screen "$LINUX_EXECUTABLE_FULL_PATH"' -all= "$DIRECTORY_OR_FILE_TO_CLEAN/"' # do not remove space character after ='
}

c_media_file_print_metadata_HELP_ONLY() {

   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" Image-ExifTool)/exiftool"
   ___print_screen "more details: https://exiftool.org/faq.html#Q30"
   ___print_screen
   ___print_screen "$LINUX_EXECUTABLE_FULL_PATH"' -ee3 -U -G3:1 -api requestall=3 -api largefilesupport "$DIRECTORY_OR_FILE_TO_CLEAN/"'
}

c_media_file_manipulation_HELP_ONLY() {

   ___print_title "convert only format (ffmpeg will auto recognize the source and target file extension):"
   ___print_screen "ffmpeg -i input_file.mp4 ouput_file.mp3"
   ___print_screen
   ___print_title 'remove only sound from video:'
   ___print_title '-i input_video_file.mp4 -vcodec copy -an ouput_video_file.mp4'
   ___print_screen
   ___print_title 'remove video from video (the target file contains only sound):'
   ___print_screen 'ffmpeg -i input_video_file.mp4 -vn -acodec copy ouput_sound_file.mp4'
   ___print_screen
   ___print_title 'split video:'
   ___print_screen "* -c copy --> splits video in seconds. this should be pass after -i argument. this is a bug. othwise you will get: Unknown decoder copy."
   ___print_screen "* -ss --> start time"
   ___print_screen "* -t --> the time until the start time"
   ___print_screen 'ffmpeg -ss 00:10:00 -t 00:01:00 -i input_file.mp4 -c copy output_1_minute_part.mp4'
   ___print_screen
   ___print_title "merge (contationation) multiple videos:"
   ___print_screen "ffmpeg -f concat -safe 0 -i list.txt -c copy video.mp4"
   ___print_screen "list.txt should include this:"
   ___print_screen "file /abc/video_part_1"
   ___print_screen "file /abc/video_part_2"
   ___print_screen "file /abc/video_part_3"
   ___print_screen
   ___print_screen
   local -r FFMPEG_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" ffmpeg)/ffmpeg"
   ___print_title "Executable is under: $FFMPEG_EXECUTABLE_FULL_PATH"
}