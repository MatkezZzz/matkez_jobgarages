fx_version 'cerulean'
game 'gta5'
author 'MatkezZz'
description 'Job garages'
lua54 'yes'
version '1.0.0'

client_scripts {
    'client.lua',
    'bridge/client/*.lua',
    '@qbx_core/modules/playerdata.lua'
}

server_scripts {
	'server.lua',
    'bridge/server/*.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'bridge/shared.lua'
}

ui_page 'ui/asd.html'

files {
    'ui/**/*',
    'locales/*.json'
}