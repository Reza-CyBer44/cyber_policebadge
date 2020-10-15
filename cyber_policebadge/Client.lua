ESX = nil
local PlayerData              = {}
local PlayerWithBadges = {}
local IsShowingBadge = false
local BadgeCode = 0
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)
RegisterNetEvent('playerSpawned')
AddEventHandler('playerSpawned', function()

  ESX.TriggerServerCallback('Cyber:GetBadges',function(badges)
  PlayerWithBadges = badges
  end)
end)


function DrawText3D(x,y,z, text, r,g,b) 
    local showing,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz)-vector3(x,y,z))
 
    local andaze = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local andaze = andaze*fov
   
    if showing then
        SetTextScale(0.0*andaze,Config.Size *andaze)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
RegisterNetEvent('Cyber:UpdateBadge')
AddEventHandler('Cyber:UpdateBadge',function(updateBadges)
PlayerWithBadges = updateBadges
end)
RegisterCommand('badge', function(source,args)
while PlayerData.job == nil do
Citizen.Wait(10)
end
        if PlayerData.job.name == 'police' and PlayerData.job.grade ~= 0 then
           if args[1] then
             if tonumber(args[1]) then
                if not IsShowingBadge then
                IsShowingBadge = true
                
                ESX.ShowNotification('You Turned ~g~ On ~s~ Your Badge With Code : ~b~ ' .. tostring(args[1]))
				TriggerServerEvent('Cyber:AddBadge',args[1])
				BadgeCode = args[1]
                else
                ESX.ShowNotification('You Changed Your Badge Code To : ' .. tostring(args[1]))
				BadgeCode = args[1]
				TriggerServerEvent('Cyber:AddBadge',args[1])
                end
              else
            
               ESX.ShowNotification('~r~ Please Type Your Badge Code Correctly')
            
              end
		  else
		    if IsShowingBadge then
		    IsShowingBadge = not IsShowingBadge
		    ESX.ShowNotification('You Turned ~r~ Off ~s~ Your Badge')
			TriggerServerEvent('Cyber:RemoveBadge') 
			else 
			ESX.ShowNotification('~r~Please Enter Badge Code')
		    end
		  end
        else
          ESX.ShowNotification('~r~ You Are Not ~y~ Police ~s~ Officer Or You Are Off Duty Current Now')		
		end
end,false)
TriggerEvent('chat:addSuggestion', '/badge', 'Show Your Badge to Others', {
{ name="Your Badge Code",help = "Write Your Badge Code : 44 For Example"}
})


-- Main Loop For Drawing badges

Citizen.CreateThread(function()
Citizen.Wait(500)
    while true do 
      for _, id in ipairs(GetActivePlayers()) do
	 
         local serverid = GetPlayerServerId(id)
		  if PlayerWithBadges[serverid] then
		     if id ~= PlayerId() then
		      local dist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(id)),GetEntityCoords(PlayerPedId()))
			  if dist < Config.DistanceForShowingBadge then
			  if not IsPedInAnyVehicle(GetPlayerPed(id)) or Config.ShowWhileInVehicle then
			  x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(id),true))
              DrawText3D(x,y,z+Config.Height,PlayerWithBadges[serverid],Config.Red,Config.Green,Config.Blue)
			  end




             end
			elseif id == PlayerId() and Config.ShowForPlayerHimSelf then
             
			  if not IsPedInAnyVehicle(GetPlayerPed(id)) or Config.ShowWhileInVehicle then
			  x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(id),true))
              DrawText3D(x,y,z+Config.Height,PlayerWithBadges[serverid],Config.Red,Config.Green,Config.Blue)
			  end
			
            end
         end
     end
	Citizen.Wait(0) 
    end
end)

Citizen.CreateThread(function()
if Config.ShowStatus then
while PlayerData.job == nil do
Wait(10)
end
while true do
 if PlayerData.job.name == 'police' then
          if IsShowingBadge then
            SetTextFont(4)
	        SetTextScale(0.0, 0.7)
	        SetTextColour(255, 255, 255, 255)
	        SetTextDropshadow(0, 0, 0, 0, 255)
	        SetTextDropShadow()
	        SetTextOutline()
         	SetTextCentre(true)
			SetTextEntry("STRING")
			AddTextComponentString('~b~Badge Shoma ~s~[~g~On~s~]~b~ Ast Ba Code~s~ : [~r~' .. BadgeCode .. '~s~]')
			AddTextComponentString('Your Badge Is ~s~[~g~On~s~]~b~ With Code : [~r~' .. BadgeCode .. '~s~]')
			DrawText(0.35, 0.93)
          elseif not IsShowingBadge then
		    SetTextFont(4)
	        SetTextScale(0.0, 0.7)
	        SetTextColour(255, 255, 255, 255)
	        SetTextDropshadow(0, 0, 0, 0, 255)
	        SetTextDropShadow()
	        SetTextOutline()
         	SetTextCentre(true)
			SetTextEntry("STRING")
			AddTextComponentString('~b~ Your Badge Is ~s~[~r~Off~s~]~b~')
			DrawText(0.35, 0.93)
		  
		   
		  end

 end
Wait(0)
end
end
end)


