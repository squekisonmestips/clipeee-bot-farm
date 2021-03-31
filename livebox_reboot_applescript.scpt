#!/usr/bin/osascript

-- exec parameters
property Cliclick_bin : "sudo /opt/local/bin/cliclick "
property Browser_ap : "Firefox"
property Browser_pr : "firefox"

on run argv
   delay 1
   do shell script "echo '' > ~/Documents/proxy.pac"
   delay 1
   tell application Browser_ap to activate
   delay 1
   tell application Browser_ap to open location "http://192.168.1.1"
   delay 1
   do shell script Cliclick_bin & " kp:" & "tab"
   delay 1
   do shell script "issw com.apple.keylayout.USInternational-PC"
   delay 1
   do shell script Cliclick_bin & " t:" & "FIXME1-put-password-here"
   do shell script Cliclick_bin & " kp:" & "return"
   delay 1
   do shell script "issw com.apple.keylayout.French"
   delay 1
   tell application Browser_ap to open location "http://192.168.1.1/supportRestart.html"
   delay 2
   do shell script Cliclick_bin & " tc:900,500"
   delay 1
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



