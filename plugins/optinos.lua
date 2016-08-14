local function show_group_optinosmod(msg, data, target)
 	if not is_momod(msg) then
    	return "For moderators only!"
  	end
  	local data = load_data(_config.moderation.data)
    if data[tostring(msg.to.id)] then
     	if data[tostring(msg.to.id)]['optinos']['flood_msg_max'] then
        	NUM_MSG_MAX = tonumber(data[tostring(msg.to.id)]['optinos']['flood_msg_max'])
        	print('custom'..NUM_MSG_MAX)
      	else 
        	NUM_MSG_MAX = 5
      	end
    end
    local bots_protection = "Yes"
    if data[tostring(msg.to.id)]['optinos']['lock_bots'] then
    	bots_protection = data[tostring(msg.to.id)]['optinos']['lock_bots']
   	end
    local leave_ban = "no"
    if data[tostring(msg.to.id)]['optinos']['leave_ban'] then
    	leave_ban = data[tostring(msg.to.id)]['optinos']['leave_ban']
   	end
    local arabic = "no"
    if data[tostring(msg.to.id)]['optinos']['lock_arabic'] then
    arabic = data[tostring(msg.to.id)]['optinos']['lock_arabic']
    end
    local sticker = "no"
    if data[tostring(msg.to.id)]['optinos']['sticker'] then
    sticker = data[tostring(msg.to.id)]['optinos']['sticker']
    end
    local link = "no"
    if data[tostring(msg.to.id)]['optinos']['lock_link'] then
    link = data[tostring(msg.to.id)]['optinos']['lock_link']
    end
    local wlc = "no"
    if data[tostring(msg.to.id)]['optinos']['welcome'] then
    wlc = data[tostring(msg.to.id)]['optinos']['welcome']
    end
    local kalkal = "off"
    if data[tostring(msg.to.id)]['optinos']['kalkal'] then
    kalkal = data[tostring(msg.to.id)]['optinos']['kalkal']
    end
  local optinos = data[tostring(msg.to.id)]['optinos']
  local text = "Group optinos:\nLock group name : "..optinos.lock_name.."\nLock group photo : "..optinos.lock_photo.."\nLock group member : "..optinos.lock_member.."\nLock group leave : "..leave_ban.."\nLock bot : "..bots_protection.."\nLock Arabic : "..arabic.."\nLock sticker : "..sticker.."\nLock link : "..link.."\nKalkal : "..kalkal.."\nWelcome : "..wlc.."\nflood sensitivity : "..NUM_MSG_MAX--.."\nPublic : "..public
  return text
end 

  if matches[1] == 'lock' and is_momod(msg) then
			local target = msg.to.id
			     if matches[2] == 'etehad' then
      	local safemode ={
        lock_group_links(msg, data, target),
		lock_group_tag(msg, data, target),
		lock_group_ads(msg, data, target),
		lock_group_spam(msg, data, target),
		lock_group_flood(msg, data, target),
		unlock_group_arabic(msg, data, target),
		unlock_group_membermod(msg, data, target),
		unlock_group_rtl(msg, data, target),
		lock_group_tgservice(msg, data, target),
		unlock_group_sticker(msg, data, target),
		unlock_group_contacts(msg, data, target),
		lock_group_english(msg, data, target),
		lock_group_fwd(msg, data, target),
		unlock_group_number(msg, data, target),
		lock_group_number(msg, data, target),
		unlock_group_join(msg, data, target),
		unlock_group_emoji(msg, data, target),
		lock_group_username(msg, data, target),
		lock_group_fosh(msg, data, target),
		unlock_group_media(msg, data, target),
		lock_group_operator(msg, data, target),
      	}
      	return lock_group_etehad(msg, data, target), safemode
      end
           local target = msg.to.id
			     if matches[2] == 'normal' then
      	local safemode ={
        lock_group_links(msg, data, target),
		lock_group_tag(msg, data, target),
		lock_group_ads(msg, data, target),
		lock_group_spam(msg, data, target),
		lock_group_flood(msg, data, target),
		unlock_group_arabic(msg, data, target),
		unlock_group_membermod(msg, data, target),
		unlock_group_rtl(msg, data, target),
		unlock_group_tgservice(msg, data, target),
		unlock_group_sticker(msg, data, target),
		unlock_group_contacts(msg, data, target),
		unlock_group_english(msg, data, target),
		unlock_group_fwd(msg, data, target),
		unlock_group_number(msg, data, target),
		unlock_group_number(msg, data, target),
		unlock_group_join(msg, data, target),
		unlock_group_emoji(msg, data, target),
		lock_group_username(msg, data, target),
		lock_group_fosh(msg, data, target),
		unlock_group_media(msg, data, target),
		unlock_group_operator(msg, data, target),
      	}
      	return lock_group_normal(msg, data, target), safemode
      end
			if matches[2] == 'links' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked link posting ")
				return lock_group_links(msg, data, target)
			end
			if matches[2] == 'spam' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked spam ")
				return lock_group_spam(msg, data, target)
			end
			if matches[2] == 'flood' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked flood ")
				return lock_group_flood(msg, data, target)
			end
           if matches[2] == 'etehad' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked etehad ")
				return lock_group_etehad(msg, data, target)
			end
			if matches[2] == 'arabic' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked arabic ")
				return lock_group_arabic(msg, data, target)
			end
           if matches[2] == 'normal' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked normal ")
				return lock_group_normal(msg, data, target)
			end
			if matches[2] == 'bots' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked bots ")
				return lock_group_bots(msg, data, target)
			end
            if matches[2] == 'join' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked join ")
				return lock_group_join(msg, data, target)
			end
            if matches[2] == 'fwd' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked fwd ")
				return lock_group_fwd(msg, data, target)
			end
            if matches[2] == 'english' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked english ")
				return lock_group_english(msg, data, target)
			end
            if matches[2] == 'tag' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked tag ")
				return lock_group_tag(msg, data, target)
			end
            if matches[2] == 'emoji' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked emoji ")
				return lock_group_emoji(msg, data, target)
			end
            if matches[2] == 'video' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked video ")
				return lock_group_video(msg, data, target)
			end
          if matches[2] == 'media' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked media ")
				return lock_group_media(msg, data, target)
			end
           if matches[2] == 'username' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked username ")
				return lock_group_username(msg, data, target)
			end
           if matches[2] == 'photos' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked photos ")
				return lock_group_photos(msg, data, target)
			end
			if matches[2] == 'member' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked member ")
				return lock_group_membermod(msg, data, target)
			end
            if matches[2] == 'number' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked number ")
				return lock_group_number(msg, data, target)
			end
			if matches[2] == 'ads' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked ads ")
				return lock_group_ads(msg, data, target)
			end
            if matches[2] == 'reply' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked reply ")
				return lock_group_reply(msg, data, target)
			end
			if matches[2]:lower() == 'rtl' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked rtl chars. in names")
				return lock_group_rtl(msg, data, target)
			end
          if matches[2]:lower() == 'fosh' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked fosh chars. in names")
				return lock_group_fosh(msg, data, target)
			end
           if matches[2]:lower() == 'operator' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked operator chars. in names")
				return lock_group_operator(msg, data, target)
			end
			if matches[2] == 'tgservice' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked Tgservice Actions")
				return lock_group_tgservice(msg, data, target)
			end
			if matches[2] == 'sticker' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked sticker posting")
				return lock_group_sticker(msg, data, target)
			end
			if matches[2] == 'contacts' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked contact posting")
				return lock_group_contacts(msg, data, target)
			end
			if matches[2] == 'strict' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked enabled strict settings")
				return enable_strict_rules(msg, data, target)
			end
		end
       if matches[1] == 'unlock' and is_momod(msg) then
			local target = msg.to.id
			     if matches[2] == 'etehad' then
      	local dsafemode ={
        lock_group_links(msg, data, target),
		unlock_group_tag(msg, data, target),
		lock_group_spam(msg, data, target),
		lock_group_flood(msg, data, target),
		unlock_group_arabic(msg, data, target),
		unlock_group_membermod(msg, data, target),
		lock_group_rtl(msg, data, target),
		lock_group_tgservice(msg, data, target),
		unlock_group_sticker(msg, data, target),
		unlock_group_contacts(msg, data, target),
		unlock_group_english(msg, data, target),
		unlock_group_number(msg, data, target),
		lock_group_ads(msg, data, target),
		unlock_group_fwd(msg, data, target),
		unlock_group_reply(msg, data, target),
		unlock_group_join(msg, data, target),
		unlock_group_emoji(msg, data, target),
		lock_group_username(msg, data, target),
		lock_group_fosh(msg, data, target),
		unlock_group_media(msg, data, target),
		unlock_group_leave(msg, data, target),
		lock_group_operator(msg, data, target),
      	}
      	return unlock_group_etehad(msg, data, target), dsafemode
      end
           local target = msg.to.id
			     if matches[2] == 'normal' then
      	local dsafemode ={
        lock_group_links(msg, data, target),
		unlock_group_tag(msg, data, target),
		lock_group_spam(msg, data, target),
		lock_group_flood(msg, data, target),
		unlock_group_arabic(msg, data, target),
		unlock_group_membermod(msg, data, target),
		lock_group_rtl(msg, data, target),
		lock_group_tgservice(msg, data, target),
		unlock_group_sticker(msg, data, target),
		unlock_group_contacts(msg, data, target),
		unlock_group_english(msg, data, target),
		unlock_group_number(msg, data, target),
		lock_group_ads(msg, data, target),
		unlock_group_fwd(msg, data, target),
		unlock_group_reply(msg, data, target),
		unlock_group_join(msg, data, target),
		unlock_group_emoji(msg, data, target),
		lock_group_username(msg, data, target),
		lock_group_fosh(msg, data, target),
		unlock_group_media(msg, data, target),
		unlock_group_leave(msg, data, target),
		lock_group_operator(msg, data, target),
      	}
      	return unlock_group_normal(msg, data, target), dsafemode
      end
			if matches[2] == 'links' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked link posting")
				return unlock_group_links(msg, data, target)
			end
			if matches[2] == 'spam' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked spam")
				return unlock_group_spam(msg, data, target)
			end
			if matches[2] == 'flood' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked flood")
				return unlock_group_flood(msg, data, target)
			end
            if matches[2] == 'etehad' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked etehad")
				return unlock_group_etehad(msg, data, target)
			end
			if matches[2] == 'arabic' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked Arabic")
				return unlock_group_arabic(msg, data, target)
			end
			if matches[2] == 'member' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked member ")
				return unlock_group_membermod(msg, data, target)
			end
          if matches[2] == 'fosh' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked fosh ")
				return unlock_group_fosh(msg, data, target)
			end
           if matches[2] == 'media' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked media ")
				return unlock_group_media(msg, data, target)
			end
           if matches[2] == 'normal' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked normal ")
				return unlock_group_normal(msg, data, target)
			end
           if matches[2] == 'bots' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked bots ")
				return unlock_group_bots(msg, data, target)
			end
           if matches[2] == 'join' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked join ")
				return unlock_group_join(msg, data, target)
			end
            if matches[2] == 'fwd' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked fwd ")
				return unlock_group_fwd(msg, data, target)
			end
           if matches[2] == 'english' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked english ")
				return unlock_group_english(msg, data, target)
			end
			if matches[2]:lower() == 'rtl' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked RTL chars. in names")
				return unlock_group_rtl(msg, data, target)
			end
                if matches[2]:lower() == 'username' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked username chars. in names")
				return unlock_group_username(msg, data, target)
			end
                if matches[2]:lower() == 'operator' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked operator chars. in names")
				return unlock_group_operator(msg, data, target)
			end
                if matches[2]:lower() == 'photos' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked photos chars. in names")
				return unlock_group_photos(msg, data, target)
			end
				if matches[2] == 'tgservice' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked tgservice actions")
				return unlock_group_tgservice(msg, data, target)
			end
            if matches[2] == 'reply' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked reply actions")
				return unlock_group_reply(msg, data, target)
			end
            if matches[2] == 'video' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked video actions")
				return unlock_group_video(msg, data, target)
			end
			if matches[2] == 'sticker' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked sticker posting")
				return unlock_group_sticker(msg, data, target)
			end
			if matches[2] == 'contacts' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked contact posting")
				return unlock_group_contacts(msg, data, target)
			end
			if matches[2] == 'strict' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked disabled strict settings")
				return disable_strict_rules(msg, data, target)
			end
		end

local function run(msg, matches)
local name_log = user_print_name(msg.from)
if matches[1] == 'optinos' or matches[1] == 'Optinos' then
      local target = msg.to.id
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group optinos ")
      return show_group_optinosmod(msg, data, target)
    end	
end
return {
  patterns = {
 "^[!#/]([Oo]ptinos)$",
  "[!#/]([Ll]ock) (.*)$",
  "[!#/]([Uu]nlock) (.*)$"
},
  run = run
}
