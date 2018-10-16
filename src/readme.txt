Oric Joy will permit you to play oric games, with your gamepad

In the "games" directory, you will find the game profiles.
- Each profile is a sub-directory.
- The name of the sub-directory will appear in Oric Joy as the name of the game ("4K Kong, Hopper,...")
- in a sub-directory profile, 4 files are required :
	- command.txt (see details below)
        - a jpeg file (for the inlay, name is not important, but the extension MUST BE .jpg )
          this file can be a screenshot, or a tape-box-cover scan.
        - a .tap file (and only one, that's ok for arcade games)
        - description.txt is a short explanation text about the game, this is an optional file
   
command.txt file
----------------
This file is the most important. It the one that permits to map the Oric keys to your gamepad buttons.
Any ps3 controller will do the job. Mine is a SOG wired gamepad (SOG = "spirit of gamers"). Yeah, it's a crap, but it works.
On the left field, just before the equal sign, you will find the controller buttons you need to map, namely :
  - up,bottom,left,right (pov)
  - b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11 and b12 (that should be enough, even if technically, it is possible to map 32 buttons).


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

   ...or one single char:
      Without quote just after the equal sign, namely :
         - numbers : 0,1,2,3,4,5,6,7,8,9
         - alphabet : a,b, .., z
         - special chars corresponding to each key of the oric keyboard : [ ] ; : ' " , < . > / and ?

      Note: the file is not case sensitive, you can write everything in lower or upper case.


Enjoy,
Chloe Avrillon