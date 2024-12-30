ESX = exports["es_extended"]:getSharedObject()

local isFlying = false
local flyStartTime = nil

CreateThread(function()
    while true do
        Wait(5000) 

        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if vehicle ~= 0 and GetEntityModel(vehicle) == GetHashKey(Config.RequiredVehicleModel) then
            if not isFlying then
                isFlying = true
                flyStartTime = GetGameTimer()
            elseif GetGameTimer() - flyStartTime > Config.RequiredFlightTime * 60000 then 
                TriggerEvent("drugSales:showMenu")
            end
        else
            isFlying = false
            flyStartTime = nil
        end
    end
end)


RegisterNetEvent("drugSales:showMenu")
AddEventHandler("drugSales:showMenu", function()
    local elements = {}
    for drugType, price in pairs(Config.DrugPrices) do
        table.insert(elements, {"sell " label = drugType .. " ($" .. price .. "/Piece)", value = drugType})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'drug_menu', {
        title = "Sell Drugs",
        align = "top-left",
        elements = elements
    }, function(data, menu)
        local drugType = data.current.value
        local amount = tonumber(InputDialog("How much do you want to sell?", "1"))

        if amount and amount > 0 then
            TriggerServerEvent("drugSales:sellDrugs", GetPlayerServerId(PlayerId()), drugType, amount)
        else
            ESX.ShowNotification("invalid amount.")
        end
    end, function(data, menu)
        menu.close()
    end)
end)

function InputDialog(text, defaultText)
    AddTextEntry('FMMC_KEY_TIP1', text)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", defaultText or "", "", "", "", 10)

    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end

    if GetOnscreenKeyboardResult() then
        return GetOnscreenKeyboardResult()
    end
    return nil
end
