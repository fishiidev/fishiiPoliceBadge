fx_version 'cerulean'
game 'gta5'

author 'fishii'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/index.js',
    'ui/index.css',
}

client_scripts {
    'cl_main.lua'
}

shared_scripts {
    'cfg.lua'
}

server_scripts {
    'sv_main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
}