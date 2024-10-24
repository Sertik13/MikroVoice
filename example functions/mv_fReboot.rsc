# Voice reboot router

global fReboot do={
:global fVoice
[$fVoice waitreboot]
:delay 5s
/system reboot
}
