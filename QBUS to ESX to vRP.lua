-- ------------------------------------------------------------
-- QBCore = nil 

-- Citizen.CreateThread(function()
-- 	while QBCore == nil do
-- 		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
-- 		Citizen.Wait(31)
-- 	end
-- end)


-- ESX = nil

-- Citizen.CreateThread(function()
--   while ESX == nil do
--     TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
--     Citizen.Wait(31)
--   end
-- end)

-- La vRP nu puneti nimic
-- -----------------------------------------------------------
-- RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
-- AddEventHandler('QBCore:Client:OnPlayerLoaded', 
    
--   RegisterNetEvent('esx:playerLoaded')
-- AddEventHandler('esx:playerLoaded',   

--   RegisterNetEvent('vRP:playerSpawned')
-- AddEventHandler('vRP:playerSpawned',   
-- --------------------------------------------------------------------
-- RegisterNetEvent('QBCore:Client:OnJobUptade')
-- AddEventHandler('QBCore:Client:OnJobUptade', 

-- RegisterNetEvent('esx:setJob')
-- AddEventHandler('esx:setJob',

-- La vRP nu exista asa ceva
-- --------------------------------------------------------------------------------
-- QBCore.UI.Menu.Open
-- QBCore.UI.Menu.CloseAll() -- (menu default scripti kurmanız gerekmektedir.)

-- ESX.UI.Menu.Open
-- ESX.UI.Menu.CloseAll()

-- vRP.openMenu(source,menudef)
-- vRPcloseMenu(source)
-- ----------------------------------------------------------------------------------------
-- QBCore.Functions.Notify("Araç kitlendi.", "error")

-- TriggerEvent('Notification',"Örnek.")

-- vRPclient.notify(source,{"Message"})
-- ----------------------------------------------------------------------------------------
-- xPlayer.Functions.GetItemByName 

-- xPlayer.getInventoryItem

-- vRP.getInventoryItemAmount(userid, idname)
-- ---------------------------------------------------------------------------------------
-- xPlayer.Functions.RemoveItem 

-- xPlayer.removeInventoryItem 

--    vRP.tryGetInventoryItem(userid, idname, amount, notify)
-- -------------------------------------------------------------------------------------------
-- xPlayer.Functions.AddItem

-- xPlayer.addInventoryItem

-- vRP.giveInventoryItem(userid, idname, amount, notify)
-- ----------------------------------------------------------------------------------------
-- QBCore.Functions.GetPlayer(src)

-- ESX.GetPlayerFromId(src)

-- vRP.getUserId(src)
-- --------------------------------------------------------------------------------------------------
-- QBCore.Functions.SpawnVehicle()
-- QBCore.Functions.GetVehicleProperties()
-- QBCore.Functions.GetClosestVehicle()


-- ESX.Game.SpawnVehicle()
-- ESX.Game.GetVehicleProperties()
-- ESX.Game.GetClosestVehicle()

-- --(Eğer ESX.Game olan neredeyse her şey QBCore.Functions olarak aynı şekildedir.)

-- 	CreateVehicle(modelHash,x, y,z, heading, isNetwork, netMissionEntity)
-- Pentru vRP nu exista GetVehicleProperties
-- 	GetClosestVehicle(x, y, z, radius, modelHash --[[ Hash ]], flags --[[ integer ]])
-- DeleteEntity(entity)

-- ------------------------------------------------------------------------------------------------------
-- QBCore.Functions.GetPlayerData()

-- ESX.GetPlayerData()

-- vRP nu are asa ceva
-- ---------------------------------------------------------------------------------------------------
-- QBCore.Functions.CreateUseableItem()

-- ESX.RegisterUsableItem()

-- vRP.defInventoryItem(idname,name,description,choices,weight)
-- --------------------------------------------------------------------------------------------------
-- QBCore.Functions.CreateCallback()

-- ESX.RegisterServerCallback()

-- Orice.RegisterServerCallback()  "Orice" depinde de ce puneti voi
-- -----------------------------------------------------------------------------------------------------------
-- QBCore.Functions.TriggerCallback()

-- ESX.TriggerServerCallback()

-- Orice.TriggerServerCallback()  "Orice" depinde de ce puneti voi
-- -----------------------------------------------------------------------------------------------------------
-- -- qb'de cid esx'de identifier kullanılıyor olayı çözmeniz için ufak bir kod bloğu bıraktık.
-- QBCore.Functions.CreateCallback('skillsystem:fetchStatus', function(source, cb)
--     local Player = QBCore.Functions.GetPlayer(source)

--      if Player then
--            exports['ghmattimysql']:execute('SELECT skills FROM players WHERE citizenid = @citizenid', {
--                ['@citizenid'] = Player.PlayerData.citizenid
--           }, function(status)
--               if status ~= nil then
--                    cb(json.decode(status))
--               else
--                    cb(nil)
--               end
--           end)
--      else
--           cb()
--      end
-- end)

-- ESX.RegisterServerCallback("gamz-skillsystem:fetchStatus", function(source, cb)
--     local src = source
--     local user = ESX.GetPlayerFromId(src)


--     local fetch = [[
--          SELECT
--               skills
--          FROM
--               users
--          WHERE
--               identifier = @identifier
--     ]]

--     MySQL.Async.fetchScalar(fetch, {
--          ["@identifier"] = user.identifier

--     }, function(status)

--          if status ~= nil then
--               cb(json.decode(status))
--          else
--               cb(nil)
--          end

--     end)
-- end)

-- Orice.RegisterServerCallback("get:Level", function(source, cb)
--     local src = source
--     local user = vRP.getUserId(src)


--     local sql = [[
--          SELECT
--               level
--          FROM
--               vrp_users
--          WHERE
--               id = @identifier
--     ]]

--     exports.ghmattimysql:execute(sql, {
--          ["@identifier"] = user

--     }, function(status)

--          if status ~= nil then
--               cb(json.decode(status))
--          else
--               cb(nil)
--          end

--     end)
-- end)
-- -----------------------------------------------------------------------------------------------------------------------
-- QBCore.Functions.ExecuteSql()

-- ESX.ExecuteSql() --(ghmattimysql)
-- MySQL.Async.execute()

-- Depinde de driver (ghmattimysql/MySQL-Async/oxmysql)
-- ----------------------------------------------------------------------------------------------------------------------
-- QBCore.Commands.Add()

-- RegisterCommand  (si pentru ESX si pentru vRP)
-- ----------------------------------------------------------------------------------------------------------------------