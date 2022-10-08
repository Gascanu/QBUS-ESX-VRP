--[[                               
    ________ __________          _________                       
    \_____  \\______   \         \_   ___ \  ___________   ____  
     /  / \  \|    |  _/  ______ /    \  \/ /  _ \_  __ \_/ __ \ 
    /   \_/.  \    |   \ /_____/ \     \___(  <_> )  | \/\  ___/ 
    \_____\ \_/______  /          \______  /\____/|__|    \___  >
           \__>      \/                  \/                   \/                                   
]]--

RegisterNetEvent('QBCore:Command:TeleportToPlayer', function(coords)
    local ped = PlayerPedId()
    SetPedCoordsKeepVehicle(ped, coords.x, coords.y, coords.z)
end)


-- [[ Folosire ]]

TriggerClientEvent("QBCore:Command:TeleportToPlayer", source, {500.0, 500.0, 500.0})

--[[                               
    ___________ _____________  ___
    \_   _____//   _____/\   \/  /
     |    __)_ \_____  \  \     / 
     |        \/        \ /     \ 
    /_______  /_______  //___/\  \
            \/        \/       \_/                                   
]]--


function ESX.Game.Teleport(entity, coords, cb)
    local vector = type(coords) == "vector4" and coords or type(coords) == "vector3" and vector4(coords, 0.0) or
                       vec(coords.x, coords.y, coords.z, coords.heading or 0.0)

    if DoesEntityExist(entity) then
        RequestCollisionAtCoord(vector.xyz)
        while not HasCollisionLoadedAroundEntity(entity) do
            Wait(0)
        end

        SetEntityCoords(entity, vector.xyz, false, false, false, false)
        SetEntityHeading(entity, vector.w)
    end

    if cb then
        cb()
    end
end

-- [[ Folosire ]]

ESX.Game.Teleport(PlayerPedId(), {500,500,500,74})

--[[                               
           ____________________ 
     ___  _\______   \______   \
     \  \/ /|       _/|     ___/
      \   / |    |   \|    |    
       \_/  |____|_  /|____|    
                   \/                                              
]]--

function tvRP.teleport(x,y,z)
    SetEntityCoords(GetPlayerPed(-1), x+0.0001, y+0.0001, z+0.0001, 1,0,0,1)
    vRPserver.updatePos({x,y,z})
  end

  -- [[ Folosire ]]

  -- Client-Side
  tvRP.teleport(500,500,500) {} vRP.teleport{500,500,500} --{Depinde de caz}

  -- Server-Side
  vRPclient.teleport(source,{500,500,500}) 
