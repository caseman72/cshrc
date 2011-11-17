#!/bin/bash
#

# usuage
if [[ -z $1 || -z $2 ]]; then
	echo "$0 <src file> <dest file>";
	exit 1;
fi

# file not found
if [[ ! -f $1 && ! -d $1 ]]; then
	echo "$1 not found";
	exit 1;
fi

# set these here
_src=$1;
_dest=$2;
_dir="$HOME/bin"


# more later
if [ $OSTYPE == cygwin ]; then
	_src=`cygpath -w $1`;
	_dest=`cygpath -w $2`;
	java -jar `cygpath -w $_dir/compiler.jar` --compilation_level SIMPLE_OPTIMIZATIONS --formatting PRETTY_PRINT --js "$_src" --js_output_file "$_dest"

else
	java -jar $_dir/compiler.jar --compilation_level SIMPLE_OPTIMIZATIONS --formatting PRETTY_PRINT --js "$_src" --js_output_file "$_dest"
fi

