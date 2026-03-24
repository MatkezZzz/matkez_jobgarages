local config = lib.require('config')

lib.callback.register('matkez_jobgarages:spawnVehicle', function(src, garage, model, color)
    if not garage then return false end
    local garageCfg = config.garages[garage]
    if not garageCfg then return false end
    local job = getPlayerJob(src, garageCfg.access.type)
    if job.name ~= garageCfg.access.name then return false end

    local vehicles = garageCfg.vehicles
    local modelData
    local exist = false
    for i = 1, #vehicles do
        local v = vehicles[i]
        if v.model == model then
            modelData = vehicles[i]
            exist = true
            break
        end
    end

    if not exist then return false end
    if job.grade < modelData.minGrade then return false end

    local spawns = garageCfg.spawnCoords[modelData.spawnType]
    local spawnCoords
    for _, v in ipairs(spawns) do
        local veh, coords = lib.getClosestVehicle(v.xyz, 3.0, true)
        if not veh then
            spawnCoords = v
            break
        end
    end

    if not spawnCoords then notify(src, translate('noSpace'), 'error', 5000) return false end

    local vehicle = CreateVehicle(model, spawnCoords.xyzw, true, false)
    while not DoesEntityExist(vehicle) do
        Wait(10)
    end
    giveKeys(src, GetVehicleNumberPlateText(vehicle))
    SetVehicleDirtLevel(vehicle, 0)
    TriggerClientEvent('matkez_jobgarages:black', src, NetworkGetNetworkIdFromEntity(vehicle))
    if modelData.color then
        SetVehicleCustomPrimaryColour(vehicle, modelData.color[1], modelData.color[2], modelData.color[3])
        SetVehicleCustomSecondaryColour(vehicle, modelData.color[1], modelData.color[2], modelData.color[3])
    end
    if garageCfg.chooseColor and color then
        SetVehicleCustomPrimaryColour(vehicle, color[1], color[2], color[3])
        SetVehicleCustomSecondaryColour(vehicle, color[1], color[2], color[3])
    end
    if garageCfg.setIntoVehicle then
        TaskWarpPedIntoVehicle(GetPlayerPed(src), vehicle, -1)
    end
    if modelData.mods then
        lib.setVehicleProperties(vehicle, modelData.mods)
    end
    return true
end)

lib.callback.register('matkez_jobgarages:setBucket', function(src, ty, garage)
    if not src then return false end
    if not garage then
        DropPlayer(src, 'Wau')
        return false
    end

    local garageCfg = config.garages[garage]
    if not garageCfg then
        DropPlayer(src, 'Wau')
        return false
    end

    local job = getPlayerJob(src, garageCfg.access.type)
    if job.name ~= garageCfg.access.name then
        DropPlayer(src, 'Wau')
        return false
    end
    
    if ty == 'set' then
        SetPlayerRoutingBucket(src, src)
    elseif ty == 'reset' then
        SetPlayerRoutingBucket(src, 0)
    end
    return true
end)