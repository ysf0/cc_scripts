___is_empty_string() {

   # -z -> checks if it is empty
   if [ -z "$@" ]; then
      return 0
   fi

   # NULL is a custom string which is using in this project. it's not a standard.
   if [ "$@" = "NULL" ]; then
      return 0
   fi

   return 1
}
