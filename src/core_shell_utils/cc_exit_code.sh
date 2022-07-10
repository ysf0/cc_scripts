# Do not use reserved exit codes: 1, 2, 126, 127, 128, 165 and 255.
# More information: https://tldp.org/LDP/abs/html/exitcodes.html
export CC_EXIT_CODE__APP_LOGIC_EXCEPTION=4
export CC_EXIT_CODE__INVALID_USER_PARAMETER=5
export CC_EXIT_CODE__COMMAND_NOT_FOUND=6

# For custom (business logic) exceptions read the "errorHandler" example in "/documentation/demo_function.sh" file.
