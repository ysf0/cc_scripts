PROJECT_ROOT_DIR_FULL_PATH="$(dirname "$0")/.."

source "$PROJECT_ROOT_DIR_FULL_PATH/src/core_shell_utils/cc_exit_code.sh" || exit 13
source "$PROJECT_ROOT_DIR_FULL_PATH/dev_scripts/dev_utils.sh" || exit 11
source "$PROJECT_ROOT_DIR_FULL_PATH/test/test_util.sh" || exit 12
source "$PROJECT_ROOT_DIR_FULL_PATH/src/core_shell_utils/cc_is_empty_string.sh" || exit 13
source "$PROJECT_ROOT_DIR_FULL_PATH/src/core_shell_utils/cc_command_executor.sh" || exit 14
source "$PROJECT_ROOT_DIR_FULL_PATH/src/core_shell_utils/cc_print_utils.sh" || exit 15
source "$PROJECT_ROOT_DIR_FULL_PATH/src/core_shell_utils/cc_core_utils.sh" || exit 13

___unit_test___execute_and_grep_and_color_line() {

    GREP_COMMAND_PARAM=""
    ___execute_and_grep_and_color_line "return" 0
    test "$?" -eq "0" || return 1

    ___execute_and_grep_and_color_line "return" 80
    test "$?" -eq "0" || return 2

    ___execute_and_grep_and_color_line this_command_not_exist
    test "$?" -eq "0" || return 3

    ___execute_and_grep_and_color_line "echo anyText"
    test "$?" -eq "0" || return 4

    local -r TEMP_FILE_FULL_PATH="$(mktemp)" || return 5
    ___execute_and_grep_and_color_line rm "$TEMP_FILE_FULL_PATH"
    test "$?" -eq "0" || return 6
    ___do_files_exist "$TEMP_FILE_FULL_PATH" && return 7

    return 0
}

___unit_test___execute_and_color_line() {

    ___execute_and_color_line "return" 0
    test "$?" -eq "0" || return 1

    ___execute_and_color_line "return" 80
    test "$?" -eq "0" || return 2

    ___execute_and_color_line this_command_not_exist
    test "$?" -eq "0" || return 3

    ___execute_and_color_line "echo anyText"
    test "$?" -eq "0" || return 4

    local -r TEMP_FILE_FULL_PATH="$(mktemp)" || return 5
    ___execute_and_color_line rm "$TEMP_FILE_FULL_PATH"
    test "$?" -eq "0" || return 6
    ___do_files_exist "$TEMP_FILE_FULL_PATH" && return 7

    return 0
}

___unit_test___execute() {

    ___execute "return" 0
    test "$?" -eq "0" || return 1

    ___execute "return" 80
    test "$?" -eq "80" || return 2

    ___execute this_command_not_exist
    test "$?" -eq "0" && return 3

    ___execute "echo anyText"
    test "$?" -eq "0" && return 4

    local -r TEMP_FILE_FULL_PATH="$(mktemp)" || return 5
    ___execute rm "$TEMP_FILE_FULL_PATH"
    test "$?" -eq "0" || return 6
    ___do_files_exist "$TEMP_FILE_FULL_PATH" && return 7

    return 0
}

___unit_test___execute_with_eval_common() {

    local -r FUNCTION_NAME="$1"

    $FUNCTION_NAME "return" 0
    test "$?" -eq "0" || return 1

    $FUNCTION_NAME "return" 80
    test "$?" -eq "80" || return 2

    $FUNCTION_NAME this_command_not_exist
    test "$?" -eq "0" && return 3

    $FUNCTION_NAME "echo anyText"
    test "$?" -eq "0" || return 4

    $FUNCTION_NAME "echo anyText | grep 123"
    test "$?" -eq "0" && return 5

    $FUNCTION_NAME echo anyText "|" grep 123
    test "$?" -eq "0" && return 6

    $FUNCTION_NAME "echo anyText | grep any"
    test "$?" -eq "0" || return 7

    $FUNCTION_NAME echo anyText "|" grep any
    test "$?" -eq "0" || return 8

    local -r TEMP_FILE_FULL_PATH="$(mktemp)" || return 14
    local -r FILE_CONTENT="hello"
    $FUNCTION_NAME "printf $FILE_CONTENT > \"$TEMP_FILE_FULL_PATH\""
    test "$?" -eq "0" || return 9
    test "$FILE_CONTENT" = "$(<$TEMP_FILE_FULL_PATH)" || return 10
    rm $TEMP_FILE_FULL_PATH || return 11

    return 0
}

___unit_test___nohup_and_disown() {
    ___nohup_and_disown "printf" hi
    test "$?" -eq "0" || return 1

    ___nohup_and_disown "printf" hi
    test "$?" -eq "0" || return 2

    ___nohup_and_disown this_command_not_exist
    test "$?" -eq "0" || return 3

    local TEMP_FILE_FULL_PATH="$(mktemp)" || return 4
    ___nohup_and_disown rm "$TEMP_FILE_FULL_PATH"
    test "$?" -eq "0" || return 5
    sleep 2 || return 6
    ___do_files_exist "$TEMP_FILE_FULL_PATH" && return 7

    local TEMP_FILE_FULL_PATH="$(mktemp)" || return 8
    local -r FILE_CONTENT="hello"
    ___nohup_and_disown "printf $FILE_CONTENT > \"$TEMP_FILE_FULL_PATH\""
    test "$?" -eq "0" || return 9
    sleep 2 || return 10
    test "$FILE_CONTENT" = "$(<$TEMP_FILE_FULL_PATH)" && return 11
    rm $TEMP_FILE_FULL_PATH || return 12

    return 0
}

___unit_test___execute_and_grep_and_color_line || printError "___unit_test___execute_and_grep_and_color_line" "$?"
___unit_test___execute_and_color_line || printError "___unit_test___execute_and_color_line" "$?"
___unit_test___execute "___execute" || printError "___unit_test___execute" "$?"
___unit_test___execute_with_eval_common "___execute_with_eval" || printError "___unit_test___execute_with_eval" "$?"
___unit_test___execute_with_eval_common "___execute_with_eval_removed_long_lines" || printError "___unit_test___execute_with_eval_removed_long_lines" "$?"
___unit_test___nohup_and_disown || printError "___unit_test___nohup_and_disown" "$?"
