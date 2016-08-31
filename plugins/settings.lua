--By @DevMohammad
--Channel @MuteTeam


do

local function create_group(msg, group_name)
    local group_creator = msg.from.print_name
    create_group_chat(group_creator, group_name, ok_cb, false)
    return 'ℹ️ '..lang_text(msg.to.id, 'createGroup:1')..' "'..string.gsub(group_name, '_', ' ')..'" '..lang_text(msg.to.id, 'createGroup:2')
end

local function remove_message(extra, success, result)
    msg = backward_msg_format(result)
    delete_msg(msg.id, ok_cb, false)
end

local function set_group_photo(msg, success, result)
    local receiver = get_receiver(msg)
    if success then
        local file = 'data/photos/chat_photo_'..msg.to.id..'.jpg'
        print('File downloaded to:', result)
        os.rename(result, file)
        print('File moved to:', file)
        if msg.to.type == 'channel' then
        	channel_set_photo (receiver, file, ok_cb, false)
	elseif msg.to.type == 'chat' then
		chat_set_photo(receiver, file, ok_cb, false)
	end
        return 'ℹ️ '..lang_text(msg.to.id, 'photoSaved')
    else
        print('Error downloading: '..msg.id)
        return 'ℹ️ '..lang_text(msg.to.id, 'photoSaved')
    end
end

local function pre_process(msg)
    local hash = 'flood:max:'..msg.to.id
    if not redis:get(hash) then
        floodMax = 5
    else
        floodMax = tonumber(redis:get(hash))
    end

    local hash = 'flood:time:'..msg.to.id
    if not redis:get(hash) then
        floodTime = 3
    else
        floodTime = tonumber(redis:get(hash))
    end
    if not permissions(msg.from.id, msg.to.id, "pre_process") then
        --Checking flood
        local hashse = 'anti-flood:'..msg.to.id
        if not redis:get(hashse) then
            print('anti-flood enabled')
            -- Check flood
            if msg.from.type == 'user' then
                if not permissions(msg.from.id, msg.to.id, "no_flood_ban") then
                    -- Increase the number of messages from the user on the chat
                    local hash = 'flood:'..msg.from.id..':'..msg.to.id..':msg-num'
                    local msgs = tonumber(redis:get(hash) or 0)
                    if msgs > floodMax then
                        local receiver = get_receiver(msg)
                        local user = msg.from.id
                        local chat = msg.to.id
                        local channel = msg.to.id
                        local bhash = 'banned:'..msg.to.id..':'..msg.from.id
                        redis:set(bhash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, lang_text(chat, 'user')..' @'..msg.from.username..' ('..msg.from.id..') '..lang_text(chat, 'isFlooding'), ok_cb, true)
                            chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, true)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, lang_text(chat, 'user')..' @'..msg.from.username..' ('..msg.from.id..') '..lang_text(chat, 'isFlooding'), ok_cb, true)
                            channel_kick_user('channel#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, true)
                        end
                    end
                    redis:setex(hash, floodTime, msgs+1)
                end
            end
        end

        if msg.action and msg.action.type then
            local action = msg.action.type
            if action == 'chat_add_user' or action == 'chat_add_user_link' then
            	hash = 'antibot:'..msg.to.id
            	if redis:get(hash) then
	                if string.sub(msg.action.user.username:lower(), -3) == 'bot' then
	                    if msg.to.type == 'chat' then
	                        chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.action.user.id, ok_cb, true)
	                    elseif msg.to.type == 'channel' then
	                        channel_kick_user('channel#id'..msg.to.id, 'user#id'..msg.action.user.id, ok_cb, true)
	                    end
	                end
	            end
            end
        end

        --Checking stickers
        if not msg.media then
            webp = 'nothing'
        else
            webp = msg.media.caption
        end
        if webp == 'sticker.webp' then
            hash = 'stickers:'..msg.to.id
            if redis:get(hash) then
                delete_msg(msg.id, ok_cb, false)
            end
        end
        if not msg.media then
            mp4 = 'nothing'
        else
            if msg.media.type == 'document' then
                mp4 = msg.media.caption or 'audio'
            end
        end
	--Checking tgservices
        hash = 'tgservices:'..msg.to.id
        if redis:get(hash) then
		local action = msg.action.type
		if action == 'chat_add_user' or action == 'chat_add_user_link' or action == 'chat_del_user' then
		    delete_msg(msg.id, ok_cb, false)
		end
	end
        --Checking GIFs and MP4 files
        if mp4 == 'giphy.mp4' then
            hash = 'gifs:'..msg.to.id
            if redis:get(hash) then
                delete_msg(msg.id, ok_cb, false)
            end
        else
            if msg.media then
                if msg.media.type == 'document' then
                    gifytpe = string.find(mp4, 'gif.mp4') or 'audio'
                    if gifytpe == 'audio' then
                        hash = 'audio:'..msg.to.id
                        if redis:get(hash) then
                            delete_msg(msg.id, ok_cb, false)
                        end
                    else
                        hash = 'gifs:'..msg.to.id
                        if redis:get(hash) then
                            delete_msg(msg.id, ok_cb, false)
                        end
                    end
                end
            end
        end
        --Checking photos
        if msg.media then
            if msg.media.type == 'photo' then
                local hash = 'photo:'..msg.to.id
                if redis:get(hash) then
                    delete_msg(msg.id, ok_cb, false)
                end
            end
        end

        --Checking muteall
        local hash = 'muteall:'..msg.to.id
        if redis:get(hash) then
            delete_msg(msg.id, ok_cb, false)
        end
    else
        if msg.media then
            if msg.media.type == 'photo' then
                local hash = 'setphoto:'..msg.to.id..':'..msg.from.id
                if redis:get(hash) then
                    redis:del(hash)
                    load_photo(msg.id, set_group_photo, msg)
                    print('setphoto')
                    delete_msg(msg.id, ok_cb, false)
                end
            end
        end
    end
    return msg
end
    if matches[1] == 'lock' then
                      if matches[2] == 'sticker' then
                        hash = 'stickers:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noStickersT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noStickersL'), ok_cb, false)
                        end
                    return
                       elseif matches[2] == 'fosh' then
                        hash = 'fosh:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noFoshT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noFoshL'), ok_cb, false)
                        end
                    return
					    elseif matches[2] == 'username' then
                        hash = 'username:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noUsernameT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noUsernameL'), ok_cb, false)
                        end
                    return
                        elseif matches[2] == 'tag' then
                        hash = 'tag:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noTagT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noTagL'), ok_cb, false)
                        end
                    return
                elseif matches[2] == 'links' then
                        hash = 'links:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noLinksT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noLinksL'), ok_cb, false)
                        end       
                    return
                elseif matches[2] == 'photo' then
                        hash = 'photo:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noPhotosT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noPhotosL'), ok_cb, false)
                        end
                    return
                elseif matches[2] == 'bot' then
                        hash = 'antibot:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noBotsT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noBotsL'), ok_cb, false)
                        end                    
                    return
                 elseif matches[2] == 'emoji' then
                        hash = 'emoji:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noEmojiT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noEmojiL'), ok_cb, false)
                        end                    
                    return
                elseif matches[2] == 'audio' then
                        hash = 'audio:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noAudiosT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noAudiosL'), ok_cb, false)
                        end                    
                    return               
                elseif matches[2] == 'flood' then
                        hash = 'anti-flood:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noFloodT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noFloodL'), ok_cb, false)
                        end                    
                    return
                elseif matches[2] == 'adv' then
                        local hash = 'spam:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'notAllowedSpamT'), ok_cb, true)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'notAllowedSpamL'), ok_cb, true)
                        end
                        return
				elseif matches[2] == 'setphoto' then
                        local hash = 'setphoto:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'notChatSetphoto'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'notChannelSetphoto'), ok_cb, false)
                        end
                        return
				elseif matches[2] == 'setname' then
                        local hash = 'name:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'notChatRename'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'notChannelRename'), ok_cb, false)
                        end
                        return	
               end					
    elseif matches[1] == 'unlock' then
                      if matches[2] == 'sticker' then
                        hash = 'stickers:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'stickersT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'stickersL'), ok_cb, false)
                        end
                    return
                       elseif matches[2] == 'fosh' then
                        hash = 'fosh:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'foshT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'foshL'), ok_cb, false)
                        end
                    return
					    elseif matches[2] == 'username' then
                        hash = 'username:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'usernameT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'usernameL'), ok_cb, false)
                        end
                    return
                        elseif matches[2] == 'tag' then
                        hash = 'tag:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'tagT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'tagL'), ok_cb, false)
                        end
                    return
                elseif matches[2] == 'links' then
                        hash = 'links:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'linksT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'linksL'), ok_cb, false)
                        end       
                    return
                elseif matches[2] == 'photo' then
                        hash = 'photo:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'photosT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'photosL'), ok_cb, false)
                        end
                    return
                elseif matches[2] == 'bot' then
                        hash = 'antibot:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'botsT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'botsL'), ok_cb, false)
                        end                    
                    return
                 elseif matches[2] == 'emoji' then
                        hash = 'emoji:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'emojiT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'emojiL'), ok_cb, false)
                        end                    
                    return
                elseif matches[2] == 'audio' then
                        hash = 'audio:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'audiosT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'audiosL'), ok_cb, false)
                        end                    
                    return               
                elseif matches[2] == 'flood' then
                        hash = 'anti-flood:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'floodT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'floodL'), ok_cb, false)
                        end                    
                    return
                elseif matches[2] == 'adv' then
                        local hash = 'spam:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'allowedSpamT'), ok_cb, true)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'allowedSpamL'), ok_cb, true)
                        end
                        return
						elseif matches[2] == 'setphoto' then
                        local hash = 'setphoto:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'chatSetphoto'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'channelSetphoto'), ok_cb, false)
                        end
                        return
				elseif matches[2] == 'setname' then
                        local hash = 'name:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'chatRename'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'channelRename'), ok_cb, false)
                        end
                        return	
                        end					
		elseif matches[1] == 'set' then
        if permissions(msg.from.id, msg.to.id, "settings") then
		local hash = ''
		if matches[2] == 'name' then
            hash = 'name:'..msg.to.id
            if not redis:get(hash) then
                if msg.to.type == 'chat' then
                    rename_chat(msg.to.peer_id, matches[3], ok_cb, false)
                elseif msg.to.type == 'channel' then
                    rename_channel(msg.to.peer_id, matches[3], ok_cb, false)
                end
            end
			elseif matches[2] == 'link' then
			 hash = 'link:'..msg.to.id
            redis:set(hash, matches[3])
            if msg.to.type == 'chat' then
                send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'linkSaved'), ok_cb, true)
            elseif msg.to.type == 'channel' then
                send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'linkSaved'), ok_cb, true)
            end
			elseif matches[2] == 'photo' then
            hash = 'setphoto:'..msg.to.id
            if not redis:get(hash) then
                    hash = 'setphoto:'..msg.to.id..':'..msg.from.id
                    redis:set(hash, true)
                    if msg.to.type == 'chat' then
                        send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'sendPhoto'), ok_cb, true)
                    elseif msg.to.type == 'channel' then
                        send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'sendPhoto'), ok_cb, true)
                    end
            else
                return 'ℹ️ '..lang_text(msg.to.id, 'setPhotoError')
            end
			                elseif matches[2] == 'floodtime' then
                    if not matches[3] then
                    else
                        hash = 'flood:time:'..msg.to.id
                        redis:set(hash, matches[3])
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'floodTime')..matches[3], ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'floodTime')..matches[3], ok_cb, false)
                        end
                    end
                    return
                elseif matches[2] == 'maxflood' then
                    if not matches[3] then
                    else
                        hash = 'flood:max:'..msg.to.id
                        redis:set(hash, matches[3])
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'floodMax')..matches[3], ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'floodMax')..matches[3], ok_cb, false)
                        end
                    end
			elseif matches[2] == 'description' then
            local text = matches[3]
            local chat = 'channel#id'..msg.to.id
            if msg.to.type == 'channel' then
                channel_set_about(chat, text, ok_cb, false)
                return 'ℹ️ '..lang_text(msg.to.id, 'desChanged')
            else
                return 'ℹ️ '..lang_text(msg.to.id, 'desOnlyChannels')
            end
			end
            return
        else
            return '🚫 '..lang_text(msg.to.id, 'require_mod')
        end
    end
    if matches[1] == 'settings' then
        if permissions(msg.from.id, msg.to.id, "settings") then
                if msg.to.type == 'chat' then
                    text = '⚙ '..lang_text(msg.to.id, 'gSettings')..':\n\n'
                elseif msg.to.type == 'channel' then
                    text = '⚙ '..lang_text(msg.to.id, 'sSettings')..':\n\n'
                end
                local allowed = lang_text(msg.to.id, 'allowed')..' ✅'
                local noAllowed = lang_text(msg.to.id, 'noAllowed')..' 🚫'
                local sD = '🔹'
				--Enable/disable Flood
                local hash = 'anti-flood:'..msg.to.id
                if redis:get(hash) then
                    sFlood = allowed
                else
                    sFlood = noAllowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'flood')..': '..sFlood..'\n\n'
				--Enable/disable bws
                local hash = 'fosh:'..msg.to.id
                if not redis:get(hash) then
                    sFosh = allowed
                else
                    sFosh = noAllowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'fosh')..': '..sFosh..'\n\n'
				--Enable/disable porns
                local hash = 'username:'..msg.to.id
                if not redis:get(hash) then
                    sUsername = allowed
                else
                    sUsername = noAllowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'username')..': '..sUsername..'\n\n'
				--Enable/disable adv
                local hash = 'spam:'..msg.to.id
                if redis:get(hash) then
                    sSpam = noAllowed
                else
                    sSpam = allowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'spam')..': '..sSpam..'\n\n'

                --Enable/disable emoji messages
                local hash = 'emoji:'..msg.to.id
                if not redis:get(hash) then
                    sEmoji = allowed
                else
                    sEmoji = noAllowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'emoji')..': '..sEmoji..'\n\n'
                --Enable/disable bots
                local hash = 'antibot:'..msg.to.id
                if not redis:get(hash) then
                    sBots = allowed
                else
                    sBots = noAllowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'bots')..': '..sBots..'\n\n'
				                --Enable/disable setphoto
                local hash = 'setphoto:'..msg.to.id
                if not redis:get(hash) then
                    sSPhoto = allowed
                else
                    sSPhoto = noAllowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'setphoto')..': '..sSPhoto..'\n\n'

                --Enable/disable changing group name
                local hash = 'name:'..msg.to.id
                if redis:get(hash) then
                    sName = noAllowed
                else
                    sName = allowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'gName')..': '..sName..'\n\n'
				--Enable/disable Stickers
                local hash = 'stickers:'..msg.to.id
                if redis:get(hash) then
                    sStickers = noAllowed
                else
                    sStickers = allowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'stickers')..': '..sStickers..'\n\n'
			    
                --Enable/disable send photos
                local hash = 'photo:'..msg.to.id
                if redis:get(hash) then
                    sPhoto = noAllowed
                else
                    sPhoto = allowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'photos')..': '..sPhoto..'\n\n'

                --Enable/disable send audios
                local hash = 'audio:'..msg.to.id
                if redis:get(hash) then
                    sAudio = noAllowed
                else
                    sAudio = allowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'audios')..': '..sAudio..'\n\n'

                --Enable/disable contacts
                local hash = 'tag:'..msg.to.id
                if not redis:get(hash) then
                    sTag = allowed
                else
                    sTag = noAllowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'tag')..': '..sTag..'\n\n'
				
                local hash = 'langset:'..msg.to.id
                if redis:get(hash) == 'fa' then
                    sLang = 'فارسی'
                elseif redis:get(hash) == 'en' then
                    sLang = 'English'
                else
                    sLang = lang_text(msg.to.id, 'noSet')
                end
                text = text..'🌐 '..lang_text(msg.to.id, 'language')..': '..sLang..'\n\n'
                local hash = 'flood:max:'..msg.to.id
                if not redis:get(hash) then
                    floodMax = 5
                else
                    floodMax = redis:get(hash)
                end

                local hash = 'flood:time:'..msg.to.id
                if not redis:get(hash) then
                    floodTime = 3
                else
                    floodTime = redis:get(hash)
                end

                text = text..'🔺 '..lang_text(msg.to.id, 'mFlood')..': '..floodMax..'\n\n🔺 '..lang_text(msg.to.id, 'tFlood')..': '..floodTime..'\n'            
                
                --Send settings to group or supergroup
                if msg.to.type == 'chat' then
                    send_msg('chat#id'..msg.to.id, text, ok_cb, false)
                elseif msg.to.type == 'channel' then
                    send_msg('channel#id'..msg.to.id, text, ok_cb, false)
                end
                return
        else
            return '🚫 '..lang_text(msg.to.id, 'require_mod')
        end
		elseif matches[1] == 'rem' then
        if permissions(msg.from.id, msg.to.id, "settings") then
            if msg.reply_id then
                get_message(msg.reply_id, remove_message, false)
                get_message(msg.id, remove_message, false)
            end
            return
        else
            return '🚫 '..lang_text(msg.to.id, 'require_mod')
        end
    elseif matches[1] == 'lang' then
        if permissions(msg.from.id, msg.to.id, "set_lang") then
            hash = 'langset:'..msg.to.id
            redis:set(hash, matches[2])
            return 'ℹ️ '..lang_text(msg.to.id, 'langUpdated')
        else
            return '🚫 '..lang_text(msg.to.id, 'require_sudo')
        end
    elseif matches[1] == 'newlink' then
        if permissions(msg.from.id, msg.to.id, "setlink") then
        	local receiver = get_receiver(msg)
            local hash = 'link:'..msg.to.id
    		local function cb(extra, success, result)
    			if result then
    				redis:set(hash, result)
    			end
	            if success == 0 then
	                return send_large_msg(receiver, 'I can\'t create a newlink.', ok_cb, true)
	            end
    		end
    		if msg.to.type == 'chat' then
                result = export_chat_link(receiver, cb, true)
            elseif msg.to.type == 'channel' then
                result = export_channel_link(receiver, cb, true)
            end
    		if result then
	            if msg.to.type == 'chat' then
	                send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'linkSaved'), ok_cb, true)
	            elseif msg.to.type == 'channel' then
	                send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'linkSaved'), ok_cb, true)
	            end
	        end
            return
        else
            return '?? '..lang_text(msg.to.id, 'require_admin')
        end
    elseif matches[1] == 'link' then
        if permissions(msg.from.id, msg.to.id, "link") then
            hash = 'link:'..msg.to.id
            local linktext = redis:get(hash)
            if linktext then
                if msg.to.type == 'chat' then
                    send_msg('chat#id'..msg.to.id, '🌐 '..lang_text(msg.to.id, 'groupLink')..': '..linktext, ok_cb, true)
                elseif msg.to.type == 'channel' then
                    send_msg('channel#id'..msg.to.id, '🌐 '..lang_text(msg.to.id, 'sGroupLink')..': '..linktext, ok_cb, true)
                end
            else
                if msg.to.type == 'chat' then
                    send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noLinkSet'), ok_cb, true)
                elseif msg.to.type == 'channel' then
                    send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noLinkSet'), ok_cb, true)
                end
            end
            return
        else
            return '🚫 '..lang_text(msg.to.id, 'require_mod')
        end
    elseif matches[1] == 'tosupergroup' then
        if msg.to.type == 'chat' then
            if permissions(msg.from.id, msg.to.id, "tosupergroup") then
                chat_upgrade('chat#id'..msg.to.id, ok_cb, false)
                return 'ℹ️ '..lang_text(msg.to.id, 'chatUpgrade')
            else
                return '🚫 '..lang_text(msg.to.id, 'require_sudo')
            end
        else
            return 'ℹ️ '..lang_text(msg.to.id, 'notInChann')
        end
    elseif matches[1] == 'setdescription' then
        if permissions(msg.from.id, msg.to.id, "description") then
            local text = matches[2]
            local chat = 'channel#id'..msg.to.id
            if msg.to.type == 'channel' then
                channel_set_about(chat, text, ok_cb, false)
                return 'ℹ️ '..lang_text(msg.to.id, 'desChanged')
            else
                return 'ℹ️ '..lang_text(msg.to.id, 'desOnlyChannels')
            end
        else
            return '🚫 '..lang_text(msg.to.id, 'require_admin')
        end
    elseif matches[1] == 'muteall' and matches[2] then
    	if permissions(msg.from.id, msg.to.id, "muteall") then
    		print(1)
    		local hash = 'muteall:'..msg.to.id
    		redis:setex(hash, tonumber(matches[2]), true)
    		print(2)
            return 'ℹ️ '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[2]..' '..lang_text(msg.to.id, 'muteAllX:2')
        else
            return '🚫 '..lang_text(msg.to.id, 'require_admin')
        end
    elseif matches[1] == 'muteall' then
    	if permissions(msg.from.id, msg.to.id, "muteall") then
    		local hash = 'muteall:'..msg.to.id
    		redis:set(hash, true)
            return 'ℹ️ '..lang_text(msg.to.id, 'muteAll')
        else
            return '🚫 '..lang_text(msg.to.id, 'require_admin')
        end
    elseif matches[1] == 'unmuteall' then
    	if permissions(msg.from.id, msg.to.id, "muteall") then
    		local hash = 'muteall:'..msg.to.id
    		redis:del(hash)
            return 'ℹ️ '..lang_text(msg.to.id, 'unmuteAll')
        else
            return '🚫 '..lang_text(msg.to.id, 'require_admin')
        end
    elseif matches[1] == 'creategroup' and matches[2] then
		if permissions(msg.from.id, msg.to.id, "creategroup") then
	            group_name = matches[2]
		    return create_group(msg, group_name)
		end
				   elseif matches[1] == 'pcreategroup' and matches[2] and matches[3] then
		if permissions(msg.from.id, msg.to.id, "creategroup") then
		    user_info('user#id'..matches[2], create_group2, {msg=msg, group_name=matches[3]})
		end
    elseif matches[1] == 'chat_created' and msg.from.id == 0 then
    table.insert(_chats.chats, {tonumber(msg.to.id), string.gsub(msg.to.title, '_', ' ')})
	print(msg.to.id..' added to _chats table')
	save_chats()
	local chat_id = msg.to.id
	chat_info('chat#id'..msg.to.id, owincreate, {chat_id=chat_id})
    end
end

return {
    patterns = {
        '^[!/#](settings)$',
		'^[!/#](set) ([^%s]+) (.*)$',
		'^[!/#](set) (.*)$',
        '^[!/#](lock) (.*)$',
        '^[!/#](unlock) (.*)$',
        '^[!/#](rem)$',
        '^[!/#](muteall)$',
        '^[!/#](muteall) (.*)$',
        '^[!/#](unmuteall)$',
        '^[!/#](link)$',
        '^[!#/](setlang)$',
        '^[!/#](newlink)$',
        '^[!/#](tosupergroup)$',
        '^[!/#](lang) (.*)$',
        '^[!/#](creategroup) (.*)$',
        '^[!/#](pcreategroup) (%d*) (.*)$',
		'^[!/#](tophoto)$',
		'^[!/#](tosticker)$',
 		'^!!tgservice (.+)$'
    },
    pre_process = pre_process,
    run = run
}
end
