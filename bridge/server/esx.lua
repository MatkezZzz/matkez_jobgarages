local config = lib.require('config')
if config.framework:lower() ~= 'esx' then return false end
local ESX = exports.es_extended:getSharedObject()

function getPlayerJob(src, jobType)
    local playerData = ESX.GetPlayerFromId(src)
    return {name = playerData.job.name, grade = playerData.job.grade} or false
end