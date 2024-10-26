#
# MikroVoice mikroTelegramTerminal by Sertik 26/10/2024
# -----------------------------------------------


# Telegram chat settings:
:local Emoji "%F0%9F%93%A2"
:local Esys "$Emoji$[/system identity get name]%0A"
:local TToken "XXXXXXXXXX:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
:local TChatId "YYYYYYYYY"



# allowed commands:
:local arrayCom [:toarray {"SMP"="accessing the mp3 player support function fSMP";
                           "Voice"="calling the fVoice function of the router's notification system";
                           "Alarm"="alarm clocks, special sounds and crashes";
                           "Funny"="jokes and aphorisms"}]


#main body script
/system script run JParseFunctions
:global Toffset
:if ([:typeof $Toffset] != "num") do={:set Toffset 0}
do {
:global JSONIn [/tool fetch url="https://api.telegram.org/bot$TToken/getUpdates\?chat_id=$TChatId&offset=$Toffset" as-value output=user]; :set JSONIn ($JSONIn->"data")
} on-error={:set $JSONIn []}
:global fJParse
:global fJParsePrintVar
:global Jdebug false
:global JParseOut [$fJParse]
:local Results ($JParseOut->"result")

# -----------------
:if ([:len $Results]>0) do={
:local TXT
  :foreach k,v in=$Results do={
    :if (any ($v->"message"->"text")) do={
     :local cmd ($v->"message"->"text")
     :local cmdR 
:if ([:len [:find $cmd " "]]=0) do={:set cmdR $cmd} else={:set cmdR [:pick $cmd 0 [:find $cmd " "]]}
      :local prefix "/"
      :local cmdrun 0

# executing special commands "list" (output commands to chat)
 :if ($cmdrun=0) do={
  :if (($cmd="list") or ($cmd=$prefix."list")) do={
  :local cmdlist; :foreach t,n in=$arrayCom do={:set $cmdlist ("$cmdlist"."/$t "."- "."$n"."\n")}
   /tool fetch url="https://api.telegram.org/bot$TToken/sendmessage\?chat_id=$TChatId"  \
    http-method=post  http-data="text=$Emoji $[/system identity get name] MikroVoice terminal commands:%0A$cmdlist" keep-result=no; set cmdrun 1
 }
}

# executing commands from a list arrayCom
   :if ($cmdrun=0) do={   
        :foreach key,val in=$arrayCom do={
              :if (($cmdR=$key) or ($cmdR=$prefix.$key)) do={
                         if ($cmdR=$prefix.$key) do={:set cmd [:pick $cmd ([:find $cmd $prefix]+1) [:len $cmd]]}
                          :local VTTanswer; 
                         :do {                  
                            :set cmd ("\$f"."$cmd")
                            :set cmdR ("f"."$key")
                            :set VTTanswer [[:parse ":global $cmdR; :return [$cmd]"]]
                          } on-error={:set TXT "ERROR call to MikroVoiceSys"; log error ("$TXT "$VTTanser");}
                                  :set cmdrun 1;
                                 :set TXT ("Executing command MikroVoice system in progress <- $cmd -> %0A")
                                /tool fetch url="https://api.telegram.org/bot$TToken/sendmessage\?chat_id=$TChatId" \
                                 http-method=post  http-data="text=$Esys $TXT $VTTanswer" keep-result=no;
              }
       }
 }

    :set $Toffset ($v->"update_id" + 1)}
  }  
} else={ 
  :set $Toffset 0;
}
