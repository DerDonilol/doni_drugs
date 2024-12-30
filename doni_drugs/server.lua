ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("drugSales:sellDrugs")
AddEventHandler("drugSales:sellDrugs", function(playerId, drugType, amount)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local drugCount = xPlayer.getInventoryItem(drugType).count

    if drugCount >= amount then
        local totalPrice = Config.DrugPrices[drugType] * amount
        xPlayer.removeInventoryItem(drugType, amount)
        xPlayer.addAccountMoney(Config.CurrencyType, totalPrice)
        TriggerClientEvent("esx:showNotification", playerId, "You got ~g~$" .. totalPrice .. "~s~ black money for " .. amount .. "x " .. drugType .. ".")
    else
        TriggerClientEvent("esx:showNotification", playerId, "You dont have enough " .. drugType .. "!")
    end
end)