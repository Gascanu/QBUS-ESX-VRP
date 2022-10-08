--[[                               
    ________ __________          _________                       
    \_____  \\______   \         \_   ___ \  ___________   ____  
     /  / \  \|    |  _/  ______ /    \  \/ /  _ \_  __ \_/ __ \ 
    /   \_/.  \    |   \ /_____/ \     \___(  <_> )  | \/\  ___/ 
    \_____\ \_/______  /          \______  /\____/|__|    \___  >
           \__>      \/                  \/                   \/                                   
]]--

function QBCore.Functions.Notify(text, texttype, length)
    if type(text) == "table" then
        local ttext = text.text or 'Placeholder'
        local caption = text.caption or 'Placeholder'
        texttype = texttype or 'primary'
        length = length or 5000
        SendNUIMessage({
            action = 'notify',
            type = texttype,
            length = length,
            text = ttext,
            caption = caption
        })
    else
        texttype = texttype or 'primary'
        length = length or 5000
        SendNUIMessage({
            action = 'notify',
            type = texttype,
            length = length,
            text = text
        })
    end
end


-- [[ Folosire ]]

QBCore.Functions.Notify("Mesaj", "error", 5000)

--[[                               
    ___________ _____________  ___
    \_   _____//   _____/\   \/  /
     |    __)_ \_____  \  \     / 
     |        \/        \ /     \ 
    /_______  /_______  //___/\  \
            \/        \/       \_/                                   
]]--


function ESX.ShowNotification(message, type, length)
    if GetResourceState("esx_notify") ~= "missing" then
        exports["esx_notify"]:Notify(type, length, message)
    else
        print("[ERROR] Missing esx_notify")
    end
end

-- [[ Folosire ]]

ESX.ShowNotification("Mesaj", "error", 5000)

--[[                               
           ____________________ 
     ___  _\______   \______   \
     \  \/ /|       _/|     ___/
      \   / |    |   \|    |    
       \_/  |____|_  /|____|    
                   \/                                              
]]--

function tvRP.notify(msg) -- Functie Default
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true, false)
end

function tvRP.notify(msg,title,timeout,type) -- Functie Custom
    local function clearColors(str)
      local idf = string.match(str, "~.~")
      while idf do
          str = str:gsub(idf, "")
          idf = string.match(str, "~.~")
      end
  
      local idf = string.match(str, "Succes:")
      while idf do
          str = str:gsub(idf, "")
          idf = string.match(str, "Succes:")
          type = "success"
      end
  
      local idf = string.match(str, "Eroare:")
      while idf do
          str = str:gsub(idf, "")
          idf = string.match(str, "Eroare:")
          type = "error"
      end
  
      local idf = string.match(str, "Info:")
      while idf do
          str = str:gsub(idf, "")
          idf = string.match(str, "Info:")
          type = "info"
      end
  
      local idf = string.match(str, "Warning:")
      while idf do
          str = str:gsub(idf, "")
          idf = string.match(str, "Warning:")
          type = "warning"
      end
  
      idf = string.match(str, "\\n")
      while idf do
          str = str:gsub(idf, " | ")
          idf = string.match(str, "\\n")
      end
      
      return str
  end
      msg = clearColors(msg)
      if GetResourceState("vrp_notify") == "started" then
        exports["vrp_notify"]:Alert(title or "Info",msg,timeout or 5000, type or "info")
      end
  end
  -- [[ Folosire ]]

  -- Client-Side
  vRP.notify("mesaj") {} vRP.notify{"mesaj"} --{Depinde de caz}

  -- Server-Side
  vRPclient.notify(source,{"mesaj"})
