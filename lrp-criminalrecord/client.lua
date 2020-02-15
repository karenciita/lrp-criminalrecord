local ESX      = nil
local PlayerData = {}
local holdingTablet = true

-- ESX
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)

	TriggerEvent('chat:addSuggestion', '/mdtpd', ' Terminal de Datos movil Policial', {})	
	end


    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()

end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

-- Notification
function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


local disablechatmdtpd = false

Citizen.CreateThread(function( )
  while true do
    Citizen.Wait(0)

    if disablechatmdtpd then

    DisableControlAction(0, 245, true)
    DisableControlAction(0, 309, true)
  
    else
    Citizen.Wait(500)
    end

  end
end)



RegisterCommand('mdtpd',function()

if (ESX.PlayerData.job.name == 'police') then


        if (holdingTablet==true) then
            TriggerEvent("tabletmdttemporal")
            print ("AnimacionTablet")
            print (holdingTablet)
            holdingTablet=false

ESX.TriggerServerCallback('lrp-criminalrecord:fetch', function(d)

    disablechatmdtpd = true
    Citizen.Wait(2000)
   
SetNuiFocus(true, true)
	SendNUIMessage({
	  action = "open",
		array  = d
	})
	end, data, 'start')


        elseif (holdingTablet==false) then
            DeleteEntity(tab)
            ClearPedTasks(PlayerPedId())
            print ("AnimacionTablet2")
            print (holdingTablet)
            holdingTablet=true
 end


else
	exports['mythic_notify']:DoCustomHudText('cajaroja', ' No eres policia o estas en servicio para usar este comando ',3500)
end


end)





RegisterNetEvent("tabletmdttemporal")
AddEventHandler("tabletmdttemporal", function()
    local ped = GetPlayerPed(-1)
    if not IsEntityDead(ped) then
        if not IsEntityPlayingAnim(ped, "amb@world_human_seat_wall_tablet@female@idle_a", "idle_c", 3) then
            RequestAnimDict("amb@world_human_seat_wall_tablet@female@idle_a")
            while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@idle_a") do
                Citizen.Wait(100)
            end
            
            TaskPlayAnim(ped, "amb@world_human_seat_wall_tablet@female@idle_a", "idle_c", 8.0, -8, -1, 49, 0, 0, 0, 0)
            tab = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)        ----0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)   
            AttachEntityToEntity(tab, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 18905), 0.12, 0.05, 0.13, -10.5, 180.0, 180.0, true, true, false, true, 1, true)        
             Citizen.Wait(2000)
            SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
        end
    end
end)



-- NUI Callback - Close
RegisterNUICallback('escape', function(data, cb)
local ped = GetPlayerPed(-1)
		
    disablechatmdtpd = false

    EnableControlAction(0, 245, true)
    EnableControlAction(0, 309, true)
    DeleteEntity(tab, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 18905), 0.12, 0.05, 0.13, -10.5, 180.0, 180.0, true, true, false, true, 1, true)    
    ClearPedTasksImmediately(ped)
    Citizen.Wait(1000)

	SetNuiFocus(false, false)
	cb('ok')


end)

-- NUI Callback - Fetch
RegisterNUICallback('fetch', function(data, cb)
	ESX.TriggerServerCallback('lrp-criminalrecord:fetch', function( d )
    cb(d)
  end, data, data.type)
end)

-- NUI Callback - Search
RegisterNUICallback('search', function(data, cb)
	ESX.TriggerServerCallback('lrp-criminalrecord:search', function( d )
    cb(d)
  end, data)
end)

-- NUI Callback - Add
RegisterNUICallback('add', function(data, cb)
	ESX.TriggerServerCallback('lrp-criminalrecord:add', function( d )
    cb(d)
  end, data)
end)

-- NUI Callback - Update
RegisterNUICallback('update', function(data, cb)
	ESX.TriggerServerCallback('lrp-criminalrecord:update', function( d )
    cb(d)
  end, data)
end)

-- NUI Callback - Remove
RegisterNUICallback('remove', function(data, cb)
	ESX.TriggerServerCallback('lrp-criminalrecord:remove', function( d )
    cb(d)
  end, data)
end)
