-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("crafting",cRP)
vSERVER = Tunnel.getInterface("crafting")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("invClose",function(data)
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "hideNUI" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCRAFTING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestCrafting",function(data,cb)
	local inventoryCraft,inventoryUser,invPeso,invMaxpeso = vSERVER.requestCrafting(data["craft"])
	if inventoryCraft then
		cb({ inventoryCraft = inventoryCraft, inventario = inventoryUser, invPeso = invPeso, invMaxpeso = invMaxpeso })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONCRAFT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("functionCraft",function(data,cb)
	vSERVER.functionCrafting(data["index"],data["craft"],data["amount"],data["slot"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONDESTROY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("functionDestroy",function(data,cb)
	vSERVER.functionDestroy(data["index"],data["craft"],data["amount"],data["slot"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("populateSlot",function(data,cb)
	TriggerServerEvent("crafting:populateSlot",data["item"],data["slot"],data["target"],data["amount"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSlot",function(data,cb)
	TriggerServerEvent("crafting:updateSlot",data["item"],data["slot"],data["target"],data["amount"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRAFTING:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("crafting:Update")
AddEventHandler("crafting:Update",function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRAFTLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local craftList = {
	{ -580.49,-883.1,26.0,269.3,"makeFoods" },
	{ 713.95,-961.54,30.4,0.0,"dressMaker" },
	{ 82.45,-1553.26,29.59,229.61,"lixeiroShop" },
	{ 1394.05,-185.45,161.56,45.36,"Favela01" },
	{ 429.42,-2051.9,18.74,229.61,"Favela02" },
	{ 1712.84,447.67,232.83,42.52,"Favela03" },
	{ 2993.52,3032.64,105.73,127.56,"Favela04" },
	{ 228.19,-1752.9,25.24,320.32,"DaNang" },
	{ -160.87,3204.73,51.8,294.81,"Favela05" },
	{ 411.46,-1500.96,33.8,274.97,"Fleeca" },
	{ -1000.98,-1025.9,2.19,121.89,"Triads" },
	{ 1145.4,-1660.32,36.48,206.93,"EastSide" },
	{ 1406.17,-1543.42,54.71,141.74,"Marabunta" },
	{ 1959.68,3828.07,32.05,209.77,"Rednecks" },
	{ 1208.81,-3115.1,5.54,272.13,"ilegalWeapons" },
	{ 895.06,-962.84,35.55,87.88,"dirtyMoneys" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTARGET
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)

	for k,v in pairs(craftList) do
		exports["target"]:AddCircleZone("crafting:"..k,vector3(v[1],v[2],v[3]),1.0,{
			name = "crafting:"..k,
			heading = v[4]
		},{
			shop = k,
			distance = 1.0,
			options = {
				{
					event = "crafting:openSystem",
					label = "Abrir",
					tunnel = "shop"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRAFTING:OPENSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("crafting:openSystem",function(shopId)
	if vSERVER.requestPerm(craftList[shopId][5]) then
		SetNuiFocus(true,true)
		SendNUIMessage({ action = "showNUI", name = craftList[shopId][5] })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRAFTING:FUELSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("crafting:fuelShop",function()
	SetNuiFocus(true,true)
	SendNUIMessage({ action = "showNUI", name = "fuelShop" })
end)