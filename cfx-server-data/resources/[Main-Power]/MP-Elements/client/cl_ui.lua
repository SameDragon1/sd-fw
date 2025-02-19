local MP = exports['MP-Base']:GetObject()
local loaded = false 

RegisterNetEvent('MP-Elements:client:OpenUI:Cash')
AddEventHandler('MP-Elements:client:OpenUI:Cash', function()
    SendNUIMessage({action = "hide"})
    MP.Functions.TriggerServerCallback('MP-Elements:Server:getMoney', function(cash, bank)
        SendNUIMessage({action = 'setValue', key = 'cash', value = cash})
    end)
end)

RegisterNetEvent('MP-Elements:client:CloseCharUI')
AddEventHandler('MP-Elements:client:CloseCharUI', function()
    SendNUIMessage({action = "hide"})
end)

RegisterNetEvent('MP-Elements:Client:UpdateCash')
AddEventHandler('MP-Elements:Client:UpdateCash', function(amount,change,value)
    SendNUIMessage({action = 'updateValue', key = 'cash', value = amount})
    if change == 'add' then 
        SendNUIMessage({action = 'addCash', value = value})
    elseif change == 'remove' then 
        SendNUIMessage({action = 'removeCash', value = value})
    end
end)

RegisterCommand('cash', function(source, args)
    TriggerEvent('MP-Elements:ShowingCash', source)
end)

RegisterNetEvent('MP-Elements:ShowingCash')
AddEventHandler('MP-Elements:ShowingCash', function()
    SendNUIMessage({action = "show"})
    Wait(5000)
    SendNUIMessage({action = "hide"})
end)

-- Notifications
-- exports['MP-Elements']:Noti(clr, msg, time)
--[[ 

clr = color || 1,2,3 | Green, red, blue // default blue
msg = msg
time short/long

--]]

function OpenNoti(clr, msg, time)
    ui = true
    SendNUIMessage({runNoti = true, color = clr, text = msg, time = time})
end

function CloseNoti()
    ui = false
    SendNUIMessage({closeNoti = true})
end

-- exports['MP-Elements']:Noti(clr, msg, time)
exports('Noti', function(clr,msg,time)
    if not clr then clr = 1 end -- default blue
    if not time then time = 6000 end 
    if time == 'short' then time = 6000 end if time == 'long' then time = 12000 end
    OpenNoti(clr, msg, time)
end)

RegisterNetEvent('MP-Elements:SendNotification')
AddEventHandler('MP-Elements:SendNotification', function(clr, msg)
    exports['MP-Elements']:Noti(clr, msg, 6000)
end)

RegisterCommand('test', function(args, raw)
    exports['MP-Elements']:Noti(2, "cocks n balls", 6000)
end)