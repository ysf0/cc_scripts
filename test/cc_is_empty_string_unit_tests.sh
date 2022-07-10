PROJECT_ROOT_DIR_FULL_PATH="$(dirname "$0")/.."

source "$PROJECT_ROOT_DIR_FULL_PATH/src/core_shell_utils/cc_exit_code.sh" || exit 13
source "$PROJECT_ROOT_DIR_FULL_PATH/dev_scripts/dev_utils.sh" || exit 13
source "$PROJECT_ROOT_DIR_FULL_PATH/test/test_util.sh" || exit 14
source "$PROJECT_ROOT_DIR_FULL_PATH/src/core_shell_utils/cc_is_empty_string.sh" || exit 15

___unit_test___is_empty_string() {
   ___is_empty_string "" || return 1
   ___is_empty_string " " && return 2
   ___is_empty_string " a" && return 3
   ___is_empty_string "NULL" || return 4
   return 0
}

___unit_test___is_empty_string || printError "___unit_test_empty_string" "$?"
