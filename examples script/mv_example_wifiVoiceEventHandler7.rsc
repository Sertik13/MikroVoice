# for ROS7 only !
# MikroVoice monitoring new wifi-client connection
# by Sertik 17/10/2024

:global wifiVoiceEventHandler do={
    :global fVoice
    /log warning "On $1 is added a new item $2 $3"
    :if ([:len $3]>0) do={[$fVoice wificonnect]}
    :return 0
}

:execute {
    :global wifiVoiceEventHandler
    /interface wifi registration-table print follow-only where [$wifiVoiceEventHandler "wifi registration" $comment $interface]

}
