Oric Joy v1.5
=============
**Oric Joy** is a portable front-end for the **Oricutron** Emulator that permit you to play oric games, with your gamepad.
![OricJoy screen shot](/screenshot.jpg)
### In OricJoy Itself :
- select "D-Pad" (default) if you use the direction pad of a gamepad (the dirrectional cross, such like a vintage nintendo controler)
  or select analog if you use an analog joystick or if you prefer to use the left analog stick of a gamepad.
- If you click once on a game thumbnail, the teaser is displayed in the bottom part.
- Double click on a game to launch it in oricutron.
- In oricutron, if you want to quit, right click with your mouse and select quit in the menu.

### In the "games" directory, 
you will find the game profiles.
- Each profile is a sub-directory.
- The name of the sub-directory will appear in Oric Joy as the name of the game ("4K Kong, Hopper,...")
- in a sub-directory profile, 3 files are required and 1 is optional :
	- command.txt (see details below)
        - a graphic file (for the inlay, name is not important, but the extension CAN BE .jpg, .jpeg, .png or .bmp )
          this file can be a screenshot, or a tape-box-cover scan.
        - a .tap or a .dsk file
        - teaser.txt is a short explanation text about the game, this is an optional file
   
command.txt file
----------------
This file is the most important. It the one that permits to map the Oric keys to your gamepad buttons.
Any ps3 controller will do the job. Mine is a SOG wired gamepad (SOG = "spirit of gamers"). Yeah, it's a crap, but it works.
On the left field, just before the equal sign, you will find the controller buttons you need to map, namely :
  - up,bottom,left,right (D-Pad or Left analog)
  - b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11 and b12 (that should be enough, even if technically, it is possible to map 32 buttons).
  
For helping you, see the PS3_controller Button map.jpg file.
Another help is located at the top-left of the Oric joy windows. If your joystick is connected, text boxes representing each controller button will show up in red.

In the right field (after the equal sign), you will provide...
    ... either one of those Special keys :
	up
	down
	left
	right
	space
	del
	ctrl
	return
	shift (stands for left shift)
	lshift (left shit)
	rshift (right shift)
	esc

   ...or one single char:
      Without quote just after the equal sign, namely :
         - numbers : 0,1,2,3,4,5,6,7,8,9
         - alphabet : a,b, .., z
         - special chars corresponding to each key of the oric keyboard : [ ] ; : ' " , < . > / and ?

   ...specials
      - keepdown=0 (default)/keepdown=1
           this permits (when set to 1), to keep keys down (see crocky profile) until another direction is pressed.
      - up-left, down-left, up-right, down-right : for diagonal directions (see Hu-bert profile)

      Note: the file is not case sensitive, you can write everything in lower or upper case.


Enjoy,
Chloe Avrillon
## How to play :
The release can be find in the binaries folder (zip file).
Just unzip and launch OricJoy.exe (OricJoy is portable, it means that it does not have to be installed in a particular folder : running it from the desktop or an USB Key is OK)
Select a game, double-click.
o exit the emulator, right-click while in emulation session to show up the emulator menu.

## How to compile :
The source code can be compiled with Delphi Community (2018 version) or Delphi Tokyo, that can be downloaded on the [Embarcadero web site](https://www.embarcadero.com/products/delphi/starter).
You can compile this tool for windows 32 bits (compatible with all windows versions from XP to Windows 10, 32 and 64 bits), or you can also compile the sources for Win 64.

## Oricutron
Oricutron is an open source portable Oric-1/Atmos/Telestrat and Pravetz 8D emulator.
[Oricutron Github](https://github.com/pete-gordon/oricutron)
**OricJoy** already includes this emulator (v1.2, for windows)

Oricutron binaries are available for various OSes :
http://www.petergordon.org.uk/oricutron/

For an Android version of **Oricutron**, please have a look to this forum thread :
http://forum.defence-force.org/viewtopic.php?f=22&t=1097&p=18212&hilit=android#p18212

## LICENCE
GNU GENERAL PUBLIC LICENSE, Version 3, 29 June 2007
