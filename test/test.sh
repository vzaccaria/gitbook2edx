#!/usr/bin/env bash
set -e

usage="
Usage:
    test [ -d | --dry ] [ -n | --noclean ]

Options:
    -d, --dry       Dont execute commands.
    -n, --noclean   Dont clean up temporary dir

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

function directory_does_exist {
	if [ ! -d "$1" ]; then
		echo 'true'
	else
		echo 'false'
	fi
}

bold=""
reset=""
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
  else
    echo "$1"
  fi
}

clean=true


while (($# > 0)) ; do
  option="$1"
  shift

  case "$option" in
    -h|--help)
      echo "$usage"
      exit
      ;;
    -d|--dry-run)      dry_run=true        ;;
    -n|--noclean)      clean=false         ;;
    *)
      echo "Unrecognized option $option" >&2
      exit 1
  esac
done

gbtdir="$srcdir/tmp-gitbook-test"
ref="$srcdir/../test/test-ref"

run "rm -rf $gbtdir"
run "mkdir $gbtdir"
run "cp -R $srcdir/../test/javascript-master $gbtdir/source"
run "cd $gbtdir && $srcdir/../bin/gitbook2edx gen source"
run "< $gbtdir/_course/course.xml sed -f $srcdir/filter.sed > $gbtdir/_course/course-clean.xml "

run "diff-files $ref/course-clean.xml                 $gbtdir/_course/course-clean.xml                  -m 'Testing course.xml   '"
run "diff-files $ref/about/overview.html              $gbtdir/_course/about/overview.html               -m 'Testing overview.html'"
run "diff-files $ref/about/short_description.html     $gbtdir/_course/about/short_description.html      -m 'Testing short descr. '"
run "diff-files $ref/2014-spring/grading_policy.json  $gbtdir/_course/2014-spring/grading_policy.json   -m 'Testing grading policy descr. '"

echo "gvimdiff $ref/about/short_description.html $gbtdir/_course/about/short_description.html"
echo "gvimdiff $gbtdir/_course/course-clean.xml $ref/course-clean.xml"
run "diff $gbtdir/_course/course-clean.xml $ref/course-clean.xml"
if [[ $clean == true ]]; then
    run "rm -rf $gbtdir"
fi
