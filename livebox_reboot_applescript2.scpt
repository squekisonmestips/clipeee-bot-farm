#!/usr/bin/osascript

-- exec parameters
property Cliclick_bin : "sudo /opt/local/bin/cliclick "
property Browser_ap : "Firefox"
property Browser_pr : "firefox"
property rgb_PinkCookie : "222 37 84"
property rgb_PinkRenew :  "242 51 105"
property rgb_GrayNoLink:  "42 42 46"
property rgb_White:  "255 255 255"
property rgb_YellowIsh: "255 250 231"
property maxcnt : 15

on run argv
   delay 1
   do shell script "echo '' > ~/Documents/proxy.pac"
   delay 1
   tell application Browser_ap to activate
   delay 1
   tell application Browser_ap to open location "https://espace-client.orange.fr/equipements/FIXME-1XXXXXXXXX/XX00X/internet"
   delay 5
   do shell script Cliclick_bin & " c:540,548"
   --do shell script Cliclick_bin & " kp:" & "tab"
   --do shell script "issw com.apple.keylayout.USInternational-PC"
   delay 1
   do shell script Cliclick_bin & " t:" & "FIXME2-PUT-PASSWORD-HERE"
   do shell script Cliclick_bin & " kp:" & "return"
   delay 1
   --do shell script "issw com.apple.keylayout.French"
   --delay 1
   tell application Browser_ap to open location "https://espace-client.orange.fr/equipements/FIXME-1XXXXXXXXX/XX00X/internet"
   delay 5
   scan_average_box(900,710,30,30,rgb_PinkCookie,10,False,False)
   delay 1
   repeat 5 times
      do shell script Cliclick_bin & " kp:" & "arrow-down"
      delay 0.5
   end repeat
   --delay 2
   --do shell script Cliclick_bin & " c:1250,740" -- hotspot link
   delay 2
   do shell script Cliclick_bin & " c:500,740" -- renew IP link
   delay 5
   scan_average_box(1150,560,30,10,rgb_YellowIsh,10,False,False)
   do shell script Cliclick_bin & " c:1150,560"  -- yellowish button
   delay 5

   -- load the httpbin web page
   tell application Browser_ap to open location "http://httpbin.org/ip"
   delay 15

   set cnt to 0
   --- now check FIRST gray screen (infitely ?)
   repeat while not scan_average_box(900,150,300,10,rgb_GrayNoLink,15,True,False) and cnt < maxcnt
      delay 15
      set cnt to cnt+1
      -- reload the tab
      tell application "System Events"
         tell process Browser_pr
            keystroke "r" using {command down, shift down}
         end tell
      end tell
   end repeat
   if cnt = maxcnt then
      do shell script "osascript -e 'quit app \"firefox\"'"
      return false
   end if

   --- then check AFTER white screen (infitely ?)
   set cnt to 0
   repeat while not scan_average_box(900,150,300,10,rgb_White,15,True,False) and cnt < maxcnt
      delay 30
      set cnt to cnt+1
      -- reload the tab
      tell application "System Events"
         tell process Browser_pr
            keystroke "r" using {command down, shift down}
         end tell
      end tell
   end repeat
   if cnt = maxcnt then
      do shell script "osascript -e 'quit app \"firefox\"'"
      return false
   end if

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
        do shell script Cliclick_bin & " m:" & xTest & "," & yTest
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

