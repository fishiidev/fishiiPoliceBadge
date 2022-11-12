function GetPlayersFromCoords(coords, distance)
    local players = GetActivePlayers()
    local ped = PlayerPedId()
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    distance = distance or 5
    local closePlayers = {}
    for _, player in pairs(players) do
        local target = GetPlayerPed(player)
        local targetCoords = GetEntityCoords(target)
        local targetdistance = #(targetCoords - coords)
        if targetdistance <= distance then
            closePlayers[#closePlayers + 1] = GetPlayerServerId(player)
        end
    end
    return closePlayers
end

function LoadAnimationDic(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(0)
        end
    end
end

RegisterNetEvent('showWithoutAnim', function(badge_photo)
    SendNUIMessage({
        type = 'displayBadge',
        badge_photo = badge_photo or Cfg.defaultBadgePhoto,
        time = Cfg.badgeTime or 5000,
    })
end)

local function displayBadge(badge_photo)
    local player = PlayerPedId()
    local badge = CreateObject(GetHashKey('prop_cs_polaroid'), GetEntityCoords(player), 1, 1, 1)
    AttachEntityToEntity(badge, player, GetPedBoneIndex(player, 28422), 0.15, 0.055, -0.025, 170.0, 0.0, -240.0, true, true, false, false, true, true)
    LoadAnimationDic("paper_1_rcm_alt1-9")
    TaskPlayAnim(PlayerPedId(), "paper_1_rcm_alt1-9", "player_one_dual-9", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
    TriggerServerEvent("fishii-s", badge_photo or Cfg.defaultBadgePhoto, GetPlayersFromCoords(GetEntityCoords(player)))
    SendNUIMessage({
        type = 'displayBadge',
        badge_photo = badge_photo or Cfg.defaultBadgePhoto,
        time = Cfg.badgeTime or 5000,
    })
    Citizen.Wait(Cfg.badgeTime or 5000)
    DeleteEntity(badge)
    StopAnimTask(PlayerPedId(), "paper_1_rcm_alt1-9", "player_one_dual-9", 1.0)
end

RegisterNetEvent('fishii:dBadge', function(badge_photo)
    displayBadge(badge_photo)
    
end)

function badge_options(user_type)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fishii_options',{
        title = 'Badge Options',
        align = 'right',
        elements = {
            {label = 'Change Badge Image', value = 'change'},
            {label = 'Give Badge', value = 'give'},
            {label = 'Delete Badge', value = 'delete'},
            {label = 'Go Back', value = 'back'},
        }

    }, function(data, menu)
        if data.current.value == 'change' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'fishii_change',{
                title = 'Ingresa la URL de la imagen'
            }, function(data2, menu2)
                local url = data2.value
                if url then
                    ESX.TriggerServerCallback('fishii:changePhoto', function(cb) end, url, user_type.pID)
                    menu2.close()
                else
                    ESX.ShowNotification('URL invalida')
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == 'delete' then
            ESX.TriggerServerCallback('fishii:deletePhoto', function(cb) end, user_type.pID)
            menu2.close()
        elseif data.current.value == 'give' then
            ESX.TriggerServerCallback('fishii:givePlate', function(cb) end, user_type.pID)

        elseif data.current.value == 'back' then
            menu.close()
            badge_creator(ESX.GetPlayerData().job.name)
        end
            
    end, function(data, menu)
        menu.close()
    end)

end


function badge_creator(job)
    local connectedOfficers = {}

    ESX.TriggerServerCallback('fishii:returnConnectedJOB', function(cb) 

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fishii_creator', {
            title = 'Badge Creator',
            align = 'right',
            elements = cb

        }, function(data, menu)

            menu.close()
            badge_options(data.current)


        end, function(data, menu)
            menu.close()
        end)


    end, job)
end



-- and ESX.GetPlayerData().job.grade == 'boss' 
CreateThread(function()
    while true do
        local wait = 1000
        

        for k,v in pairs(Cfg.badgeS) do
            if #(GetEntityCoords(PlayerPedId()) - v.coords) < v.dist and ESX.GetPlayerData().job.name == v.jobName and ESX.GetPlayerData().job.grade == 'boss' then
                wait = 0
                HelpNotification(Cfg.Locales['badge_creator'], v.coords)
       
                if IsControlJustPressed(0, 38) then
                    badge_creator(v.jobName)
                end
            end
        end



        Wait(wait)
    end
end)
