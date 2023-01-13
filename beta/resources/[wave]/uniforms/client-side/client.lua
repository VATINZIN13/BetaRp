-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROXY
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("uniforms",cRP)
vSERVER = Tunnel.getInterface("uniforms")
-----------------------------------------------------------------------------------------------------------------------------------------
--  DECODE
-----------------------------------------------------------------------------------------------------------------------------------------
local services = { 
    [1] = {"Police",-780.39,-1211.84,10.38,"Police","HPolice" },
    [2] = {"Paramedic",1145.9,-1560.68,35.39,"Paramedic","HParamedic" },
    [3] = {"Mechanic",-602.58,-913.88,23.88,"Mechanic","HMechanic" },
    [4] = {"Mechanic2",826.41,-953.37,22.09,"Mechanic","HMechanic" },
}

Citizen.CreateThread( function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
        if not IsPedInAnyVehicle(ped) then
            local coords = GetEntityCoords(ped)
            for k,v in pairs(services) do
                local distance = #(coords - vector3(v[2],v[3],v[4]))
                if distance <= 1.5 then
                    timeDistance = 4
                    DrawText3D(v[2],v[3],v[4],"~p~E~w~   ABRIR")
                    if IsControlJustPressed(0,38) then
                        local checkPermission,checkLider = vSERVER.requestPermission(v[5],v[6])
                        if checkPermission and checkLider then 
                            exports["dynamic"]:SubMenu("Uniformes","Todas os uniformes de sua corporação.","uniforms")

                            exports["dynamic"]:SubMenu("Opções","Gerenciamento de uniformes líder.","optionsUniforms")
                            exports["dynamic"]:AddButton("Adicionar","Adicione o uniforme que está em seu corpo.","sysClothes:applyPreset","apply","optionsUniforms",true)
                            exports["dynamic"]:AddButton("Deletar","Delete algum uniforme existente.","sysClothes:applyPreset","delete","optionsUniforms",true)
                        elseif checkPermission then
                            exports["dynamic"]:SubMenu("Uniformes","Todas os uniformes de sua corporação.","uniforms")
                        end
                        
                        local uniforms = vSERVER.requestClothes(v[1],v[5])
                        if uniforms ~= nil then 
                            for _,x in pairs(uniforms) do 
                                exports["dynamic"]:AddButton(x.name,"Roupa para utilizar em serviço.","sysClothes:applyClothes",x.name,"uniforms",true)
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(timeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text)
	SetTextFont(4)
	SetTextCentre(1)
	SetTextEntry("STRING")
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z,0)
	DrawText(0.0,0.0)
	local factor = (string.len(text) / 450) + 0.01
	DrawRect(0.0,0.0125,factor,0.03,40,36,52,240)
	ClearDrawOrigin()
end