#!/bin/sh
#
#: Title       : Krita-install
#: Author      : David REVOY < info@davidrevoy.com >
#: License     : GPL ; read LICENSE
#  Inspired by : Spell script : http://pastebin.com/KkT9SvTs , Kubuntiac script : http://forum.kde.org/viewtopic.php?f=139&t=92880

# Script version
scriptversion="v0.4a"

# Help page
helppage=https://github.com/Deevad/compilscripts

# CPU available
numCores=$((`cat /proc/cpuinfo | grep processor | wc -l`))

# Git repository adress
gitRepo=git://anongit.kde.org/calligra.git

# Color lib, issue with Xfce terminal emulator...
# PINK="\033[1;35m"
# BLACK="\033[1;0m"
# BLUE="\033[1;34m"
# GREEN="\033[1;32m"
# RED="\033[1;31m"
# Workaround, turn them off...
PINK=""
BLACK=""
BLUE=""
GREEN=""
RED=""

_separators()
{
	echo " "
	echo "${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLUE}-${PINK}=${BLACK}"
	echo " "
}

_setup_dir()
{
	mkdir -p $HOME/kde4/build/calligra
	mkdir -p $HOME/kde4/inst
	mkdir -p $HOME/kde4/src
}

_done()
{
	echo " "
	echo "${GREEN}------------------------------------------------------------"
	echo " All task requested are now done"
	echo "-----------------------------------------------------------"
	echo " Note : this doesn't mean everything was fine, scrollback for more info."
	echo "${BLACK}"
}

_refresh()
{
	echo " "
	echo "${GREEN}------------------------------------------------------------"
	echo " Refreshing menus and icons with Kbuildsycoca4 on a external terminal windows"
	echo " (because output is dirty and often non revelant ... )"
	echo "-----------------------------------------------------------"
	xfce4-terminal --command=kbuildsycoca4
}

_install_dependencies()
{
	echo "${RED}IMPORTANT : TO-READ"
	echo " "
	echo  "This part will do an attempt to auto-install all the dependencies "
	echo  "All you have to do is taking care your Manjaro being correctly update."
	echo  "( Note : remove manually with Pamac any calligra/krita package installed before proceed ).${BLACK}"
	echo " "
	echo -n "             press [Enter] when you feel ready, or [Ctrl+C] to exit"
	read CHOICE     
	echo "${BLUE}------------------------------------------------------"
	echo "INSTALLING MAIN DEPENDENCIES AROUND CALLIGRA"
	echo "------------------------------------------------------${BLACK}"
	echo "      "
	sudo pacman -Sy automoc4 git cmake boost boost-build kdepimlibs eigen2 freetds kdegraphics-okular libgsf libwpd libwpg libwps pstoedit glew gsl cmake automoc4 boost libkdcraw libpqxx fftw opengtl lcms2 vc
}

_postinstalltodo()
{
	echo "${RED}IMPORTANT : TO-DO NOW"
	echo " "
	echo  "If compilation went well ( scrollback, see if it's 100% everywhere, no bad error ) "
	echo  "do the following post install manually , edit  ~/.xprofile and paste this at the end : ${BLACK}"
	echo  "export KDEDIRS=$HOME/kde4/inst:$KDEDIRS"
	echo  "export PATH=$HOME/kde4/inst/bin:$PATH"
	echo  "export KDEHOME=$HOME/.kde"
	echo " "
	echo -n "${RED}             press [Enter] when it's done${BLACK}"
	read CHOICE
	echo "${RED}<<>><<>><<>><<>><<>><<>><<>> NOTICE <<>><<>><<>><<>><<>><<>><<>>"
	echo " Now, it's adviced to do a system restart or Krita will not launch."
	echo "<<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>>${BLACK}"
}

_get_sources()
{
	cd $HOME/kde4/src
	_separators
	echo "${BLUE}  Now, getting the Calligra source with GIT ${BLACK}"
	echo "${BLUE}  [ Note: the project is large, speed depend of server, internet connection. ] ${BLACK}"
	git clone $gitRepo
}

_compile_sources()
{
	cd $HOME/kde4/build/calligra
	_separators
	echo "${BLUE}  Now, configuring...this is the part of the script, where error are important to read, it might complain for missing dependencies to install manually. ${BLACK}"
	echo "${BLUE}  [ Note: this part can take from 2min to 1h depending of your CPU and disk speed access ] ${BLACK}"
	echo "      "
	cmake -DCMAKE_INSTALL_PREFIX=$HOME/kde4/inst $HOME/kde4/src/calligra -DCMAKE_BUILD_TYPE=RelWithDebInfo -DPRODUCTSET=CREATIVE -DBUILD_karbon=OFF
	make -j$numCores
	make install -j$numCores
	echo "      "
}

_update_sources()
{
	cd $HOME/kde4/src/calligra
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
	_refresh
	_postinstalltodo
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
	_refresh
	_done
}

_user_compile_only()
{
	echo "${BLUE}------------------------------------------------------"
	echo "COMPILE ONLY"
	echo "------------------------------------------------------${BLACK}"
	echo "      "
	_compile_sources
	_refresh
	_done
}

_user_reset_master()
{
	echo "${BLUE}------------------------------------------------------"
	echo "RESET TO MASTER"
	echo "------------------------------------------------------${BLACK}"
	echo "      "
	cd $HOME/kde4/src/calligra
	git reset --hard master
	git checkout master
	git pull
	git clean -dfx
	_compile_sources
	_refresh
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
echo "  - path :   ~/kde4/inst/ ~/kde4/src/calligra and /kde4/build/calligra ..."

# menu
echo "${BLUE}------------------------------------------------------------${BLACK}"
echo "${BLUE}     MENU   ${BLACK}"
echo "      "
echo "   (1) Install Krita for the first time"
echo "   (2) Update Krita"
echo "   (3) Compile only (without updating code, useful after patch or switching branch )"
echo "   (4) Reset to master (napalm all change, and go back master)"
echo "   (5) Launch browser , Compilscript Github page "
echo "   (6) Exit"
echo " "
echo "${BLUE}------------------------------------------------------------${BLACK}"
echo -n "               Enter your choice (1-6) then press [enter] :${PINK}"
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
		xdg-open $helppage
	
	elif [ "$mainmenu" = 6 ]; then
		echo " ${PINK}Bye Bye ! ${BLACK} "
		
	else
	echo "the script couldn't understand your choice, try again...";
	fi;


