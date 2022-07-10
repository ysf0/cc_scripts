PROJECT_ROOT_DIR_FULL_PATH="$(dirname "$0")/.."

source "$PROJECT_ROOT_DIR_FULL_PATH/src/core_shell_utils/cc_exit_code.sh" || exit 13
source "$PROJECT_ROOT_DIR_FULL_PATH/dev_scripts/dev_utils.sh" || exit 11
source "$PROJECT_ROOT_DIR_FULL_PATH/test/test_util.sh" || exit 12
source "$PROJECT_ROOT_DIR_FULL_PATH/src/core_shell_utils/cc_exception_handler.sh" || exit 14

___unit_test___errorHandler() {
    command_not_exist || {
        ___errorHandler "$?" 12345
        test "$?" -eq "$CC_EXIT_CODE__APP_LOGIC_EXCEPTION" || return 1
    }

    return 0
}

___unit_test___errorHandler || printError "___unit_test___errorHandler" "$?"
