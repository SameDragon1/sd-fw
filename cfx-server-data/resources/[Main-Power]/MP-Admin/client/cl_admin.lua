local blank = -1 
-- RegisterNetEvent('MP-Admin:Client:SaveCoords')
-- AddEventHandler('MP-Admin:Client:SaveCoords', function()
--     blank = blank +1 -- set to 0 on default
--     x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
--     TriggerServerEvent('MP-Admin:SaveCoords', blank, x, y, z)
-- end)

-- RegisterNetEvent('MP-Admin:SpawnVehicle')
-- AddEventHandler('MP-Admin:SpawnVehicle', function(vehicle)
--     local PlayerPos = GetEntityCoords(GetPlayerPed(-1))
--     RequestModel(GetHashKey(vehicle))
--     if not IsModelValid(GetHashKey(vehicle)) then 
--         Wait(0)
--     end
--     CreateVehicle(GetHashKey(vehicle), PlayerPos.x, PlayerPos.y, PlayerPos.z, 200, 1,0 )
-- end)
-- Export Based 
function MP.Admin.SaveCoords()
    blank = blank +1 -- set to 0 on default
    x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    TriggerServerEvent('MP-Admin:SaveCoords', blank, x, y, z)
end

function MP.Admin.SpawnVehicle(vehicle)
    local PlayerPos = GetEntityCoords(GetPlayerPed(-1))
    RequestModel(GetHashKey(vehicle))
    if not IsModelValid(GetHashKey(vehicle)) then 
        Wait(0)
    end
    CreateVehicle(GetHashKey(vehicle), PlayerPos.x, PlayerPos.y, PlayerPos.z, 200, 1,0 )
end

function MP.Admin.TeleportWaypoint(source)
    local blip = GetFirstBlipInfoId(8)
    if DoesBlipExist(blip) then 
        local PointCoords = GetBlipInfoIdCoord(blip)
        for height = 1,1000 do 
            SetPedCoordsKeepVehicle(source, PointCoords["x"], PointCoords["y"], PointCoords["z"], height + 0.0)

            local ground, zPos = GetGroundZFor_3dCoord(PointCoords["x"], PointCoords["y"], PointCoords["z"], height + 0.0)

            if ground then 
                SetPedCoordsKeepVehicle(source, PointCoords["x"], PointCoords["y"], PointCoords["z"], height + 0.0)
                break
            end
            Wait(10)
        end
    else
        TriggerClientEvent('MP-Elements:SendNotification', source,  2, "No Blip Found" )
    end
end

function MP.Admin.BringPlayer(pos)
    local ped = source

    Citizen.CreateThread(function()
        RequestCollisionAtCoord(pos["x"], pos["y"], pos["z"])
        SetEntityCoordsNoOffset(ped, pos["x"], pos["y"], pos["z"], 0, 0, 2.0)
        FreezeEntityPosition(ped, true)
        SetPlayerInvincible(ped, true)

        Wait(10000)
        FreezeEntityPosition(ped, false)
        SetPlayerInvincible(ped, false)
    end)
end

RegisterNetEvent("MP-Admin:bringPlayer")
AddEventHandler("MP-Admin:bringPlayer", function(source,target)

    -- Target = number
    local pedCoords = GetEntityCoords(source, false)
    local pos = {}
    pos["x"] = pedCoords.x
    pos["y"] = pedCoords.y
    pos["z"] = pedCoords.z

    MP.Admin.BringPlayer(pos,target)
end)