local config = lib.require('config')
if config.framework:lower() ~= 'esx' then return false end
local ESX = exports.es_extended:getSharedObject()

function getPlayerJob(jobType)
    local playerData = ESX.GetPlayerData()
    return {name = playerData.job.name, grade = playerData.job.grade} or false
end

RegisterNetEvent('esx:playerLoaded', function (xPlayer, skin)
    setupGarages()
end)