local self = {}

--[[                               
    ________ __________          _________                       
    \_____  \\______   \         \_   ___ \  ___________   ____  
     /  / \  \|    |  _/  ______ /    \  \/ /  _ \_  __ \_/ __ \ 
    /   \_/.  \    |   \ /_____/ \     \___(  <_> )  | \/\  ___/ 
    \_____\ \_/______  /          \______  /\____/|__|    \___  >
           \__>      \/                  \/                   \/                                   
]]--

function self.Functions.AddMoney(moneytype, amount, reason)
    reason = reason or 'unknown'
    moneytype = moneytype:lower()
    amount = tonumber(amount)
    if amount < 0 then return end
    if not self.PlayerData.money[moneytype] then return false end
    self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] + amount

    if not self.Offline then
        self.Functions.UpdatePlayerData()
        if amount > 100000 then
            TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'AddMoney', 'lightgreen', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') added, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason, true)
        else
            TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'AddMoney', 'lightgreen', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') added, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason)
        end
        TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, false)
        TriggerClientEvent('QBCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, "add", reason)
        TriggerEvent('QBCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, "add", reason)
    end

    return true
end

function self.Functions.RemoveMoney(moneytype, amount, reason)
    reason = reason or 'unknown'
    moneytype = moneytype:lower()
    amount = tonumber(amount)
    if amount < 0 then return end
    if not self.PlayerData.money[moneytype] then return false end
    for _, mtype in pairs(QBCore.Config.Money.DontAllowMinus) do
        if mtype == moneytype then
            if (self.PlayerData.money[moneytype] - amount) < 0 then
                return false
            end
        end
    end
    self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] - amount

    if not self.Offline then
        self.Functions.UpdatePlayerData()
        if amount > 100000 then
            TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'RemoveMoney', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') removed, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason, true)
        else
            TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'RemoveMoney', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') removed, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason)
        end
        TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, true)
        if moneytype == 'bank' then
            TriggerClientEvent('qb-phone:client:RemoveBankMoney', self.PlayerData.source, amount)
        end
        TriggerClientEvent('QBCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, "remove", reason)
        TriggerEvent('QBCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, "remove", reason)
    end

    return true
end

function self.Functions.SetMoney(moneytype, amount, reason)
    reason = reason or 'unknown'
    moneytype = moneytype:lower()
    amount = tonumber(amount)
    if amount < 0 then return false end
    if not self.PlayerData.money[moneytype] then return false end
    local difference = amount - self.PlayerData.money[moneytype]
    self.PlayerData.money[moneytype] = amount

    if not self.Offline then
        self.Functions.UpdatePlayerData()
        TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'SetMoney', 'green', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') set, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason)
        TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, math.abs(difference), difference < 0)
        TriggerClientEvent('QBCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, "set", reason)
        TriggerEvent('QBCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, "set", reason)
    end

    return true
end

function self.Functions.GetMoney(moneytype)
    if not moneytype then return false end
    moneytype = moneytype:lower()
    return self.PlayerData.money[moneytype] or 0
end

--[[                               
    ___________ _____________  ___
    \_   _____//   _____/\   \/  /
     |    __)_ \_____  \  \     / 
     |        \/        \ /     \ 
    /_______  /_______  //___/\  \
            \/        \/       \_/                                   
]]--

function self.addMoney(money, reason)
    money = ESX.Math.Round(money)
    self.addAccountMoney('money', money, reason)
end

function self.removeMoney(money, reason)
    money = ESX.Math.Round(money)
    self.removeAccountMoney('money', money, reason)
end

function self.setMoney(money)
    money = ESX.Math.Round(money)
    self.setAccountMoney('money', money)
end

function self.getMoney()
    return self.getAccount('money').money
end


function self.setAccountMoney(accountName, money, reason)
    reason = reason or 'unknown'
    if not tonumber(money) then 
        print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number!'):format(accountName, self.playerId))
        return
    end
    if money >= 0 then
        local account = self.getAccount(accountName)

        if account then
            money = account.round and ESX.Math.Round(money) or money
            self.accounts[account.index].money = money

            self.triggerEvent('esx:setAccountMoney', account)
            TriggerEvent('esx:setAccountMoney', self.source, accountName, money, reason)
        else 
            print(('[^1ERROR^7] Tried To Set Invalid Account ^5%s^0 For Player ^5%s^0!'):format(accountName, self.playerId))
        end
    else 
        print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number!'):format(accountName, self.playerId))
    end
end

function self.addAccountMoney(accountName, money, reason)
    reason = reason or 'Unknown'
    if not tonumber(money) then 
        print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number!'):format(accountName, self.playerId))
        return
    end
    if money > 0 then
        local account = self.getAccount(accountName)
        if account then
            money = account.round and ESX.Math.Round(money) or money
            self.accounts[account.index].money += money

            self.triggerEvent('esx:setAccountMoney', account)
            TriggerEvent('esx:addAccountMoney', self.source, accountName, money, reason)
        else 
            print(('[^1ERROR^7] Tried To Set Add To Invalid Account ^5%s^0 For Player ^5%s^0!'):format(accountName, self.playerId))
        end
    else 
        print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number!'):format(accountName, self.playerId))
    end
end

function self.removeAccountMoney(accountName, money, reason)
    reason = reason or 'Unknown'
    if not tonumber(money) then 
        print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number!'):format(accountName, self.playerId))
        return
    end
    if money > 0 then
        local account = self.getAccount(accountName)

        if account then
            money = account.round and ESX.Math.Round(money) or money
            self.accounts[account.index].money -= money

            self.triggerEvent('esx:setAccountMoney', account)
            TriggerEvent('esx:removeAccountMoney', self.source, accountName, money, reason)
        else 
            print(('[^1ERROR^7] Tried To Set Add To Invalid Account ^5%s^0 For Player ^5%s^0!'):format(accountName, self.playerId))
        end
    else 
        print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number!'):format(accountName, self.playerId))
    end
end

--[[                               
           ____________________ 
     ___  _\______   \______   \
     \  \/ /|       _/|     ___/
      \   / |    |   \|    |    
       \_/  |____|_  /|____|    
                   \/                                              
]]--

-- Doar pentru cine are nevoie
--function Comma(amount) local formatted = amount; while true do ;formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2');if (k==0) then;break;end;end;return formatted;end


function vRP.giveMoney(user_id,amount) --Aceasta functie ofera banii unui jucator  Parameters-Types {user_id = number, amount = number}
  local money = vRP.getMoney(user_id)
  vRP.setMoney(user_id,money+amount)
end

function vRP.tryPayment(user_id,amount) --Aceasta functie scoate banii unui jucator daca ii are la el. Parameters-Types {user_id = number, amount = number}
  local money = vRP.getMoney(user_id)
  if amount >= 0 and money >= amount then
    vRP.setMoney(user_id,money-amount)
    return true
  else
    return false
  end
end

function vRP.getMoney(user_id) --Aceasta functie returneaza banii unui jucator. Parameters-Types {user_id = number}
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    return tmp.wallet or 0
  else
    return 0
  end
end

function vRP.setMoney(user_id,value) --Aceasta functie seteaza banii unui jucator. Parameters-Types {user_id = number, value = number}
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    tmp.wallet = value
  end

  local source = vRP.getUserSource(user_id)
  if source ~= nil then
    vRPclient.setDivContent(source,{"money",lang.money.display({Comma(vRP.getMoney(user_id))})}) --Aceasta functie updateaza sumele de banii in hud
  end
end




