# Voice check login
# for Ros 7 only !
# add in Scheduler with interval 15 sec and name in $SchedName, сhange $userName


:local SchedName "check_loginMV"
:local userName "admin"

:global fVoice

:local Stime ([pick [/system scheduler get value-name=next-run [find name=$SchedName]] 11 19] - [/system scheduler get value-name=interval [find name=$SchedName]] *2); 
:foreach i in=[/log find message~"user $userName logged in from" && time>=$Stime] do={
[$fVoice admin]};

:foreach i in=[/log find message~"login failure" && time>=$Stime] do={
[$fVoice badlogin]
};

:foreach i in=[/log find message~"authentication failed" && time>=$Stime] do={
[$fVoice badlogin]
};
