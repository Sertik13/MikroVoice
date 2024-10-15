#--------------------------
# Backup MikroVoice script 
#--------------------------

# send or no send on E-mail

:local mailsend false
:local mailBox "user@mail.ru"

:global fVoice

    :log warning "Starting Backup Script...";
    :local sysname [/system identity get name];
    :local sysver [/system package get system version];
    :local sysDate ([:pick [/system clock get date] 7 11] . [:pick [/system clock get date] 0 3] . [:pick [/system clock get date] 4 6])
    :log info "Flushing DNS cache...";
     /ip dns cache flush;
     :delay 2;

     :log info "Deleting last Backups...";   
   :if (any $fVoice) do={
       :do {
        $fVoice delfiles
       } on-error={}  
    }
         :foreach i in=[/file find] do={:if (([:typeof [:find [/file get $i name] \
         "$sysname-backup-"]]!="nil") or ([:typeof [:find [/file get $i name] \
         "$sysname-script-"]]!="nil")) do={/file remove $i}};
      :delay 2;

    :if (any $fVoice) do={
       :do {
        $fVoice backup
       } on-error={}  
    }

     :local backupfile ("$sysname-backup-" . "$sysDate" . ".backup");
     :log warning "Creating new Full Backup file...$backupfile";

     /system backup save name=$backupfile;
     :delay 5;

     :local exportfile ("$sysname-backup-" . "$sysDate" . ".rsc");
     :log warning "Creating new Setup Script file...$exportfile";

     /export verbose file=$exportfile;
     :delay 5;

     :local scriptfile ("$sysname-script-" . "$sysDate" . ".rsc");
     :log warning "Creating new file export all scripts ...$scriptfile";

     /system script export file=$scriptfile;
     :delay 2;

     :if (any $fVoice) do={
        :do {
           $fVoice "backup_saved"
         } on-error={}
      }

   :log warning "All System Backups and export all Scripts created successfully.\nBackuping completed.";

if ($mailsend) do={
        :log info "";
        :log warning "Sending Setup Script file via E-mail...";
        :local smtpserv [:resolve "smtp.mail.ru"];
        :local Eaccount [/tool e-mail get user];
        :local pass [/tool e-mail get password];

         /tool e-mail send from="<$Eaccount>" to=$mailBox server=$smtpserv \
         port=587 user=$Eaccount password=$pass start-tls=yes file=($backupfile, $exportfile, $scriptfile) \
         subject=("$sysname Setup Script Backup (" . [/system clock get date] . \
         ")") body=("$sysname Setup Script file see in attachment.\nRouterOS \
         version: $sysver\nTime and Date stamp: " . [/system clock get time] . " \
         " . [/system clock get date]);

       :log warning "Setup Script file e-mail send";
     :delay 5;
}
