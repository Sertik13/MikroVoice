# for ROS 6!
# Voice NTP synchro

:do {
:global pntp [:resolve "0.ru.pool.ntp.org"]
:global sntp [:resolve "1.ru.pool.ntp.org"]
} on-error={:error "NTP servers not responded"}

:if ([/system ntp client get status]!="synchronized") do={

[/system ntp client set enable=no]
/system ntp client set primary-ntp=$pntp;
/system ntp client set secondary-ntp=$sntp;
[/system ntp client set enable=yes]
:delay 5s
:global fVoice
:if ([/system ntp client get status]="synchronized") do={[$fVoice ntpok]} else={[$fVoice ntpno]}

}
