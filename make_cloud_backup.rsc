# Func: Telegram send message
:local TGSendMessage do={
    :local tgUrl "https://api.telegram.org/bot$Token/sendMessage?chat_id=$ChatID&text=$Text&parse_mode=html&disable_web_page_preview=True";
    /tool fetch http-method=get url=$tgUrl keep-result=no;
}

# Constants
# fill in with your telegram information
:local TelegramBotToken "";
:local TelegramChatID "";
:local DeviceName [/system identity get name];
:local TelegramMessageText "$DeviceName: ";

# backup password (typically in password manager)
:local backupPassword "";

# find the existing backup and replace it with a new one
:local existingBackup [/system backup cloud find 0];
/system backup cloud upload-file action=create-and-upload replace=$existingBackup password=$backupPassword;

# send the new download key to Telegram. stupid thing wants you to run print first before we can extract the key :|
/ system backup cloud print;
:local dlKey ( [ /system backup cloud get 0 ]->"secret-download-key" );
:log info ("cloud backup successfull. secret download key: " . $dlKey );

# Send the Telegram message
:set TelegramMessageText  ($TelegramMessageText . "Cloud backup complete. Secret download key: " . $dlKey);
$TGSendMessage Token=$TelegramBotToken ChatID=$TelegramChatID Text=$TelegramMessageText;
