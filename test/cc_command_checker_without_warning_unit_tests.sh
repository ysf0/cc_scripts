PROJECT_ROOT_DIR_FULL_PATH="$(dirname "$0")/.."

source "$PROJECT_ROOT_DIR_FULL_PATH/src/core_shell_utils/cc_exit_code.sh" || exit 13
source "$PROJECT_ROOT_DIR_FULL_PATH/dev_scripts/dev_utils.sh" || exit 11
source "$PROJECT_ROOT_DIR_FULL_PATH/test/test_util.sh" || exit 12
source "$PROJECT_ROOT_DIR_FULL_PATH/src/core_shell_utils/cc_is_empty_string.sh" || exit 15
source "$PROJECT_ROOT_DIR_FULL_PATH/src/core_shell_utils/cc_command_checker_without_warning.sh" || exit 16

___unit_test___do_executables_exist_without_output() {
    ___do_executables_exist_without_output "printf" || return 1
    ___do_executables_exist_without_output "sh" || return 2
    ___do_executables_exist_without_output "this_not_exist" && return 3
    ___do_executables_exist_without_output "___unit_test___do_executables_exist_without_output" || return 4
    ___do_executables_exist_without_output "" && return 5
    ___do_executables_exist_without_output "sh" "printf" || return 6
    ___do_executables_exist_without_output "sh" "this_not_exist" && return 7
    ___do_executables_exist_without_output "this_not_exist" "sh" && return 8
    return 0
}

___unit_test___do_executables_exist_without_output || printError "___unit_test___do_executables_exist_without_output" "$?"
