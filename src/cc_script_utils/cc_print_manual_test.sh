# This is not a unit test. This can be called from runtime.
___print_color_test() {

   requestScriptPath || return

   local -r TEST_COMMANDS=". \"$CC_SCRIPTS_FILE_PATH\"; ___print_color_test_current_shell"

   ___stdout_and_new_line "-- running on zsh"
   zsh -c "$TEST_COMMANDS" || {
      ___errorHandler "$?" 100032
      return
   }

   ___stdout_and_new_line "-- running on bash"
   bash -c "$TEST_COMMANDS" || {
      ___errorHandler "$?" 100033
      return
   }
}

# This should not call directly. This should be called by ___print_color_test.
___print_color_test_current_shell() {

   ___stdout_and_new_line "** colors below should be on their names:"

   CC_OUTPUT_COLOR=true
   ___print_screen "blue"
   ___print_title "red"
   ___stdout_and_new_line "default"

   CC_OUTPUT_COLOR=false
   ___print_screen "default"
   ___print_title "default"
   ___stdout_and_new_line "default"
   ___stdout_and_new_line
}
