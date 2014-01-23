
						Compilscripts
	WARNING !		
	== PROJECT UNMAINTAINED ==
	This project ended with the introduction of the 'Build cat documentation' here :
	http://www.davidrevoy.com/article/193/guide-building-krita-on-linux-for-cats.html
	
	The replacement script I use is shorter.
	http://pastebin.kde.org/psj3xhnk6
	
	What mean Unmaintained ? it mean it's not tested anymore, and can break things.
	Soon , by mid 2014 compilscript repo will be closed.
	Thanks for those who reported, used the project. 
	
	-David
	==========================
	
	

	What is it?
	-----------
	Compilscript are a set of script to compil, update Gfx FLOSS project as Mypaint, Krita with ease.
	0.2 serie is the actual latest version, this one have Krita + VC, and Mypaint.
	Script are designed for Linux Mint 14 KDE, but also aim to be 'buntu compatible, from 12.04 and after...
	
	
	Note
	------------

	* By mid-october I will remove all scripts for 'buntu/Mint and propose them for Manjaro/Arch only.
	* My final goal should be to remove this all, and propose it via AUR only. But I'm not skilled enough right now. Fork and new maintainer welcome...
	* Note : Dropping support for 'buntu/Mint is not because I'm evil, it's because I have no time to maintain them. Fork and new maintainer welcome...


	Installation
	------------

	* 'buntu users : Ignore or delete the script krita-install-manjaro.sh .
	* Manjaro/Arch users : Ignore or delete all other scripts than krita-install-manjaro.sh
	
	* Get the script :
	  - Download as ZIP : https://github.com/Deevad/compilscripts/archive/master.zip
	  - or Clone with Git :  git clone https://github.com/Deevad/compilscripts.git
	
	Install Mypaint first, then VC , then Krita ; and reboot.
	
	* Run a script :
	  - Open a terminal in the folder containing the script :
		( ex: on file explorer 'Dolphin' , right click , Action > Open a terminal here )
		
	  - Permissions : be sure the *.sh files can be executed.
		( ex : chmod +x krita-install.sh )
		
	  - Execute them inside a terminal.
		( ex : ./krita-install.sh )
		
	  - Follow the instructions written on screen.
		
	  
	  If you use the script often , you might want to make a launcher. 
			1. Right click on KDE menu
			2. Edit Application
			3. Select 'System' in the tree
			4. Press 'New item'
			5. Name it Krita-install
			6. In command, use the file explorer icon to find your krita-install.sh script on disk.
			7. When its done, Open the advanced tab and check 'Run in terminal'
			8. Redo the same for the Mypaint script
			9. Press save and close. 
			10. Now you have in your KDE menu , under System the script ready to launch , or put as favorite

	
	
	Documentation
	------------

	To use this script, you must know basics of compilation.
	The main menu offer 7 choice :
		
		(1) Install  
			To perform only one time the first time
			It will grab source with GIT, compile them, and install
			
		(2) Update	
			To update an already installed project. 
			It will update the source code, and compile and reinstall over the previous
			Ideal to follow daily or weekly a project
		
		(3) Compile only
			Specific for user who do change in source code and want a simple
			compilation only. 
		
		(4) Reset to master
			If your source is corrupt with changes, or you want to clean
			this option propose method to clean local files and assure
			you to be updated to master
		
		(5) Uninstall
			This option remove the build project installed
			
		(6) Online manual
			This option launch the default webbrowser and load
			https://github.com/Deevad/compilscripts
			where you can read this documentation, and report issue, commit code.
		
		(7) Exit
			This option exit from the menu
			
			
			
	Troubleshot
	------------

	How to behave in case of trouble :
	
		1) Check the log :
			You might not be used to read terminal output, but in case of error , the lines are usually obvious and sometime propose a solution.
			Configure the preferences of your Terminal to see more than 500 lines of history is also good to know whats really happen.
			
		2) Restart a bit later
			The script compile the source code commited 1second ago. 
			Developpers might did a mistake who lead into broken compilation, but it never stay long to get corrected. 
			Also, Git server might not be connected. 
			The scripts depend of a lot of services, so its always wise to retry a bit later. 
			
		3) Send the log to bug repport
			If you can save the log with the error in a txt file ( a copy/paste ) and send it to developpers, they can guide you about why
			the compilation didn't succeed on your machine. 

	
	
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
	
	
