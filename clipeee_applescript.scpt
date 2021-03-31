#!/usr/bin/osascript



-- FIXME-1 : Please Install Firefox {with "Random User Agent" for better usage, and Select Only Firefox windows/mac/etc}
-- FIXME-2 : Please Install cliclick on Mac
-- exec parameters
property Cliclick_bin : "sudo /opt/local/bin/cliclick "
property Browser_ap : "Firefox"
property Browser_pr : "firefox"

-- FIXME-3  : Please : USE COMMAND + SHIFT + '4' to get RIGHT COORDINATES  for every "scan_average_box(x, y, delta_x, delta_y, [color_to_search,number_of_tries,move_mouse,check_if_color_changes])
-- FIXME-4  : Please : If not working, try to get the colors with the mac color picker
-- simple colors : 
property rgb_White : "255 255 255"
property rgb_Triangle : "255 200 39"
property rgb_Googlecheckbox  : "128 128 128"
property rgb_Googlebuttonlog : "66 133 244"
property rgb_Googlebuttonauthorize1 : "26 115 232"
property rgb_Googlebuttonauthorize2 : "27 102 200"
property rgb_Youtubebutton : "255 0 0"
property rgb_Googlelightblue : "232 240 254"
-- url list
-- FIXME-5  : Change the URL list with a right one
property list_urls : {"https://tipeee.com/PUTYOUTNAMEHERE","https://tipeee.com/PUTYOUTNAMEHERE"}
property maxcnt : 8


on run argv
   set login to False
   tell application Browser_ap to activate
   delay 4

   -- (a) - google account and password
   tell application Browser_ap to open location "https://accounts.google.com/signin/v2/identifier?flowName=GlifWebSignIn&flowEntry=ServiceLogin"
   delay 10
   --
   do shell script Cliclick_bin & " t:" & (argv as text) -- FIXME-6 : THIS IS A PARAMETER : THE ACCOUNT NAME
   delay 0.5
   do shell script Cliclick_bin & " kp:" & "return"
   delay 10
   do shell script Cliclick_bin & " t:" & "FIXME PLEASE SET THE COMMON ACCOUNT PASSWORD"  -- FIXME-6 : THIS IS A PARAMETER : THE COMMON PASSWORD
   --
   delay 0.5
   -- do shell script Cliclick_bin & " kp:" & "return"
   -- delay 3
   if not scan_average_box(1020,520,40,80,rgb_Googlebuttonauthorize1,100,False,True) then
      do shell script "osascript -e 'quit app \"firefox\"'"
      return false
   end if

   -- (b) - clipeee main script
   delay 3
   set the_url to some item of list_urls
   tell application Browser_ap to open location the_url
   delay 5
   set n to (random number from 3 to 10) -- FIXME-7 : Number of tries, PUT 1 to 1 IF ONLY ONE TRY AT TIME
   repeat n times
      -- (b.1) main loop from start webpage
      delay 4
      repeat 2 times
         do shell script Cliclick_bin & " kp:" & "arrow-down"
         delay 0.5
      end repeat
      -- yellow orange triangle |> button
      scan_average_box(1280,700,100,100,rgb_Triangle,300,False,True)
      delay 3
      -- (b.2) login step
      if not login then
         -- "clipeee" to "google account" checkbox and blue button
         scan_average_box(580,440,35,35,rgb_Googlecheckbox,500,False,True)
         delay 2
         scan_average_box(930,500,100,40,rgb_Googlebuttonlog,300,False,False)
         delay 3
         -- "google" : select the "upper" logged account (try not to be on bottom)
         if not scan_average_box(700,450,50,50,rgb_Googlelightblue,300,True,True) then
            do shell script "osascript -e 'quit app \"firefox\"'"
            return false
         end if
         -- go down and confirm to google
         delay 3
         repeat 5 times
            do shell script Cliclick_bin & " kp:" & "arrow-down"
            delay 0.5
         end repeat
         if not scan_average_box(850,670,50,100,rgb_Googlebuttonauthorize1,300,False,True) then
            do shell script "osascript -e 'quit app \"firefox\"'"
            return false
         end if
         set login to True
      end if

      delay 5
      -- (b.3) main screen videos : search the lighter within the videos
      set cnt to 0
      repeat while scan_changing_color_box(920,540,500,200,5) and cnt < maxcnt
          delay 5
          set cnt to cnt+1
      end repeat

      if cnt = maxcnt then
         do shell script "osascript -e 'quit app \"firefox\"'"
         return false
      end if

      delay 3

      -- (b.4) search youtube run button /or/ white  then red after some time
      if not scan_average_box(910,480,50,50,rgb_Youtubebutton,50,True,False) then
         if not scan_average_box(910,480,50,50,rgb_White,50,True,False) then -- Try while start first
             do shell script "osascript -e 'quit app \"firefox\"'"
             return false
         else
             delay 20
             if not scan_average_box(910,480,50,50,rgb_Youtubebutton,50,True,False) then -- Try then red start
                do shell script "osascript -e 'quit app \"firefox\"'"
                return false
             end if
         end if
      end if

      set modusone to (random number from 1 to 240)
      set modusbis to (random number from 1 to 240)
      set randomNumber to 65 + (((random number from 1 to 240) mod modusone) mod modusbis)
      delay randomNumber

      -- (b.last) reload back
      tell application "System Events"
         tell process Browser_pr
            keystroke "r" using {command down, shift down}
         end tell
      end tell
   end repeat

   do shell script "osascript -e 'quit app \"firefox\"'"
   return true
end




--
-- Split according to a list of delimiters
-- (from https://erikslab.com/2007/08/31/applescript-how-to-split-a-string/)
--

on theSplit(theString, theDelimiters)
   -- save delimiters to restore old settings
   set oldDelimiters to AppleScript's text item delimiters
   -- set delimiters to delimiter to be used
   set AppleScript's text item delimiters to theDelimiters
   -- create the array
   set theArray to every text item of theString
   -- restore the old setting
   set AppleScript's text item delimiters to oldDelimiters
   -- return the result
   return theArray
end theSplit


--
-- Replace the set of strings by another
-- (from https://stackoverflow.com/questions/38041852/does-applescript-have-a-replace-function)
--

on theReplaceString(theString, theSearchSetOfStrings, theReplacementString)
   -- save delimiters to restore old settings
   set oldDelimiters to AppleScript's text item delimiters
   -- set delimiters to delimiter to be searched for
   set AppleScript's text item delimiters to the theSearchSetOfStrings
   -- create the array
   set theArray to every text item of theString
   -- set delimiters to delimiter to be used as replacement
   set AppleScript's text item delimiters to the theReplacementString
   -- convert the array to string with the new delimiter
   set theString to theArray as string
   -- restore the old setting
   set AppleScript's text item delimiters to oldDelimiters
   -- return the result
   return theString
end replace_chars






---
--- Scan 3 times the same color and click in the average coordinates
---

on scan_average_box(xStart,yStart,xRange,yRange,rgbColor,maxLoopCount,move_mouse,check_button_change)
   --
   set xAvg to 0
   set yAvg to 0
   set xyCount to 0
   set loopCount to 0

   -- Get coordiates with color-match
   repeat while xyCount < 3 and loopCount < maxLoopCount
      set Xtest to xStart + random number from -xRange to xRange
      set Ytest to yStart + random number from -yRange to yRange
      --
      set coords to "" & (Xtest) & "," & (Ytest)
      if move_mouse then
        do shell script Cliclick_bin & " m:" & coords
      end if
      set rgb to do shell script Cliclick_bin & " cp:" & coords
      set rgb to theReplaceString(rgb,{"\r","\n"},"")
      --

      set loopCount to loopCount+1
      if rgb = rgbColor then
         set xAvg to xAvg + Xtest
         set yAvg to yAvg + Ytest
         set xyCount to xyCount + 1
      end if
   end repeat

   if xyCount = 0 then
      return false
   end if


   -- Average coordinates computation
   set xAvg to xAvg div xyCount
   set yAvg to yAvg div xyCount

   -- COLOR CHECK : Get color before moving
   if move_mouse then
      do shell script Cliclick_bin & " m:" & xAvg & "," & yAvg
   end if

   if check_button_change then
      set rgb_before to do shell script Cliclick_bin & " cp:"  & xAvg & "," & yAvg
      set rgb_before to theReplaceString(rgb_before,{"\r","\n"},"")
      delay 0.2
   end if

   -- do a click
   delay 0.3
   do shell script Cliclick_bin & " c:" & xAvg & "," & yAvg
   delay 0.5

   -- COLOR CHECK : do a color check to test if color has changed
   if check_button_change then

      set rgb_after to do shell script Cliclick_bin & " cp:"  & xAvg & "," & yAvg
      set rgb_after to theReplaceString(rgb_after,{"\r","\n"},"")

      set cnt to 0
      repeat while rgb_after = rgb_before and cnt < maxcnt
         delay 0.2
         do shell script Cliclick_bin & " c:" & xAvg & "," & yAvg
         delay 0.5
         set rgb_after to do shell script Cliclick_bin & " cp:"  & xAvg & "," & yAvg
         set rgb_after to theReplaceString(rgb_after,{"\r","\n"},"")
         set cnt to cnt+1
      end repeat

      if cnt = maxcnt then
         return false
      end if

   end if
   return true
end scan_check_box



---
--- stupid click then scan if changing color box
---

on scan_changing_color_box(xStart,yStart,xRange,yRange,maxLoopCount)
   --
   set loopCount to -1
   --
   set rgb_after to ""
   set rgb_before to ""

   -- do a color check to test if color has changed
   repeat while rgb_after = rgb_before and loopCount < maxLoopCount
      -- move away
      do shell script Cliclick_bin & " m:" & 1 & "," & 1
      delay 0.3
      -- take random coordinates
      set xJump to xStart  + random number from -xRange to xRange
      set yJump to yStart  + random number from -yRange to yRange
      -- get color before moving
      set rgb_before to do shell script Cliclick_bin & " cp:"  & xJump & "," & yJump
      set rgb_before to theReplaceString(rgb_before,{"\r","\n"},"")
      -- do a click
      do shell script Cliclick_bin & " c:" & xJump & "," & yJump
      delay 0.3
      -- move away
      do shell script Cliclick_bin & " m:" & 1 & "," & 1
      delay 1.3
      -- get color after
      set rgb_after to do shell script Cliclick_bin & " cp:"  & xJump & "," & yJump
      set rgb_after to theReplaceString(rgb_after,{"\r","\n"},"")
      --
      set loopCount to loopCount+1
      --
   end repeat
   return rgb_after = rgb_before
end scan_changing_color_box
