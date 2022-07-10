___get_maven_command() {

   local -r MAVEN_WRAPPER="./mvnw"

   if ___do_executables_exist_without_output "$MAVEN_WRAPPER"; then
      ___stdout "$MAVEN_WRAPPER"
   else
      ___stdout "mvn"
   fi
}

c_maven_clean_install() {
   local -r MAVEN_EXECUTABLE="$(___get_maven_command)"

   local -r CURRENT_DIR_PATH="$(pwd)"
   local -r CURRENT_DIR_NAME="$(basename $CURRENT_DIR_PATH)"

   ___execute "$MAVEN_EXECUTABLE" clean install $@

   local -r LAST_COMMAND_EXIT_CODE="$?"
   c_notify_user "0.1" "maven finish for $CURRENT_DIR_NAME"
   return "$LAST_COMMAND_EXIT_CODE"
}

c_maven_clean_install_update_snapshots() {
   local -r MAVEN_EXECUTABLE="$(___get_maven_command)"

   local -r CURRENT_DIR_PATH="$(pwd)"
   local -r CURRENT_DIR_NAME="$(basename $CURRENT_DIR_PATH)"

   ___execute "$MAVEN_EXECUTABLE" clean install -U $@

   local -r LAST_COMMAND_EXIT_CODE="$?"
   c_notify_user '0.1' "maven finish for $CURRENT_DIR_NAME"
   return "$LAST_COMMAND_EXIT_CODE"
}

c_maven_clean_install_skip_tests() {
   local -r MAVEN_EXECUTABLE="$(___get_maven_command)"

   local -r CURRENT_DIR_PATH="$(pwd)"
   local -r CURRENT_DIR_NAME="$(basename $CURRENT_DIR_PATH)"

   ___execute "$MAVEN_EXECUTABLE" clean install -DskipTests $@

   local -r LAST_COMMAND_EXIT_CODE="$?"
   c_notify_user '0.1' "maven finish for $CURRENT_DIR_NAME"
   return "$LAST_COMMAND_EXIT_CODE"
}
