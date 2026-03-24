local config = lib.require('config')
if config.framework:lower() ~= 'qbox' then return false end

function getPlayerJob(jobType)
    local playerData = QBX.PlayerData
    if jobType == 'gang' then
        return {name = playerData.gang.name, grade = playerData.gang.grade.level} or false
    elseif jobType == 'job' then
        return {name = playerData.job.name, grade = playerData.job.grade.level} or false
    end
end

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    setupGarages()
end)