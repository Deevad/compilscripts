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
helppage=https://github.com/Deevad/compilscripts

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

_separators()
{
	echo " "
	echo "${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLACK}"
	echo " "
}

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
	echo " Note : this doesn't mean everything was fine, check the log for more info.${BLACK}"
	echo " "
}

_install_dependencies()
{
	echo "${RED}<<>><<>><<>><<>><<>><<>><<>> WARNING <<>><<>><<>><<>><<>><<>><<>>"
	echo "      "
	echo "IMPORTANT : TO-READ AND TO-DO"
	echo " "
	echo  "This part will do an attempt to auto-install all the dependencies "
	echo  "for building $project. Around 2GB will be necessary to install everything in your"
	echo  "/home directory, and system will be updated"
	echo  "Also, every Krita , Karbon and Calligra package must be uninstalled"
	echo  "The script will try to do it for you, but it's better to also do it manually "
	echo  "Using a package manager as Synaptic for exemple."
	echo " "
	echo  "Reason : You can't use 2.5 or 2.6 stable from package along this compilation !"
	echo " "
	echo " also : "
	echo  "1) You need to have a recent VC library installed first, VC manage performance/CPU/etc..."
	echo  "* To compile VC, use the vc-install.sh script and install it"
	echo "      "
	echo  "2) You need to activate the sources repositories manually"
	echo  "* Open KDE menu"
	echo  "* Search for 'Software Sources'"
	echo  "* Open it"
	echo  "* On the tab 'Linux Mint Software' , check to activate 'Source code' "
	echo  "* On the tab 'Other Software' check to activate 'Ubuntu 12.10 Quantal Quetzal (source code) ' "
	echo  "...then close the windows to finish "
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
	echo "${BLUE}------------------------------------------------------"
	echo "AUTOREMOVING KRITA, KOFFICE, KARBON, CALLIGRA PACKAGES"
	echo "------------------------------------------------------${BLACK}"
	echo "      "
	sudo apt-get purge krita* koffice* karbon* calligra*
	echo "${BLUE}------------------------------------------------------"
	echo "UPDGRADING SYSTEM"
	echo "------------------------------------------------------${BLACK}"
	echo "      "
	sudo apt-get -y upgrade
	echo "${BLUE}------------------------------------------------------"
	echo "INSTALLING LITTLE DEPENDENCIES AROUND CALLIGRA"
	echo "------------------------------------------------------${BLACK}"
	echo "      "
	sudo apt-get -y install cl-fftw3 liblcms2-dev cmake liblcms2-2 liblcms2-utils git xserver-xorg-input-wacom oxygen-icon-theme kde-runtime wget liblcms1-dev kdebase-runtime systemsettings qt4-qtconfig qtcurve libwpg-tools libwpd-tools poppler-utils opengtl-tools libcxxtools-dev phonon-backend-gstreamer
	echo "${BLUE}------------------------------------------------------"
	echo "INSTALLING CALLIGRA DEPENDENCIES"
	echo "------------------------------------------------------${BLACK}"
	echo "      "
	sudo apt-get -y build-dep calligra
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
	echo "${BLUE}  Now, getting the $project source with GIT ${BLACK}"
	echo "${BLUE}  [ Note: the project is large, speed depend of server, internet connection. ] ${BLACK}"
	git clone $gitRepo src
}

_compile_sources()
{
	cd $buildDir
	_separators
	echo "${BLUE}  Now, configuring, compiling, installing ... this is the main part of the script, error are important to read ${BLACK}"
	echo "${BLUE}  [ Note: this part can take from 2min to 1h depending of your CPU and disk speed access ] ${BLACK}"
	echo "      "
	cmake ../src -DCREATIVEONLY=ON -DCMAKE_BUILD_TYPE=RELWITHDEBINFO -DCMAKE_INSTALL_PREFIX=../inst
	make -j$numCores
	make install -j$numCores

	if [ ! -e $token ]; then
			# token don't exist
			
			# backing extra in .profileEND
			echo "export PATH=$PATH:$instDir/bin" >> ~/.profile
			echo "export KDEDIRS=$KDEDIRS:$instDir" >> ~/.profile
			
			
			
			#token is created
			touch $token
	fi
	_separators
	echo "${BLUE}  Now, updating links with kbuildsycoca4 , not important to read, often a lot of lines ${BLACK}"
	echo "      "
	kbuildsycoca4

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
	echo "${RED}<<>><<>><<>><<>><<>><<>><<>> NOTICE <<>><<>><<>><<>><<>><<>><<>>"
	echo " Now, it's adviced to do a system restart, or Krita will not launch."
	echo "<<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>>${BLACK}"
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
	kbuildsycoca4
	echo "${RED} To-do manually : $project"
	echo "* Now if you want to also delete the sources and build directory , delete manually $directory/$project "
	echo "* You can also clean the 2 export lines added to your ~/.profile files "
	echo "   export PATH=$PATH:$instDir/bin"
	echo "   export KDEDIRS=$KDEDIRS:$instDir"
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
echo "	|_/ _.|_ _  "
echo "	| \| ||_(_| "
echo "${BLACK}      "
echo " Welcome, this script will help you to compile and update $project"
echo "      "
echo "${GREEN}  *Infos*${BLACK} "
echo "  - script version : "$scriptversion
echo "  - source path :    "$srcDir
echo "  - build path :    "$buildDir
echo "  - install path :     "$instDir
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


