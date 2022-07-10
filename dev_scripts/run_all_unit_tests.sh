#!/bin/bash

readonly PROJECT_ROOT_DIR_FULL_PATH="$(dirname "$0")/.."
source "$PROJECT_ROOT_DIR_FULL_PATH/dev_scripts/dev_utils.sh" || exit 1
"$PROJECT_ROOT_DIR_FULL_PATH/dev_scripts/build_release.sh" || exit 2

# Unit test files should not have hashbang on their first line. Because they should run both on zsh and bash.
# To run the same script file on multiple shell interpreters, you should source them.

readonly TEST_COMMANDS="
cd '$PROJECT_ROOT_DIR_FULL_PATH/test'
source '$PROJECT_ROOT_DIR_FULL_PATH/test/cc_command_checker_unit_tests.sh'
source '$PROJECT_ROOT_DIR_FULL_PATH/test/cc_command_checker_without_warning_unit_tests.sh'
source '$PROJECT_ROOT_DIR_FULL_PATH/test/cc_command_executor_unit_tests.sh'
source '$PROJECT_ROOT_DIR_FULL_PATH/test/cc_core_utils_unit_tests.sh'
source '$PROJECT_ROOT_DIR_FULL_PATH/test/cc_excepiton_handler_unit_tests.sh'
source '$PROJECT_ROOT_DIR_FULL_PATH/test/cc_is_empty_string_unit_tests.sh'
source '$PROJECT_ROOT_DIR_FULL_PATH/test/cc_file_system_unit_tests.sh'
"

___dev_print_screen "Running all tests on zsh"
zsh -c 'printf "%s\n" "ZSH VERSION: $ZSH_VERSION"' || exit 1
zsh -c "$TEST_COMMANDS" || exit 2

___dev_print_screen "Running all tests on bash"
bash -c 'printf "%s\n" "BASH VERSION: $BASH_VERSION"' || exit 3
bash -c "$TEST_COMMANDS" || exit 4
