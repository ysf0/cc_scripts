# CONTRIBUTOR

# RULES

- Shell language standards: https://github.com/koalaman/shellcheck
- Syntax auto-formatter: https://github.com/mvdan/sh (open source vscode extension: "foxundermoon.shell-format")

# STANDARDS

All functions must follow all standards which are written on
the [demo_function.sh](https://github.com/ysf0/cc_scripts/tree/master/documentation/demo_function.sh).

# TEST

- ## Unit test
  Unit tests should be written on [test](https://github.com/ysf0/cc_scripts/tree/master/test) directory.

- ## Test inside Docker
  Run [start_container_and_attach_on.sh](https://github.com/ysf0/cc_scripts/tree/master/dev_scripts/start_container_and_attach_on.sh)
  . It will create and run the Docker container and attach automatically to container's shell.

  It will also print how to install the cc_script file. You just copy-paste the installations command and start using
  cc_scripts inside Docker container.