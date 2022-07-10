c_system_details_using_only_neofetch() {

   # --backend off --> do not print OS logo
   # --refresh_rate --> print refresh rate of screen
   # --travis --> prints more detail
   # --no_config --> Do not create a config file inside $HOME/config/neofetch directory
   ___execute_with_eval "$CC_STANDALONE_APPS_PATH_ROOT/neofetch \
           --cpu_temp C \
           --travis \
           --no_config \
           --backend off \
           --kernel_shorthand off \
           --title_fqdn on \
           --distro_shorthand off \
           --os_arch on \
           --uptime_shorthand off \
           --memory_percent on \
           --package_managers on \
           --shell_path on \
           --shell_version on \
           --cpu_brand on \
           --cpu_speed on \
           --gpu_brand on \
           --gpu_type all \
           --refresh_rate on \
           --gtk_shorthand off \
           --gtk2 on \
           --gtk3 on \
           --ip_timeout 8 \
           --de_version on"
}

c_notify_user() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r TIME_TO_BEEP="$1"
   local -r MESSAGE="$2"
   ##############################
   ##############################
   ##############################

   ___print_screen "$MESSAGE"

   # MacOS GUI notification
   ___do_executables_exist_without_output "osascript" && { osascript -e "display notification \""$MESSAGE"\" with title "cc_scripts" "; }

   # Linux GUI notification
   ___do_executables_exist_without_output "notify-send" && { notify-send "$MESSAGE" --app-name "cc_scripts"; }

   local -r MS_WINDOWS_NOTIFY_COMMANDS='
   [reflection.assembly]::loadwithpartialname("System.Windows.Forms")
   [reflection.assembly]::loadwithpartialname("System.Drawing")
   $notify = new-object system.windows.forms.notifyicon
   $notify.icon = [System.Drawing.SystemIcons]::Information
   $notify.visible = $true
   $notify.showballoontip(20,"cc_scripts","'$MESSAGE'",[system.windows.forms.tooltipicon]::None)
   '

   ___do_executables_exist_without_output "powershell" && { powershell -c "$MS_WINDOWS_NOTIFY_COMMANDS"; }

   # always return success. This a simple notification function. It should not block the parent script.
   ___do_executables_exist_without_output "speaker-test" "timeout" || return 0

   ___is_empty_string "$TIME_TO_BEEP" && TIME_TO_BEEP="3"

   timeout --kill-after="$TIME_TO_BEEP" 1 speaker-test --frequency 1000 --test sine >"/dev/null"

   # always return success. This a simple notification function. It should not block the parent script.
   return 0
}

c_calculator() {

   ___print_title "Type directly and press 'enter'. Examples:"
   ___print_screen "(1^2)*3"
   ___print_screen "sqrt(9)    ---> Square root"
   ___print_screen
   ___print_title "Scale is 20 now. To change it type:"
   ___print_screen "scale=5;    ---> that means only 5 digits will print after comma."
   ___print_screen

   # -q --> do not print welcome text
   # -l --> set scale as 20
   bc -q -l
}
