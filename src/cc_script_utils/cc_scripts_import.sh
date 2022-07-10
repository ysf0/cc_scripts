c_ccscripts_import() {

   ##############################
   # ABOUT
   ##############################
   # adds a new line (to .bashrc and .zshrc files) which executes(imports) this(cc_scripts.sh) file
   ##############################
   ##############################
   ##############################

   requestScriptPath || return

   ___do_executables_exist "cp" "grep" || return

   local -r LINE_TO_IMPORT1="export CC_SCRIPTS_FILE_PATH='$CC_SCRIPTS_FILE_PATH'"
   local -r LINE_TO_IMPORT2='source "$CC_SCRIPTS_FILE_PATH"'

   for SHELL_RC_FILE_NAME in ".bashrc" ".zshrc"; do
      local SHELL_RC_FILE="$HOME/$SHELL_RC_FILE_NAME"

      # if we have a keyword of 'cc_scripts' anywhere on file, stop the script.
      if grep "cc_scripts" "$SHELL_RC_FILE" >"/dev/null"; then
         ___print_screen "$SHELL_RC_FILE already have something about cc_scripts. It is better to add manually. Skipping..."
      else
         # everything is OK. importing lines...
         ___stdout_using_format "\n\n%s\n%s\n\n" "$LINE_TO_IMPORT1" "$LINE_TO_IMPORT2" >>"$SHELL_RC_FILE"

         ___print_screen "added to $SHELL_RC_FILE"
      fi
   done # en of loop of '.bashrc', '.zshrc' filess
}
