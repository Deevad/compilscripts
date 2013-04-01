#!/bin/sh
#
#: Title       : Krita-install
#: Author      : David REVOY < info@davidrevoy.com >
#: License     : GPL ; read LICENSE
#  Inspired by : Spell script : http://pastebin.com/KkT9SvTs , Kubuntiac script : http://forum.kde.org/viewtopic.php?f=139&t=92880

# Script version
scriptversion="v0.2"

# Project name
project=krita

# Help page
helppage=http://www.davidrevoy.com/article155/linux-mint-14-kde-for-painters

# Root directory
directory=$HOME/Software

# Subfolder
srcDir=$directory/$project/src
instDir=$directory/$project/inst
buildDir=$directory/$project/build

# CPU available
numCores=$((`cat /proc/cpuinfo | grep processor | wc -l`))

# Git repository adress
gitRepo=git://anongit.kde.org/calligra.git

# Token to check a first install
token=$directory/$project/.krita-token

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
	echo " "
	echo "${GREEN}------------------------------------------------------------"
	echo " All task requested are now done"
	echo "-----------------------------------------------------------"
	echo " Note : this doesn't mean everything was fine, check the log for more info-${BLACK}"
	echo " "
}

_install_dependencies()
{
	echo "${RED}----------------------WARNING-------------------------"
	echo "      "
	echo  "This part will install all the dependencies for building $project"
	echo  "Around 2GB will be necessary to install everything in your /home directory, and system will be updated"
	echo  "Also, every Krita , Karbon and Calligra package must be uninstalled"
	echo "      "
	echo "      "
	echo "       ==== IMPORTANT : TO-READ AND TO-DO ===="
	echo  "Before going further, you need to activate the sources repositories manually"
	echo  "* Open KDE menu"
	echo  "* Search for 'Software Sources'"
	echo  "* Open it"
	echo  "* On the tab 'Linux Mint Software' , check to activate 'Source code' "
	echo  "* On the tab 'Other Software' check to activate 'Ubuntu 12.10 Quantal Quetzal (source code) ' "
	echo  "...then close the windows to finish "
	echo "      "
	echo "      "
	echo "      "
	echo "-----------------------------------------------------${BLACK}"
	echo -n "press [Enter] when you did all the task and met all requirement, or [Ctrl+C] to abort"
	read CHOICE     
	
	sudo apt-get -y update
	sudo apt-get purge krita* koffice* karbon* calligra*
	sudo apt-get -y upgrade
	sudo apt-get -y install cl-fftw3 liblcms2-dev cmake liblcms2-2 liblcms2-utils git xserver-xorg-input-wacom oxygen-icon-theme kde-runtime wget liblcms1-dev kdebase-runtime systemsettings qt4-qtconfig qtcurve libwpg-tools libwpd-tools poppler-utils opengtl-tools libcxxtools-dev phonon-backend-gstreamer
	sudo apt-get -y build-dep calligra
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
	cmake ../src -DCREATIVEONLY=ON -DCMAKE_BUILD_TYPE=RELWITHDEBINFO -DCMAKE_INSTALL_PREFIX=../inst
	make -j$numCores
	make install -j$numCores

	if [ ! -e $token ]; then
			# token don't exist
			
			# backing extra in .profile
			echo "export PATH=$PATH:$instDir/bin" >> ~/.profile
			echo "export KDEDIRS=$KDEDIRS:$instDir" >> ~/.profile
			
			
			
			#token is created
			touch $token
	fi
	
	kbuildsycoca4

}

_update_sources()
{
	cd $srcDir
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
	echo "Now, it's adviced to perform a system restart, or Krita will not launch."
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
echo "   3) Compile only"
echo "   4) Reset to master"
echo "   5) Help webpage"
echo "   ... or Ctrl+C to exit"
echo " "
echo "------------------------------------------------------"
echo -n "                  Enter your choice (1-6) :"
read mainmenu
echo " "
echo " "
	if [ "$mainmenu" = 1 ]; then
		_user_install
		
	elif [ "$mainmenu" = 2 ]; then
		_user_update
		
	elif [ "$mainmenu" = 3 ]; then
		_user_compile_only

	elif [ "$mainmenu" = 4 ]; then
		_user_reset_master
		
	elif [ "$mainmenu" = 5 ]; then
		xdg-open $helppage
		
	else
	echo "the script couldn't understand your choice, try again...";
	fi;
	
cd $directory

# a key to prevent terminal closing
echo -n "Script finished job, press a key to exit"
read END