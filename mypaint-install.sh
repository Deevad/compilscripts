#!/bin/sh
#
#: Title       : Mypaint-install
#: Author      : David REVOY < info@davidrevoy.com >
#: License     : GPL ; read LICENSE
#  Inspired by : Spell script : http://pastebin.com/KkT9SvTs , Kubuntiac script : http://forum.kde.org/viewtopic.php?f=139&t=92880


# Script version
scriptversion="v0.2a"

# Project name
project=mypaint

# Help page
helppage=http://www.davidrevoy.com/article155/linux-mint-14-kde-for-painters

# Root directory
directory=$HOME/Software

# Subfolder
srcDir=$directory/$project

# Git repository adress
gitRepo=git://gitorious.org/mypaint/mypaint.git

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
}

_done()
{
	echo " "
	echo "${GREEN}------------------------------------------------------------"
	echo " All task requested are now done"
	echo "-----------------------------------------------------------"
	echo " Note : this doesn't mean everything was fine, check the log for more info-${BLACK}"
	echo " "
}

_install_dependencies()
{
	echo "${RED}This part will install all the dependencies for building $project"
	echo "the repositories will be updated then new package installed"
	echo  "Also, every $project package already installed will be automatically uninstalled"
	echo -n "press [Enter] to continue, or [Ctrl+C] to exit${BLACK}"
	read CHOICE
	sudo apt-get -y update
	sudo apt-get purge mypaint*
	sudo apt-get -y install build-essential git libgtk-3-dev python-gi-dev gir1.2-gtk-3.0 python-gi-cairo g++ git-core python-dev python-numpy swig scons gettext libpng12-dev liblcms2-dev libjson0-dev
	sudo apt-get -f install
}

_get_sources()
{
	cd $directory
	git clone $gitRepo $project
}

_compile_sources()
{
	cd $srcDir
	_separators
	echo "${BLUE}  Now, configuring, compiling, installing ... this is the main part of the script, error are important to read ${BLACK}"
	echo "${BLUE}  As Mypaint is installed in /usr/local , the script will ask you password for admin permission ${BLACK}"
	echo "      "
	sudo scons prefix=/usr/local install
	_separators
	echo "${BLUE}  Updating GTK Cache for icons ${BLACK}"
	echo "      "
	sudo gtk-update-icon-cache --ignore-theme-index /usr/local/share/icons/hicolor
}

_update_sources()
{
	cd $srcDir
	_separators
	echo "${BLUE}  Now, updating $project source with GIT ${BLACK}"
	git pull
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
	cd $srcDir
	sudo scons prefix=/usr/local uninstall
	sudo gtk-update-icon-cache --ignore-theme-index /usr/local/share/icons/hicolor
	echo "${RED} To-do manually : $project"
	echo "* Now if you want to also delete the sources , delete manually $directory/$project/ "
	echo -n "press [Enter] to continue, or [Ctrl+C] to exit${BLACK}"
	read CHOICE
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

_user_compile_only()
{
	echo "${BLUE}------------------------------------------------------"
	echo "COMPILE ONLY"
	echo "------------------------------------------------------${BLACK}"
	echo "      "
	_compile_sources
	_done
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
echo " |\/|   _  _ . _ _|_"
echo " |  |\/|_)(_||| | | "
echo "     / |  "
echo "${BLACK}      "
echo " Welcome, this script will help you to compile and update $project"
echo "      "
echo "${GREEN}  *Infos*${BLACK} "
echo "  - script version : "$scriptversion
echo "  - source path :    "$directory/$project
echo "  - build path :     "$directory/$project
echo "  - install path :   /usr/local"
echo "  "
echo "      "

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
	echo "${RED}we couldn't understand your choice, try again...${BLACK}";
	fi;


