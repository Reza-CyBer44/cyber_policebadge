ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
PlayerWithBadges = {}
RegisterNetEvent('Cyber:AddBadge')
AddEventHandler('Cyber:AddBadge',function(code)
xPlayer = ESX.GetPlayerFromId(source)
if xPlayer.job.name == 'police' then
PlayerWithBadges[source] = '~r~#' .. code .. '~s~ ' .. xPlayer.job.grade_label
TriggerClientEvent('Cyber:UpdateBadge',-1,PlayerWithBadges)
else
print('CHEATER. ID : ' .. source)
end
end)
RegisterNetEvent('Cyber:RemoveBadge')
AddEventHandler('Cyber:RemoveBadge',function()
PlayerWithBadges[source] = nil
TriggerClientEvent('Cyber:UpdateBadge',-1,PlayerWithBadges)
end)
AddEventHandler('playerDropped', function()

PlayerWithBadges[source] = nil
TriggerClientEvent('Cyber:UpdateBadge',-1,PlayerWithBadges)
end)

ESX.RegisterServerCallback('Cyber:GetBadges',function(cb)
cb(PlayerWithBadges)
end)