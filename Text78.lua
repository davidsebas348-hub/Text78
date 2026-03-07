repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if getgenv().ESPSheriffActivo == nil then
    getgenv().ESPSheriffActivo = false
end

getgenv().ESPSheriffActivo = not getgenv().ESPSheriffActivo

if not getgenv().ESPSheriffConns then
    getgenv().ESPSheriffConns = {}
end

local function createESP(plr)
    if not getgenv().ESPSheriffActivo then return end
    if not plr.Character then return end
    if plr == LocalPlayer then return end
    if plr.Character:FindFirstChild("ESP_SHERIFF") then return end

    local hl = Instance.new("Highlight")
    hl.Name = "ESP_SHERIFF"
    hl.Adornee = plr.Character
    hl.FillColor = Color3.fromRGB(0,150,255)
    hl.OutlineColor = Color3.fromRGB(0,150,255)
    hl.FillTransparency = 0.5
    hl.Parent = workspace
end

local function removeZeroHighlights()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Highlight") and v.Name:sub(1,1) == "0" then
            v:Destroy()
        end
    end
end

removeZeroHighlights()

table.insert(getgenv().ESPSheriffConns,
    workspace.DescendantAdded:Connect(function(v)
        if v:IsA("Highlight") and v.Name:sub(1,1) == "0" then
            v:Destroy()
        end
    end)
)

local function checkSheriff(plr)
    if not plr.Team then return end

    if plr.Team.Name == "Sheriffs" then
        createESP(plr)
    else
        local hl = plr.Character and plr.Character:FindFirstChild("ESP_SHERIFF")
        if hl then hl:Destroy() end
    end
end

local function setupPlayer(plr)
    if plr == LocalPlayer then return end

    local function charAdded(char)
        checkSheriff(plr)
    end

    if plr.Character then
        charAdded(plr.Character)
    end

    table.insert(getgenv().ESPSheriffConns,
        plr.CharacterAdded:Connect(charAdded)
    )

    table.insert(getgenv().ESPSheriffConns,
        plr:GetPropertyChangedSignal("Team"):Connect(function()
            checkSheriff(plr)
        end)
    )
end

if getgenv().ESPSheriffActivo then

    for _,plr in pairs(Players:GetPlayers()) do
        setupPlayer(plr)
    end

    table.insert(getgenv().ESPSheriffConns,
        Players.PlayerAdded:Connect(setupPlayer)
    )

else

    for _,c in pairs(getgenv().ESPSheriffConns) do
        pcall(function()
            c:Disconnect()
        end)
    end

    getgenv().ESPSheriffConns = {}

    for _,plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            local hl = plr.Character:FindFirstChild("ESP_SHERIFF")
            if hl then hl:Destroy() end
        end
    end

end
