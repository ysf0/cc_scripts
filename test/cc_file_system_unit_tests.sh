PROJECT_ROOT_DIR_FULL_PATH="$(dirname "$0")/.."

source "$PROJECT_ROOT_DIR_FULL_PATH/src/core_shell_utils/cc_exit_code.sh" || exit 11
source "$PROJECT_ROOT_DIR_FULL_PATH/dev_scripts/dev_utils.sh" || exit 12
source "$PROJECT_ROOT_DIR_FULL_PATH/test/test_util.sh" || exit 13
source "$PROJECT_ROOT_DIR_FULL_PATH/src/cc_file_system.sh" || exit 14

c_file_name_invalid_detect_common_test() {

    local -r TEMP_ROOT_DIRECTORY="$(mktemp --directory)" || return 1
    local -r FILE_PATH="$TEMP_ROOT_DIRECTORY/$1"

    if [ "$3" = "DIRECTORY" ]; then
        mkdir "$FILE_PATH" || return 3
    elif [ "$3" = "FILE" ]; then
        printf '' >"$FILE_PATH" || return 4
    else
        ___dev_print_screen "Wrong argument!"
        return 5
    fi

    c_file_name_invalid_detect "$TEMP_ROOT_DIRECTORY" "NO_NEED_FOR_REGEX_FOR_EXCLUSION"
    ___string_contains "$(cat "$INVALID_FILE_LIST")" "$FILE_PATH" || return 6
    ___string_contains "$(cat "$INVALID_FILE_ERROR_CODE_LIST")" "$2" || return 7
    return 0
}

c_file_name_invalid_detect_common_file_test() {

    c_file_name_invalid_detect_common_test "$1" "$2" "FILE"
}

c_file_name_invalid_detect_common_directory_test() {

    c_file_name_invalid_detect_common_test "$1" "$2" "DIRECTORY"
}

___unit_test___c_file_name_invalid_detect() {

    # tested on gnu grep 3.4.

    for RESERVED_NAME_LETTER in "CON" "LPT1"; do
        c_file_name_invalid_detect_common_file_test "$RESERVED_NAME_LETTER.1234" "MS_WINDOWS_RULE___CAN_NOT_START_WITH_$RESERVED_NAME_LETTER""_AND_DOT" || return 1$?

        c_file_name_invalid_detect_common_file_test "$RESERVED_NAME_LETTER. " "MS_WINDOWS_RULE___CAN_NOT_START_WITH_$RESERVED_NAME_LETTER""_AND_DOT" || return 2$?

        c_file_name_invalid_detect_common_file_test "$RESERVED_NAME_LETTER" "MS_WINDOWS_RULE___ONLY_$RESERVED_NAME_LETTER""_IS_RESERVED" || return 3$?
    done

    c_file_name_invalid_detect_common_file_test "PRN." "MS_WINDOWS_RULE___ONLY_PRN_AND_DOT_IS_RESERVED" || return 4$?

    # We can not use a local variable here. It works on zsh. But on "bash" the for-loop creates sub-shell and the parameter lose it's value. 
    local LONG_FILE_NAME="$(mktemp)" || return 18
    for ((i = 1; i <= 253; i++)); do
        printf '%s' 'l' >> "$LONG_FILE_NAME"
    done
    c_file_name_invalid_detect_common_file_test "$(cat $LONG_FILE_NAME)" "MS_WINDOWS_RULE___MAX_252_CHAR_LIMIT" || return 5$?

    c_file_name_invalid_detect_common_file_test "0" "MS_WINDOWS_RULE___0_IS_RESERVED" || return 6$?

    c_file_name_invalid_detect_common_directory_test "dir1 " "MS_WINDOWS_RULE___CAN_NOT_END_WITH_SPACE" || return 7$?

    c_file_name_invalid_detect_common_directory_test "dir1." "MS_WINDOWS_RULE___CAN_NOT_END_WITH_DOT" || return 8$?

    for RESERVED_CHAR in '*' '?' ':' '"' '<' '>' '|' '\'; do
        c_file_name_invalid_detect_common_file_test "hello$RESERVED_CHAR""world" "MS_WINDOWS_RULE___RESERVED_CHARACTER_$RESERVED_CHAR" || return 9$?
    done

    c_file_name_invalid_detect_common_directory_test "hello world" "SUGGESTION___INCLUDES_SPACE" || return 10$?
    c_file_name_invalid_detect_common_directory_test " " "SUGGESTION___INCLUDES_SPACE" || return 11$?

    local -r CONTROL_CHARACTER="$(printf "\x02")"
    c_file_name_invalid_detect_common_directory_test "A$CONTROL_CHARACTER" "SUGGESTION___INCLUDES_CONTROL_CHARACTER" || return 12$?
    c_file_name_invalid_detect_common_directory_test "$CONTROL_CHARACTER" "SUGGESTION___INCLUDES_CONTROL_CHARACTER" || return 13$?

    c_file_name_invalid_detect_common_directory_test " ' " "SUGGESTION___'_CHARACTER_IS_NOT_RECOMMENDED" || return 14$?
    c_file_name_invalid_detect_common_directory_test "'" "SUGGESTION___'_CHARACTER_IS_NOT_RECOMMENDED" || return 15$?
    c_file_name_invalid_detect_common_directory_test "a'" "SUGGESTION___'_CHARACTER_IS_NOT_RECOMMENDED" || return 16$?
    c_file_name_invalid_detect_common_directory_test "''" "SUGGESTION___'_CHARACTER_IS_NOT_RECOMMENDED" || return 17$?

    return 0
}

___unit_test___c_file_name_invalid_detect || printError "___unit_test___c_file_name_invalid_detect" "$?"
