COLOR_YELLOW="$TPUT_BOLD$TPUT_WHITE$(tput setab 3)" || exit 1
CC_COLOR_RESET="$(tput sgr 0)" || exit 2

___dev_print_screen() {
    printf "%s\n" "$COLOR_YELLOW$*$CC_COLOR_RESET"
}
