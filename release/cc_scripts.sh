
# shellcheck disable=SC3028 # $RANDOM variable is undefined.
# shellcheck disable=SC2148 # shebang does not exist. because this script will work both "zsh" and "bash".
# shellcheck disable=SC2162 #  will mangle backslashes. it does not important for now.
# shellcheck disable=SC2068,SC2128,SC2086,SC2124,SC2294,SC2145,SC2198 # TODO about $* $@
# shellcheck disable=SC2059 # printf wrapper warning.
# shellcheck disable=SC2155 # command may give error. variable assignment should be in another line.
# shellcheck disable=SC2016 # single vs double quotes
# shellcheck disable=SC1004 # line splitting is true. we need both linefeed+ empty spaces.
# shellcheck disable=SC2046 # all cases are valid. word splitting is not important in those cases. 

#############################################
# PROJECT NAME: cc_scripts
# SHORT DESCRIPTION: Multi-purpose shell functions.
# URL: https://github.com/ysf0/cc_scripts
export CC_SCRIPTS_PROJECT_VERSION=26
############################################# 

# File name:core_shell_utils/cc_exit_code.sh
# Do not use reserved exit codes: 1, 2, 126, 127, 128, 165 and 255.
# More information: https://tldp.org/LDP/abs/html/exitcodes.html
export CC_EXIT_CODE__APP_LOGIC_EXCEPTION=4
export CC_EXIT_CODE__INVALID_USER_PARAMETER=5
export CC_EXIT_CODE__COMMAND_NOT_FOUND=6

# For custom (business logic) exceptions read the "errorHandler" example in "/documentation/demo_function.sh" file.

# File name:core_shell_utils/cc_is_empty_string.sh
___is_empty_string() {

   # -z -> checks if it is empty
   if [ -z "$@" ]; then
      return 0
   fi

   # NULL is a custom string which is using in this project. it's not a standard.
   if [ "$@" = "NULL" ]; then
      return 0
   fi

   return 1
}

# File name:core_shell_utils/cc_core_utils.sh
___check_parameters() {

   if [ "$1" = "-h" ]; then
      ___print_title "required parameters"
      for param in "${___required_parameters[@]}"; do
         ___print_screen "$param"
      done
      ___required_parameters=()
      return 1
   fi

   local -r REQUIRED_PARAM_COUNT="${#___required_parameters[@]}"
   local -r USER_PASSED_PARAM_COUNT="$#"

   if [ "$REQUIRED_PARAM_COUNT" = "$USER_PASSED_PARAM_COUNT" ]; then
      ___required_parameters=()
      return 0
   else
      ___print_screen "Check the parameters. Use -h to see the parameters."
      ___required_parameters=()
      return 2
   fi
}

___do_files_exist() {

   for FILE in "$@"; do
      if [ ! -f "$FILE" ]; then
         ___print_screen "file does not exist: $FILE"
         return 1
      fi
   done
}

___do_directories_exist() {

   for DIRECTORY in "$@"; do
      if [ ! -d "$DIRECTORY" ]; then
         return 1
      fi
   done
}

___string_ends_with() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r ALL_STRING="$1"
   local -r ENDS_WITH="$2"
   ##############################
   ##############################
   ##############################

   if [[ "$ALL_STRING" == *"$ENDS_WITH" ]]; then
      return 0
   fi
   return 1
}

___string_starts_with() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r ALL_STRING="$1"
   local -r START_WITH="$2"
   ##############################
   ##############################
   ##############################

   if [[ "$ALL_STRING" == "$START_WITH"* ]]; then
      return 0
   fi
   return 1
}

___string_contains() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r ALL_STRING="$1"
   local -r SUB_STRING="$2"
   ##############################
   ##############################
   ##############################

   if [[ "$ALL_STRING" == *"$SUB_STRING"* ]]; then
      return 0
   fi
   return 1
}

# File name:core_shell_utils/cc_command_checker.sh
___do_executables_exist() {

   ##############################
   # ABOUT
   ##############################
   # This function check all parameter if they are callable from command line.
   # In other words; it returns 0, if each parameter is an alias or command or executable or shell function or any callable...
   ##############################
   ##############################
   ##############################

   for COMMAND in "$@"; do
      # do not use 'which' command to check if executable exist.
      # we prefer 'command' because it is POSIX standard.
      # reason why: https://stackoverflow.com/a/677212 ("web.archive.org" and "archive.is". archived date: 01/05/2020)
      command -v "$COMMAND" >/dev/null 2>&1 || {
         ___print_screen "command does not exist: $COMMAND"
         return $CC_EXIT_CODE__COMMAND_NOT_FOUND
      }
   done
}

# File name:core_shell_utils/cc_print_utils.sh
# We prefer to change the background color instead of text itself. because the background of terminal interpreter can be any color (same or similar color with our print output).

CC_COLOR_RED=""   # only ___print_title command will use it
CC_COLOR_BLUE=""  # only ___print_screen command will use it (normal text color. Should not be use for titles.)
CC_COLOR_GREEN="" # use it only if you don't use ___print_screen function and use a different color than others.
CC_COLOR_RESET="" # should be use every end of print screen command

if ___do_executables_exist "tput"; then
   TPUT_BOLD="$(tput bold)" # we prefer bold. text are cleaner/bigger.
   TPUT_WHITE="$(tput setaf 7)"
   CC_COLOR_RED="$TPUT_BOLD$TPUT_WHITE$(tput setab 1)"
   CC_COLOR_GREEN="$TPUT_BOLD$TPUT_WHITE$(tput setab 2)"
   CC_COLOR_BLUE="$TPUT_BOLD$TPUT_WHITE$(tput setab 4)"
   CC_COLOR_RESET="$(tput sgr 0)"
else
   CC_OUTPUT_COLOR="false"
fi

___print_screen() {

   ___is_empty_string "$@" && {
      ___stdout_and_new_line
      return
   }

   if [ "$CC_OUTPUT_COLOR" = "true" ]; then
      ___stdout_and_new_line "$CC_COLOR_BLUE""$*$CC_COLOR_RESET"
      return
   fi

   ___stdout_and_new_line "** $*"
}

___print_title() {

   if [ "$CC_OUTPUT_COLOR" = "true" ]; then
      ___stdout_and_new_line "$CC_COLOR_RED""$*$CC_COLOR_RESET"
      return
   fi

   ___stdout_and_new_line "*** $*"
}

color_line() {

   ##############################
   # USAGE
   ##############################
   # ls -a | color_line
   # ping google.com | color_line
   ##############################
   ##############################
   ##############################

   ___do_executables_exist "read" || return

   while read line; do
      ___stdout_and_new_line "$CC_COLOR_BLUE$line$CC_COLOR_RESET"
      read line
      ___stdout_and_new_line "$line"
   done
}

# We have 2 printf wrapper functions.
# Only because we never format numbers, we always print literals.
# With these wrapper you don't have to write "%s\n" all of your codes.
___stdout() {
   printf "%s" "$*"
}

___stdout_and_new_line() {
   printf "%s\n" "$*"
}

___stdout_using_format() {
   printf "$@"
}

# File name:core_shell_utils/cc_command_checker_without_warning.sh
___do_executables_exist_without_output() {

   ##############################
   # ABOUT
   ##############################
   # This is same as ___do_executables_exist function.
   # The only difference is that this function does not print any warning if it finds any non-executable.
   ##############################
   ##############################
   ##############################

   for COMMAND in "$@"; do
      # Do not use 'which' command to check if executable exist.
      # We prefer 'command' because it is POSIX standard.
      # Reason why: https://stackoverflow.com/a/677212 ("web.archive.org" and "archive.is". archived date: 01/05/2020)
      command -v "$COMMAND" >/dev/null 2>&1 || return $CC_EXIT_CODE__COMMAND_NOT_FOUND
   done
}

# File name:core_shell_utils/cc_command_executor.sh
OUTPUT_PREFIX="** executing command:"

___print_execute_command_line_info() {
   if [ "$CC_OUTPUT_COLOR" = "true" ]; then
      # we can not use ___print_screen because ___print_screen does not support multiple colors in the same line.
      ___stdout_and_new_line "$CC_COLOR_RED$OUTPUT_PREFIX $CC_COLOR_GREEN $* $CC_COLOR_RESET"
   else
      ___stdout_and_new_line "$OUTPUT_PREFIX $*"
   fi
}

___execute_and_color_line() {
   ___print_execute_command_line_info "$@ | color_line"
   "$@" | color_line
}

___execute_and_grep_and_color_line() {
   ___print_execute_command_line_info "$@ | grep -i $GREP_COMMAND_PARAM | color_line"
   "$@" | grep -i "$GREP_COMMAND_PARAM" | color_line
}

___execute() {
   ___print_execute_command_line_info "$@"
   "$@"
}

___execute_with_eval() {
   # eval is a must in some cases like:
   #
   # ___execute_with_eval 'docker stop $(docker ps -a -q)'
   #
   # $(docker ps -a -q) --> must be pass as string, so we can print which command runs.
   #
   # eval should not be preferred because:
   # A- eval should be installed on system otherwise command will not work.
   # B- eval may side effect on some platforms.
   # C- a command which runs with command should be wrapped with " (double quote).
   #    therefore it is unreadable (especially when the command is long).

   ___print_execute_command_line_info "eval $@"

   ___do_executables_exist "eval" && {
      eval "$@"
      return
   }
   ___print_title "'eval' command does not exist. could not run the command."
   return 1
}

___execute_with_eval_removed_long_lines() {

   ___print_execute_command_line_info "$@"
   c_line_remove_long_enable

   ___do_executables_exist "eval" && {
      eval "$@"
      LAST_COMMAND_EXIT_CODE="$?" # We save it, so we can return
      c_line_remove_long_disable
      return "$LAST_COMMAND_EXIT_CODE"
   }
   c_line_remove_long_disable
   ___print_title "'eval' command does not exist. could not run the command."
   return 1
}

___nohup_and_disown() {

   # This should be preferred only for background processes or GUI apps.

   ___do_executables_exist "nohup" || {
      ___print_screen "___nohup_and_disown warning:"
      ___print_screen "command does not exist: nohup"
      ___print_execute_command_line_info "$@ & disown"
      "$@" &
      disown
      return
   }

   ___do_executables_exist "disown" || {
      ___print_screen "___nohup_and_disown warning:"
      ___print_screen "command does not exist: disown"
      ___print_execute_command_line_info "nohup $@"
      nohup "$@"
      return
   }

   ___print_execute_command_line_info "nohup $@ & disown"
   nohup "$@" &
   disown
}

___run_command_as_root() {

   if ___do_executables_exist "sudo"; then
      # env "PATH=$PATH" = set environment variables for sudo command
      ___execute_with_eval "sudo env \"PATH=$PATH\" $@"
      return
   fi

   if ___do_executables_exist "su"; then
      # TODO pass environment variable like above (sudo case)
      ___execute_with_eval "su -c '""$@""'"
      return
   fi

   ___print_screen "'sudo' or 'su' commands not found. script will try to execute the command as current user."

   # maybe the current user is privileged
   ___execute_with_eval "$@"
}

c_line_remove_long_enable() {
   # enables "word wrap"
   if ___do_executables_exist "tput"; then
      tput rmam
   else
      ___stdout '\033[?7l'
   fi
}

c_line_remove_long_disable() {
   # disables "word wrap"
   if ___do_executables_exist "tput"; then
      tput smam
   else
      ___stdout '\033[?7h'
   fi
}

# File name:core_shell_utils/cc_exception_handler.sh
___errorHandler() {
    ___print_title "last command exit code: $1"
    ___print_title "cc_script exit code: $2"
    return $CC_EXIT_CODE__APP_LOGIC_EXCEPTION
}

# File name:cc_cassandra.sh
# Default values
CC_CASSANDRA_USERNAME="cassandra"
CC_CASSANDRA_PASSWORD="cassandra"
CC_CASSANDRA_HOST="localhost"
CC_CASSANDRA_PORT="9042"

# If you have multiple cassandra instances (environments) on remote you can do below:
#
# - "source cassandra_remote_1.sh" (this file includes EXPORT CC_CASSANDRA_HOST=remote.com)
# - run any cassandra command which starts with "c_cassandra".

OUTPUT_FORMAT_HELP_TEXT="OUTPUT_FORMAT:\n
- 0 ---> open output with text editor\n
- 1 ---> each row of table will print in new line (long lines will remove/truncate)\n
- 2 ---> each row of table will print on a new block\n"

c_cassandra_execute_cql() {
   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r OUTPUT_FORMAT="$1"
   local -r CQL="$2"
   ##############################
   ##############################
   ##############################

   ___required_parameters=("$OUTPUT_FORMAT_HELP_TEXT" "CQL (with double-quote character at the end and start)")
   ___check_parameters "$@" || return

   local CQL_PREFIX=""
   local COLOR_ARG=""
   # Do not ask user the output format on this function. because user may redirect the output to any file.
   if [ "$OUTPUT_FORMAT" = "1" ]; then
      COLOR_ARG="--color"
   elif [ "$OUTPUT_FORMAT" = "2" ]; then
      CQL_PREFIX="EXPAND ON;"
      COLOR_ARG="--color"
   elif [ "$OUTPUT_FORMAT" = "0" ]; then
      COLOR_ARG="--no-color"
   else
      ___print_screen "wrong OUTPUT_FORMAT. script will exit"
      ___errorHandler "$?" 100028
      return
   fi

   local -r CASSANDRA_EXECUTABLE="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" apache-cassandra)""/bin/cqlsh"

   local -r CASSANDRA_COMMAND="\"$CASSANDRA_EXECUTABLE\" $COLOR_ARG --username $CC_CASSANDRA_USERNAME --password $CC_CASSANDRA_PASSWORD \"$CC_CASSANDRA_HOST\" $CC_CASSANDRA_PORT --execute \"$CQL_PREFIX $CQL\" "

   if [ "$OUTPUT_FORMAT" = "0" ]; then
      local -r OUTPUT_FILE="cassandra_latest_output.json"
      local -r CURRENT_DATE_TIME="$(date '+%Y-%m-%d   %H:%M:%S   %z')"
      ___stdout_and_new_line "Execution date-time: $CURRENT_DATE_TIME" >"$OUTPUT_FILE"
      ___stdout_and_new_line "executed command: $CASSANDRA_COMMAND" >>"$OUTPUT_FILE"
      ___execute_with_eval "$CASSANDRA_COMMAND >> $OUTPUT_FILE"
      "$CC_TEXT_EDITOR_FOR_NON_ROOT_FILES" "$OUTPUT_FILE"

   elif [ "$OUTPUT_FORMAT" = "1" ]; then
      ___execute_with_eval_removed_long_lines "$CASSANDRA_COMMAND"
   else
      ___execute_with_eval "$CASSANDRA_COMMAND"
   fi
}

c_cassandra_list_all_tables_and_keyspaces() {
   c_cassandra_execute_cql "2" "describe tables;"
}

c_cassandra_table_print_data() {
   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r OUTPUT_FORMAT="$1"
   local -r NAMESPACE="$2"
   local -r TABLE_NAME="$3"
   ##############################
   ##############################
   ##############################

   ___required_parameters=("$OUTPUT_FORMAT_HELP_TEXT" "NAMESPACE" "TABLE_NAME")
   ___check_parameters "$@" || return

   c_cassandra_execute_cql "$OUTPUT_FORMAT" "USE $NAMESPACE; SELECT * FROM $TABLE_NAME;"
}

# File name:cc_docker.sh
c_docker_list_all_containers() {
   # SHOW ALL CONTAINERS = -a
   # LIST THE CONTAINERS = ps
   ___execute_and_color_line docker ps -a
}

c_docker_stop_force_all_containers() {

   # ONLY DISPLAY NUMERIC ID'S = -q
   # SHOW ALL CONTAINERS = -a
   # LIST THE CONTAINERS = ps
   # FORCE REMOVE RUNNING CONTAINER = -f
   # REMOVE CONTAINER = rm
   ___execute_with_eval 'docker stop $(docker ps -a -q)'
}

c_docker_remove_force_all_containers() {

   # ONLY DISPLAY NUMERIC ID'S = -q
   # SHOW ALL CONTAINERS = -a
   # LIST THE CONTAINERS = ps
   ___execute_with_eval 'docker stop $(docker ps -a -q)'
   ___execute_with_eval 'docker rm -f $(docker ps -a -q)'
}

c_docker_show_container_ip() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r CONTAINER_NAME_OR_ID="$1"
   ##############################
   ##############################
   ##############################

   ___required_parameters=("CONTAINER_NAME_OR_ID")
   ___check_parameters "$@" || return

   ___print_screen "note: this will not work if network bridge has a name."

   # FORMAT THE INSPECT OUTPUT GIVEN THE TEMPLATE ---> -f
   # shellcheck disable=SC1083 # shellcheck recognize shell expression. but it's not.
   ___execute_with_eval docker inspect -f \'{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}\' "$CONTAINER_NAME_OR_ID"
}

# File name:cc_download_media.sh
c_download_media_HELP_ONLY() {

   local -r DOWNLOADER_EXECUTABLE="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" yt-dlp)"
   local -r PHANTOMJS_EXECUTABLE="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" phantomjs)""/bin"

   ___print_screen '- yt-dlp command downloads from many services. Not only from Youtube.'
   ___print_screen '- If zsh will give "no matches found" error, make sure URL is quoted string with ".'
   ___print_screen '- Do not use audio download command. Because it downloads the full video and then extracts the audio. Prefer the split video via ffmpeg command.'

   ___print_title "Update the application"
   ___print_screen "$DOWNLOADER_EXECUTABLE -U"

   ___print_title "Adding PhantomJS to PATH for some web sites."
   ___print_screen "c_path_add $PHANTOMJS_EXECUTABLE"

   ___print_title "PARAMETERS"
   ___print_screen "--write-sub --> download subtitles. subtitle details are given in: --sub-lang"
   ___print_screen "-i --> ignore errors. if any error happens then resumes with the next media (if the URL is list)"
   ___print_screen "--rm-cache-dir --> it removes cache. sometimes cache make bugs. it does not store too much files. so it is better to clean everytime."
   ___print_screen "-v ---> show all logs"

   ___print_screen "$DOWNLOADER_EXECUTABLE -v --rm-cache-dir -i --write-sub --sub-lang eng,tr,el,en,en-US,en-UK,en-GB "'$VIDEO_URL'
}

# File name:cc_file_system.sh
c_copy_HELP_ONLY() {
   ___print_screen 'rsync --info=progress2 --bwlimit=10000 -a --append --progress source-file destination-file'
   ___print_screen
   ___print_screen '- rsync does not store any metadata for copy progress. This command can be kill anytime via CTRL+C, and it will be resumable with the same command.'
}

c_find_text_inside_files_HELP_ONLY() {
   ___print_title 'below command prints: first the file name and than the founded line (for binary files founded line is not printed)'
   ___print_screen 'grep -r -i text_to_search /dir'
   ___print_screen
   ___print_screen '-l : sometimes printed line is very long. therefore we can disable to print the founded line.'
   ___print_screen '-r : recursive directories'
   ___print_screen '-i : ignore case'
}

c_file_find_locked_process_HELP_ONLY() {
   ___print_screen
   ___print_screen "fuser FILE_FULL_PATH"
   ___print_screen
   # print format info. because fuser does not print column titles(headers)
   ___print_title "The format of above command is:"
   ___print_screen "file-full-path: process-id"
   ___print_screen
   ___print_screen "Or use below command:"
   ___print_screen "lsof FILE_FULL_PATH"
}

___invalid_file_name() {
   ___print_title "File: $2 ---> Invalid Reason: $1"
   ___stdout "$2" >>"$INVALID_FILE_LIST"
   ___stdout "$1" >>"$INVALID_FILE_ERROR_CODE_LIST"
}

c_file_name_invalid_detect() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   # This function detects the invalid file names for MS Windows.
   # The rules are taken from this page: https://docs.microsoft.com/en-us/windows/win32/fileio/naming-a-file ("web.archive.org" and "archive.is". archived date: 01/05/2020)
   #
   # This function also prints suggestions for file names. Example suggestions:
   # - if it includes non-alpha numeric caharacter
   # - if it includes non-pritable character
   # - if it includes ' character
   ##############################
   ##############################
   ##############################

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r DIRECTORY_TO_VALIDATE="$1"
   local -r EXCLUDE_REGEX="$2"
   ##############################
   ##############################
   ##############################

   ___required_parameters=("DIRECTORY_TO_VALIDATE" "EXCLUDE_REGEX")
   ___check_parameters "$@" || return

   ___do_executables_exist "basename" "grep" "find" "read" "mktemp" || return

   # This is needed for unit tests.
   export INVALID_FILE_LIST="$(mktemp)" || {
      ___errorHandler "$?" 100036
      return
   }
   export INVALID_FILE_ERROR_CODE_LIST="$(mktemp)" || {
      ___errorHandler "$?" 100037
      return
   }

   local -r PREFIX_MS_WINDOWS="MS_WINDOWS_RULE___"
   local -r PREFIX_NIX_FAMILY="NIX_FAMILY_RULE___"
   local -r PREFIX_BOTH_NIX_AND_MS_WINDOWS="BOTH_NIX_AND_MS_WINDOWS_RULE___"
   local -r PREFIX_SUGGESTION="SUGGESTION___" # These are only suggestion. They are not mandatory by any OS/filesystem.

   local -r MAX_FILE_LENGTH="252" # Max path length is 255. But there is drive directory letters which is minimum 3 character (example: C:\ ).

   # do not use other loop types because they will break if file name have special character: https://stackoverflow.com/questions/9612090/how-to-loop-through-file-names-returned-by-find ("web.archive.org" and "archive.is". archived date: 01/05/2020)
   find "$DIRECTORY_TO_VALIDATE" -name "*" ! -path "*/$EXCLUDE_REGEX/*" -print0 |
      while IFS= read -r -d '' FILE_OR_DIR_FULL_PATH; do

         local FILE_OR_DIR_NAME="$(basename "$FILE_OR_DIR_FULL_PATH")"

         for RESERVED_NAME in "CON" "PRN" "AUX" "NUL" "COM1" "COM2" "COM3" "COM4" "COM5" "COM6" "COM7" "COM8" "COM9" "LPT1" "LPT2" "LPT3" "LPT4" "PT5" "LPT6" "LPT7" "LPT8" "LPT9"; do
            local REGEX1='^'"$RESERVED_NAME"'[.].*' # start with 'CON' & have dot character & have any character
            local REGEX2='^'"$RESERVED_NAME"'$'     # start with 'CON' & ends
            local REGEX3='^'"$RESERVED_NAME"'[.]$'  # start with 'CON' & have dot character & ends
            ___stdout "$FILE_OR_DIR_NAME" | grep --basic-regexp "$REGEX1" >/dev/null 2>&1 && ___invalid_file_name "$PREFIX_MS_WINDOWS""CAN_NOT_START_WITH_$RESERVED_NAME""_AND_DOT" "$FILE_OR_DIR_FULL_PATH"
            ___stdout "$FILE_OR_DIR_NAME" | grep --basic-regexp "$REGEX2" >/dev/null 2>&1 && ___invalid_file_name "$PREFIX_MS_WINDOWS""ONLY_$RESERVED_NAME""_IS_RESERVED" "$FILE_OR_DIR_FULL_PATH"
            ___stdout "$FILE_OR_DIR_NAME" | grep --basic-regexp "$REGEX3" >/dev/null 2>&1 && ___invalid_file_name "$PREFIX_MS_WINDOWS""ONLY_$RESERVED_NAME""_AND_DOT_IS_RESERVED" "$FILE_OR_DIR_FULL_PATH"
         done

         local FILE_OR_DIR_FULL_PATH_LENGTH="$(expr length \""$FILE_OR_DIR_FULL_PATH"\")"
         local DIRECTORY_TO_VALIDATE_LENGTH="$(expr length \""$DIRECTORY_TO_VALIDATE"\")"
         local RELATIVE_PATH_LENGTH="$(expr $FILE_OR_DIR_FULL_PATH_LENGTH - $DIRECTORY_TO_VALIDATE_LENGTH)"
         # -gt -> greater than
         if [ "$RELATIVE_PATH_LENGTH" -gt "$MAX_FILE_LENGTH" ]; then
            ___invalid_file_name "$PREFIX_MS_WINDOWS""MAX_252_CHAR_LIMIT" "$FILE_OR_DIR_FULL_PATH"
         fi

         test "$FILE_OR_DIR_NAME" = '0' && ___invalid_file_name "$PREFIX_MS_WINDOWS""0_IS_RESERVED" "$FILE_OR_DIR_FULL_PATH"

         test "$FILE_OR_DIR_NAME" = '.' && ___invalid_file_name "$PREFIX_BOTH_NIX_AND_MS_WINDOWS""ONLY_DOT_IS_REZERVED" "$FILE_OR_DIR_FULL_PATH"

         test "$FILE_OR_DIR_NAME" = '..' && ___invalid_file_name "$PREFIX_BOTH_NIX_AND_MS_WINDOWS""ONLY_DUBLE_DOT_IS_REZERVED" "$FILE_OR_DIR_FULL_PATH"

         if ___do_directories_exist "$FILE_OR_DIR_FULL_PATH"; then

            ___stdout "$FILE_OR_DIR_NAME" | grep --basic-regexp '[.]$' >/dev/null 2>&1 && ___invalid_file_name "$PREFIX_MS_WINDOWS""CAN_NOT_END_WITH_DOT" "$FILE_OR_DIR_FULL_PATH"
            ___stdout "$FILE_OR_DIR_NAME" | grep --basic-regexp '[ ]$' >/dev/null 2>&1 && ___invalid_file_name "$PREFIX_MS_WINDOWS""CAN_NOT_END_WITH_SPACE" "$FILE_OR_DIR_FULL_PATH"
         fi

         # shellcheck disable=SC1003
         for RESERVED_CHAR in '*' '?' ':' '"' '<' '>' '|' '\\'; do
            ___stdout "$FILE_OR_DIR_NAME" | grep --basic-regexp "$RESERVED_CHAR" >/dev/null 2>&1 && ___invalid_file_name "$PREFIX_MS_WINDOWS""RESERVED_CHARACTER_$RESERVED_CHAR" "$FILE_OR_DIR_FULL_PATH"
         done

         # shellcheck disable=SC1003
         for RESERVED_CHAR in '/'; do
            ___stdout "$FILE_OR_DIR_NAME" | grep --basic-regexp "$RESERVED_CHAR" >/dev/null 2>&1 && ___invalid_file_name "$PREFIX_NIX_FAMILY""RESERVED_CHARACTER_$RESERVED_CHAR" "$FILE_OR_DIR_FULL_PATH"
         done

         ___string_contains "$FILE_OR_DIR_NAME" ' ' && ___invalid_file_name "$PREFIX_SUGGESTION""INCLUDES_SPACE" "$FILE_OR_DIR_FULL_PATH"

         ___string_contains "$FILE_OR_DIR_NAME" "'" && ___invalid_file_name "$PREFIX_SUGGESTION""'_CHARACTER_IS_NOT_RECOMMENDED" "$FILE_OR_DIR_FULL_PATH"

         ___stdout_using_format "$FILE_OR_DIR_NAME" | grep --basic-regexp '[[:cntrl:]]' >/dev/null 2>&1 && ___invalid_file_name "$PREFIX_SUGGESTION""INCLUDES_CONTROL_CHARACTER" "$FILE_OR_DIR_FULL_PATH"

         ___stdout_using_format "$FILE_OR_DIR_NAME" | grep --basic-regexp '[^[:print:]]' >/dev/null 2>&1 && ___invalid_file_name "$PREFIX_SUGGESTION""INCLUDES_NON_PRINTABLE_CHARACTER" "$FILE_OR_DIR_FULL_PATH"

         ___stdout "$FILE_OR_DIR_NAME" | grep --invert-match --extended-regexp '^[a-zA-Z0-9_.-]{1,}$' >/dev/null 2>&1 && ___invalid_file_name "$PREFIX_SUGGESTION""IS_NOT_ALPHA_NUMERIC_AND_EXCEPT_UNDERSCORE_AND_DASH_AND_DOT" "$FILE_OR_DIR_FULL_PATH"
      done
}

c_date_reset_of_files_and_subdirs() {

   ___print_screen "script will reset all dates of sub files and directories of current directory. do you want to resume? y/n"
   read RESUME

   if [ "$RESUME" != "y" ]; then
      ___print_screen "script will exit."
      return
   fi

   ___execute_with_eval find -type f -exec touch {} +
}

c_file_system___return_file_or_directory_which_contains() {

    ##############################
    # ABOUT
    ##############################
    # This function prints the directory or file which contains the string which sent as second parameter.
    # This can be done via "find" command. But this function does not depend on any command.
    ##############################
    ##############################
    ##############################

    ##############################
    # FUNCTION PARAMETERS
    ##############################
    local -r DIRECTORY_TO_SEARCH="$1"
    local -r TEXT_CONTAINS="$2"
    ##############################
    ##############################
    ##############################

    ___required_parameters=("DIRECTORY_TO_SEARCH" "TEXT_CONTAINS")
    ___check_parameters "$@" || return

    for DIRECTORY_OR_FILE in "$DIRECTORY_TO_SEARCH/"*; do
        if ___string_contains "$DIRECTORY_OR_FILE" "$TEXT_CONTAINS"; then
            ___stdout_and_new_line "$DIRECTORY_OR_FILE"
            return
        fi
    done
}

c_rename_files_batch() {

   ##############################
   # ABOUT
   ##############################
   # massren alternative.
   # massren does not have any package installer (deb, rpm, snap, flatpak...) or standalone version.
   # massren depends on 'go' platform. this is a simple shell alternative.
   ##############################
   ##############################
   ##############################

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r DIRECTORY_TO_RENAME="$1"
   # shellcheck disable=SC2034 # EXCLUDE_REGEX is using by ___required_parameters
   local -r EXCLUDE_REGEX="$2"
   ##############################
   ##############################
   ##############################

   # TODO: a bug exist about for files which have $ character.

   # sort is needed when we want same changes apply to another (cloned) directory (like backup)
   ___do_executables_exist "mkdir" "mv" "expr" "find" "while" "read" "sort" || return

   ___do_executables_exist "sed" || ___do_executables_exist "awk" || return

   ___required_parameters=("DIRECTORY_TO_RENAME" "EXCLUDE_REGEX")
   ___check_parameters "$@" || return

   local -r DIRECTORY_TO_RENAME_LENGTH="$(expr length \""$DIRECTORY_TO_RENAME"\")"
   DIRECTORY_TO_RENAME_LENGTH=$((DIRECTORY_TO_RENAME_LENGTH - 2))

   OLD_FILE_LIST="$HOME/old_files_list.txt"
   NEW_FILE_LIST="$HOME/new_files_list.txt"
   ___stdout "" >"$OLD_FILE_LIST"
   ___stdout "" >"$NEW_FILE_LIST"

   # do not use other loop types because they will break if file name have special character: https://stackoverflow.com/questions/9612090/how-to-loop-through-file-names-returned-by-find ("web.archive.org" and "archive.is". archived date: 01/05/2020)
   find "$DIRECTORY_TO_RENAME" -type f -name "*" ! -path "*/$EXCLUDE_REGEX/*" -print0 | sort -z |
      while IFS= read -r -d '' FILE_OR_DIR_FULL_PATH; do
         ___stdout "$FILE_OR_DIR_FULL_PATH" >>"$OLD_FILE_LIST"
         ___stdout "${FILE_OR_DIR_FULL_PATH:$DIRECTORY_TO_RENAME_LENGTH}" >>"$NEW_FILE_LIST"
      done

   "$CC_TEXT_EDITOR_FOR_NON_ROOT_FILES" "$NEW_FILE_LIST"

   ___print_screen 'if you changed the file names, type "y" to resume...'
   read RESUME

   if [ "$RESUME" != "y" ]; then
      ___print_screen "script will exit."
      return
   fi

   local LINE_NUMBER="1"
   local FIRST_LINE_OF_OLD_FILE_LIST="TRUE"
   while read OLD_FILE_FULL_PATH; do
      if [ "$FIRST_LINE_OF_OLD_FILE_LIST" = "TRUE" ]; then
         FIRST_LINE_OF_OLD_FILE_LIST="FALSE"
      else
         LINE_NUMBER=$((LINE_NUMBER + 1))

         local NEW_RELATIVE_FILE_NAME=""

         if ___do_executables_exist "sed"; then
            NEW_RELATIVE_FILE_NAME=$(sed "$LINE_NUMBER"'!d' "$NEW_FILE_LIST")
         elif ___do_executables_exist "awk"; then
            NEW_RELATIVE_FILE_NAME=$(awk 'NR=='"$LINE_NUMBER" "$NEW_FILE_LIST")
         else
            ___errorHandler "$?" 100031
            return
         fi

         if [ "$OLD_FILE_FULL_PATH" != "$DIRECTORY_TO_RENAME$NEW_RELATIVE_FILE_NAME" ]; then
            # -p --> do not give error if dir already exist
            local FOLDER="$(dirname "$DIRECTORY_TO_RENAME$NEW_RELATIVE_FILE_NAME")"
            mkdir -p "$FOLDER"
            ___execute_with_eval "mv" \'"$OLD_FILE_FULL_PATH"\' \'"$DIRECTORY_TO_RENAME$NEW_RELATIVE_FILE_NAME"\'

         fi
      fi
   done <"$OLD_FILE_LIST"
}

c_sync_directories() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r SOURCE_DIRECTORY="$1"
   local -r DESTINATION_DIRECTORY="$2"
   ##############################
   ##############################
   ##############################

   ___required_parameters=("SOURCE_DIRECTORY" "DESTINATION_DIRECTORY")
   ___check_parameters "$@" || return

   ___do_executables_exist "rsync" "eval" || return

   # --omit-dir-times --no-perms --inplace parameters are required for android usb devices

   local -r RSYNC_COMMAND="rsync --recursive --archive -verbose --delete-excluded --size-only --progress --omit-dir-times --no-perms --recursive --inplace \"$SOURCE_DIRECTORY\"/ \"$DESTINATION_DIRECTORY\"/"

   ___print_screen "list only changes first? (if you answer 'n' it will directly start to sync. CTRL+C to stop it now.)"
   ___print_screen "y/n"
   read listOnlyChanges

   if [ "$listOnlyChanges" = "y" ]; then
      ___execute_with_eval "$RSYNC_COMMAND --dry-run" || {
         ___errorHandler "$?" 100023
         return
      }

      ___print_screen "accept above changes?"
      ___print_screen "y/n"
      read choice

      if [ "$choice" != "y" ]; then
         ___print_screen "wrong choice or decline by user."
         return
      fi

   elif [ "$listOnlyChanges" != "n" ]; then

      ___print_screen "wrong choice."
      return
   fi

   ___execute_with_eval "$RSYNC_COMMAND"

   local -r LAST_COMMAND_EXIT_CODE="$?"
   c_notify_user 5 "sync finished"
   return "$LAST_COMMAND_EXIT_CODE"
}

c_file_type_info() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r FILE="$1"
   ##############################
   ##############################
   ##############################

   ___required_parameters=("FILE")
   ___check_parameters "$@" || return

   ___print_screen "mime type"
   # -b --> do not print the file name again
   ___execute file -i -b "$FILE"

   ___print_screen
   ___print_screen "type"
   # -b --> do not print the file name again
   ___execute file -b "$FILE"

   ___print_screen
   if awk '/\r$/{exit 0;} 1{exit 1;}' "$FILE"; then
      ___print_screen 'End of line character is: MS-Windows: CR+LF (\n\r)'
   else
      ___print_screen 'End of line character is: POSIX: LF (\n)'
   fi

   ___print_screen
   ___print_screen "first 300 bytes as hex+ASCII"
   ___execute_with_eval "head -c 300 myfile | hexdump"

   ___print_screen
   ___print_screen "first 300 bytes"
   ___execute head -c300 "$FILE"
}

# File name:cc_git.sh
c_git_log_all_branches() {
   ___execute git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
}

c_git_log_current_branch() {
   local -r CURRENT_BRANCH=$(git branch --show-current)
   ___execute git log "$CURRENT_BRANCH"
}

c_git_list_all_references() {
   if [ "$CC_OUTPUT_COLOR" = "true" ]; then
      # only standard colors of cc_scripts will be define globally. therefore we define these colors locally.
      local -r COLOR_YELLOW="$TPUT_BOLD$TPUT_WHITE$(tput setab 3)"
      local -r COLOR_PURPLE="$TPUT_BOLD$TPUT_WHITE$(tput setab 5)"
      ___stdout "$CC_COLOR_RED""REF""$CC_COLOR_RESET" "$CC_COLOR_BLUE""TRACKING REF""$CC_COLOR_RESET" "$COLOR_YELLOW""LATEST COMMIT TIME""$CC_COLOR_RESET" "$COLOR_PURPLE""AUTHOR""$CC_COLOR_RESET" "$CC_COLOR_GREEN""COMMIT SHA(SHORT)""$CC_COLOR_RESET" "COMMIT COMMENT"
   else
      ___stdout "REF - TRACKING REF - LATEST COMMIT TIME - AUTHOR - COMMIT SHA(SHORT) - COMMIT COMMENT"
   fi
   ___print_screen
   ___print_screen

   ___execute git for-each-ref --sort=-committerdate --format='%(color:red bold)%(refname)%(color:reset) %(color:blue bold)%(upstream)%(color:reset) %(color:yellow)%(committerdate:relative)%(color:reset) %(color:magenta bold)%(authorname)%(color:reset) %(color:green)%(objectname:short)%(color:reset) %(contents:subject)'
}

c_git_fetch_all_branches() {
   ___execute_and_color_line git branch
}

c_git_fetch_all_branches() {
   ___execute git fetch --all
}

c_git_fetch() {
   ___execute git fetch
}

c_git_checkout_by_remote_branch_name() {
   ___execute git checkout -b "$1" "origin/$1"
}

# File name:cc_gui_apps.sh
c_iso_to_usb___unetbootin() {

   c_path_add "$CC_STANDALONE_APPS_PATH_ROOT/7z"

   local -r ENABLE_FIREJAIL="TRUE"
   local -r HOME_DIR_NAME="unetbootin"
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" unetbootin)"
   local -r ENABLE_ROOT="TRUE"
   local -r APP_PARAMS=""

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_android_remote_desktop() {

   ___print_screen 'The device should be: '
   ___print_screen '- connected via usb'
   ___print_screen '- usb debug mode should be enabled'
   ___print_screen '- file transfer should be enabled'

   ___do_executables_exist "adb" || return

   ___execute adb devices

   local -r ENABLE_FIREJAIL="FALSE"
   local -r HOME_DIR_NAME="scrcpy"
   local -r LINUX_EXECUTABLE_FULL_PATH="scrcpy"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS=""

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_android_studio() {

   local -r ENABLE_FIREJAIL="FALSE"
   local -r HOME_DIR_NAME=""
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" android-studio)/bin/studio.sh"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS=""

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_intellij_idea_community() {

   local -r ENABLE_FIREJAIL="FALSE"
   local -r HOME_DIR_NAME=""
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" idea-IC)/bin/idea.sh"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS="$@"

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_insomnia() {

   local -r ENABLE_FIREJAIL="FALSE"
   local -r HOME_DIR_NAME="INSOMNIA"
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" Insomnia)"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS=""

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_eclipse_ide() {

   local -r ENABLE_FIREJAIL="FALSE"
   local -r HOME_DIR_NAME=""
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" eclipse)/eclipse"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS="$@"

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_vscodium() {

   local -r ENABLE_FIREJAIL="FALSE"
   local -r HOME_DIR_NAME=""
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" VSCodium)"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS="$@"

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_dbeaver() {
   export _JAVA_OPTIONS="-Duser.home=$CC_APPS_HOME/DBEAVER"

   local -r ENABLE_FIREJAIL="FALSE"
   local -r HOME_DIR_NAME="DBEAVER"
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" dbeaver)/dbeaver"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS=""

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_soapui() {
   export _JAVA_OPTIONS="-Duser.home=$CC_APPS_HOME/SOAPUI"

   local -r ENABLE_FIREJAIL="FALSE"
   local -r HOME_DIR_NAME="SOAPUI"
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" SoapUI)/bin/soapui.sh"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS=""

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_peazip() {
   local -r ENABLE_FIREJAIL="TRUE"
   local -r HOME_DIR_NAME="peazip"
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" peazip)/peazip"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS="$HOME" # Peazip opens here as default. othwerwise we need to route manually to $HOME (which is using in most cases).

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_photo_editor___gimp() {

   local -r ENABLE_FIREJAIL="TRUE"
   local -r HOME_DIR_NAME="GIMP"
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" GIMP)"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS=""

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_password_manager_KeePassXC() {

   local -r ENABLE_FIREJAIL="TRUE"
   local -r HOME_DIR_NAME="KeePassXC"
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" KeePassXC)"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS=""

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_google_chrome() {

   local -r ENABLE_FIREJAIL="FALFE"
   local -r HOME_DIR_NAME="google-chrome"
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" google-chrome)/opt/google/chrome/google-chrome"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS=""

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_tor_browser() {

   local -r ENABLE_FIREJAIL="FALSE"
   local -r HOME_DIR_NAME="tor-browser"
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" tor-browser)/Browser/start-tor-browser"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS=""

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

___start_gui_app() {

   local -r ENABLE_FIREJAIL="$1"
   local -r HOME_DIR_NAME="$2"
   local -r LINUX_EXECUTABLE_FULL_PATH="$3"
   local -r ENABLE_ROOT="$4"
   local -r APP_PARAMS="$5"

   local -r HOME_DIR_BACKUP="$HOME"
   ___create_home_and_switch_it "$HOME_DIR_NAME"

   # do not enable profiles on firejail commands. because profile rules (as default) does not allow to read from /nix/* and $HOME/app_name/* directories.

   # do not use "$APP_PARAMS" using double quote. That makes problem if APP_PARAMS is empty string.

   if [ "$ENABLE_ROOT" = "TRUE" ]; then
      if ___do_executables_exist "firejail"; then
         if [ "$ENABLE_FIREJAIL" = "TRUE" ]; then
            ___run_command_as_root firejail --net=none --noprofile "$LINUX_EXECUTABLE_FULL_PATH" $APP_PARAMS
            return
         fi
      fi
      ___run_command_as_root "$LINUX_EXECUTABLE_FULL_PATH" $APP_PARAMS
   else
      if ___do_executables_exist "firejail"; then
         if [ "$ENABLE_FIREJAIL" = "TRUE" ]; then
            ___nohup_and_disown firejail --net=none --noprofile "$LINUX_EXECUTABLE_FULL_PATH" $APP_PARAMS
            return
         fi
      fi
      ___nohup_and_disown "$LINUX_EXECUTABLE_FULL_PATH" $APP_PARAMS
   fi

   HOME="$HOME_DIR_BACKUP"
}

___create_home_and_switch_it() {

   # If the value is empty the function should not swithch HOME directory.
   # This case required for development-apps like Eclipse, other IDE, VScode...
   ___is_empty_string "$1" && return

   # -p ignores the warning: folder already exist.
   mkdir -p "$CC_APPS_HOME" || {
      ___print_screen "Error: could not create $CC_APPS_HOME (\$CC_APPS_HOME) directory. \$HOME will not change. The script will resume."
      return
   }

   # -p ignores the warning: folder already exist.
   mkdir -p "$CC_APPS_HOME/$1" || {
      ___print_screen "Error: could not create directory under $CC_APPS_HOME/$1. \$HOME will not change. The script will resume."
      return
   }

   HOME="$CC_APPS_HOME/$1"
}

# File name:cc_maven.sh
___get_maven_command() {

   local -r MAVEN_WRAPPER="./mvnw"

   if ___do_executables_exist_without_output "$MAVEN_WRAPPER"; then
      ___stdout "$MAVEN_WRAPPER"
   else
      ___stdout "mvn"
   fi
}

c_maven_clean_install() {
   local -r MAVEN_EXECUTABLE="$(___get_maven_command)"

   local -r CURRENT_DIR_PATH="$(pwd)"
   local -r CURRENT_DIR_NAME="$(basename $CURRENT_DIR_PATH)"

   ___execute "$MAVEN_EXECUTABLE" clean install $@

   local -r LAST_COMMAND_EXIT_CODE="$?"
   c_notify_user "0.1" "maven finish for $CURRENT_DIR_NAME"
   return "$LAST_COMMAND_EXIT_CODE"
}

c_maven_clean_install_update_snapshots() {
   local -r MAVEN_EXECUTABLE="$(___get_maven_command)"

   local -r CURRENT_DIR_PATH="$(pwd)"
   local -r CURRENT_DIR_NAME="$(basename $CURRENT_DIR_PATH)"

   ___execute "$MAVEN_EXECUTABLE" clean install -U $@

   local -r LAST_COMMAND_EXIT_CODE="$?"
   c_notify_user '0.1' "maven finish for $CURRENT_DIR_NAME"
   return "$LAST_COMMAND_EXIT_CODE"
}

c_maven_clean_install_skip_tests() {
   local -r MAVEN_EXECUTABLE="$(___get_maven_command)"

   local -r CURRENT_DIR_PATH="$(pwd)"
   local -r CURRENT_DIR_NAME="$(basename $CURRENT_DIR_PATH)"

   ___execute "$MAVEN_EXECUTABLE" clean install -DskipTests $@

   local -r LAST_COMMAND_EXIT_CODE="$?"
   c_notify_user '0.1' "maven finish for $CURRENT_DIR_NAME"
   return "$LAST_COMMAND_EXIT_CODE"
}

# File name:cc_media_file.sh
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

# File name:cc_network.sh
c_tor_run_with_command() {

   local -r TOR_CONFIG_FILE="$CC_STANDALONE_APPS_PATH_ROOT/../tor_config.txt"
   local -r TOR_EXECUTABLE="$CC_STANDALONE_APPS_PATH_ROOT/tor/usr/bin/tor"
   local -r LIB_EVENT_PATH="$CC_STANDALONE_APPS_PATH_ROOT/libevent-2.1-6_2.1.8-stable-4build1_amd64/usr/lib/x86_64-linux-gnu"

   ___do_executables_exist "$TOR_EXECUTABLE" "cp" "read" || return

   # getting default configs
   ___execute cp "$CC_STANDALONE_APPS_PATH_ROOT/tor/etc/tor/torrc" "$TOR_CONFIG_FILE" || {
      ___errorHandler "$?" 100029
      return
   }

   # adding custom configs
   ___stdout_using_format "\n%s\n%s" 'ControlPort 9051 # "torsocks" will connect this port as default.' 'CookieAuthentication 0' >>"$TOR_CONFIG_FILE" || {
      ___errorHandler "$?" 100034
      return
   }

   COMMAND__TO_RUN_ON_NEW_SHELL="export LD_LIBRARY_PATH=\"$LIB_EVENT_PATH\"; \"$TOR_EXECUTABLE\" --defaults-torrc \"$TOR_CONFIG_FILE\""

   ___print_title "run below command on another terminal window:"
   ___print_screen "$COMMAND__TO_RUN_ON_NEW_SHELL"
   ___print_screen
   ___print_screen "check the other terminal if tor started (connected to any bridge) properly. if yes, then type 'y', otherwise 'n'."
   read userChoice

   if [ "$userChoice" = "y" ]; then
      # default settings are enough to run
      export TORSOCKS_CONF_FILE="$CC_STANDALONE_APPS_PATH_ROOT/torsocks/etc/tor/torsocks.conf"
      ___execute_with_eval "LD_PRELOAD=\"$CC_STANDALONE_APPS_PATH_ROOT/torsocks/usr/lib/x86_64-linux-gnu/torsocks/libtorsocks.so\" $@"
      ___print_screen "Close the other terminal window with CTRL+C. Otherwise it will work background."
   else
      ___print_screen "script will exit"
   fi
}

c_mac_address_change_random() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r NETWORK_INTERFACE="$1"
   ##############################
   ##############################
   ##############################

   ___required_parameters=("NETWORK_INTERFACE (c_ip function can print the network interfaces.)")
   ___check_parameters "$@" || return

   ___do_executables_exist "ip" "sed" "service" || return

   local -r hexchars="0123456789ABCDEF"
   # shellcheck disable=SC2034 # "i" is not using. not important currently.
   local -r end=$(for i in {1..6}; do ___stdout ${hexchars:$((RANDOM % 16)):1}; done | sed -e 's/\(..\)/:\1/g')
   local -r MAC_ADDRESS="00:60:2F$end"
   ___print_screen "new mac: $MAC_ADDRESS"
   ___run_command_as_root ip link set dev "$NETWORK_INTERFACE" down || {
      ___errorHandler "$?" 100006
      return
   }
   ___run_command_as_root ip link set dev "$NETWORK_INTERFACE" address "$MAC_ADDRESS" || {
      ___errorHandler "$?" 100007
      return
   }
   ___run_command_as_root ip link set dev "$NETWORK_INTERFACE" up || {
      ___errorHandler "$?" 100008
      return
   }
   ___run_command_as_root service network-manager restart || {
      ___errorHandler "$?" 100009
      return
   }
   ___print_screen "now you should wait 5-10 seconds because network-manager service is restarting."
   ___print_screen "mac address will revert to default after reboot of OS."
}

c_port_open_serving_string() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r TEXT_TO_SHARE="$1"
   local -r LOCAL_PORT="$2"
   ##############################
   ##############################
   ##############################

   ___required_parameters=("TEXT_TO_SHARE" "LOCAL_PORT")
   ___check_parameters "$@" || return

   # -l --> creates server connection
   # -n --> do not lookup DNS
   # -v --> verbose output
   ___execute_with_eval printf '%s' "$TEXT_TO_SHARE" "|" nc -n -v -l "$LOCAL_PORT"

   local -r LAST_COMMAND_EXIT_CODE="$?"
   c_notify_user 1 "port closed"
   return "$LAST_COMMAND_EXIT_CODE"
}

c_port_kill_all_processes_by_port_number() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r PORT_NUMBER="$1"
   ##############################
   ##############################
   ##############################

   ___required_parameters=("PORT_NUMBER")
   ___check_parameters "$@" || return

   ___execute lsof -i:"$PORT_NUMBER"

   ___print_screen "-t --> show only process ID"
   ___print_screen "-i --> show only internet connections related process"
   ___print_screen "-9 --> kill forcefully"
   ___print_screen 'kill -9 $(lsof -t -i:'$PORT_NUMBER')'
}

c_port_details_HELP_ONLY() {
   ___print_screen "ss --all --processes --tcp --udp | color_line"
   ___print_screen "netstat -p -u -t -a | color_line"
}

c_host_file_edit_or_view_HELP_ONLY() {
   HOST_FILE="/etc/hosts"
   ___execute_and_color_line cat "$HOST_FILE"
   ___print_screen "sudo gedit $HOST_FILE"
}

c_print_host_names_and_local_ip_addresses_HELP_ONLY() {
   ___print_screen "list of all full host names"
   ___execute hostname -A
   ___print_screen "list of all IP addresses for this host"
   ___execute hostname -I
}

c_ip_external() {
   ___print_screen "external ip"
   ___execute dig +short myip.opendns.com @resolver1.opendns.com
}

c_ip_HELP_ONLY() {
   ___print_title "PARAMETERS" 
   ___print_screen "COLORFUL OUTPUT = -c"
   ___print_screen "SHOW ALL INTERFACES = -a"
   ___print_screen
   ___print_screen "ip -c a"
   ___print_screen
   ___print_title "If you need a json to see what is each value, use below command and format it with ny json pritifier."
   ___print_screen "ip -j a"
   ___print_screen
   ___print_screen "ifconfig -a"
}

# File name:cc_nix.sh
___nix_install_app() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r ATTRIBUTE="$1"
   local -r APP_ID="$2"
   local -r ADDITIONAL_CONFIG="$3"
   ##############################
   ##############################
   ##############################

   ___required_parameters=("ATTRIBUTE" "APP_ID" "ADDITIONAL_CONFIG")
   ___check_parameters "$@" || return

   ___is_empty_string "$ATTRIBUTE" && ATTRIBUTE=""
   ___is_empty_string "$ADDITIONAL_CONFIG" && ADDITIONAL_CONFIG=""

   ___run_command_as_nix_user "$CC_NIX_BIN_ALL_PATH/nix-env -i$ATTRIBUTE $APP_ID --arg config \"{ allowUnfree = true; $ADDITIONAL_CONFIG }\""
}

c_nix_install_app() {

   ___nix_install_app "NULL" "$1" "NULL"
}

c_nix_install_app_by_attribute() {

   ___nix_install_app "A" "$1" "NULL"
}

c_nix_install_app_with_config() {

   ___nix_install_app "NULL" "$1" "$2"
}

c_nix_remove_app() {

   ___run_command_as_nix_user "$CC_NIX_BIN_ALL_PATH/nix-env -e $1"
}

c_nix_list_all_apps() {

   ___run_command_as_nix_user "$CC_NIX_BIN_ALL_PATH/nix-env -q"
}

c_nix_install_all_updates() {

   ___run_command_as_nix_user "$CC_NIX_BIN_ALL_PATH/nix-channel --update nixpkgs --arg config \"{ allowUnfree = true; }\""
   ___run_command_as_nix_user "$CC_NIX_BIN_ALL_PATH/nix-env -u \"*\" --arg config \"{ allowUnfree = true; }\""
}

___run_command_as_nix_user() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r COMMAND_WITH_PARAMS="$1"
   ##############################
   ##############################
   ##############################

   if ___do_executables_exist "su"; then
      # RUN THE COMMAND = -c
      ___execute_with_eval "su $CC_NIX_USER -c '""$COMMAND_WITH_PARAMS""'"
   else
      ___print_screen "could not run command as $NIXUSER. reason: 'su' command not found."
   fi
}

# File name:cc_others.sh
c_system_details_using_only_neofetch() {

   # --backend off --> do not print OS logo
   # --refresh_rate --> print refresh rate of screen
   # --travis --> prints more detail
   # --no_config --> Do not create a config file inside $HOME/config/neofetch directory
   ___execute_with_eval "$CC_STANDALONE_APPS_PATH_ROOT/neofetch \
           --cpu_temp C \
           --travis \
           --no_config \
           --backend off \
           --kernel_shorthand off \
           --title_fqdn on \
           --distro_shorthand off \
           --os_arch on \
           --uptime_shorthand off \
           --memory_percent on \
           --package_managers on \
           --shell_path on \
           --shell_version on \
           --cpu_brand on \
           --cpu_speed on \
           --gpu_brand on \
           --gpu_type all \
           --refresh_rate on \
           --gtk_shorthand off \
           --gtk2 on \
           --gtk3 on \
           --ip_timeout 8 \
           --de_version on"
}

c_notify_user() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r TIME_TO_BEEP="$1"
   local -r MESSAGE="$2"
   ##############################
   ##############################
   ##############################

   ___print_screen "$MESSAGE"

   # MacOS GUI notification
   ___do_executables_exist_without_output "osascript" && { osascript -e "display notification \""$MESSAGE"\" with title "cc_scripts" "; }

   # Linux GUI notification
   ___do_executables_exist_without_output "notify-send" && { notify-send "$MESSAGE" --app-name "cc_scripts"; }

   local -r MS_WINDOWS_NOTIFY_COMMANDS='
   [reflection.assembly]::loadwithpartialname("System.Windows.Forms")
   [reflection.assembly]::loadwithpartialname("System.Drawing")
   $notify = new-object system.windows.forms.notifyicon
   $notify.icon = [System.Drawing.SystemIcons]::Information
   $notify.visible = $true
   $notify.showballoontip(20,"cc_scripts","'$MESSAGE'",[system.windows.forms.tooltipicon]::None)
   '

   ___do_executables_exist_without_output "powershell" && { powershell -c "$MS_WINDOWS_NOTIFY_COMMANDS"; }

   # always return success. This a simple notification function. It should not block the parent script.
   ___do_executables_exist_without_output "speaker-test" "timeout" || return 0

   ___is_empty_string "$TIME_TO_BEEP" && TIME_TO_BEEP="3"

   timeout --kill-after="$TIME_TO_BEEP" 1 speaker-test --frequency 1000 --test sine >"/dev/null"

   # always return success. This a simple notification function. It should not block the parent script.
   return 0
}

c_calculator() {

   ___print_title "Type directly and press 'enter'. Examples:"
   ___print_screen "(1^2)*3"
   ___print_screen "sqrt(9)    ---> Square root"
   ___print_screen
   ___print_title "Scale is 20 now. To change it type:"
   ___print_screen "scale=5;    ---> that means only 5 digits will print after comma."
   ___print_screen

   # -q --> do not print welcome text
   # -l --> set scale as 20
   bc -q -l
}

# File name:cc_path.sh
c_path_search() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r KEYWORD="$1" # keyword to search inside $PATH
   ##############################
   ##############################
   ##############################

   ___do_executables_exist "grep" "tr" || return

   # IGNORE CASE = -i
   # tr ':' '\n' = replaces : character to new-line
   ___execute_with_eval "printf \"%s\" \""'$PATH'"\" | tr ':' '\n' | grep \"$KEYWORD\" -i | color_line"
}

c_path_add() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r DIR="$1"
   ##############################
   ##############################
   ##############################

   ___is_empty_string "$DIR" && {
      ___print_screen "$DIR is empty."
      return
   }

   ___string_contains "$PATH" "$DIR" && {
      ___print_screen "$DIR already exist."
      return
   }

   PATH="$DIR:$PATH"

   ___print_screen "Path added. New PATH: $PATH"
}

# File name:cc_script_utils/cc_print_manual_test.sh
# This is not a unit test. This can be called from runtime.
___print_color_test() {

   requestScriptPath || return

   local -r TEST_COMMANDS=". \"$CC_SCRIPTS_FILE_PATH\"; ___print_color_test_current_shell"

   ___stdout_and_new_line "-- running on zsh"
   zsh -c "$TEST_COMMANDS" || {
      ___errorHandler "$?" 100032
      return
   }

   ___stdout_and_new_line "-- running on bash"
   bash -c "$TEST_COMMANDS" || {
      ___errorHandler "$?" 100033
      return
   }
}

# This should not call directly. This should be called by ___print_color_test.
___print_color_test_current_shell() {

   ___stdout_and_new_line "** colors below should be on their names:"

   CC_OUTPUT_COLOR=true
   ___print_screen "blue"
   ___print_title "red"
   ___stdout_and_new_line "default"

   CC_OUTPUT_COLOR=false
   ___print_screen "default"
   ___print_title "default"
   ___stdout_and_new_line "default"
   ___stdout_and_new_line
}

# File name:cc_script_utils/cc_scripts_help.sh
c_help_open_cc_scripts_with_text_editor() {
   requestScriptPath || return
   "$CC_TEXT_EDITOR_FOR_NON_ROOT_FILES" "$CC_SCRIPTS_FILE_PATH"
}

# File name:cc_script_utils/cc_scripts_import.sh
c_ccscripts_import() {

   ##############################
   # ABOUT
   ##############################
   # adds a new line (to .bashrc and .zshrc files) which executes(imports) this(cc_scripts.sh) file
   ##############################
   ##############################
   ##############################

   requestScriptPath || return

   ___do_executables_exist "cp" "grep" || return

   local -r LINE_TO_IMPORT1="export CC_SCRIPTS_FILE_PATH='$CC_SCRIPTS_FILE_PATH'"
   local -r LINE_TO_IMPORT2='source "$CC_SCRIPTS_FILE_PATH"'

   for SHELL_RC_FILE_NAME in ".bashrc" ".zshrc"; do
      local SHELL_RC_FILE="$HOME/$SHELL_RC_FILE_NAME"

      # if we have a keyword of 'cc_scripts' anywhere on file, stop the script.
      if grep "cc_scripts" "$SHELL_RC_FILE" >"/dev/null"; then
         ___print_screen "$SHELL_RC_FILE already have something about cc_scripts. It is better to add manually. Skipping..."
      else
         # everything is OK. importing lines...
         ___stdout_using_format "\n\n%s\n%s\n\n" "$LINE_TO_IMPORT1" "$LINE_TO_IMPORT2" >>"$SHELL_RC_FILE"

         ___print_screen "added to $SHELL_RC_FILE"
      fi
   done # en of loop of '.bashrc', '.zshrc' filess
}

# File name:cc_script_utils/cc_scripts_file_requestor.sh
requestScriptPath() {

   ##############################################
   # CC_SCRIPTS_FILE_PATH is a global variable which indicates the script file path of cc_scripts.sh.
   #
   # This variable is using by some functions like:
   # - c_help
   # - c_download_with_curl_script
   #
   # It is not easy to detect (programmatically) the absolute file path of running current script. Because there are too many ways for running a script. Some examples:
   # - Where the script is running: Zsh or Bash and their different versions (and maybe some distro/terminal are overriding the behaviors)
   # - sourcing or executing script file
   # - sourcing or executing from another script file
   # - mingw (ms-windows) or subsystem linux (ms-windows) or linux or mac
   # - calling the script using it's relative path or absolute path
   #
   # Therefore we prefer to ask it to user.
   ##############################################

   if ___is_empty_string "$CC_SCRIPTS_FILE_PATH"; then

      ___print_screen "type below:"
      ___print_screen 'export CC_SCRIPTS_FILE_PATH="/absolute/path/to/cc_scripts.sh"'
      ___errorHandler "$?" 100026
      return
   fi

   if ! ___do_files_exist "$CC_SCRIPTS_FILE_PATH"; then

      ___print_screen "You have exported CC_SCRIPTS_FILE_PATH as $CC_SCRIPTS_FILE_PATH"
      ___print_screen "But the file does not exist. Make sure and export it again as below:"
      ___print_screen 'export CC_SCRIPTS_FILE_PATH="/absolute/path/to/cc_scripts.sh"'
      ___errorHandler "$?" 100027
      return
   fi
}

# File name:cc_script_utils/cc_scripts_init.sh
##############################################
# OPTIONAL VARIABLES
##############################################

# we don't use nix daemon. we prefer to create a new user only for nix installations.
# so any user who knows the password of $CC_NIX_USER can install packages on nix.
# otherwise nix does not allow multi-users installation of nix packages.
___is_empty_string "$CC_NIX_USER" && CC_NIX_USER='nixuser'

# this is the directory where the nix binaries storing.
# you do not need to add $CC_NIX_BIN_ALL_PATH to your $PATH. all cc_script functions reads both CC_NIX_BIN_ALL_PATH and PATH.
___is_empty_string "$CC_NIX_BIN_ALL_PATH" && CC_NIX_BIN_ALL_PATH="/nix/var/nix/profiles/per-user/$CC_NIX_USER/profile/bin"

# this folder can include any of these:
# - official portable/standalone versions of apps
# - extracted (official) '.deb' files of apps
___is_empty_string "$CC_STANDALONE_APPS_PATH_ROOT" && CC_STANDALONE_APPS_PATH_ROOT="$HOME/APPS/EXTRACTED_FILES"

# We set $HOME as $CC_APPS_HOME/appName before start any app which use GUI (except development apps like: Eclipse, IntelliJ, VSCode)
___is_empty_string "$CC_APPS_HOME" && CC_APPS_HOME="$HOME/APPS/HOME"

# text editors
___is_empty_string "$CC_TEXT_EDITOR_FOR_NON_ROOT_FILES" && CC_TEXT_EDITOR_FOR_NON_ROOT_FILES="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" VSCodium)"
___is_empty_string "$CC_TEXT_EDITOR_FOR_ROOT_FILES" && CC_TEXT_EDITOR_FOR_ROOT_FILES='gedit'

# Enable/disable output color.
# This is not recommended if your terminal supports color.
# Because all cc_script functions prints colorful text, so you can recognize which output is printed which command.
# For example "git" command output will not mixed with the cc_script's custom text output. Because the "git" output will be printed colorless.
___is_empty_string "$CC_OUTPUT_COLOR" && CC_OUTPUT_COLOR='true'

##############################################
# PRINT VERSION WHEN CC_SCRIPT.SH FILE IS LOADED
##############################################

___print_screen "cc_scripts version: $CC_SCRIPTS_PROJECT_VERSION"

