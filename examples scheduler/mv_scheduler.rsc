# scheduler examples for MokroVoice
# by Sertik

/system scheduler
add name=start_Mikro_Voice_demo on-event="\r\
    \n:log warning \"Starting MikroVoice system ...\"\r\
    \n:local SMPflag true\r\
    \n:local VoiceLang RUS\r\
    \n:global fSMP\r\
    \n:global fVoice\r\
    \n:global fAlarm\r\
    \n\r\
    \n:delay 10s;\r\
    \n\r\
    \n# setup MikroVoice system functions\r\
    \n    :log warning \"Install system functions ....\"\r\
    \n           :do {\r\
    \n                      /system script run mv_fSMP\r\
    \n                      /system script run mv_fVoice\r\
    \n                      /system script run mv_fAlarm\r\
    \n                   } on-error={:log error \"MikroVoice components is not\
    \_find or crahed\";\r\
    \n                      :set SMPflag false}\r\
    \n     :log warning \"MikroVoice system is set\"\r\
    \n\r\
    \n\r\
    \n:if (\$SMPflag=true) do={\r\
    \n\r\
    \n# reset mp3 module and check it\r\
    \n:log warning \"Checking MP3/Wav Player module ....\"\r\
    \n          :local SMPanswer [\$fSMP reset]\r\
    \n                :if (\$SMPanswer=\"OK\") do={\r\
    \n                      :log warning \"Please wait for Voice system ready \
    ...\"\r\
    \n                      :delay 60s\r\
    \n\r\
    \n#-------  playing introdaction\r\
    \n                      :do {\r\
    \n                               [\$fAlarm imperial]\r\
    \n#                             [\$fSMP playfile 1 11]\r\
    \n                               :log warning \"Playing Imperial ...\"\r\
    \n                               :delay 20s;\r\
    \n                               [\$fVoice hellolong \$VoiceLang]\r\
    \n                               :log warning \"Introdaction MikroVoice\"\
    \r\
    \n                              } on-error={\r\
    \n                                                           :log error \"\
    Error MikroVoice components works\"\r\
    \n                            } \r\
    \n              :log warning \"MikroVoice system is ready !\"\r\
    \n       } else={:log error \$SMPanswer}\r\
    \n}" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add interval=30m name=mv_clock on-event="# MikroVoice voicing the current time\
    \r\
    \n\r\
    \n:do {\r\
    \n      :global fVoice\r\
    \n      :global fAlarm\r\
    \n      :if ([:pick [/system clock get time] 3 5]=30)\\\r\
    \n           do={\r\
    \n               \$fAlarm clock_cuckoo\r\
    \n              } else={\r\
    \n               \$fVoice (\"h\".\"\$[:pick [/system clock get time] 0 2]\
    \")\r\
    \n              }\r\
    \n    } on-error={}" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=jun/28/2024 start-time=00:00:00
