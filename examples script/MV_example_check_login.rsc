# add in Scheduler with interval 15 sec and name in $SchedName, сhange $userName

:local SchedName "check_loginMV"
:local userName "admin"

:global fVoice
:local lstime ([/system scheduler get value-name=next-run [find name=$SchedName]] - [/system scheduler get value-name=interval [find name=$SchedName]] * 2);
:foreach i in=[/log find message~"user $userName logged in from" && time>=$lstime] do={
[$fVoice admin]};

:foreach i in=[/log find message~"login failure" && time>=$lstime] do={
[$fVoice badlogin]
};

:foreach i in=[/log find message~"authentication failed" && time>=$lstime] do={
[$fVoice badlogin]
};
