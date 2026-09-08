fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'rlz'
description ''
repository ''
version '2.0.0'

files {
    'web/dist/**/*',
}

ui_page 'web/dist/index.html'

client_scripts {
    'class.lua',
    'utils/*.lua',
    'menu/main.lua',
    'menu/items.lua',
    'menu/functions.lua',
    'menu/callbacks.lua',
    'test.lua',
}