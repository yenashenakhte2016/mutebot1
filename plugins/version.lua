--------------------------------------------------
--      ____  ____ _____                        --
--     |    \|  _ )_   _|___ ____   __  __      --
--     | |_  )  _ \ | |/ ·__|  _ \_|  \/  |     --
--     |____/|____/ |_|\____/\_____|_/\/\_|     --
--                                              --
--------------------------------------------------
--                                              --
--       Developers: @Josepdal & @MaSkAoS       --
--     Support: @Skneos,  @iicc1 & @serx666     --
--                                              --
--------------------------------------------------

do

function run(msg, matches)
  return 'Security Bot V1 Supergroups\nAn advanced Administration bot \n\nDevelopers: @MohammadDeveloper @Mutepuker\nChannel: @MuteTeam'
end

return {
  patterns = {
    "^#version$",
    "^!version$",
    "^/version$"
  }, 
  run = run 
}

end
