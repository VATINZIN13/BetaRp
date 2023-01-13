fx_version 'bodacious'
games { 'gta5' }

author 'Wave Shop'
description 'Script for phone'
version '1.0'

ui_page "html/index.html"

shared_scripts {
    "config.lua",
    "locale.lua",
    "locales/*.lua",
}

client_scripts {
	"@vrp/lib/utils.lua",
	'locale.lua',
	'locales/*.lua',
    'client/*.lua',
}

server_scripts {
	"@vrp/lib/utils.lua",
	'locale.lua',
	'locales/*.lua',
	"system/functions.lua",
    'server/*.lua',
}

files {
    'html/*',
    'html/**/*',
    'html/**/**/*',
}

dependencies {
    'vrp',
    'oxmysql'
}