
# only ROS 6
# Voice inform about run services

:global fVoice
:if ([/ip service get ftp disabled]) do={[$fVoice ftpoff]} else={[$fVoice ftpon]}
:delay 3s
:if ([/ip service get telnet disabled]) do={[$fVoice telnetoff]} else={[$fVoice telneton]}
:delay 3s
:if ([/ip service get ssh disabled]) do={[$fVoice sshoff]} else={[$fVoice sshon]}
:delay 5s
:if ([/snmp get enabled]) do={[$fVoice snmpon]} else={[$fVoice snmpoff]}
:delay 5s
:if ([/ip smb get enabled]) do={[$fVoice sambaon]} else={[$fVoice sambaoff]}
:delay 3s
:if ([/tool romon get enabled]) do={[$fVoice romonon]} else={[$fVoice romonoff]}
:delay 3s
:do {
:if ([/dude get enabled]) do={[$fVoice dudeon]} else={[$fVoice dudeoff]}
:delay 3s
} on-error={}
