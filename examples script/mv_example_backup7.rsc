#------------------------------------
# Backup MikroVoice script for ROS7
#------------------------------------

:global fVoice

    :log warning "Starting Backup Script...";
    :local sysname [/system identity get name]
    :local sysver [/system resource get version];
    :local sysDate [/system clock get date]
    :log info "Flushing DNS cache...";
     /ip dns cache flush;
     :delay 2;

     :log info "Deleting last Backups...";
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
