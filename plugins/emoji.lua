local function run(msg, matches)
    if not permissions(msg.from.id, msg.to.id, "settings") then
        local hash = 'emoji:'..msg.to.id
        if redis:get(hash) then
            delete_msg(msg.id, ok_cb, false)
            send_report(msg)
        end
    end
end

return {
patterns = {
    "😄",
    "😃",
    "😂",
    "😁",
    "😀",
    "😊",
    "☺" ,
    "😐",
    "😯",
    "😉",
    "😈",
    "😇",
    "😆",
    "😅",
    "😴",
    "😢",
    "😡",
    "😬",
    "😠",
    "😕",
    "😑",
    "😨",
    "😧",
    "😦",
    "😥",
    "😤",
    "😣",
    "😮",
    "😍",
    "😎",
    "😭",
    "😓",
    "😱",
    "😚",
    "😗",
    "😷",
    "😫",
    "😪"
}, run = run}
