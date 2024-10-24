# function Voice check service
# by Sertik 24/10/2024 for MikroVoice example

:global fCheckService do={

:if ($1="help") do={
:put ""
:put "function Voice check service 1.0"
:put "by Sertik 24/10/2024 for MikroVoice"
:put "$0 ftp"
:put "$0 telnet"
:put "$0 ssh"
:put "$0 snmp"
:put "$0 smb"
:put "$0 romon"
:put "$0 dude"
:put "$0 all"
:return []}


:global fVoice
:if ($1="ftp") do={
:local Vftp
:if ([/ip service get ftp disabled]) do={[$fVoice ftpoff]; :set Vftp off} else={[$fVoice ftpon]; :set Vftp on}
:delay 3s
:return $Vftp}

:if ($1="telnet") do={
:local Vtelnet
:if ([/ip service get telnet disabled]) do={[$fVoice telnetoff]; set Vtelnet off} else={[$fVoice telneton]; :set Vtelnet on}
:delay 3s
:return $Vtelnet}

:if ($1="ssh") do={
:local Vssh
:if ([/ip service get ssh disabled]) do={[$fVoice sshoff]; :set Vssh off} else={[$fVoice sshon]; set Vssh on}
:delay 5s
:return $Vssh}

:if ($1="snmp") do={
:local Vsnmp
:if ([/snmp get enabled]) do={[$fVoice snmpon]; :set Vsnmp on} else={[$fVoice snmpoff]; :set Vsnmp off}
:delay 5s
:return $Vsnmp}

:if ($1="smb") do={
:local Vsmb
:if (([/ip smb get enabled]=true) or ([/ip smb get enabled]=auto)) do={[$fVoice sambaon]; :set Vsmb on} else={[$fVoice sambaoff]; :set Vsmb off}
:delay 3s
:return $Vsmb}

:if ($1="romon") do={
:local Vromon
:if ([/tool romon get enabled]) do={[$fVoice romonon]; :set Vromon on} else={[$fVoice romonoff]; :set Vromon off}
:delay 3s
:return $Vromon}

:if ($1="dude") do={
:local Vdude "package not set in system"
:do {
:if ([/dude get enabled]) do={[$fVoice dudeon]; :set Vdude on} else={[$fVoice dudeoff]; :set Vdude off}
:delay 3s
} on-error={}
:return $Vdude}

:if ($1="all") do={
:if (!any $fVoice) do={:return "Voice system not set"}
:put ""
:put "Voice checking services:"
:put ""
:put ("ftp "."$[[:parse "global $[:pick $0 1 [:len $0]]; return [$0 ftp]"]]")
:put ("telnet "."$[[:parse "global $[:pick $0 1 [:len $0]]; return [$0 telnet]"]]")
:put ("ssh "."$[[:parse "global $[:pick $0 1 [:len $0]]; return [$0 ssh]"]]")
:put ("snmp "."$[[:parse "global $[:pick $0 1 [:len $0]]; return [$0 snmp]"]]")
:put ("smb "."$[[:parse "global $[:pick $0 1 [:len $0]]; return [$0 smb]"]]")
:put ("romon "."$[[:parse "global $[:pick $0 1 [:len $0]]; return [$0 romon]"]]")
:put ("dude "."$[[:parse "global $[:pick $0 1 [:len $0]]; return [$0 dude]"]]")

:put ("verification of the services has been completed"); :return []}

}
