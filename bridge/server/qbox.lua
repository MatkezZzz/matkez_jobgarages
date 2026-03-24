local config = lib.require('config')
if config.framework:lower() ~= 'qbox' then return false end

function getPlayerJob(src, jobType)
    local playerData = exports.qbx_core:GetPlayer(src).PlayerData
    if jobType == 'gang' then
        return {name = playerData.gang.name, grade = playerData.gang.grade.level} or false
    elseif jobType == 'job' then
        return {name = playerData.job.name, grade = playerData.job.grade.level} or false
    end 
end