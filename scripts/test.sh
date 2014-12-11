#!/usr/bin/env sh 
set -e

usage="
Usage: 
    test [ -d | --dry ]

Options:
    -d, --dry       Dont execute commands.

Description:
    Launch gitbook2edx tests
"


# Absolute path:
# 
# Usage: abs=`get_abs_path ./deploy/static`
#		 echo $abs
# 
function get_abs_path {
   dir=$(cd `dirname $1` >/dev/null; pwd )
   echo $dir
}
#

# Get basename:
function get_base_name {
	n=$1
	n=$(basename "$n")
	echo "${n%.*}"
}


#if [ $? -eq 0 ]
#then
#    echo "it worked"
#else
#    echo "it failed"
#fi

# Source directory
#
srcdir=`dirname $0`
srcdir=`cd $srcdir; pwd`

#
# Temp directory:
#
# dstdir=`mktemp -d -t bashtmp`
#
# or current:
#
dstdir=`pwd`

function directory_does_exist {
	if [ ! -d "$1" ]; then
		echo 'true'
	else
		echo 'false'
	fi
}

bold=$(tput bold)
reset=$(tput sgr0)
function print_important_message {
	printf "${bold}$1${reset}. "
}

function ask_for_key {
	printf "Press [enter] to continue"
	read -s # suppress user input
	echo 
}


# dryrun
dry_run=false
run() {
  if [[ $dry_run == false ]] ; then
    eval "$1"
  fi
}


while (($# > 0)) ; do
  option="$1"
  shift

  case "$option" in
    -h|--help)
      echo "$usage"
      exit
      ;;
    -d|--dry-run)      dry_run=true        ;;
    *)
      echo "Unrecognized option $option" >&2
      exit 1
  esac
done

run "rm -rf $dstdir/_course"
run "$srcdir/../bin/gitbook2edx gen $srcdir/../test/javascript-master"
run "diff-files $srcdir/../test/test-ref/course.xml $dstdir/_course/course.xml                                      -m 'Testing course.xml   '"
run "diff-files $srcdir/../test/test-ref/about/overview.html $dstdir/_course/about/overview.html                    -m 'Testing overview.html'"
run "diff-files $srcdir/../test/test-ref/about/short_description.html $dstdir/_course/about/short_description.html  -m 'Testing short descr. '"
