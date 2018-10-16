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
<p>This file is the most important. It the one that permits to map the Oric keys to your gamepad buttons.
Any PS3 controller will do the job. Mine is a SOG wired gamepad (SOG = "spirit of gamers"). Yeah, it's a crap, but it works.</p>

<p>On the left field, just before the equal sign, you will find the controller buttons you need to map, namely :</p>
- up, bottom, left, right (D-Pad or Left analog)
- b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11 and b12 (that should be enough, even if technically, it is possible to map 32 buttons).
  
<p>For helping you, please, have a look :<br />
![PS3 controller button map](/PS3_controller_bm.jpg)
Another help is located at the top-left of the Oric joy windows. If your joystick is connected, text boxes representing each controller button will show up in red.</p>

<p>In the right field (after the equal sign), you will provide...<br />
* <p>... either one of those Special keys :<br />
  * up<br />
  * down<br />
  * left<br />
  * right<br />
  * space<br />
  * del<br />
  * ctrl<br />
  * return<br />
  * shift (stands for left shift)<br />
  * lshift (left shit)<br />
  * rshift (right shift)<br />
  * esc<br /></p>

* <p>...or one single char:<br />Without quote just after the equal sign, namely :<br />
  * numbers :
    0,1,2,3,4,5,6,7,8,9
  * alphabet :
    a,b, .., z
  * special chars corresponding to each key of the oric keyboard :
    [ ] ; : ' " , < . > / and ?
</p>

  * <p>...specials :<br />
<ul>
<li><p>keepdown=0 (default)/keepdown=1</p>
<p>this permits (when set to 1), to keep keys down (see crocky profile) until another direction is pressed.</p></li>
<li><p>up-left, down-left, up-right, down-right : for diagonal directions (see Hu-bert profile)</p></li>
</ul></p>

      Note: the file is not case sensitive, you can write everything in lower or upper case.

###Samples :
<p>The distribution already comes with game profiles, among them, you will find...</p>
command.txt for Hopper :
    up='
    down=/
    left=z
    right=x
    b1=1
    b2=2
    b3=3
    b4=4
    b6=p
command.txt for Hu-bert :
    up-left=a
    down-left=z
    up-right=l
    down-right=,
    b1=1
    b2=2
    b3=3
    b4=4
    b6=p
command.txt for Blake 7 :
    up=up
    down=down
    left=left
    right=right
    b1=1
    b2=2
    b3=3
    b4=4
    b5=5
    b6=6
    b7=7
    b8=8
    b9=9
    b10=esc
commad.txt for Crocky
    up=p
    down=l
    left=a
    right=s
    b1=space
    b2=space
    b3=space
    b4=space
    b10=space
    keepdown=1

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
<p>Oricutron is an open source portable Oric-1/Atmos/Telestrat and Pravetz 8D emulator.</p>
<p>[Oricutron Github](https://github.com/pete-gordon/oricutron)</p>
<p>**OricJoy** already includes this emulator (v1.2, for windows)</p>

<p>Oricutron binaries are available for various OSes :</p>
<p>http://www.petergordon.org.uk/oricutron/</p>

<p>For an Android version of **Oricutron**, please have a look to this forum thread :</p>
<p>http://forum.defence-force.org/viewtopic.php?f=22&t=1097&p=18212&hilit=android#p18212</p>

## LICENCE
GNU GENERAL PUBLIC LICENSE, Version 3, 29 June 2007
