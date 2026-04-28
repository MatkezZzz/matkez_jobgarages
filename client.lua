local config = lib.require('config')
local previewVehicle
local previewCam
local currentGarage
local props = {}
local i = config.icons

function doPreview(model, color)
    if not currentGarage then return end
    local garageCfg = config.garages[currentGarage]
    if not garageCfg then return end

    if previewVehicle then
        local previewHash = GetEntityModel(previewVehicle)
        local modelHash = GetHashKey(model)
        if previewHash == modelHash then
            DeleteEntity(previewVehicle)
            previewVehicle = nil
            return
        end
    end

    local modelData
    for i = 1, #garageCfg.vehicles do
        local v = garageCfg.vehicles[i]
        if v.model == model then
            modelData = garageCfg.vehicles[i]
            break
        end
    end
    if not modelData then return end

    DeleteEntity(previewVehicle)
    previewVehicle = nil
    local previewData = garageCfg.preview[modelData.previewType]
    SendNUIMessage({
        event = 'loading',
        show = true
    })
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    previewVehicle = CreateVehicle(model, previewData.vehCoords.xyzw, false, false)
    SendNUIMessage({
        event = 'loading',
        show = false
    })
    SetVehicleDirtLevel(previewVehicle, 0)
    SetVehicleFixed(previewVehicle)
    SetEntityInvincible(previewVehicle, true)
    FreezeEntityPosition(previewVehicle, true)
    SetVehicleDoorsLocked(previewVehicle, 10)
    SetVehicleExtraColours(previewVehicle, 0)
    SetVehicleEngineOn(previewVehicle, true, true, false)
    SetEntityCollision(previewVehicle, false, false)

    if modelData.color then
        SetVehicleCustomPrimaryColour(previewVehicle, modelData.color[1], modelData.color[2], modelData.color[3])
        SetVehicleCustomSecondaryColour(previewVehicle, modelData.color[1], modelData.color[2], modelData.color[3])
    end
    if garageCfg.chooseColor and color then
        SetVehicleCustomPrimaryColour(previewVehicle, color[1], color[2], color[3])
        SetVehicleCustomSecondaryColour(previewVehicle, color[1], color[2], color[3])
    end
    if modelData.mods then
        lib.setVehicleProperties(previewVehicle, modelData.mods)
    end
    if previewCam then
        RenderScriptCams(false, true, 0, false, false)
        DestroyCam(previewCam)
    end
    SetFocusPosAndVel(previewData.vehCoords.xyz, 0, 0, 0)
    previewCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(previewCam, previewData.camCoords.xyz)
    PointCamAtCoord(previewCam, previewData.vehCoords.xyz)
    RenderScriptCams(true, true, 0, false, true)
end

function stopPreview()
    ClearFocus()
    DeleteEntity(previewVehicle)
    previewVehicle = nil
    RenderScriptCams(false, true, 0, false, false)
    DestroyCam(previewCam)
    previewCam = nil
    currentGarage = nil
    SetEntityInvincible(cache.ped, false)
end

function openGarage(garage)
    local garageCfg = config.garages[garage]
    if not garageCfg then return end
    currentGarage = garage
    local playerJob = getPlayerJob(garageCfg.access.type)
    local vehicles = {}
    for _, v in ipairs(garageCfg.vehicles) do
        table.insert(vehicles, {
            model = v.model,
            brand = v.brand,
            label = v.label,
            locked = playerJob.grade < v.minGrade and true or false,
            image = v.image == false and 'https://docs.fivem.net/vehicles/'..v.model..'.webp' or v.image
        })
    end
    SendNUIMessage({
        event = 'open',
        vehicles = vehicles,
        label = garageCfg.label,
        chooseColor = garageCfg.chooseColor,
        icon = garageCfg.icon
    })
    SetNuiFocus(true, true)
    SetEntityInvincible(cache.ped, true)
end

function setupGarages()
    Wait(500)
    for i = 1, #props do
        DeleteEntity(props[i])
    end
    for k, v in pairs(config.garages) do
        local inter = v.interaction
        local model = inter.prop
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end

        local prop = CreateObject(model, inter.coords.xyz, false, false, false)
        SetEntityHeading(prop, inter.coords.w)
        FreezeEntityPosition(prop, true)
        SetEntityInvincible(prop, true)
        table.insert(props, prop)

        createInteraction(prop, {
            {
                icon = i.open,
                label = translate('open'),
                distance = inter.openDistance,
                canInteract = function()
                    return not IsPedInAnyVehicle(cache.ped, false)
                end,
                onSelect = function()
                    local job = getPlayerJob(v.access.type)
                    if job.name == v.access.name then
                        openGarage(k)
                        return
                    end
                    notify(nil, translate('noAccess'), 'error', 5000)
                end,
                allowInVehicle = true
            },
            {
                icon = i.returnVehicle,
                label = translate('returnVehicle'),
                distance = inter.returnDistance,
                canInteract = function()
                    return IsPedInAnyVehicle(cache.ped, false) or false
                end,
                onSelect = function()
                    local job = getPlayerJob(v.access.type)
                    if job.name == v.access.name then
                        local veh = GetVehiclePedIsIn(cache.ped, false)
                        TaskLeaveVehicle(cache.ped, veh, 1)
                        Wait(1500)
                        if not DoesEntityExist(veh) then return false end
                        DeleteEntity(veh)
                        return
                    end
                    notify(nil, translate('noAccess'), 'error', 5000)
                end,
                allowInVehicle = true
            },
        })

        for _, a in ipairs(inter.additionalReturns) do
            local additionalReturn = CreateObject(model, a.xyz, false, false, false)
            SetEntityHeading(additionalReturn, a.w)
            FreezeEntityPosition(additionalReturn, true)
            SetEntityInvincible(additionalReturn, true)
            table.insert(props, additionalReturn)
            
            createInteraction(additionalReturn, {
                {
                    icon = i.returnVehicle,
                    label = translate('returnVehicle'),
                    distance = inter.returnDistance,
                    canInteract = function()
                        return IsPedInAnyVehicle(cache.ped, false) or false
                    end,
                    onSelect = function()
                        local job = getPlayerJob(v.access.type)
                        if job.name == v.access.name then
                            local veh = GetVehiclePedIsIn(cache.ped, false)
                            TaskLeaveVehicle(cache.ped, veh, 1)
                            Wait(1500)
                            if not DoesEntityExist(veh) then return false end
                            DeleteEntity(veh)
                            return
                        end
                        notify(nil, translate('noAccess'), 'error', 5000)
                    end,
                    allowInVehicle = true
                },
            })
        end
    end
end

RegisterNetEvent('matkez_jobgarages:black', function(net)
    if not net then return end
    local veh = NetToVeh(net)
    SetVehicleExtraColours(veh, 0)
end)

RegisterNUICallback('setModel', function (body, rc)
    local color = false
    if body.color and body.color ~= 'undefinied' then
        local r, g, b = lib.math.hextorgb(body.color)
        color = {r, g, b}
    end
    doPreview(body.model, color)
    rc('asdasd')
end)

RegisterNUICallback('close', function (body, rc)
    stopPreview()
    SetNuiFocus(false, false)
    rc('asd')
end)

RegisterNUICallback('spawn', function (body, rc)
    if not currentGarage or not body.model then return end
    local color = false
    if body.color and body.color ~= 'undefinied' then
        local r, g, b = lib.math.hextorgb(body.color)
        color = {r, g, b}
    end
    lib.callback.await('matkez_jobgarages:spawnVehicle', false, currentGarage, body.model, color)
    stopPreview()
    rc('asd')
end)

RegisterNUICallback('setColor', function (body, rc)
    local r, g, b = lib.math.hextorgb(body.color)
    SetVehicleCustomPrimaryColour(previewVehicle, r, g, b)
    SetVehicleCustomSecondaryColour(previewVehicle, r, g, b)
    rc('asd')
end)

AddEventHandler('onResourceStop', function(r)
    if GetCurrentResourceName() ~= r then return end
    for i =1, #props do
        DeleteEntity(props[i])
    end
    if currentGarage then
        stopPreview()
    end
end)

AddEventHandler('onResourceStart', function(r)
    if GetCurrentResourceName() ~= r then return end
    setupGarages()
end)

RegisterCommand('asdd', function()
    local v = GetVehiclePedIsIn(cache.ped, false)
    print(json.encode(lib.getVehicleProperties(v)))
end)