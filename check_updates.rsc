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

# Check Update
:local MyVar [/system package update check-for-updates as-value];
:local Chan ($MyVar -> "channel");
:local InstVer ($MyVar -> "installed-version");
:local LatVer ($MyVar -> "latest-version");

:if ($InstVer = $LatVer) do={
    :set TelegramMessageText  ($TelegramMessageText . "system is already up to date");
} else={
    :set TelegramMessageText  "$TelegramMessageText Version $LatVer is available! <a href=\"https://mikrotik.com/download/changelogs\">Changelogs</a>. [Installed version $InstVer, channel $Chan].";
    $TGSendMessage Token=$TelegramBotToken ChatID=$TelegramChatID Text=$TelegramMessageText;
}

:log info $TelegramMessageText;
