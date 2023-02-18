#!/bin/bash

# export WITHGDB=NO to avoid using GDB where it is a hinderance.
export WITHGDB=NO
binDir="$(pwd)/build/naev-0.10.4-lin64-$(lsb_release -r -s)"
NAEVdatDir="$(pwd)/SoC-dev-dat/refs/NAEV-vanilla-dat-0.10.4"

wrapper() {
   if [[ ! "$WITHGDB" =~ "NO" ]] && type "gdb" > /dev/null 2>&1; then
      export ASAN_OPTIONS=abort_on_error=1
      DRI_PRIME=1 exec gdb -x "$binDir/.gdbinit" --args "$@"
   else
      DRI_PRIME=1 exec "$@"
   fi
}

if [ ! -d "$binDir" ]; then
  echo "ERROR : $binDir does not exist."
  echo "Please compile NAEV for your system by running the following commands :"
  echo "  cd <Your NAEV repo copy>"
  echo "  meson setup $binDir ."
  echo "  cd $binDir"
  echo "  meson compile"
  exit
fi

if [ ! -d "$NAEVdatDir" ]; then
  echo "ERROR : $NAEVdatDir does not exist."
  echo "Please check the NAEV vanilla data folder exists."
  exit
fi

# Run NAEV within a dedicated folder
# Writing from editors is done on hard-coded "../dat" from this path
cd run/NAEV
wrapper "$binDir/naev" -devmode -d $NAEVdatDir
