OS=$(uname)

#.0 CHECK DEPENDENCIES

#.1 INSTALL VIM

INSTALL_COMMAND=""
if [ -z $OS ]
then
	echo "err: Can't find OS"
	exit
elif [ $OS = "Linux" ]
then
	# Need to check with the "lsb_release -a"
	INSTALL_COMMAND=""
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

USERS=("${@:1}")

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

function get_home_directory() {
	IFS=$'\n'
	set -f
	local PATHS="$(sudo cat /etc/passwd | grep "$1:")"
	for PATH in $PATHS; do
		IFS=$':'
		local TEMP=($PATH)
		if [ $1 = ${TEMP[0]} ]
		then
			eval "$2=${TEMP[5]}"
		fi
	done
	set +f
	IFS=$' '
}

HOME_PATH=""
VIM_PATH=""
VIMRC_PATH=""

if [ $OS = "Darwin" ]
then
	HOME_PATH=$HOME
else 
	# GETTING PATH FROM /etc/passwd
	get_home_directory "$F_USER" HOME_PATH
fi

VIM_PATH=$HOME_PATH"/.vim"
VIMRC_PATH=$HOME_PATH"/.vimrc"

echo $VIMRC_PATH

#.4 SET VIMRC

/bin/rm "$VIMRC_PATH"
/usr/bin/wget -O "$VIMRC_PATH" "https://raw.githubusercontent.com/WyldeCat/settings/master/.vimrc"

#.5 SET VIM PLUGINS

mkdir "$VIM_PATH"/autoload
mkdir "$VIM_PATH"/bundle

#.6 APPLY TO OTHER USERS
