# example add MikroVoice in DHCP-client script

/ip dhcp-client set [/ip dhcp-client find] script=\
"# script dhcp-client MikroVoice System;\
 # by Sertik 20/06/2024;\
 #
  :global fSMP;
  :global fVoice;
  :if (\$bound=1) do={
:do {
     :put [\$fSMP stop]
     :put [\$fVoice dhcpclient]
        } on-error={}
   :delay 5s
   :if ([/ping 8.8.8.8 count=3 interface=\$interface]>1) do={\
        :put [\$fVoice inetok]
      } else={\
        :put [\$fVoice inetno]} 
}"