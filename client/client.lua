ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
  end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        for i = 1, #Config.AKbot, 1 do
            local loc = Config.AKbot[i]
            local userDst = GetDistanceBetweenCoords(pedCoords, loc.x, loc.y, loc.z, true)
            if userDst <= 5 then
                sleep = 2
                if userDst <= 2 then
                    if userDst <= 1.0 then
                        if Config.DrawText then 
                            DrawText3D(loc.x, loc.y, loc.z, 'Press[E] For Check in/Heal $'.. Config.Price)
                        else    
                        local table = {
                            ['key'] = 'E', -- key
                            ['event'] = 'script:myevent',
                            ['title'] = 'Press [E] to Relog',
                            ['fa'] = '<i class="fa-solid fa-circle-info"></i>',
                            ['unpack_arg'] = false,   
                        }
                        TriggerEvent('renzu_popui:drawtextuiwithinput',table)
                        end
                        if IsControlJustPressed(0, 38) then

                            if Config.AkPunda then 
                                    ESX.TriggerServerCallback('SYDEV:akpunda', function(hasEnoughMoney)
                                        if hasEnoughMoney then
                                            if Config.UseRprogress then
                                            exports.rprogress:Custom({
                                                Duration = 10,
                                                Label = "relogging.....",
                                                DisableControls = {
                                                    Mouse = false,
                                                    Player = true,
                                                    Vehicle = true
                                                }
                                            })
                                            Citizen.Wait(10)
                                            TriggerServerEvent('esx_multicharacter:relog')
                                            TriggerServerEvent('SYDEV:money')
                                            TriggerEvent('renzu_popui:closeui')
                                            else
                                                TriggerServerEvent('esx_multicharacter:relog')
                                                TriggerServerEvent('SYDEV:money')  
                                            end
                                        end
                                    end)
                            else
                                ESX.TriggerServerCallback('SYDEV:akpunda', function(hasEnoughMoney)
                                    if hasEnoughMoney then
                                        if Config.UseRprogress then
                                            exports.rprogress:Custom({
                                                Duration = 1000,
                                                Label = "relogging.....",
                                                DisableControls = {
                                                    Mouse = false,
                                                    Player = true,
                                                    Vehicle = true
                                                }
                                            })
                                            Citizen.Wait(1000)
                                        TriggerServerEvent('esx_multicharacter:relog')
                                        TriggerServerEvent('SYDEV:money')
                                        else
                                            TriggerServerEvent('esx_multicharacter:relog')
                                            TriggerServerEvent('SYDEV:money')
                                        end

                                    else
                                        exports['okokNotify']:Alert("RELOG", "You Dont Have Enough Money!", 6000, 'error')
                                    end
                                end)
                            end
                        end
                    else
                        TriggerEvent('renzu_popui:closeui')    
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)
--Ped--
Citizen.CreateThread(function()
    RequestModel(GetHashKey(Config.ped))
    while not HasModelLoaded(GetHashKey(Config.ped)) do
        Wait(1)
    end
	if Config.EnablePeds then
        for _, ped in pairs(Config.AKbot) do
			local npc = CreatePed(4, Config.pedhash, ped.x, ped.y, ped.z-1.0, ped.heading, false, true)
			SetEntityHeading(npc, ped.heading)
			FreezeEntityPosition(npc, true)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
		end
	end
end)
--3D--
function DrawText3D(x,y,z,text,size)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end
--Blip--
Citizen.CreateThread(function()
    if Config.EnableBlips then
        for k,v in pairs(Config.AKbot) do
            local blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite (blip, Config.Sprite)                    --https://docs.fivem.net/docs/game-references/blips/
            SetBlipDisplay(blip, 2)
            SetBlipScale  (blip, Config.Scale)
            SetBlipColour (blip, Config.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('RELOG BOT')
            EndTextCommandSetBlipName(blip)
        end
    end
end)