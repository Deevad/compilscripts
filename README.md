

						Compilscripts
	
	

	What is it?
	-----------
	Compilscript are a set of script to compil, update Gfx FLOSS project as Mypaint, Krita with ease.
	0.2 serie is the actual latest version, this one have Krita + VC, and Mypaint.
	Script are designed for Linux Mint 14 KDE, but also aim to be 'buntu compatible, from 12.04 and after
	
	
	Installation
	------------
	Download, check execute permissions and execute them inside a terminal.
	Install Mypaint first, then VC , then Krita ; and reboot.
	Follow the instructions written on screen.
	
	
	Changelog :
	-----------
	
	[ 0.2 - 2013-04-01]
	* Colored output in the terminal, more user friendly
	* Better warning for Krita's need to have VC installed, and Ubuntu source activated
	* Click to close at the end
	* Drop of 'Reset to Stable' option of previous versions : it was making dependencies & preferences conflict
	* Added Readme, license
	* Repo created on GitHub
	* Uninstaller 
	
	[ 0.1 - 2013-01-09]
	* Updated webpage link for option 6
	* Krita-install.sh now remove all pre-installed calligra package
	
	[ 0.0 - 2013-01-01]
	* First release of krita-install.sh, mypaint-install.sh, vc-install.sh
	
	
	To-do and known-bug :
	---------------------
	* Krita script install in the user home folder and need a extra 'export' alias added to '~/.export' to execute binaries
	A solution would be to switch to /usr/local/ the install path, Debian style.
	Sources and compilation can still be in the ~/Software directory
	
	* A lot user influenced by the bad default Gnome behavior of proposing to execute a script from the filemanager
	try to execute the script with double clicking on them. Nothing happen thx to the main Menu who block interaction. 
	But annoying. I should find a way to launch a terminal in this case automatically, but have no idea about it. 
	
	* If a user launch two install of Krita on the same system, his file '~/.export' might be blotted with a lot of export lines :
	for the moment my script add the export lines each time.
	
	* Mypaint use now GTK3, new libs were added not sure if all is functionnal
	
	* Script should be tested on all 'buntu and remain compatible with the last LTS
	
	* A better check of package installed should be done by the script
	
	* Distro still set 500 lines back terminal history output by default, and it sucks for debugging. 
	A system to log all the output into a /tmp/xxx-compil.txt file sound legit.
	
	
	Contributing
	---------
	Anyone interrested in, may fork it, propose better, and join :)
	I am an artist, and learned this script things very recently, my skill is bad. 
	Any help is warmly welcome. 
	
	
	Licensing
	---------
	Please see the file called LICENSE.
	
	
	Contacts
	--------
	David REVOY, < info@davidrevoy.com >
	
	
