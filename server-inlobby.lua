-- in the lobby (listener is PVP_QUEUE_1)
-- add attribute to workspace called "QUEUEABLE" | it will last until it is full, until intermission is too far (20 seconds left)
local MessagingService = game:GetService("MessagingService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local Code = game.PrivateServerId 
local PlannedJoins = 10 -- how much should join minus 1

if Code == nil then
    return warn("NOT RESEVE SERVER")
end

local SUCCESS, CONNECTION
SUCCESS, CONNECTION = pcall(function()
    return MessagingService:SubscribeAsync("PVP_QUEUE_1", function(Message)
        if workspace:GetAttribute("QUEUEABLE") ~= nil and PlannedJoins > 0 then
            if Message ~= nil then
                PlannedJoins -= 1
                local _message = {
                    User = Message.User,
                    Code = Code
                }
                MessagingService:PublicAsync("PVP_QUEUE_2", _message)
            end
        else
            CONNECTION:Disconnect()
        end
    end)
end)

