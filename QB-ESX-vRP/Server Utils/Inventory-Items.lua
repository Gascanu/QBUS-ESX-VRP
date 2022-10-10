--[[                               
    ________ __________          _________                       
    \_____  \\______   \         \_   ___ \  ___________   ____  
     /  / \  \|    |  _/  ______ /    \  \/ /  _ \_  __ \_/ __ \ 
    /   \_/.  \    |   \ /_____/ \     \___(  <_> )  | \/\  ___/ 
    \_____\ \_/______  /          \______  /\____/|__|    \___  >
           \__>      \/                  \/                   \/                                   
]]--

function QBCore.Functions.CreateUseableItem(item, data)
    QBCore.UsableItems[item] = data
end

function QBCore.Functions.CanUseItem(item)
    return QBCore.UsableItems[item]
end

function QBCore.Functions.UseItem(source, item)          
    if GetResourceState('qb-inventory') == 'missing' then return end
    exports['qb-inventory']:UseItem(source, item)
end

function QBCore.Functions.HasItem(source, items, amount)
    if GetResourceState('qb-inventory') == 'missing' then return end
    return exports['qb-inventory']:HasItem(source, items, amount)
end


function QBCore.Functions.AddItem(itemName, item)
    if type(itemName) ~= "string" then
        return false, "invalid_item_name"
    end

    if QBCore.Shared.Items[itemName] then
        return false, "item_exists"
    end

    QBCore.Shared.Items[itemName] = item

    TriggerClientEvent('QBCore:Client:OnSharedUpdate', -1, 'Items', itemName, item)
    TriggerEvent('QBCore:Server:UpdateObject')
    return true, "success"
end

function QBCore.Functions.RemoveItem(itemName)
    if type(itemName) ~= "string" then
        return false, "invalid_item_name"
    end

    if not QBCore.Shared.Items[itemName] then
        return false, "item_not_exists"
    end

    QBCore.Shared.Items[itemName] = nil

    TriggerClientEvent('QBCore:Client:OnSharedUpdate', -1, 'Items', itemName, nil)
    TriggerEvent('QBCore:Server:UpdateObject')
    return true, "success"
end

--[[                               
    ___________ _____________  ___
    \_   _____//   _____/\   \/  /
     |    __)_ \_____  \  \     / 
     |        \/        \ /     \ 
    /_______  /_______  //___/\  \
            \/        \/       \_/                                   
]]--

--[[Self este folosti ca variabila, ea se inlocuieste cu Player-ul]]


-- Pe ESX nu exista o functie specifica pentru verificarea daca un item poate fii folosit

function ESX.RegisterUsableItem(item, cb)
    Core.UsableItemsCallbacks[item] = cb
  end
  
  function ESX.UseItem(source, item, ...)
    if ESX.Items[item] then
      local itemCallback = Core.UsableItemsCallbacks[item]
  
      if itemCallback then
        local success, result = pcall(itemCallback, source, item, ...)
  
        if not success then
          return result and print(result) or
                print(('[^3WARNING^7] An error occured when using item ^5"%s"^7! This was not caused by ESX.'):format(item))
        end
      end
    else
      print(('[^3WARNING^7] Item ^5"%s"^7 was used but does not exist!'):format(item))
    end
  end


-- Pe ESX verificarea daca jucator-ul are un item este print xPlayer.getInventoryItem(item_code).count

-- Probabil se poate folosi functia de mai jos daca este necesar
local self = {}

--[[
    function self.HasItem(item)
    return self.getInventoryItem(item).count
end
]]--  NU stiu daca functioneaza!




function self.addInventoryItem(name, count, metadata, slot)
    local item = self.getInventoryItem(name)

    if item then
        count = ESX.Math.Round(count)
        item.count = item.count + count
        self.weight = self.weight + (item.weight * count)

        TriggerEvent('esx:onAddInventoryItem', self.source, item.name, item.count)
        self.triggerEvent('esx:addInventoryItem', item.name, item.count)
    end
end

function self.removeInventoryItem(name, count, metadata, slot)
    local item = self.getInventoryItem(name)

    if item then
        count = ESX.Math.Round(count)
        local newCount = item.count - count

        if newCount >= 0 then
            item.count = newCount
            self.weight = self.weight - (item.weight * count)

            TriggerEvent('esx:onRemoveInventoryItem', self.source, item.name, item.count)
            self.triggerEvent('esx:removeInventoryItem', item.name, item.count)
        end
    end
end


function self.canCarryItem(name, count, metadata)
    local currentWeight, itemWeight = self.weight, ESX.Items[name].weight
    local newWeight = currentWeight + (itemWeight * count)

    return newWeight <= self.maxWeight
end

function self.hasItem(item)
    for k,v in ipairs(self.inventory) do
        if (v.name == item) and (v.count >= 1) then
            return v, v.count
        end
    end

    return false
end

function self.getWeight()
    return self.weight
end

function self.getMaxWeight()
    return self.maxWeight
end

--[[                               
           ____________________ 
     ___  _\______   \______   \
     \  \/ /|       _/|     ___/
      \   / |    |   \|    |    
       \_/  |____|_  /|____|    
                   \/                                              
]]--


-- Pe vRP nu exista functiile pentru folosirea/verificarea itemelor

function vRP.defInventoryItem(idname,name,description,choices,weight)
  if weight == nil then
    weight = 0
  end

  local item = {name=name,description=description,choices=choices,weight=weight}
  vRP.items[idname] = item

  -- build give action
  item.ch_give = function(player,choice)
  end

  -- build trash action
  item.ch_trash = function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
      -- prompt number
      vRP.prompt(player,lang.inventory.trash.prompt({vRP.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
        local amount = parseInt(amount)
        if vRP.tryGetInventoryItem(user_id,idname,amount,false) then
          vRPclient.notify(player,{lang.inventory.trash.done({vRP.getItemName(idname),amount})})
          vRPclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
        else
          vRPclient.notify(player,{lang.common.invalid_value()})
        end
      end)
    end
  end
end

  

function vRP.giveInventoryItem(user_id,idname,amount,notify)
  if notify == nil then notify = true end -- notify by default

  local data = vRP.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry then -- add to entry
      entry.amount = entry.amount+amount
    else -- new entry
      data.inventory[idname] = {amount=amount}
    end

    -- notify
    if notify then
      local player = vRP.getUserSource(user_id)
      if player ~= nil then
        vRPclient.notify(player,{lang.inventory.give.received({vRP.getItemName(idname),amount})})
      end
    end
  end
end
function vRP.tryGetInventoryItem(user_id,idname,amount,notify)
  if notify == nil then notify = true end -- notify by default

  local data = vRP.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry and entry.amount >= amount then -- add to entry
      entry.amount = entry.amount-amount

      -- remove entry if <= 0
      if entry.amount <= 0 then
        data.inventory[idname] = nil 
      end

      -- notify
      if notify then
        local player = vRP.getUserSource(user_id)
        if player ~= nil then
          vRPclient.notify(player,{lang.inventory.give.given({vRP.getItemName(idname),amount})})
        end
      end
      return true
    else
      -- notify
      if notify then
        local player = vRP.getUserSource(user_id)
        if player ~= nil then
          local entry_amount = 0
          if entry then entry_amount = entry.amount end
          vRPclient.notify(player,{lang.inventory.missing({vRP.getItemName(idname),amount-entry_amount})})
        end
      end
    end
  end

  return false
end
function vRP.getInventoryItemAmount(user_id,idname)
  local data = vRP.getUserDataTable(user_id)
  if data and data.inventory then
    local entry = data.inventory[idname]
    if entry then
      return entry.amount
    end
  end

  return 0
end
function vRP.getInventoryWeight(user_id)
  local data = vRP.getUserDataTable(user_id)
  if data and data.inventory then
    return vRP.computeItemsWeight(data.inventory)
  end

  return 0
end

function vRP.getInventoryMaxWeight(user_id)
  return math.floor(vRP.expToLevel(vRP.getExp(user_id, "physical", "strength")))*cfg.inventory_weight_per_strength
end





  -- Aici este scris pe scurt, ce-am scris si mai sus

-- QBCore Functions ">" ESX Functions ">" vRP Functions

QBCore.Functions.CreateUseableItem(item, data) ">" ESX.RegisterUsableItem(item, cb) ">" vRP.defInventoryItem(idname,name,description,choices,weight)

QBCore.Functions.CanUseItem(item) "> Pe ESX nu exista functie care sa verifice daca un item poate fii folosit" "> Pe vRP nu exista functie care sa verifice daca un item poate fii folosit"

QBCore.Functions.UseItem(source, item) ">" ESX.UseItem(source, item, ...) "> Pe vRP nu exista functie care sa foloseasca un item direct"

QBCore.Functions.HasItem(source, items, amount) ">" self.getInventoryItem(item_code).count ">"  vRP.getInventoryItemAmount(user_id,idname)

QBCore.Functions.AddItem(itemName, item)  ">"  self.addInventoryItem(name, count, metadata, slot) ">" vRP.giveInventoryItem(user_id, idname, amount, notify)

QBCore.Functions.RemoveItem(itemName) ">" self.removeInventoryItem(name, count, metadata, slot) ">" vRP.tryGetInventoryItem(user_id, idname, amount, notify)
