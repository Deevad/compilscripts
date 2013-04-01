#!/bin/sh
#
#: Title       : Vc-install
#: Author      : David REVOY < info@davidrevoy.com >
#: License     : GPL ; read LICENSE
#  Inspired by : Spell script : http://pastebin.com/KkT9SvTs , Kubuntiac script : http://forum.kde.org/viewtopic.php?f=139&t=92880

# Script version
scriptversion="v0.2"

# Project name
project=vc

# Help page
helppage=http://www.davidrevoy.com/article155/linux-mint-14-kde-for-painters

# Root directory
directory=$HOME/Software

# Subfolder
srcDir=$directory/$project/src
buildDir=$directory/$project/build

# CPU available
numCores=$((`cat /proc/cpuinfo | grep processor | wc -l`))

# Git repository adress
gitRepo=git://gitorious.org/vc/vc.git

# Color lib
PINK="\033[1;35m"
BLACK="\033[1;0m"
BLUE="\033[1;34m"
GREEN="\033[1;32m"
RED="\033[1;31m"

_setup_dir()
{
	mkdir -p $srcDir
	mkdir -p $instDir
	mkdir -p $buildDir
}

_done()
{
	echo "Done."
	echo "Thanks for using the $project-install.sh script"
	echo "-----------------------------------------------"
}

_install_dependencies()
{
	echo "This part will install all the dependencies for building $project"
	echo "the system will be updated and new package installed"
	echo -n "press [Enter] to continue, or [Ctrl+C] to abort"
	read CHOICE
	sudo apt-get -y update
	sudo apt-get -y upgrade
	sudo apt-get -y install build-essential git cmake
	sudo apt-get -f install
}

_get_sources()
{
	cd $directory/$project/
	git clone $gitRepo src
}

_compile_sources()
{
	cd $buildDir
	cmake ../src
	make -j$numCores
	sudo make install -j$numCores
}

_update_sources()
{
	cd $srcDir
	git pull
}

_user_install()
{
	echo "------------------------------------------------------"
	echo "INSTALLATION"
	echo "------------------------------------------------------"
	echo "      "
	_setup_dir
	_install_dependencies
	_get_sources
	_update_sources
	_compile_sources
	_done
}

_user_update()
{
	echo "------------------------------------------------------"
	echo "UPDATE"
	echo "------------------------------------------------------"
	echo "      "
	_update_sources
	_compile_sources
	_done
}

#######
# UI  #
#######

clear
tput rev
echo "$project-install.sh"
tput sgr0
echo "      "
echo "     __  (\_"
echo "    (_ \ ( '>"
echo "      ) \/_)="
echo "      (_(_ )_"
echo "      "
echo "Compile, update, and more for $project"
echo "  in "$directory/$project
echo "  written for Linux Mint KDE 14"
echo "      "
# menu
echo "------------------------------------------------------"
echo "     MENU   "
echo "      "
echo "   1) Install"
echo "   2) Update"
echo "   3) Open sources folder"
echo "   4) Help webpage"
echo "   ... or Ctrl+C to exit"
echo " "
echo "------------------------------------------------------"
echo -n "                  Enter your choice (1-4) :"
read mainmenu
echo " "
echo " "
	if [ "$mainmenu" = 1 ]; then
		_user_install
		
	elif [ "$mainmenu" = 2 ]; then
		_user_update

	elif [ "$mainmenu" = 3 ]; then
		cd $srcDir
		
	elif [ "$mainmenu" = 4 ]; then
		xdg-open $helppage
	else
	echo "the script couldn't understand your choice, try again...";
	fi;
	
cd $directory

# a key to prevent terminal closing
echo -n "Script finished job, press a key to exit"
read END