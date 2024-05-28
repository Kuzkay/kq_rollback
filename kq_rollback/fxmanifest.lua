fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'KuzQuality | Kuzkay'
description 'Better Rollback & handbrake turns by KuzQuality.com'
version '1.0.0'

--
-- Client
--

client_scripts {
    'config.lua',
    'client/client.lua',
}

escrow_ignore {
    'config.lua',
    'client/client.lua',
}
