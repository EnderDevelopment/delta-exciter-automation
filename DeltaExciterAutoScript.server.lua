-- Delta Exciter Auto Script for 'Eat the World'

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Configuration
local MAX_SIZE = 100 -- Adjust this value based on the game's max size
local SELL_DISTANCE = 20 -- Distance to the sell point
local GRAB_DISTANCE = 25 -- Distance to grab food
local EAT_DISTANCE = 10 -- Distance to eat food

-- Remote Events
local sellEvent = Instance.new("RemoteEvent")
sellEvent.Name = "SellEvent"
sellEvent.Parent = ReplicatedStorage

local grabEvent = Instance.new("RemoteEvent")
grabEvent.Name = "GrabEvent"
sellEvent.Parent = ReplicatedStorage

local eatEvent = Instance.new("RemoteEvent")
sellEvent.Name = "EatEvent"
sellEvent.Parent = ReplicatedStorage

-- Main function
local function onPlayerAdded(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Auto Sell when max size
    local function checkSize()
        while true do
            if humanoid.Size >= MAX_SIZE then
                sellEvent:FireServer(player)
            end
            wait(1)
        end
    end
    
    -- Auto Grab
    local function autoGrab()
        while true do
            local nearestFood = nil
            local shortestDistance = GRAB_DISTANCE
            
            for _, food in ipairs(workspace:GetChildren()) do
                if food:IsA("Model") and food:FindFirstChild("Food") then
                    local distance = (rootPart.Position - food.PrimaryPart.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        nearestFood = food
                    end
                end
            end
            
            if nearestFood then
                grabEvent:FireServer(player, nearestFood)
            end
            
            wait(0.5)
        end
    end
    
    -- Auto Eat
    local function autoEat()
        while true do
            local nearestFood = nil
            local shortestDistance = EAT_DISTANCE
            
            for _, food in ipairs(workspace:GetChildren()) do
                if food:IsA("Model") and food:FindFirstChild("Food") then
                    local distance = (rootPart.Position - food.PrimaryPart.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        nearestFood = food
                    end
                end
            end
            
            if nearestFood then
                eatEvent:FireServer(player, nearestFood)
            end
            
            wait(0.5)
        end
    end
    
    -- Start functions
    coroutine.wrap(checkSize)()
    coroutine.wrap(autoGrab)()
    coroutine.wrap(autoEat)()
end

-- Connect player added event
Players.PlayerAdded:Connect(onPlayerAdded)

-- Handle remote events
sellEvent.OnServerEvent:Connect(function(player)
    -- Sell logic
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            -- Implement sell logic here
            print(player.Name .. " sold their Delta Exciter")
        end
    end
end)

grabEvent.OnServerEvent:Connect(function(player, food)
    -- Grab logic
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            -- Implement grab logic here
            print(player.Name .. " grabbed food")
        end
    end
end)

eatEvent.OnServerEvent:Connect(function(player, food)
    -- Eat logic
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            -- Implement eat logic here
            print(player.Name .. " ate food")
        end
    end
end)