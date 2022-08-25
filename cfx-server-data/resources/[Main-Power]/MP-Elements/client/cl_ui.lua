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
