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
