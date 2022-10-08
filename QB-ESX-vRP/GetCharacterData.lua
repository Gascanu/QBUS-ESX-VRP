--[[                               
    ________ __________          _________                       
    \_____  \\______   \         \_   ___ \  ___________   ____  
     /  / \  \|    |  _/  ______ /    \  \/ /  _ \_  __ \_/ __ \ 
    /   \_/.  \    |   \ /_____/ \     \___(  <_> )  | \/\  ___/ 
    \_____\ \_/______  /          \______  /\____/|__|    \___  >
           \__>      \/                  \/                   \/                                   
]]--

local Player = QBCore.Functions.GetPlayerData()

--[[                               
    ___________ _____________  ___
    \_   _____//   _____/\   \/  /
     |    __)_ \_____  \  \     / 
     |        \/        \ /     \ 
    /_______  /_______  //___/\  \
            \/        \/       \_/                                   
]]--


local Player = ESX.GetPlayerData()
--[[                               
           ____________________ 
     ___  _\______   \______   \
     \  \/ /|       _/|     ___/
      \   / |    |   \|    |    
       \_/  |____|_  /|____|    
                   \/                                              
]]--


--[[ vRP-ul nu are o functie specifica pentru toate informatiile unui user_id, se foloseste fiecare functie in parte 

  local user_id = vRP.getUserId{sursa}
  local bani = vRP.getMoney(user_id)
  etc.etc

  Daca va este usor, puteti folosi functia lasata mai jos, ceva asamanator
  
  Functia de mai jos se foloseste asa:

  local userdata, factiondata = vRP.getPlayerData{source} sau vRP.getPlayerData(source) In Functie de caz

  id = userdata.id
  salariu = factiondata.salariu
  factiune = factiondata.factiune
]]

vRP.getPlayerData = function(sursa)
    local user_id = vRP["getUserId"](sursa)
    if type(sursa) ~= "number" then return end;if sursa == nil then return end
    local userdata = {user_id = user_id, bani = vRP["getMoney"](user_id), banca = vRP["getBankMoney"](user_id), ore = vRP["getUserHoursPlayed"](user_id)}
    local factiondata = {factiune = vRP["getUserFaction"](user_id), rank = vRP["getFactionRank"](user_id),salariu = vRP["getFactionRankSalary"](vRP["getuserFaction"](user_id), vRP["getFactionRank"](user_id)), fType = vRP["getFactionType"](vRP["getUserFaction"](user_id))}
    return userdata, factiondata
end