:local allowedIP "allowedList"
/ip dhcp-server lease
:foreach i in=[find] do={
    :local addrTMP [get $i address]
    :if ([get $i status]="bound" && ![get $i dynamic]) do={
        :do {/ip firewall address-list add address=$addrTMP list=$allowedIP
                 :global $fVoice
                  $fVoice addaddress
            } on-error={}
    } else={
        :do {/ip firewall address-list remove [find address=$addrTMP list=$allowedIP]} on-error={}
    }
} 