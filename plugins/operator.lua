local function run(msg, matches)
    if not permissions(msg.from.id, msg.to.id, "settings") then
        local hash = 'operator:'..msg.to.id
        if redis:get(hash) then
            delete_msg(msg.id, ok_cb, false)
            send_report(msg)
        end
    end
end

return {
patterns = {
   "ایرانسل(.*)",
    "همراه اول(.*)",
    "تالیا(.*)",
    "رایتل(.*) ",
    "شارژ(.*)",
    "شارژ مستقیم(.*)",
    "شارژ غیرمستقیم(.*)",
    "شارژ بریز(.*)",
    "سایت شارژ(.*)",
    "سایت(.*)",
    "شارژ",
    "همراه اول",
    "تالیا",
    "ایرانسل",
    "رایتل",
    "شارژ مستقیم",
    "شارژ غیرمستقیم",
    "سایت شارژ",
    "شارژ بریز",
    "شارژ رایگان",
}, run = run}
