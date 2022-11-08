ESX = exports['es_extended']:getSharedObject()


Cfg = {} or Cfg

Cfg.badgeTime = 5 * 1000 -- 5 seconds
Cfg.defaultBadgePhoto = 'https://cdn.discordapp.com/attachments/926087498705301525/1039350990702391386/image.png'

-- and ESX.GetPlayerData().job.grade == 'boss'
Cfg.badgeS = {
    {jobName = 'unemployed', coords = vec3(865.01, -716.69, 42.57), dist = 3.0},
}

Cfg.Locales = {
    ['badge_creator'] = '[E] | Police Badge Creator'
}

function HelpNotification(text, coords)
    ESX.ShowFloatingHelpNotification(text, coords)
end

Cfg.itemName = 'pdbadge'