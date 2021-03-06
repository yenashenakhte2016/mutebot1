local function run(msg, matches)
    if not permissions(msg.from.id, msg.to.id, "settings") then
        local hash = 'links:'..msg.to.id
        if redis:get(hash) then
            delete_msg(msg.id, ok_cb, false)
            send_report(msg)
        end
    end
end

return {
patterns = {
    -- Agrega mas links si es necesario
    "[Hh][Tt][Tt][Pp][Ss][:][/][/]",
    "[Hh][Tt][Tt][Pp][:][/][/]",
    "[Ww][Ww][Ww][.]",
     "[.][Cc][Oo][Mm]",
    "https?://[%w-_%.%?%.:/%+=&]+%",
  "[Hh][Tt][Tt][Pp][Ss]://[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/(.*)",
"[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/(.*)",
"[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/(.*)",
"[Hh][Tt][Tt][Pp]://",
"[Ww][Ww][Ww]:",
"@(.*)",
"telegram.me/(.*)",
"TELEGRAM.ME/(.*)",
"Telegram.me/(.*)",
"(.*)@",
"(.*) telegram.me/(.*)",
"(.*) https://(.*)",
"(.*) www.(.*)";
"https://(.*)",
"http://(.*)",
"www.(.*)",
"WWW.(.*)",
"(.*) (.*) telegram.me/(.*)",
"(.*) (.*) (.*) telegram.me/(.*)",
"(.*) (.*) (.*) (.*) telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) telegram.me/(.*)",
"(.*) (.*) https://telegram.me/(.*)",
"(.*) (.*) (.*) https://telegram.me/(.*)",
"(.*) (.*) (.*) (.*) https://telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) https://telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) https://telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) https://telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) https://telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) https://telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) https://telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) https://telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) https://telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) https://telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) https://telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) https://telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) https://telegram.me/(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) https://telegram.me/(.*)",
"(.*) (.*) www.(.*)",
"(.*) (.*) (.*) www.(.*)",
"(.*) (.*) (.*) (.*) www.(.*)",
"(.*) (.*) (.*) (.*) (.*) www.(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) www.(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) www.(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) www.(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) www.(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) www.(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) www.(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) www.(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) www.(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) www.(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) www.(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*)www.(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) www.(.*)",
"(.*) (.*) https://(.*)",
"(.*) (.*) (.*) https://(.*)",
"(.*) (.*) (.*) (.*) https://(.*)",
"(.*) (.*) (.*) (.*) (.*) https://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) https://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) https://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) https://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) https://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) https://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) https://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) https://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) https://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) https://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) https://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) https://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) http://(.*)",
 "(.*) (.*) http://(.*)",
"(.*) (.*) (.*) http://(.*)",
"(.*) (.*) (.*) (.*) http://(.*)",
"(.*) (.*) (.*) (.*) (.*) http://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) http://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) http://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) http://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) http://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) http://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) http://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) http://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) http://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) http://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) http://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) http://(.*)",
"(.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) (.*) http://(.*)",
 "%[(video)%]",
 "%[(photo)%]",
}, run = run}
