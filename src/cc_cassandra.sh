# Default values
CC_CASSANDRA_USERNAME="cassandra"
CC_CASSANDRA_PASSWORD="cassandra"
CC_CASSANDRA_HOST="localhost"
CC_CASSANDRA_PORT="9042"

# If you have multiple cassandra instances (environments) on remote you can do below:
#
# - "source cassandra_remote_1.sh" (this file includes EXPORT CC_CASSANDRA_HOST=remote.com)
# - run any cassandra command which starts with "c_cassandra".

OUTPUT_FORMAT_HELP_TEXT="OUTPUT_FORMAT:\n
- 0 ---> open output with text editor\n
- 1 ---> each row of table will print in new line (long lines will remove/truncate)\n
- 2 ---> each row of table will print on a new block\n"

c_cassandra_execute_cql() {
   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r OUTPUT_FORMAT="$1"
   local -r CQL="$2"
   ##############################
   ##############################
   ##############################

   ___required_parameters=("$OUTPUT_FORMAT_HELP_TEXT" "CQL (with double-quote character at the end and start)")
   ___check_parameters "$@" || return

   local CQL_PREFIX=""
   local COLOR_ARG=""
   # Do not ask user the output format on this function. because user may redirect the output to any file.
   if [ "$OUTPUT_FORMAT" = "1" ]; then
      COLOR_ARG="--color"
   elif [ "$OUTPUT_FORMAT" = "2" ]; then
      CQL_PREFIX="EXPAND ON;"
      COLOR_ARG="--color"
   elif [ "$OUTPUT_FORMAT" = "0" ]; then
      COLOR_ARG="--no-color"
   else
      ___print_screen "wrong OUTPUT_FORMAT. script will exit"
      ___errorHandler "$?" 100028
      return
   fi

   local -r CASSANDRA_EXECUTABLE="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" apache-cassandra)""/bin/cqlsh"

   local -r CASSANDRA_COMMAND="\"$CASSANDRA_EXECUTABLE\" $COLOR_ARG --username $CC_CASSANDRA_USERNAME --password $CC_CASSANDRA_PASSWORD \"$CC_CASSANDRA_HOST\" $CC_CASSANDRA_PORT --execute \"$CQL_PREFIX $CQL\" "

   if [ "$OUTPUT_FORMAT" = "0" ]; then
      local -r OUTPUT_FILE="cassandra_latest_output.json"
      local -r CURRENT_DATE_TIME="$(date '+%Y-%m-%d   %H:%M:%S   %z')"
      ___stdout_and_new_line "Execution date-time: $CURRENT_DATE_TIME" >"$OUTPUT_FILE"
      ___stdout_and_new_line "executed command: $CASSANDRA_COMMAND" >>"$OUTPUT_FILE"
      ___execute_with_eval "$CASSANDRA_COMMAND >> $OUTPUT_FILE"
      "$CC_TEXT_EDITOR_FOR_NON_ROOT_FILES" "$OUTPUT_FILE"

   elif [ "$OUTPUT_FORMAT" = "1" ]; then
      ___execute_with_eval_removed_long_lines "$CASSANDRA_COMMAND"
   else
      ___execute_with_eval "$CASSANDRA_COMMAND"
   fi
}

c_cassandra_list_all_tables_and_keyspaces() {
   c_cassandra_execute_cql "2" "describe tables;"
}

c_cassandra_table_print_data() {
   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r OUTPUT_FORMAT="$1"
   local -r NAMESPACE="$2"
   local -r TABLE_NAME="$3"
   ##############################
   ##############################
   ##############################

   ___required_parameters=("$OUTPUT_FORMAT_HELP_TEXT" "NAMESPACE" "TABLE_NAME")
   ___check_parameters "$@" || return

   c_cassandra_execute_cql "$OUTPUT_FORMAT" "USE $NAMESPACE; SELECT * FROM $TABLE_NAME;"
}
