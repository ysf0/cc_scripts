PROJECT_ROOT_DIR_FULL_PATH="$(dirname "$0")/.."

source "$PROJECT_ROOT_DIR_FULL_PATH/src/core_shell_utils/cc_exit_code.sh" || exit 13
source "$PROJECT_ROOT_DIR_FULL_PATH/dev_scripts/dev_utils.sh" || exit 11
source "$PROJECT_ROOT_DIR_FULL_PATH/test/test_util.sh" || exit 12
source "$PROJECT_ROOT_DIR_FULL_PATH/src/core_shell_utils/cc_is_empty_string.sh" || exit 13
source "$PROJECT_ROOT_DIR_FULL_PATH/src/core_shell_utils/cc_command_checker.sh" || exit 14
source "$PROJECT_ROOT_DIR_FULL_PATH/src/core_shell_utils/cc_print_utils.sh" || exit 15

___unit_test___do_executables_exist() {
    ___do_executables_exist "printf" || return 1
    ___do_executables_exist "sh" || return 2
    ___do_executables_exist "this_not_exist" && return 3
    ___do_executables_exist "___unit_test___do_executables_exist" || return 4
    ___do_executables_exist "" && return 5
    ___do_executables_exist "sh" "printf" || return 6
    ___do_executables_exist "sh" "this_not_exist" && return 7
    ___do_executables_exist "this_not_exist" "sh" && return 8
    return 0
}

___unit_test___do_executables_exist || printError "___unit_test___do_executables_exist" "$?"
