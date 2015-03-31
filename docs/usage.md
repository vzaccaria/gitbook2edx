Usage:
    gitbook2edx gen DIR [ -c CONFIG ]
    gitbook2edx json DIR [ -c CONFIG ]
    gitbook2edx info DIR [ -c CONFIG ]
    gitbook2edx -h | --help

Options:
    -h, --help              Just this help
    -c, --config CONFIG     Filename of the YAML configuration of the course

Arguments:
    DIR                     Root directory of the Gitbook to be converted

Commands:
    gen                     Generate the `course.tar.gz` file for the gitbook in DIR.
