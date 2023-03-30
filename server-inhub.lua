-- in the hub (listener is PVP_QUEUE_2)
local MessagingService = game:GetService("MessagingService")
local Players = game:GetService("Players")

local status = Instance.new("StringValue") -- listen to this for updates status.Changed

-- wont be a need to leave queue since it will either generate or join a queue
-- do a mass test to make sure it doesn't have problems (might have to add a full predictor)
function EnterQueue(Player)
    local found = nil

    local SUCCESS, CONNECTION = pcall(function()
        return MessagingService:SubscribeAsync("PVP_QUEUE_2", function(Message)
            if Message.User == Player.UserId
                TeleportService:TeleportToPrivateServer(000, Message.Code, Player) -- place pvp hub id here
            end
        end)
    end)

    if SUCCESS then
        -- sends multiple requests to pvp hub (lobbies)
        local req = 0
        repeat
            req += 1
            status.Value = "Looking for server [REQUEST #"..req.."]"
            MessagingService:PublicAsync("PVP_QUEUE_1", {User = Player.UserId})
            task.wait(10) -- wait
        until req == 3 or found ~= nil or Players[Player] ~= nil

        -- fails to join
        -- checks if they are still here
        if Players[Player] ~= nil then
            status.Value = "Server not found! Creating lobby..."
            local Code = TeleportService:ReserveServer(000) -- put pvp hub id in here
            TeleportService:TeleportToPrivateServer(000, Code, Player) -- put pvp hub id here
        end
    end
end