# MikroVoice monitoring new ppp-client VPN connections
# by Sertik 29/08/2024

:global pppVoiceEventHandler do={
    :global fVoice
    /log warning "On $1 is added a new item $2 $3"
    :if ([:len $2]>0) do={[$fVoice vpnconnect]} else={[$fVoice vpndisconnect]}
    :return []
}

:execute {
    :global pppVoiceEventHandler
    /ppp active print follow-only where [$pppVoiceEventHandler "ppp active" $name $"caller-id"]

}