#! /bin/bash

set -e

VERBOSE=n
if [[ "x$1" == "x-v" ]]; then
    VERBOSE=y
fi

TOPDIR=$(cd $(dirname $0)/.. && pwd)
[[ -n "$top_builddir" ]] || top_builddir=$TOPDIR
[[ -n "$top_srcdir" ]] || top_srcdir=$TOPDIR


AUGPARSE=${top_builddir}/src/augparse
LENS_DIR=${top_srcdir}/lenses
TESTS=$LENS_DIR/tests/test_*.aug

LOG=$(mktemp)
trap "rm $LOG" EXIT

for t in $TESTS
do
  printf "%-30s ... " $(basename $t .aug)
  ${AUGPARSE} -I $LENS_DIR $t > $LOG 2>&1
  ret=$?
  if [[ ! $ret -eq 0 ]]; then
    echo FAIL
    result=1
  elif [[ $ret -eq 0 ]]; then
    echo PASS
  fi
  if [[ "$VERBOSE" == "y" ]] ; then
     cat $LOG
  fi
done
