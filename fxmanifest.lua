fx_version 'cerulean'
games { 'gta5' }
author 'Snooppikoira'
lua54 'yes'

shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua',
	'config.lua',
}

client_scripts {
	'client/*.lua',
	'elevators/*.lua',
}

files {
	'locales/*.json',
	'web/index.html',
	'web/*.js',
	'web/*.css',
	'web/assets/*.mp3'
}

ui_page 'web/index.html'
