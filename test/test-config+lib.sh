#
#   test-config+lib.sh - This file is part of cpd - The Copy Daemon
#
#   Copyright (C) 2017 loh.tar@googlemail.com
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#   MA 02110-1301, USA.

# Some config settings
cpdDir="/tmp/cpd"
testDataDir="/tmp/cpd-testdata"

if [[ "$1" == "only-config" ]] ; then
#   shift
  return
fi

# Some always the same actions
fileType="$(basename "$0")"
fileType="${fileType:4}"
fileType="${fileType,[A-Z]}"

fileDir="$testDataDir/$fileType"

if [[ "$1" == "force" ]] ; then
  echo "Forced to recreate files. Remove old stuff"
  rm -rf "$fileDir"
fi

if [[ "$1" == "tidy" ]] ; then
  echo "Tidy up $fileType, remove everything"
  rm -rf "$fileDir"
  rm -f "./$fileType"
  exit 0
fi

if [[ -d "$fileDir" ]] ; then
  echo "$fileType are available"
  exit
fi

echo "Create tmp source dir: $fileDir"
mkdir -p "$fileDir"

# Thanks terdon, https://unix.stackexchange.com/a/157455
free=$(df -Pk "$fileDir" |tail -n1 |tr -s ' ' $'\t' | cut -f4)
left=$(bc <<< "$free - 1 * $needSpace"); left="${left%.[0-9]*}"
if (( left < 0 )) ; then
  echo "Not enough free space, missing: ${left}k"
  rmdir "$fileDir"
  exit 1
fi

# Some helpful functions
finishCreation() {
  rm -f "./$fileType"
  echo "Link new created test files to: $(realpath ./$fileType)"
  ln -sf "$fileDir/" "./$fileType"
}
