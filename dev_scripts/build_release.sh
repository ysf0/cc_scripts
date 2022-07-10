#!/bin/bash

PROJECT_ROOT_DIR_FULL_PATH="$(dirname "$0")/.."

RELEASE_FILE_FULL_PATH="$PROJECT_ROOT_DIR_FULL_PATH/release/cc_scripts.sh"
source "$PROJECT_ROOT_DIR_FULL_PATH/dev_scripts/dev_utils.sh" || exit 2
source "$PROJECT_ROOT_DIR_FULL_PATH/src/core_shell_utils/cc_core_utils.sh" || exit 3

# if this script file executed using relative path, we convert to absolute path.
if ___string_starts_with "$RELEASE_FILE_FULL_PATH" "./"; then
   # ${RELEASE_FILE_FULL_PATH:1} --> removed the first character which is "." (dot) in this case.
   readonly RELEASE_FILE_FULL_PATH="$(pwd)${RELEASE_FILE_FULL_PATH:1}" || exit 36
fi

printf '
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
############################################# \n\n' >"$RELEASE_FILE_FULL_PATH" || exit 4

appendToReleaseFile() {
   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r SOURCE_FILE_NAME="$1"
   ##############################
   ##############################
   ##############################

   local -r SOURCE_FILE_FULL_PATH="$PROJECT_ROOT_DIR_FULL_PATH/src/$SOURCE_FILE_NAME"
   local -r FILE_CONTENT="$(<"$SOURCE_FILE_FULL_PATH")" || exit 5
   # %s --> print the string as literally (it will not fail if the the content has shell syntax).
   printf '# File name:%s\n%s\n\n' "$SOURCE_FILE_NAME" "$FILE_CONTENT" >>"$RELEASE_FILE_FULL_PATH" || exit 6
}

# order of these is important.
appendToReleaseFile core_shell_utils/cc_exit_code.sh || exit 23
appendToReleaseFile core_shell_utils/cc_is_empty_string.sh || exit 7
appendToReleaseFile core_shell_utils/cc_core_utils.sh || exit 8
appendToReleaseFile core_shell_utils/cc_command_checker.sh || exit 9
appendToReleaseFile core_shell_utils/cc_print_utils.sh || exit 10
appendToReleaseFile core_shell_utils/cc_command_checker_without_warning.sh || exit 11
appendToReleaseFile core_shell_utils/cc_command_executor.sh || exit 12
appendToReleaseFile core_shell_utils/cc_exception_handler.sh || exit 13

# below order is not important.
appendToReleaseFile cc_cassandra.sh || exit 15
appendToReleaseFile cc_docker.sh || exit 17
appendToReleaseFile cc_download_media.sh || exit 20
appendToReleaseFile cc_file_system.sh || exit 22
appendToReleaseFile cc_git.sh || exit 23
appendToReleaseFile cc_gui_apps.sh || exit 24
appendToReleaseFile cc_maven.sh || exit 25
appendToReleaseFile cc_media_file.sh || exit 25
appendToReleaseFile cc_network.sh || exit 26
appendToReleaseFile cc_nix.sh || exit 27
appendToReleaseFile cc_others.sh || exit 28
appendToReleaseFile cc_path.sh || exit 29
appendToReleaseFile cc_script_utils/cc_print_manual_test.sh || exit 30
appendToReleaseFile cc_script_utils/cc_scripts_help.sh || exit 31
appendToReleaseFile cc_script_utils/cc_scripts_import.sh || exit 32

# these should be last.
appendToReleaseFile cc_script_utils/cc_scripts_file_requestor.sh || exit 33
appendToReleaseFile cc_script_utils/cc_scripts_init.sh || exit 34

___dev_print_screen "Build done."
___dev_print_screen "Sourcing the builded script, in case of any syntax error..."
source "$RELEASE_FILE_FULL_PATH" || exit 35
___dev_print_screen "Script sourced successfully."
___dev_print_screen "Some useful commands to run and test the new cc_scripts release:"
___dev_print_screen
___dev_print_screen "export CC_SCRIPTS_FILE_PATH='$RELEASE_FILE_FULL_PATH'"
___dev_print_screen
___dev_print_screen 'source "$CC_SCRIPTS_FILE_PATH"'
