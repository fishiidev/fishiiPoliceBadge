
local function getBadgePhoto(pID)
    local xPlayer = ESX.GetPlayerFromId(pID)
    local identifier = xPlayer.identifier
    local badge_photo = MySQL.scalar.await('SELECT badge_photo FROM users WHERE identifier = ?', {identifier})
    if badge_photo then
        return badge_photo
    else
        return nil
    end
end

local function insertBadgePhoto(pID,url)
    local xPlayer = ESX.GetPlayerFromId(pID)
    local identifier = xPlayer.identifier
    MySQL.update('UPDATE users SET badge_photo = ? WHERE identifier = ?', {url, identifier}, function()
        print('Badge photo updated')
    end)
end

local function deleteBadgePhoto(pID)
    local xPlayer = ESX.GetPlayerFromId(pID)
    local identifier = xPlayer.identifier
    MySQL.update('UPDATE users SET badge_photo = NULL WHERE identifier = ?', {identifier}, function()
        print('Badge photo deleted')
    end)
end


ESX.RegisterServerCallback('fishii:changePhoto', function(src, cb, url, pID)
    insertBadgePhoto(pID, url)
end)


ESX.RegisterServerCallback('fishii:deletePhoto', function(src, cb, pID)
    deleteBadgePhoto(pID, url)
end)

ESX.RegisterServerCallback('fishii:givePlate', function(src, cb, pID)
    local xPlayer = ESX.GetPlayerFromId(pID)
    if not xPlayer then ESX.GetPlayerFromId(src).ShowNotification('Jugador no en linea') return end
    xPlayer.addInventoryItem(Cfg.itemName, 1)
end)


ESX.RegisterUsableItem(Cfg.itemName, function(src)
    TriggerClientEvent('fishii:dBadge', src, getBadgePhoto(src))
end)


ESX.RegisterServerCallback('fishii:returnConnectedJOB', function(src, cb, jobName)
    local xPlayers = ESX.GetPlayers()
    local jobPlayers = {}
    for k,v in pairs(xPlayers) do
        local xPlayer = ESX.GetPlayerFromId(v)
        if xPlayer.job.name == jobName then
            table.insert(jobPlayers, {
                label = 'ID: '..xPlayer.source..' | '..xPlayer.name,
                name = xPlayer.name,
                identifier = xPlayer.identifier,
                pID = xPlayer.source,
                badge_photo = getBadgePhoto(xPlayer.source) or Cfg.defaultBadgePhoto,
            })
        end
    end
    cb(jobPlayers)
end)



RegisterNetEvent("fishii-s", function(info, players)
    for k,v in pairs(players) do
        TriggerClientEvent('showWithoutAnim', v, info)
    end
end)
