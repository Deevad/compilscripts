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
helppage=https://github.com/Deevad/compilscripts

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

_separators()
{
	echo " "
	echo "${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLACK}"
	echo " "
}

_setup_dir()
{
	mkdir -p $srcDir
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
	echo "${RED}<<>><<>><<>><<>><<>><<>><<>> WARNING <<>><<>><<>><<>><<>><<>><<>>"
	echo "      "
	echo "IMPORTANT : TO-READ AND TO-DO"
	echo " "
	echo  "This part will do an attempt to auto-install all the dependencies "
	echo  "for building $project. Around 150MB will be necessary to perform it"
	echo " "
	echo "Also ; a full system update/upgrade will be done"
	echo " "
	echo "<<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>>${BLACK}"
	echo -n "           press [Enter] when your system is setup and ready, or [Ctrl+C] to exit"
	read CHOICE     
	echo "${BLUE}------------------------------------------------------"
	echo "UPDATING SYSTEM"
	echo "------------------------------------------------------${BLACK}"
	echo "      "
	sudo apt-get -y update
	sudo apt-get -y upgrade
	echo "${BLUE}------------------------------------------------------"
	echo "INSTALLING DEPENDENCIES"
	echo "------------------------------------------------------${BLACK}"
	echo "      "
	sudo apt-get -y install build-essential git cmake
	echo "${BLUE}------------------------------------------------------"
	echo "CHECK BROKEN PACKAGES"
	echo "------------------------------------------------------${BLACK}"
	echo "      "
	sudo apt-get -f install
}

_get_sources()
{
	cd $directory/$project/
	_separators
	echo "${BLUE}  Now, updating $project source with GIT ${BLACK}"
	git clone $gitRepo src
}

_compile_sources()
{
	cd $buildDir
	_separators
	echo "${BLUE}  Now, configuring, compiling, installing ... this is the main part of the script, error are important to read ${BLACK}"
	echo "${BLUE}  [ Note: this part can take from 2min to 30min depending of your CPU and disk speed access ] ${BLACK}"
	echo "      "
	cmake ../src
	make -j$numCores
	_separators
	echo "${BLUE}  Now, installing $project direcly into your system ${BLACK}"
	echo "      "
	sudo make install -j$numCores
}

_update_sources()
{
	cd $srcDir
	_separators
	echo "${BLUE}  Now, updating $project source with GIT ${BLACK}"
	git pull
}

_user_reset_master()
{
	echo "${BLUE}------------------------------------------------------"
	echo "RESET TO MASTER"
	echo "------------------------------------------------------${BLACK}"
	echo "      "
	cd $srcDir
	git reset --hard master
	git checkout master
	git pull
	git clean -dfx
	_compile_sources
	_done
}

_user_install()
{
	echo "${BLUE}------------------------------------------------------"
	echo "INSTALLATION"
	echo "------------------------------------------------------${BLACK}"
	echo "      "
	_setup_dir
	_install_dependencies
	_get_sources
	_update_sources
	_compile_sources
	_done
}

_user_uninstall()
{
	echo "${BLUE}------------------------------------------------------"
	echo "UNINSTALLATION"
	echo "------------------------------------------------------${BLACK}"
	echo "      "
	echo "${RED}This part will uninstall all $project"
	echo "Obviously : to uninstall , you need a previous installation"
	echo -n "press [Enter] to continue, or [Ctrl+C] to exit${BLACK}"
	read CHOICE
	cd $buildDir
	make uninstall
	echo "${RED} To-do manually : $project"
	echo "* Now if you want to also delete the sources and build directory , delete manually $directory/$project ${BLACK} "
	_done
	
}

_user_compile_only()
{
	echo "${BLUE}------------------------------------------------------"
	echo "COMPILE ONLY"
	echo "------------------------------------------------------${BLACK}"
	echo "      "
	_compile_sources
	_done
}

_user_update()
{
	echo "${BLUE}------------------------------------------------------"
	echo "UPDATE"
	echo "------------------------------------------------------${BLACK}"
	echo "      "
	_update_sources
	_compile_sources
	_done
}

_endkey()
{
# a key to exit
echo -n "Press [enter] to exit"
read END
}

#######
# UI  #
#######

clear
echo "${PINK}      "
echo "    _ "
echo " \/(_ "
echo "      "
echo "${BLACK}     "
echo " Welcome, this script will help you to compile and update $project"
echo "      "
echo "${GREEN}  *Infos*${BLACK} "
echo "  - script version : "$scriptversion
echo "  - source path :    "$srcDir
echo "  - build path :    "$buildDir
echo "  - install path :     installed in your system"
echo "  "
# menu
echo "${BLUE}------------------------------------------------------------${BLACK}"
echo "${BLUE}     MENU   ${BLACK}"
echo "      "
echo "   (1) Install"
echo "   (2) Update"
echo "   (3) Compile only"
echo "   (4) Reset to master"
echo "   (5) Uninstall"
echo "   (6) Online manual "
echo "   (7) Exit"
echo " "
echo "${BLUE}------------------------------------------------------------${BLACK}"
echo -n "               Enter your choice (1-7) then press [enter] :${PINK}"
read mainmenu
echo " "
echo " ${BLACK}"
clear

	if [ "$mainmenu" = 1 ]; then
		_user_install
		_endkey
		
	elif [ "$mainmenu" = 2 ]; then
		_user_update
		_endkey
		
	elif [ "$mainmenu" = 3 ]; then
		_user_compile_only
		_endkey

	elif [ "$mainmenu" = 4 ]; then
		_user_reset_master
		_endkey
		
	elif [ "$mainmenu" = 5 ]; then
		_user_uninstall
		_endkey
		
	elif [ "$mainmenu" = 6 ]; then
		xdg-open $helppage
	
	elif [ "$mainmenu" = 7 ]; then
		echo " ${PINK}Bye Bye ! ${BLACK} "
		
	else
	echo "the script couldn't understand your choice, try again...";
	fi;