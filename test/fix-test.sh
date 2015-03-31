#!/usr/bin/env bash
set -e

usage="
Usage:
    fix-test [ -d | --dry ]

Options:
    -d, --dry       Dont execute commands.

Description:
    Launch gitbook2edx tests
"


srcdir=`dirname $0`
srcdir=`cd $srcdir; pwd`
dstdir=`pwd`

# dryrun
dry_run=false
run() {
  if [[ $dry_run == false ]] ; then
    eval "$1"
  else
    echo "$1"
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

gbtdir="$srcdir/test-data.tmp"
run "rm -rf $srcdir/test-ref"
run "mv $gbtdir $srcdir/test-ref"
