# sep/29/2024 23:22:27 by RouterOS 6.49.17
# software id = GVIU-V57A
#
# model = RouterBOARD mAP 2nD
# serial number = 71DF06E95471
/system script
add dont-require-permissions=no name=fVoice owner=puh policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#\
    !rsc by RouterOS\r\
    \n# RouterOS script: mv_fVoice\r\
    \n# Copyright (c) 2023-2024 Sertik (Sergey Serkov) <mikrovoice@bk.ru>\r\
    \n# https://github.com/Sertik13/MikroVoice/blob/main/LICENSE\r\
    \n#\r\
    \n# The ROS version is required to be at least version 6.43\r\
    \n#\r\
    \n# Universal network event voiceover function for mp3 Catalex YX5300/6300\
    , DF Player Pro and BT201\r\
    \n#\r\
    \n\r\
    \n\r\
    \n:global fVoice do={\r\
    \n\r\
    \n  :global SMPport\r\
    \n  :global VoiceFlag\r\
    \n  :global VoiceActive\r\
    \n  :global VoiceFolder 2; # default RUS\r\
    \n  :local fFL7Lang \"MikroVoiceLang\"\r\
    \n  :local MVLang\r\
    \n  :local LangRUS 2; #RUS=folder2\r\
    \n  :local LangENG 3; #ENG=folder3\r\
    \n  :local LangCNR 4; #CNR=folder4\r\
    \n  :global fSMP\r\
    \n  :local SMPflag true\r\
    \n\r\
    \n  :if ([:typeof \$VoiceActive]!=\"bool\") do={:set VoiceActive true}\r\
    \n  \r\
    \n  :if (\$1=\"ON\") do={:set VoiceActive true; \r\
    \n     :put \"Voice system activated\"\r\
    \n     :log warning \"Voice system activated\"\r\
    \n     :do {\r\
    \n     :global fVoice; [\$fVoice voice_active];\r\
    \n      } on-error={}\r\
    \n     :return \"ON\"}\r\
    \n  :if (\$1=\"OFF\") do={:set VoiceActive false;\r\
    \n     :put \"Voice system disactivated\"\r\
    \n     :log warning \"Voice system disactivated\"\r\
    \n     :return \"OFF\"}\r\
    \n\t \r\
    \n  :if (\$1=\"STATUS\") do={\r\
    \n      :do {\r\
    \n      :if (\$VoiceActive) do={:return \"ON\"}\r\
    \n      :if (!\$VoiceActive) do={:return \"OFF\"}\r\
    \n\t      } on-error={:return \"set incorrect\"}\r\
    \n       }\r\
    \n\t   \r\
    \n  :if (\$1=\"help\") do={\r\
    \n  :put \"\"\r\
    \n  :put \"function \$0 for MikroVoice system\"\r\
    \n  :put (\"\$0\".\" list \")\r\
    \n  :put (\"\$0\".\" find \". \"xxx\")\r\
    \n  :put (\"\$0\".\" ON \".\"- voice activated\")\r\
    \n  :put (\"\$0\".\" OFF \".\"- voice disactivated\")\r\
    \n  :put (\"\$0\".\" STATUS \".\"- voice get active\")\r\
    \n  :put (\"\$0\".\" lang \".\"RUS/ENG/CNR\")\r\
    \n  :put (\"\$0\".\" stop\")\r\
    \n  :put (\"\$0\".\" pause\")\r\
    \n  :put (\"\$0\".\" playback\")\r\
    \n  :put (\"\$0\".\" stop\")\r\
    \n  :put \"\"\r\
    \n  }\r\
    \n\r\
    \n  :do {\r\
    \n     :if (!any \$fSMP) do={:global fSMP; /system script run mv_fSMP}; \r\
    \n         } on-error={:set SMPflag false}\r\
    \n\r\
    \n\r\
    \n   :if (!\$SMPflag) do={:return \"Error: no SMP function\"}\r\
    \n   \r\
    \n      :if ([:len [/ip firewall layer7-protocol find name=\$fFL7Lang]]!=0\
    ) do={\r\
    \n                :set MVLang [/ip firewall layer7-protocol get [find name\
    =\$fFL7Lang] regexp]\r\
    \n                    :if ((\$MVLang=\"RUS\") or (\$MVLang=\"ENG\") or (\$\
    MVLang=\"CNR\")) do={\r\
    \n                    :if (\$MVLang=\"RUS\") do={set VoiceFolder \$LangRUS\
    }\r\
    \n                    :if (\$MVLang=\"ENG\") do={:set VoiceFolder \$LangEN\
    G}\r\
    \n                    :if (\$MVLang=\"CNR\") do={:set VoiceFolder \$LangCN\
    R} \r\
    \n    }\r\
    \n  } \r\
    \n\r\
    \n   :if (([:typeof \$2]=\"str\") and ((\$2=\"ENG\") or (\$2=\"RUS\") or (\
    \$2=\"CNR\"))) do={\r\
    \n         :if (\$2=\"RUS\") do={:set VoiceFolder \$LangRUS}\r\
    \n         :if (\$2=\"ENG\") do={:set VoiceFolder \$LangENG}\r\
    \n         :if (\$2=\"CNR\") do={:set VoiceFolder \$LangCNR} \r\
    \n     }\r\
    \n\r\
    \n:local AlertVoice do={\r\
    \n :global VoiceFolder\r\
    \n :global VoiceFlag\r\
    \n :global fSMP\r\
    \n  :local alertJingle 114\r\
    \n  :local importantJingle 113\r\
    \n  :local currentJingle 112\r\
    \n:if ([:len \$1]=1) do={:set \$1 [:tonum \$1]}\r\
    \n:if ((\$VoiceFlag>0) or ([:len \$1]=1)) do={\r\
    \n  :if ((\$VoiceFlag=1) or (\$1=1)) do={\r\
    \n       :do {\r\
    \n               [\$fSMP playfile \$VoiceFolder \$currentJingle]\r\
    \n                } on-error={:return \"Error \$0 function call MikroVoice\
    \_module function fSMP\"}\r\
    \n               :delay 5s\r\
    \n              }\r\
    \n  :if ((\$VoiceFlag=2) or (\$1=2)) do={\r\
    \n       :do {\r\
    \n               [\$fSMP playfile \$VoiceFolder \$importantJingle]\r\
    \n                } on-error={:return \"Error \$0 function call MikroVoice\
    \_module function fSMP\"}\r\
    \n              :delay 5s\r\
    \n              }\r\
    \n  :if ((\$VoiceFlag=3) or (\$1=3)) do={\r\
    \n       :do {\r\
    \n               [\$fSMP playfile \$VoiceFolder \$alertJingle]\r\
    \n                } on-error={:return \"Error \$0 function call MikroVoice\
    \_module function fSMP\"}\r\
    \n              :delay 5s\r\
    \n              }\r\
    \n   } else={\r\
    \n# add option play jingle predalarm 5s (in local AlertVoice)\r\
    \n       :do {  :global fAlarm\r\
    \n              :if ([\$fAlarm find \$1]=true) do={[\$fAlarm \$1]; :delay \
    5s; [\$fSMP stop]\r\
    \n              }\r\
    \n   }\r\
    \n}\r\
    \n:return []}\r\
    \n\r\
    \nlocal ArrayComVoice {\r\
    \nhellolong=1\r\
    \ninform=2\r\
    \nstart=3\r\
    \nreboot=4\r\
    \nhello=5\r\
    \nstartset=6\r\
    \ninetcheck=7\r\
    \nwanmain=8\r\
    \nwanreserve=9\r\
    \ninetok=10\r\
    \ninetno=11\r\
    \ninetblock=12\r\
    \ninetrestore=13\r\
    \nwaitreboot=14\r\
    \nrebooting=15\r\
    \nshutdown=16\r\
    \nfirewalloff=17\r\
    \nfirewallon=18\r\
    \nrosavaliable=19\r\
    \nvpnenable=20\r\
    \nvpndisable=21\r\
    \nvpnconnect=22\r\
    \nvpndisconnect=23\r\
    \n\"wifi+\"=24\r\
    \nwifion=25\r\
    \n\"wifi-\"=26\r\
    \nwifioff=27\r\
    \nquestwifion=28\r\
    \nguestwifioff=29\r\
    \n\"lte+\"=30\r\
    \nlteon=31\r\
    \n\"lte-\"=32\r\
    \nlteoff=33\r\
    \ndudeon=34\r\
    \ndudeoff=35\r\
    \nbackup=36\r\
    \n\"backup_saved\"=37\r\
    \n\"backup_saved_disk\"=38\r\
    \n\"backup_saved_cloud\"=39\r\
    \nwaitrestore=40\r\
    \nrestoreok=41\r\
    \nrestore=42\r\
    \nfirmware=43\r\
    \ntelegram=44\r\
    \nhealthcare=45\r\
    \nsmssend=46\r\
    \nsmsin=47\r\
    \nmailsend=48\r\
    \ninetnot=49\r\
    \nswitchmain=50\r\
    \nswitchreserve=51\r\
    \n\"dhcp_client+\"=52\r\
    \n\"dhcp_client-\"=53\r\
    \ndhcpoff=54\r\
    \ndhcpon=55\r\
    \nconsole=56\r\
    \nbadlogin=57\r\
    \nadmin=58\r\
    \n\"change_password\"=61\r\
    \n\"change_password_ok\"=62\r\
    \ngpson=63\r\
    \ngpsoff=64\r\
    \nusbreset=65\r\
    \nattack=66\r\
    \nattackfix=67\r\
    \naddressblock=68\r\
    \ndispleyoff=69\r\
    \ndispleyon=70\r\
    \nftpon=71\r\
    \nftpoff=72\r\
    \ntelneton=73\r\
    \ntelnetoff=74\r\
    \nsambaon=75\r\
    \nsambaoff=76\r\
    \nsshon=77\r\
    \nsshoff=78\r\
    \nmodbuson=79\r\
    \nmodbusoff=80\r\
    \nsnmpon=81\r\
    \nsnmpoff=82\r\
    \npingno=83\r\
    \npingok=84\r\
    \nromonon=85\r\
    \nromonoff=86\r\
    \nradiuson=87\r\
    \nradiusoff=88\r\
    \nportblocked=89\r\
    \nlogclear=90\r\
    \nservicelog=91\r\
    \ndhcpclient=92\r\
    \ngatewayok=93\r\
    \ngatewayno=94\r\
    \npowerdown=95\r\
    \n\"power_reserve\"=96\r\
    \npowerup=97\r\
    \ngreeting=98\r\
    \ncopiright=99\r\
    \n100=100\r\
    \ncheckwork=101\r\
    \nntpok=102\r\
    \nntpno=103\r\
    \ntimedatenoset=104\r\
    \ntimedatewrong=105\r\
    \nntpcloud=106\r\
    \ntimedateset=107\r\
    \ntimedateupdate=108\r\
    \nread=109\r\
    \nwrite=110\r\
    \nadmininform=111\r\
    \naccident=112\r\
    \nimportant=113\r\
    \ncurrent=114\r\
    \n\"voice_active\"=115\r\
    \nrus=116\r\
    \neng=117\r\
    \ncnr=118\r\
    \n\"newDHCP\"=119\r\
    \n\"newUserDHCP\"=120\r\
    \n\"userDHCPblocked\"=121\r\
    \n\"userWIFIblocked\"=122\r\
    \naddroute=123\r\
    \naddmarkroute=124\r\
    \ndelroute=125\r\
    \ndelmarkroute=126\r\
    \ndelinactroute=127\r\
    \nfirewallreset=128\r\
    \nfirewallinactreset=129\r\
    \naddscript=130\r\
    \ndelscript=131\r\
    \naddsched=132\r\
    \nactsched=133\r\
    \ndelsched=134\r\
    \naddadrlist=135\r\
    \naddaddress=136\r\
    \ndeladdress=137\r\
    \naddintlist=138\r\
    \n\"VPNinactreconnect\"=139\r\
    \n\"LTEinactreconnect\"=140\r\
    \n\"PPPinactreconnect\"=141\r\
    \n\"VPNreset\"=142\r\
    \nsslclient=143\r\
    \nsslserver=144\r\
    \npassword=145\r\
    \nmodeminit=146\r\
    \nwaitmodem=147\r\
    \ncelupdate=148\r\
    \nati=149\r\
    \ncregok=150\r\
    \ncregno=151\r\
    \nmodemreset=152\r\
    \nrssiok=153\r\
    \nrssilow=154\r\
    \nspeedhigh=155\r\
    \nspeedlow=156\r\
    \n\"modem_inetok\"=157\r\
    \n\"modem_inetno\"=158\r\
    \n\"firmware_lte\"=159\r\
    \n\"firmware_lte_ok\"=160\r\
    \n\"firmware_lte_error\"=161\r\
    \nusbconnect=162\r\
    \nusbnas=163\r\
    \nusbdisk=164\r\
    \nusblan=165\r\
    \nusbmodem=166\r\
    \nusbserial=167\r\
    \nusbno=168\r\
    \nusbbusy=169\r\
    \nusbinactive=170\r\
    \nmainofficeno=171\r\
    \nmainofficeok=172\r\
    \nfilialno=173\r\
    \nfilialok=174\r\
    \nvpnmain=175\r\
    \nvpnreserve=176\r\
    \nvpnmainno=177\r\
    \nvpnreserveok=178\r\
    \nvpnclientno=179\r\
    \nvpnclientok=180\r\
    \nvpnunstable=181\r\
    \nspeedvpnhigh=182\r\
    \nspeedvpnmiddle=183\r\
    \nspeedvpnlow=184\r\
    \nfetchint=185\r\
    \nfetchintans=186\r\
    \nfetchext=187\r\
    \nfetchextans=188\r\
    \ncpu90=189\r\
    \ncpu100=190\r\
    \ncpuload=191\r\
    \nimport=192\r\
    \ninkey=193\r\
    \n\"enter_login\"=194\r\
    \n\"enter_password\"=195\r\
    \n\"enter_key\"=196\r\
    \n\"enter_yn\"=197\r\
    \nwifitimerange=198\r\
    \ninettimerange=199\r\
    \nblock=200\r\
    \nunblock=201\r\
    \ntesendactive=202\r\
    \ntesendlogin=203\r\
    \ntesend=204\r\
    \nwifistop=205\r\
    \nwifistart=206\r\
    \nwifirun=207\r\
    \nwifiactive=208\r\
    \nwificonnect=209\r\
    \nwifiout=210\r\
    \nwificome=211\r\
    \nwifishutdown=212\r\
    \nwifilimit=213\r\
    \nltelimit=214\r\
    \ndelfiles=215\r\
    \nmikrotik=216\r\
    \nforum=217\r\
    \nforumrus=218\r\
    \nsertik=219\r\
    \nvoicetimerun=220\r\
    \nh00=221\r\
    \nh01=222\r\
    \nh02=223\r\
    \nh03=224\r\
    \nh04=225\r\
    \nh05=226\r\
    \nh06=227\r\
    \nh07=228\r\
    \nh08=229\r\
    \nh09=230\r\
    \nh10=231\r\
    \nh11=232\r\
    \nh12=233\r\
    \nh13=234\r\
    \nh14=235\r\
    \nh15=236\r\
    \nh16=237\r\
    \nh17=238\r\
    \nh18=239\r\
    \nh19=240\r\
    \nh20=241\r\
    \nh21=242\r\
    \nh22=243\r\
    \nh23=244\r\
    \nvoicetimestop=245\r\
    \n}\r\
    \n\r\
    \n#-----------------------------------------------------------------------\
    -----\r\
    \n# main function`s code\r\
    \n# ----------------------------------------------------------------------\
    -----\r\
    \n\r\
    \n\r\
    \n:if ([:len \$1]=0) do={:return \"Error: no set name command/name jingle\
    \"}\r\
    \n\r\
    \n   :if (\$1=\"list\") do={\r\
    \n      :put \"\"; :put \"<---- List \$0 jingles name in function ---->\"\
    \r\
    \n          :foreach k,v in=\$ArrayComVoice do={\r\
    \n      :if ([:len \$2]>0) do={\\\r\
    \n          :if ([:len [:find \$k \$2]]>0) do={:put \$k}\\\r\
    \n         } else={:put \$k}\r\
    \n     }\r\
    \n      :put \"\";\r\
    \n  :return []}\r\
    \n\r\
    \n:if (\$1=\"\\6C\\69\\73\\74\\65\\78\\74\") do={\r\
    \n      :put \"\"; :put \"<---- List \$0 jingles num in folder \$VoiceFold\
    er TF-card and name in function ---->\"\r\
    \n   :local Lfind [:toarray \"\"]\r\
    \n          :foreach k,v in=\$ArrayComVoice do={\r\
    \n   :if ([:len \$2]>0) do={\\\r\
    \n          :if ([:len [:find \$k \$2]]>0) do={:put (\"\$v\".\" - \".\"\$k\
    \"); :set Lfind (\$Lfind,\"\$k=\$v\")}\\\r\
    \n         } else={:put (\"\$v\".\" - \".\"\$k\")}\r\
    \n     }\r\
    \n      :put \"\";\r\
    \n :if ([:len \$2]>0) do={:return \$Lfind} else={:return \$ArrayComVoice}\
    \r\
    \n}\r\
    \n\r\
    \n :if (\$1=\"find\") do={\r\
    \n     :if ([:len (\$ArrayComVoice->\$2)]>0) do={:return true} else={:retu\
    rn false}\r\
    \n     }\r\
    \n\r\
    \n    :local SMPanswer\r\
    \n\r\
    \n  :if (\$1=\"stop\") do={\r\
    \n   :do {\r\
    \n        :set SMPanswer [\$fSMP mp3type]\r\
    \n           :if (\$SMPanswer=\"DFPlayer\") do={:return \"mp3 module is no\
    t supported\"}\r\
    \n        :set SMPanswer [\$fSMP stop]\r\
    \n            } on-error={:return \"Error \$0 function call MikroVoice mod\
    ule function SMP\"}\r\
    \n}\r\
    \n\r\
    \n  :if (\$1=\"pause\") do={\r\
    \n   :do {\r\
    \n        :set SMPanswer [\$fSMP mp3type]\r\
    \n           :if (\$SMPanswer=\"DFPlayer\") do={:return \"mp3 module is no\
    t supported\"}\r\
    \n        :set SMPanswer [\$fSMP pause]\r\
    \n            } on-error={:return \"Error \$0 function call MikroVoice mod\
    ule function SMP\"}\r\
    \n}\r\
    \n\r\
    \n :if (\$1=\"playback\") do={\r\
    \n   :do {\r\
    \n        :set SMPanswer [\$fSMP mp3type]\r\
    \n           :if (\$SMPanswer=\"DFPlayer\") do={:return \"mp3 module is no\
    t supported\"}\r\
    \n        :set SMPanswer [\$fSMP play]\r\
    \n            } on-error={:return \"Error \$0 function call MikroVoice mod\
    ule function SMP\"}\r\
    \n}\r\
    \n\r\
    \n  :if (\$1=\"lang\") do={\r\
    \n      :if ((\$2=\"RUS\") or (\$2=\"ENG\") or (\$2=\"CNR\")) do={ \r\
    \n      :if ([:len [/ip firewall layer7-protocol find name=\$fFL7Lang]]=0)\
    \_do={\r\
    \n            /ip firewall layer7-protocol add name=\$fFL7Lang regexp=\$2 \
    \\\r\
    \n        } else={\\\r\
    \n            :if (\$2!=[/ip firewall layer7 get [find name=\$fFL7Lang] re\
    gexp]) do={\r\
    \n                          /ip firewall layer7-protocol set [find name=\$\
    fFL7Lang] regexp=\$2}\r\
    \n             :if (\$2=\"RUS\") do={:set \$2 \"rus\"}\t\t\t\t \r\
    \n             :if (\$2=\"ENG\") do={:set \$2 \"eng\"}\r\
    \n             :if (\$2=\"CNR\") do={:set \$2 \"cnr\"}\r\
    \n               do {\r\
    \n                :global fVoice; [\$fVoice \$2]\r\
    \n              } on-error={}\r\
    \n             :return \"Done. Select MikroVoice language \$2\"}\r\
    \n} else={:return \"ERROR select language \$2\"}\r\
    \n}\r\
    \n\r\
    \n:local VoiceNum; :do {:set VoiceNum [:tonum \$1]} on-error={}\r\
    \n               :local JingleNum\r\
    \n               :local cmd\r\
    \n\r\
    \n:if ([:typeof \$VoiceNum]=\"num\") do={\r\
    \n\r\
    \n     :foreach k,v in=\$ArrayComVoice do={:if (\$v=\$VoiceNum) do={:set c\
    md \$k; set JingleNum \$v}}\r\
    \n     :if ([:len \$cmd]=0) do={:return \"Error: jingle number mismatch \$\
    0\"}\r\
    \n               :if (\$VoiceActive) do={\r\
    \n               :do {\$AlertVoice \$3} on-error={}\r\
    \n               :put (\"Play jingle\".\" \$cmd\". \" < \$JingleNum >\".\"\
    \_in bibliojinglesfolder \$VoiceFolder\")\r\
    \n               :log warning (\"Play jingle\".\" \$cmd\". \" < \$JingleNu\
    m >\".\" in bibliojinglesfolder \$VoiceFolder\")\r\
    \n               :do {\r\
    \n               :set SMPanswer [\$fSMP playfile \$VoiceFolder \$VoiceNum]\
    \r\
    \n                } on-error={:return \"Error \$0 function call MikroVoice\
    \_module function SMP\"}\r\
    \n                  } else={:return \"Voice system disactive\"}\r\
    \n                    } else={\r\
    \n\r\
    \n   :set cmd (\$ArrayComVoice->\$1)\r\
    \n    :if ([:len \$cmd]=0) do={:return \"Error: bad command/name jingle\"}\
    \r\
    \n               :if (\$VoiceActive) do={\r\
    \n               :do {\$AlertVoice \$3} on-error={}\r\
    \n               :put \"Play jingle \$1 in bibliojinglesfolder \$VoiceFold\
    er\"\r\
    \n               :log warning \"Play jingle \$1 in bibliojinglesfolder \$V\
    oiceFolder\"\r\
    \n               :do {\r\
    \n               :set SMPanswer [\$fSMP playfile \$VoiceFolder \$cmd]\r\
    \n                } on-error={:return \"Error \$0 function call MikroVoice\
    \_module function SMP\"}\r\
    \n            } else={:return \"Voice system disactive\"}\r\
    \n   }\r\
    \n  :return \$SMPanswer\r\
    \n}"
