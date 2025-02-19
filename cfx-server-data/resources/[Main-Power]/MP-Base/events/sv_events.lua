--  Call Mp.
MP.Functions = MP.Functions or {}
MP.Commands =  {}
MP.CommandsSuggestions =  {}
MP.ServerCallbacks = MP.ServerCallbacks or {}
MP.ServerCallback = {}


MP.Functions.RegisterServerCallback = function(name, cb)
	MP.ServerCallbacks[name] = cb
end

MP.Functions.TriggerServerCallback = function(name, requestId, source, cb, ...)
	if MP.ServerCallbacks[name] ~= nil then
		MP.ServerCallbacks[name](source, cb, ...)
	end
end

MP.Functions.getPlayer = function(source)
	if MP.Players[source] ~= nil then
		return MP.Players[source]
	end
end

MP.Functions.AdminPlayer = function(source) -- Admin
    if MP.APlayers[source] ~= nil then 
        return MP.APlayers[source]
    end
end

RegisterNetEvent('MP-Base:server:UpdatePlayer')
AddEventHandler('MP-Base:server:UpdatePlayer', function()
    local civ = source 
    local player = MP.Functions.GetPlayer(civ)
    if player then 
        Player.Functions.Save()
    end
end)

-- Character SQL Stuff
MP.Functions.CreatePlayer = function(source, Data)
	exports['ghmattimysql']:execute('INSERT INTO players (`identifier`, `license`, `name`, `cash`, `bank`) VALUES (@identifier, @license, @name, @cash, @bank)', {
		['identifier'] = Data.identifier,
		['license'] = Data.license,
		['name'] = Data.name,
		['cash'] = Data.cash,
		['bank'] = Data.bank
	})

    print('[MP-Base] '..Data.name..' was created successfully')

    MP.Functions.LoadPlayer(source, Data)
end

MP.Functions.LoadPlayer = function(source, pData, cid, new)
    local src 			= source
	local identifier 	= pData.identifier
	
	Citizen.Wait(7)
	exports['ghmattimysql']:execute('SELECT * FROM players WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = identifier, ['@cid'] = cid}, function(result)

		--Server
		exports['ghmattimysql']:execute('UPDATE players SET name = @name WHERE identifier = @identifier AND cid = @cid', { ['@identifier'] = identifier, ['@name'] = pData.name, ['@cid'] = cid})

        MP.Player.LoadData(source, identifier, cid)
		Citizen.Wait(7)
		local player = MP.Functions.getPlayer(source)
        TriggerClientEvent('MP-SetCharData', source, {
            identifier = result[1].identifier,
			license = result[1].license,
			cid = result[1].cid,
			name = result[1].name,
			cash = result[1].cash,
			bank = result[1].bank,
			citizenid = result[1].citizenid,
        })

        TriggerClientEvent('MP-Base:PlayerLoaded', source, new)
        -- TriggerClientEvent() come back to for ui
        -- Trigger for Admin
    end)
end

MP.Functions.addCommand = function(command, callback, suggestion, args)
    MP.Commands[command] = {}
	MP.Commands[command].cmd = callback
    MP.Commands[command].args = args or -1

    if suggestion then 
        if not suggestion.params or not type(suggestion.params) == 'table' then suggestion.params = {} end 
        if not suggestion.help or not type(suggestion.help) == 'string' then suggestion.help = {} end

        MP.CommandsSuggestions[command] = suggestion
    end

    RegisterCommand(command, function(source, args)
        if((#args <= MP.Commands[command].args and #args == MP.Commands[command].args) or MP.Commands[command].args == -1) then 
            callback(source, args, MP.Players[source])
        end
    end, false)
end

MP.Functions.addGroupCommand = function(command, group, callback, callbackfailed, suggestion, arguments)
	MP.Commands[command] = {}
	MP.Commands[command].perm = math.maxinteger
	MP.Commands[command].group = group
	MP.Commands[command].cmd = callback
	MP.Commands[command].callbackfailed = callbackfailed
	MP.Commands[command].arguments = arguments or -1

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end

		MP.CommandsSuggestions[command] = suggestion
	end

	ExecuteCommand('add_ace group.' .. group .. ' command.' .. command .. ' allow')

	RegisterCommand(command, function(source, args)
		local Source = source
		local pData = MP.Functions.AdminPlayer(Source)

		if(source ~= 0)then
			if pData ~= nil then
				if pData.Data.usergroup == MP.Commands[command].group then
					if((#args <= MP.Commands[command].arguments and #args == MP.Commands[command].arguments) or MP.Commands[command].arguments == -1)then
						callback(source, args, MP.Players[source])
					end
				else
					callbackfailed(source, args, MP.Players[source])
				end
			end
		else
			if((#args <= MP.Commands[command].arguments and #args == MP.Commands[command].arguments) or MP.Commands[command].arguments == -1)then
				callback(source, args, MP.Players[source])
			end
		end
	end, true)
end


-- Usergroups for admin
MP.Functions.setGroup = function(player, group)
    local identifier = player.Data.identifier
    local pCid = player.Data.cid
    exports['ghmattimysql']:execute('DELETE FROM ranking WHERE identifier = @identifier', {['@identifier'] = identifier})
	Wait(1000)
    
	
	exports['ghmattimysql']:execute('INSERT INTO ranking (`usergroup`, `identifier`) VALUES (@usergroup, @identifier)', {
		['@usergroup'] = group,
		['@identifier'] = identifier
	})
    print('Function Group : '..group)
    TriggerClientEvent('MP-Admin:updateGroup', player.Data.PlayerId, group)
end

MP.Functions.BuildCommands = function(source)
    local src = source
    for k,v in pairs(MP.CommandsSuggestions) do 
        TriggerClientEvent('chat:addSuggestion', src, '/'..k, v.help, v.params)
    end
end

MP.Functions.ClearCommands = function(source)
    for k,v in pairs(MP.CommandsSuggestions) do 
        TriggerClientEvent('chat:removeSuggestion', src, '/'..k, v.help, v.params)
    end
end