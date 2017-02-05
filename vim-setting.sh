OS=$1

#.0 CHECK DEPENDENCIES

#.1 INSTALL VIM

INSTALL_COMMAND=""
if [ -z $OS ]
then
	echo "err: Need argument"
	exit
elif [ $OS = "Linux" ]
then
	INSTALL_COMMAND="sudo apt-get install vim -y"
elif [ $OS = "Darwin" ]
then
	echo "No need to install vim on mac"
else
	echo "err: Unknown OS"
	exit
fi

$INSTALL_COMMAND


#.2 CHECK USERS
# TODO : add detail option

USERS=("${@:2}")

if [ -z "$USERS" ]
then
	USERS=("$USER")
else
	if [ $OS = "Darwin" ]
	then
		echo "err: Does not support remote settings on Mac"
		exit
	fi
fi

F_USER="$USERS"


#.3 FIND DIRECTORY about F_USER

HOME_PATH=""
VIM_PATH=""
VIMRC_PATH=""

if [ $OS = "Darwin" ]
then
	HOME_PATH=$HOME
else 
	# GETTING PATH FROM /etc/passwd

	IFS=$'\n'
	set -f
	PATHS="$(sudo cat /etc/passwd | grep "$F_USER:")"
	for PATH in $PATHS; do
		IFS=$':'
		TEMP=($PATH)
		if [ $F_USER = ${TEMP[0]} ]
		then
			HOME_PATH=${TEMP[5]}
		fi
	done
fi

echo $HOME_PATH


exit


VIM_PATH=$HOME_PATH"/.vim"
VIMRC_PATH=$HOME_PATH"/.vimrc"

#.4 SET VIMRC

rm $VIMRC_PATH
touch $VIMRC_PATH

TAB_WIDTH="2"
GLOBAL_PROPERTY=("syntax on" "set number")
BASIC_PROPERTY=("set cindent expandtab sw=2 sts=2")
BASIC_PROPERTIES=("au BufNewFile,BufReadPost *.c $BASIC_PROPERTY" "au BufNewFile,BufReadPost *.cpp $BASIC_PROPERTY" "au BufNewFile,BufReadPost *.h $BASIC_PROPERTY" "au BufNewFile,BufReadPost *.hpp $BASIC_PROPERTY")

echo GLOBAL_PROPERTY >> $VIMRC_PATH

for property in $(BASIC_PROPERTIES); do
	echo $property >> $VIMRC_PATH
done

#.5 SET VIM PLUGINS

#.6 APPLY TO OTHER USERS
