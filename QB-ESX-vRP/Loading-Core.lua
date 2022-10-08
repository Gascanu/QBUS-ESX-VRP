--[[                               
    ________ __________          _________                       
    \_____  \\______   \         \_   ___ \  ___________   ____  
     /  / \  \|    |  _/  ______ /    \  \/ /  _ \_  __ \_/ __ \ 
    /   \_/.  \    |   \ /_____/ \     \___(  <_> )  | \/\  ___/ 
    \_____\ \_/______  /          \______  /\____/|__|    \___  >
           \__>      \/                  \/                   \/                                   
]]--

QBCore = nil 

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(31)
	end
end)


-- sau  se adauga aceasta linie de cod in side-urile specifice

QBCore = exports['qb-core']:GetCoreObject()

--[[                               
    ___________ _____________  ___
    \_   _____//   _____/\   \/  /
     |    __)_ \_____  \  \     / 
     |        \/        \ /     \ 
    /_______  /_______  //___/\  \
            \/        \/       \_/                                   
]]--


ESX = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(31)
  end
end)


[[ESX Extended Version 1.2]]

-- Se adauga aceasta linie in fxmanifest.lua

shared_script '@es_extended/imports.lua'


-- sau se adauga aceasta linie in side-urile specifice
ESX = exports['es_extended']:getSharedObject()

--[[                               
           ____________________ 
     ___  _\______   \______   \
     \  \/ /|       _/|     ___/
      \   / |    |   \|    |    
       \_/  |____|_  /|____|    
                   \/                                              
]]--

-- Se adauga aceste linii de cod in fxmanifest.lua

server_scripts {
    '@vrp/lib/utils.lua'
    }

client_scripts {
    '@vrp/client/Tunnel.lua',
    '@vrp/client/Proxy.lua'
    }

-- Si se adauga aceste linii de cod in side-urile specifice

local Tunnel =  module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")


local vRP , vRPclient  = Proxy.getInterface("vRP"), Tunnel.getInterface("vRP", "nume script");
