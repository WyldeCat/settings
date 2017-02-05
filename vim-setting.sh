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
#/bin/touch "$VIMRC_PATH"

TAB_WIDTH="2"
GLOBAL_PROPERTY=("syntax on" "set number")
BASIC_PROPERTY=("set cindent expandtab sw=2 sts=2")
CONDITIONAL_PROPERTIES[0]="au BufNewFile,BufReadPost *.c"
CONDITIONAL_PROPERTIES[1]="au BufNewFile,BufReadPost *.cpp"
CONDITIONAL_PROPERTIES[2]="au BufNewFile,BufReadPost *.h" 
CONDITIONAL_PROPERTIES[3]="au BufNewFile,BufReadPost *.hpp"


for property in "${GLOBAL_PROPERTY[@]}"; do
	echo "$property" >> $VIMRC_PATH
done

for property in "${CONDITIONAL_PROPERTIES[@]}"; do
	echo "$property$BASIC_PROPERTY" >> $VIMRC_PATH
done

#.5 SET VIM PLUGINS

#.6 APPLY TO OTHER USERS
