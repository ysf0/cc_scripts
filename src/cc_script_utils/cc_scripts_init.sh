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
