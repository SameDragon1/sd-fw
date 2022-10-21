
fx_version 'adamant'
game 'gta5'


dependency 'ghmattimysql'

author 'JSP'


server_scripts {
    "config.lua",
    "server/sv_logs.lua",
}

client_scripts{
    "config.lua",
    "client/cl_discord.lua",
    -- "client/cl_logDeath.lua",
}