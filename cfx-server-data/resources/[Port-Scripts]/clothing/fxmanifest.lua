fx_version 'cerulean'
game 'gta5'

description 'QB-Clothing'

ui_page 'html/index.html'

shared_script 'config.lua'

server_scripts {
	'server/main.lua'
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/ComboZone.lua',
	'client/main.lua'
}
files {
	'html/index.html',
	'html/style.css',
	'html/reset.css',
	'html/script.js',
	'html/image.png',
}

lua54 'yes'
