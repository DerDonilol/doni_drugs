ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("drugSales:sellDrugs")
AddEventHandler("drugSales:sellDrugs", function(playerId, drugType, amount)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local drugCount = xPlayer.getInventoryItem(drugType).count

    if drugCount >= amount then
        local totalPrice = Config.DrugPrices[drugType] * amount
        xPlayer.removeInventoryItem(drugType, amount)
        xPlayer.addAccountMoney(Config.CurrencyType, totalPrice)
        TriggerClientEvent("esx:showNotification", playerId, "Du hast ~g~$" .. totalPrice .. "~s~ Schwarzgeld für " .. amount .. "x " .. drugType .. " erhalten.")
    else
        TriggerClientEvent("esx:showNotification", playerId, "Du hast nicht genug " .. drugType .. " dabei!")
    end
end)