
:local SchedName "check_loginMV"
:global fVoice
:local lstime ([/system scheduler get value-name=next-run [find name=$SchedName]] - [/system scheduler get value-name=interval [find name=$SchedName]] * 2);
:foreach i in=[/log find message~"user puhel13 logged in from" && time>=$lstime] do={
[$fVoice admin]};

:foreach i in=[/log find message~"login failure" && time>=$lstime] do={
[$fVoice badlogin]
};

:foreach i in=[/log find message~"authentication failed" && time>=$lstime] do={
[$fVoice badlogin]
};