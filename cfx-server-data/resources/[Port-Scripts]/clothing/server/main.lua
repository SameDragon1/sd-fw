local MP = exports['MP-Base']:GetObject()

RegisterServerEvent("qb-clothing:saveSkin")
AddEventHandler('qb-clothing:saveSkin', function(model, skin)
    local src = source
    local Player = MP.Functions.getPlayer(src)
    if model ~= nil and skin ~= nil then
        -- TODO: Update primary key to be citizenid so this can be an insert on duplicate update query
        exports['ghmattimysql']:execute('DELETE FROM playerskins WHERE citizenid = ?', { Player.Data.citizenid }, function()
            exports['ghmattimysql']:execute('INSERT INTO playerskins (citizenid, model, skin, active) VALUES (?, ?, ?, ?)', {
                Player.Data.citizenid ,
                model,
                skin,
                1
            })
        end)
    end
end)

RegisterServerEvent("qb-clothes:loadPlayerSkin")
AddEventHandler('qb-clothes:loadPlayerSkin', function()
    local src = source
    local Player = MP.Functions.getPlayer(src)
    local result = exports['ghmattimysql']:execute('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', { Player.Data.citizenid , 1 })
    if result[1] ~= nil then
        TriggerClientEvent("qb-clothes:loadSkin", src, false, result[1].model, result[1].skin)
    else
        TriggerClientEvent("qb-clothes:loadSkin", src, true)
    end
end)

RegisterServerEvent("qb-clothes:saveOutfit")
AddEventHandler("qb-clothes:saveOutfit", function(outfitName, model, skinData)
    local src = source
    local Player = MP.Functions.getPlayer(src)
    if model ~= nil and skinData ~= nil then
        local outfitId = "outfit-"..math.random(1, 10).."-"..math.random(1111, 9999)
        exports['ghmattimysql']:execute('INSERT INTO player_outfits (citizenid, outfitname, model, skin, outfitId) VALUES (?, ?, ?, ?, ?)', {
            Player.Data.citizenid ,
            outfitName,
            model,
            json.encode(skinData),
            outfitId
        }, function()
            local result = exports['ghmattimysql']:execute('SELECT * FROM player_outfits WHERE citizenid = ?', { Player.Data.citizenid  })
            if result[1] ~= nil then
                TriggerClientEvent('qb-clothing:client:reloadOutfits', src, result)
            else
                TriggerClientEvent('qb-clothing:client:reloadOutfits', src, nil)
            end
        end)
    end
end)

RegisterServerEvent("qb-clothing:server:removeOutfit")
AddEventHandler("qb-clothing:server:removeOutfit", function(outfitName, outfitId)
    local src = source
    local Player = MP.Functions.getPlayer(src)
    exports['ghmattimysql']:execute('DELETE FROM player_outfits WHERE citizenid = ? AND outfitname = ? AND outfitId = ?', {
        Player.Data.citizenid ,
        outfitName,
        outfitId
    }, function()
        local result = exports['ghmattimysql']:execute('SELECT * FROM player_outfits WHERE citizenid = ?', { Player.Data.citizenid  })
        if result[1] ~= nil then
            TriggerClientEvent('qb-clothing:client:reloadOutfits', src, result)
        else
            TriggerClientEvent('qb-clothing:client:reloadOutfits', src, nil)
        end
    end)
end)

MP.Functions.TriggerServerCallback('qb-clothing:server:getOutfits', function(source, cb)
    local src = source
    local Player = MP.Functions.getPlayer(src)
    local anusVal = {}

    local result = exports['ghmattimysql']:execute('SELECT * FROM player_outfits WHERE citizenid = ?', { Player.Data.citizenid  })
    if result[1] ~= nil then
        for k, v in pairs(result) do
            result[k].skin = json.decode(result[k].skin)
            anusVal[k] = v
        end
        cb(anusVal)
    end
    cb(anusVal)
end)