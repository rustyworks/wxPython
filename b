#!/bin/bash
# ---------------------------------------------------------------------------
# New and improved build script for wrapping build-wxpython.py and
# only needing to use super-simple one or two letter command line args.
# ---------------------------------------------------------------------------

set -o errexit
#set -o xtrace

if [ "$PYTHON" = "" ]; then
    case $1 in 
	23 | 2.3) VER=23; PYVER=2.3; shift ;;
	24 | 2.4) VER=24; PYVER=2.4; shift ;;
	25 | 2.5) VER=25; PYVER=2.5; shift ;;
	26 | 2.6) VER=26; PYVER=2.6; shift ;;
	30 | 3.0) VER=30; PYVER=3.0; shift ;;
	
	*) VER=25; PYVER=2.5
    esac
	
    if [ "$OSTYPE" = "cygwin" ]; then
	PYTHON=$TOOLS/python$VER/python.exe
    else
	PYTHON=python$PYVER
    fi
fi
echo "Using Python:"
$PYTHON -c "import sys;print sys.version, '\n'"


if [ "$SWIG" = "" ]; then
    if [ "$OSTYPE" = "cygwin" ]; then
	SWIG=$PROJECTS\\SWIG-1.3.29\\swig.exe
    else
	SWIG=/opt/swig/bin/swig-1.3.29
    fi
fi
export SWIG


ARGS="--reswig --unicode --build_dir=../bld"
DEBUG="--debug"
BOTH="no"

case $1 in 
      c) ARGS="$ARGS --clean";             shift ;;
     cw) ARGS="$ARGS --clean=wx";          shift ;;
     cp) ARGS="$ARGS --clean=py";          shift ;;
     ce) ARGS="$ARGS --clean=pyext";       shift ;;

     cb) BOTH="yes"; ARGS="$ARGS --clean";        shift ;;
    cbw) BOTH="yes"; ARGS="$ARGS --clean=wx";     shift ;;
    cbp) BOTH="yes"; ARGS="$ARGS --clean=py";     shift ;;
    cbe) BOTH="yes"; ARGS="$ARGS --clean=pyext";  shift ;;

      d) DEBUG="--debug";            shift ;;
      h) DEBUG="";                   shift ;;
      b) BOTH="yes";                 shift ;;

      t) find . -name "*.i" | xargs -t touch; echo "*.i files touched"; exit 0 ;;
esac


if [ "$OSTYPE" = "cygwin" -a "$BOTH" = "yes" ]; then
    set -o xtrace
    $PYTHON -u ./build-wxpython.py $ARGS --debug $@
    $PYTHON -u ./build-wxpython.py $ARGS $@
else
    set -o xtrace
    $PYTHON -u ./build-wxpython.py $ARGS $DEBUG $@
fi
