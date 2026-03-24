local config = lib.require('config')
local locales

function loadLocales()
    local jsonFile = LoadResourceFile(GetCurrentResourceName(), ('locales/%s.json'):format(config.language))
    locales = json.decode(jsonFile)
    Wait(50)
    if not IsDuplicityVersion() then
        SendNUIMessage({
            event = 'locales',
            locales = locales
        })
    end
end

CreateThread(function()
    loadLocales()
end)

function translate(m)
    return locales[m] or 'No locale '..m
end

function notify(src, desc, notifyType, duration)
    if IsDuplicityVersion() then
        lib.notify(src, {
            description = desc,
            type = notifyType,
            duration = duration
        })
    else
        lib.notify({
            description = desc,
            type = notifyType,
            duration = duration
        })
    end
end

function createInteraction(entity, options)
    if config.interaction == 'ox_target' then
        exports.ox_target:addLocalEntity(entity, options)
    elseif config.interaction == 'sleepless_interact' then
        exports.sleepless_interact:addLocalEntity(entity, options)
    end
end

function giveKeys(src, plate)
    TriggerClientEvent('vehiclekeys:client:SetOwner', src, plate)
end