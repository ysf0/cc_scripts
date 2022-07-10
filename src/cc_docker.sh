c_docker_list_all_containers() {
   # SHOW ALL CONTAINERS = -a
   # LIST THE CONTAINERS = ps
   ___execute_and_color_line docker ps -a
}

c_docker_stop_force_all_containers() {

   # ONLY DISPLAY NUMERIC ID'S = -q
   # SHOW ALL CONTAINERS = -a
   # LIST THE CONTAINERS = ps
   # FORCE REMOVE RUNNING CONTAINER = -f
   # REMOVE CONTAINER = rm
   ___execute_with_eval 'docker stop $(docker ps -a -q)'
}

c_docker_remove_force_all_containers() {

   # ONLY DISPLAY NUMERIC ID'S = -q
   # SHOW ALL CONTAINERS = -a
   # LIST THE CONTAINERS = ps
   ___execute_with_eval 'docker stop $(docker ps -a -q)'
   ___execute_with_eval 'docker rm -f $(docker ps -a -q)'
}

c_docker_show_container_ip() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r CONTAINER_NAME_OR_ID="$1"
   ##############################
   ##############################
   ##############################

   ___required_parameters=("CONTAINER_NAME_OR_ID")
   ___check_parameters "$@" || return

   ___print_screen "note: this will not work if network bridge has a name."

   # FORMAT THE INSPECT OUTPUT GIVEN THE TEMPLATE ---> -f
   # shellcheck disable=SC1083 # shellcheck recognize shell expression. but it's not.
   ___execute_with_eval docker inspect -f \'{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}\' "$CONTAINER_NAME_OR_ID"
}
