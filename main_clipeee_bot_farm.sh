#!/bin/bash

#
# FIXME-1-put at the end of the file "/etc/sudoers" the lines by "sudo nano /etc/sudoers", 
#
# "yourusername" ALL=(ALL) NOPASSWD: /sbin/ifconfig
# "yourusername" ALL=(ALL) NOPASSWD: /usr/sbin/networksetup
# "yourusername" ALL=(ALL) NOPASSWD: /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport
# "yourusername" ALL=(ALL) NOPASSWD: /opt/local/bin/brightness
#
# FIXME-1 the last line is not needed unless you want the "brightness" to be set automaticly to "0", you must INSTALL the tool brightness (macport install here)
#

accounts=("FIXME-2-PUT-A-GOOGLE-ACCOUNT-HERE" "FIXME-2-PUT-A-GOOGLE-ACCOUNT-HERE")
ethemacs=("3a:e3:c1:a5:42:4f" "3a:e3:c1:a5:42:4f")
en="en1"

while true
do
    size=${#accounts[@]}
    echo "${#accounts[@]} < ${#ethemacs[@]}"
    
    index=$(($RANDOM % $size))
    account=${accounts[$index]}
    ethemac=${ethemacs[$index]}
    
    echo ${account}
    echo $ethemac
    sleep 4
    
    # (1.1) reset firefox, by default i was using a proxy.pac with ///USERNAME/Documents/proxy
    osascript -e 'quit app "firefox"'
    #echo "" > ~/Documents/proxy.pac
    
    # (1.2) restart network with new mac adresss # FIXME - COMMENT-THIS-IF-UNNEEDED
    sudo /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -z
    sudo /sbin/ifconfig ${en} ether ${ethemac}
    sudo /usr/sbin/networksetup -detectnewhardware
    sudo /usr/sbin/networksetup -setnetworkserviceenabled Wi-Fi off
    sudo /usr/sbin/networksetup -setnetworkserviceenabled Wi-Fi on
    sudo /opt/local/bin/brightness 0
    
    NMAX=4800 # FIXME-3 : PUT 30 TO TEST AND NOT 4800
    # (1.3) natural timing

    # "mostly" night sleep
    if [[ $(date +%-H) -lt 7 ]]; then
        sleep $(( $RANDOM % $NMAX + 1  ))
    fi

    # "opening day" low activity
    if [[ $(date +%-H) -lt 10 ]]; then
        sleep $(( $RANDOM % (  $RANDOM % $NMAX + 1 ) ))
    fi

    # "beginning of night" lower activity
    if [[ $(date +%-H) -gt 22 ]]; then
        sleep $(( $RANDOM % ( $RANDOM % ( $RANDOM % $NMAX + 1 ) + 1 ) ))
    fi

    # "after 16"
    if [[ $(date +%-H) -gt 16 ]]; then
        sleep $(( $RANDOM % ( $RANDOM % ( $RANDOM % ( $RANDOM % $NMAX + 1 ) + 1 ) + 1 ) ))
    fi

    # "before 12"
    if [[ $(date +%-H) -lt 12 ]]; then
        sleep $(( $RANDOM % ( $RANDOM % ( $RANDOM % ( $RANDOM % $NMAX + 1 ) + 1 ) + 1 ) ))
    fi
    
    sleep $(( $RANDOM % ( $RANDOM % ( $RANDOM % (  $RANDOM % $NMAX + 1 ) + 1 ) + 1 ) ))

    # (2.1) run the script
    /Applications/Firefox.app/Contents/MacOS/firefox https://httpbin.org/ip &
    sleep 7
    t=$(( $RANDOM % 4 ))
    if [[ ${t} -gt 2 ]]; # 1/4
    then
	/FIXME-4/PUT_THE_GLOBAL_DIR_TO_SCRIPT/google_validate_applescript.scpt ${account}
    else
        /FIXME-4/PUT_THE_GLOBAL_DIR_TO_SCRIPT/clipeee_applescript.scpt ${account}
    fi
done
