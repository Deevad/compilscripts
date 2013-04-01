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
	echo  "This part will do an attempt to auto-install all the dependencies for building $project"
	echo  "Around 2GB will be necessary to install everything in your /home directory, and system will be updated"
	echo  "Also, every Krita , Karbon and Calligra package must be uninstalled"
	echo "      "
	echo "      "
	echo "       ==== IMPORTANT : TO-READ AND TO-DO ===="
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
echo "${BLUE}      "
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
	
cd $directory

# a key to prevent terminal closing
echo -n "Script finished job, press a key to exit"
read END