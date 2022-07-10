c_iso_to_usb___unetbootin() {

   c_path_add "$CC_STANDALONE_APPS_PATH_ROOT/7z"

   local -r ENABLE_FIREJAIL="TRUE"
   local -r HOME_DIR_NAME="unetbootin"
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" unetbootin)"
   local -r ENABLE_ROOT="TRUE"
   local -r APP_PARAMS=""

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_android_remote_desktop() {

   ___print_screen 'The device should be: '
   ___print_screen '- connected via usb'
   ___print_screen '- usb debug mode should be enabled'
   ___print_screen '- file transfer should be enabled'

   ___do_executables_exist "adb" || return

   ___execute adb devices

   local -r ENABLE_FIREJAIL="FALSE"
   local -r HOME_DIR_NAME="scrcpy"
   local -r LINUX_EXECUTABLE_FULL_PATH="scrcpy"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS=""

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_android_studio() {

   local -r ENABLE_FIREJAIL="FALSE"
   local -r HOME_DIR_NAME=""
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" android-studio)/bin/studio.sh"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS=""

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_intellij_idea_community() {

   local -r ENABLE_FIREJAIL="FALSE"
   local -r HOME_DIR_NAME=""
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" idea-IC)/bin/idea.sh"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS="$@"

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_insomnia() {

   local -r ENABLE_FIREJAIL="FALSE"
   local -r HOME_DIR_NAME="INSOMNIA"
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" Insomnia)"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS=""

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_eclipse_ide() {

   local -r ENABLE_FIREJAIL="FALSE"
   local -r HOME_DIR_NAME=""
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" eclipse)/eclipse"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS="$@"

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_vscodium() {

   local -r ENABLE_FIREJAIL="FALSE"
   local -r HOME_DIR_NAME=""
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" VSCodium)"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS="$@"

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_dbeaver() {
   export _JAVA_OPTIONS="-Duser.home=$CC_APPS_HOME/DBEAVER"

   local -r ENABLE_FIREJAIL="FALSE"
   local -r HOME_DIR_NAME="DBEAVER"
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" dbeaver)/dbeaver"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS=""

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_soapui() {
   export _JAVA_OPTIONS="-Duser.home=$CC_APPS_HOME/SOAPUI"

   local -r ENABLE_FIREJAIL="FALSE"
   local -r HOME_DIR_NAME="SOAPUI"
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" SoapUI)/bin/soapui.sh"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS=""

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_peazip() {
   local -r ENABLE_FIREJAIL="TRUE"
   local -r HOME_DIR_NAME="peazip"
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" peazip)/peazip"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS="$HOME" # Peazip opens here as default. othwerwise we need to route manually to $HOME (which is using in most cases).

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_photo_editor___gimp() {

   local -r ENABLE_FIREJAIL="TRUE"
   local -r HOME_DIR_NAME="GIMP"
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" GIMP)"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS=""

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_password_manager_KeePassXC() {

   local -r ENABLE_FIREJAIL="TRUE"
   local -r HOME_DIR_NAME="KeePassXC"
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" KeePassXC)"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS=""

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_google_chrome() {

   local -r ENABLE_FIREJAIL="FALFE"
   local -r HOME_DIR_NAME="google-chrome"
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" google-chrome)/opt/google/chrome/google-chrome"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS=""

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

c_tor_browser() {

   local -r ENABLE_FIREJAIL="FALSE"
   local -r HOME_DIR_NAME="tor-browser"
   local -r LINUX_EXECUTABLE_FULL_PATH="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" tor-browser)/Browser/start-tor-browser"
   local -r ENABLE_ROOT="FALSE"
   local -r APP_PARAMS=""

   ___start_gui_app "$ENABLE_FIREJAIL" "$HOME_DIR_NAME" "$LINUX_EXECUTABLE_FULL_PATH" "$ENABLE_ROOT" "$APP_PARAMS"
}

___start_gui_app() {

   local -r ENABLE_FIREJAIL="$1"
   local -r HOME_DIR_NAME="$2"
   local -r LINUX_EXECUTABLE_FULL_PATH="$3"
   local -r ENABLE_ROOT="$4"
   local -r APP_PARAMS="$5"

   local -r HOME_DIR_BACKUP="$HOME"
   ___create_home_and_switch_it "$HOME_DIR_NAME"

   # do not enable profiles on firejail commands. because profile rules (as default) does not allow to read from /nix/* and $HOME/app_name/* directories.

   # do not use "$APP_PARAMS" using double quote. That makes problem if APP_PARAMS is empty string.

   if [ "$ENABLE_ROOT" = "TRUE" ]; then
      if ___do_executables_exist "firejail"; then
         if [ "$ENABLE_FIREJAIL" = "TRUE" ]; then
            ___run_command_as_root firejail --net=none --noprofile "$LINUX_EXECUTABLE_FULL_PATH" $APP_PARAMS
            return
         fi
      fi
      ___run_command_as_root "$LINUX_EXECUTABLE_FULL_PATH" $APP_PARAMS
   else
      if ___do_executables_exist "firejail"; then
         if [ "$ENABLE_FIREJAIL" = "TRUE" ]; then
            ___nohup_and_disown firejail --net=none --noprofile "$LINUX_EXECUTABLE_FULL_PATH" $APP_PARAMS
            return
         fi
      fi
      ___nohup_and_disown "$LINUX_EXECUTABLE_FULL_PATH" $APP_PARAMS
   fi

   HOME="$HOME_DIR_BACKUP"
}

___create_home_and_switch_it() {

   # If the value is empty the function should not swithch HOME directory.
   # This case required for development-apps like Eclipse, other IDE, VScode...
   ___is_empty_string "$1" && return

   # -p ignores the warning: folder already exist.
   mkdir -p "$CC_APPS_HOME" || {
      ___print_screen "Error: could not create $CC_APPS_HOME (\$CC_APPS_HOME) directory. \$HOME will not change. The script will resume."
      return
   }

   # -p ignores the warning: folder already exist.
   mkdir -p "$CC_APPS_HOME/$1" || {
      ___print_screen "Error: could not create directory under $CC_APPS_HOME/$1. \$HOME will not change. The script will resume."
      return
   }

   HOME="$CC_APPS_HOME/$1"
}
