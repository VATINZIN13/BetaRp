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
Tunnel.bindInterface("uniforms",cRP)
vCLIENT = Tunnel.getInterface("uniforms")
vSKINSHOP = Tunnel.getInterface("skinshop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("uniforms/removeData","DELETE FROM uniforms WHERE name = @name")
vRP.prepare("uniforms/getData","SELECT * FROM uniforms WHERE permission = @permission")
vRP.prepare("uniforms/getData2","SELECT * FROM uniforms ")
vRP.prepare("uniforms/getDataName","SELECT uniforms FROM uniforms WHERE name = @name")
vRP.prepare("uniforms/setData","REPLACE INTO uniforms(uniforms,permission,name) VALUES(@uniforms,@permission,@name)")
vRP.prepare("uniforms/insertData","INSERT INTO uniforms(uniforms,permission,name) VALUES(@uniforms,@permission,@name)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPERMS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestPermission(permission,lider)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,permission) then
            if vRP.hasPermission(user_id,permission) and vRP.hasPermission(user_id,lider) then
                return true,true
            end

            return true,false
        end

    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUNIFORMS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestClothes(names,permission)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local request = vRP.query("uniforms/getData",{ permission = permission })
        if request then
            return request
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADCUNIFORMS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("sysClothes:applyPreset")
AddEventHandler("sysClothes:applyPreset",function(mode)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if mode == "apply" then
            if vRP.hasPermission(user_id,"Police") then
                local nameClothes = vRP.prompt(source,"Nome:","")
                if nameClothes == "" then
                    return
                end

                local clothes = vSKINSHOP.getCustomization(source)
                vRP.execute("uniforms/insertData",{ uniforms = json.encode(clothes), permission = "Police", name = nameClothes })
            elseif vRP.hasPermission(user_id,"Paramedic") then
                local nameClothes = vRP.prompt(source,"Nome:","")
                if nameClothes == "" then
                    return
                end

                local clothes = vSKINSHOP.getCustomization(source)
                vRP.execute("uniforms/insertData",{ uniforms = json.encode(clothes), permission = "Paramedic", name = nameClothes })
            elseif vRP.hasPermission(user_id,"Mechanic") then
                local nameClothes = vRP.prompt(source,"Nome:","")
                if nameClothes == "" then
                    return
                end

                local clothes = vSKINSHOP.getCustomization(source)
                vRP.execute("uniforms/insertData",{ uniforms = json.encode(clothes), permission = "Mechanic", name = nameClothes })
            end
        elseif mode == "delete" then
            local nameClothes = vRP.prompt(source,"Nome:","")
            if nameClothes == "" then
                return
            end

            vRP.execute("uniforms/removeData",{ name = nameClothes })
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADCUNIFORMS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("sysClothes:applyClothes")
AddEventHandler("sysClothes:applyClothes",function(mode)
    local source = source
    local user_id = vRP.getUserId(source)
    local names = vRP.query("uniforms/getData2")

    for k,v in pairs(names) do
        if user_id then
            if mode == v["name"] then
                local request = vRP.query("uniforms/getDataName",{ name = mode })
                clothings = json.decode(request[1]["uniforms"])
                TriggerClientEvent("updateRoupas",source,clothings)
            end
        end
    end
end)