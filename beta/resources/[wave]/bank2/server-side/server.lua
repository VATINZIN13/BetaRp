-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")


-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local sacou = 0
local depositou = 0
local salario = 0
local fatura = 0
local multado = 0
local transferido = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("bank2",cRP)
vCLIENT = Tunnel.getInterface("bank2")
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestBank()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.userIdentity(user_id)
		return identity.bank
	end	
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTFINES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestFines()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local fines = {}
		local consult = vRP.query("fines/getFines2",{ user_id = parseInt(user_id) })
		for k,v in pairs(consult) do
			if v.nuser_id == 0 then
				table.insert(fines,{ id = v.id, user_id = parseInt(v.user_id), nuser_id = "Government", date = v.date, price = parseInt(v.price), text = tostring(v.text) })
			else
				local identity = vRP.userIdentity(v.nuser_id)
				table.insert(fines,{ id = v.id, user_id = parseInt(v.user_id), nuser_id = tostring(identity.name.." "..identity.name2), date = v.date, price = parseInt(v.price), text = tostring(v.text) })
			end
		end
		return fines
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINESPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.finesPayment(id,price)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if multado == 0 then
			multado = multado + 1
			vCLIENT.blockButtons(source,true)
			TriggerClientEvent("bankCloseEvent",source)
			TriggerClientEvent("Notify",source,"azul","Multa sendo paga...",5000)
			SetTimeout(3000,function()
				vCLIENT.blockButtons(source,false)
				if vRP.paymentBank(user_id,parseInt(price)) then
					TriggerClientEvent("Notify",source,"verde","Multa paga com sucesso!",5000)
					TriggerClientEvent("bank:Update",source,"requestFines")
					vRP.execute("fines/removeFines2",{ id = parseInt(id), user_id = parseInt(user_id) })
					vRP.execute("characters/removeFines",{ id = parseInt(user_id), fines = price })
				else
					TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente na sua conta bancária.",5000)
				end
			end)
		else
			TriggerClientEvent("Notify",source,"azul","Aguarde 10 segundos para pagar outro multa.",5000)
		end
		if multado >= 1 then
			Wait(10000)
			multado = 0
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANKDEPOSIT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.bankDeposit(amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if depositou == 0 then
			depositou = depositou + 1

			vCLIENT.blockButtons(source,true)
			TriggerClientEvent("bankCloseEvent",source)
			TriggerClientEvent("Notify",source,"azul","Efetuando deposito...",5000)
			SetTimeout(3000,function()
				vCLIENT.blockButtons(source,false)
				TriggerClientEvent("Notify",source,"verde","Deposito efetuado com sucesso!",5000)
				if parseInt(amount) > 0 then
					if vRP.tryGetInventoryItem(user_id,"dollars",parseInt(amount)) then
						vRP.addBank(user_id,parseInt(amount))
						TriggerClientEvent("bank:Update",source,"requestInicio")
					end
				end
			end)
		else
			TriggerClientEvent("bankCloseEvent",source)
			TriggerClientEvent("Notify",source,"azul","Aguarde 15 segundos para efetuar um deposito.",5000)
		end
		if depositou >= 1 then
			Wait(15000)
			depositou = 0
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANWITHDRAW
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.bankWithdraw(amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then

		if vRP.getFines(user_id) > 0 then
			TriggerClientEvent("Notify",source,"vermelho","Multas pendentes encontradas.",3000)
			return false
		end


		if sacou == 0 then
			sacou = sacou + 1
			if parseInt(amount) > 0 then
				vCLIENT.blockButtons(source,true)
				TriggerClientEvent("bankCloseEvent",source)
				TriggerClientEvent("Notify",source,"azul","Sacando seu dinheiro...",5000)
				SetTimeout(3000,function()
					vCLIENT.blockButtons(source,false)
					if vRP.withdrawCash(user_id,parseInt(amount)) then
						TriggerClientEvent("Notify",source,"verde","Dinheiro sacado com sucesso!",5000)
						TriggerClientEvent("bank:Update",source,"requestInicio")
					else
						TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente na sua conta bancária.",5000)
					end
				end)
			end
		else
			TriggerClientEvent("bankCloseEvent",source)
			TriggerClientEvent("Notify",source,"azul","Aguarde um minuto para efetuar outro saque.",5000)
		end

		if sacou >= 1 then 
			Wait(60000)
			sacou = 0
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERIRVALOR
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.transferirValor(amount,target)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)

	local nplayer = vRP.getUserSource(target)
	local nuser_id = vRP.getUserId(nplayer)
	local identity2 = vRP.getUserIdentity(nuser_id)
	local banco = 0
	local banco = vRP.getBank(user_id)
	local banconu = vRP.getBank(nuser_id)

	if nuser_id then
		if nuser_id ~= user_id then
			if tonumber(amount) >= 0 and tonumber(amount) <= 3000 then
				if banco > tonumber(amount) then
					if transferido == 0 then
						transferido = transferido + 1
						TriggerClientEvent("cancelando",source,true)
						TriggerClientEvent("bankCloseEvent",source)
						TriggerClientEvent("Notify",source,"azul","Transferindo...",5000)
						SetTimeout(3000,function()
							TriggerClientEvent("cancelando",source,false)
							vRP.paymentBank(user_id,parseInt(amount))
							vRP.addBank(nuser_id,banconu+tonumber(amount))
							TriggerClientEvent("Notify",nplayer,"verde","<b>"..identity.name.." "..identity.name2.."</b> depositou <b>$"..amount.." dólares</b> na sua conta.",8000)
							TriggerClientEvent("Notify",source,"verde","Você transferiu <b>$"..amount.." dólares</b> para conta de <b>"..identity2.name.." "..identity2.name2.."</b>.",8000)
						end)
					else
						TriggerClientEvent("atmCloseEvent",source)
						TriggerClientEvent("Notify",source,"vermelho","Aguarde 5 minutos para efetuar outra transferência",5000)
					end
				end
			else
				TriggerClientEvent("Notify",source,"vermelho","Caixas eletronicos só aceitam até 3.000,00 dólares de transferencia.",5000)
			end
		else
			TriggerClientEvent("atmCloseEvent",source)
			TriggerClientEvent("Notify",source,"vermelho","Não encontramos a conta do ID fornecido.",5000)
		end
	end
	if transferido >= 1 then 
		Wait(300000)
		transferido = 0
	end
end