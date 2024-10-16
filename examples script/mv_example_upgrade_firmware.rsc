
# firmware upgrade

global fVoice
:delay 10s
/system routerboard
:if ([get current-firmware] != [get upgrade-firmware]) do={
    upgrade
    :delay 10s
	[$fVoice firmware]
	:delay 3s
	[$fVoice rebooting]
	:delay 2s
    /system reboot
}