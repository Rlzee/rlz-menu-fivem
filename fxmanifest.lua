fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Rlzee'
description 'A menu system for FiveM'
repository 'https://github.com/Rlzee/rlz-menu'
version '1.0.0'

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