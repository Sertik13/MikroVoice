# rextended wireless on off with mode button
# https://forum.mikrotik.com/viewtopic.php?f=7&t=115078&p=857648#p857648
# for MikroVoice updated by Sertik

/system leds
:if ([:len [find where leds=user-led]] < 1) do={add leds=user-led type=on}
:log info "user-led on"
:global $fVoice
/interface wireless
:if ([get [find default-name=wlan1] disabled]) do={
    :log info "Wi-Fi activated"
    set [find] disabled=no
    [$fVoice wifion]
    /sys leds set [find where leds=user-led] type=on
} else={
    :log info "Wi-Fi disactivated"
    set [find] disabled=yes
    [$fVoice wifioff]
    /sys leds set [find where leds=user-led] type=off
}

###########################################

/system routerboard mode-button
set enabled=yes on-event="/system leds\r\
    \n:if ([:len [find where leds=user-led]] < 1) do={add leds=user-led type=on}\r\
    \n:log info \"user-led on\"\r\
    \n:global $fVoice\r\
    \n/interface wireless\r\
    \n:if ([get [find default-name=wlan1] disabled]) do={\r\
    \n :log info \"Wi-Fi activated\"\r\
    \n set [find] disabled=no\r\
    \n [$fVoice wifion]\r\
    \n /sys leds set [find where leds=user-led] type=on\r\
    \n} else={\r\
    \n :log info \"Wi-Fi disactivated\"\r\
    \n set [find] disabled=yes\r\
    \n [$fVoice wifioff]\r\
    \n /sys leds set [find where leds=user-led] type=off\r\
    \n}\r\
    \n"
