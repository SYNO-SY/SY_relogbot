ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('SYDEV:money')
AddEventHandler('SYDEV:money', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeAccountMoney('bank', Config.Price)
    TriggerClientEvent('okokNotify:Alert', source, 'RELOG', '$'.. Config.Price ..' Money Detucted', 5000, 'success')

end)

ESX.RegisterServerCallback('SYDEV:akpunda', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.getMoney() - Config.Price) 
end)