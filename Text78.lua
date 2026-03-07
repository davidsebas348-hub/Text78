repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

repeat task.wait() until LocalPlayer

if _G.ESPSheriffActivo == nil then
    _G.ESPSheriffActivo = false
end

_G.ESPSheriffActivo = not _G.ESPSheriffActivo

if not _G.ESPSheriffConns then
    _G.ESPSheriffConns = {}
end

local function createESP(plr)

    if not _G.ESPSheriffActivo then return end
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

local function removeZeroHighlights(plr)

    if not plr.Character then return end

    for _,v in pairs(plr.Character:GetDescendants()) do
        if v:IsA("Highlight") and string.sub(v.Name,1,1) == "0" then
            v:Destroy()
        end
    end

end

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

        removeZeroHighlights(plr)
        checkSheriff(plr)

        table.insert(_G.ESPSheriffConns,
            char.DescendantAdded:Connect(function(obj)
                if obj:IsA("Highlight") and string.sub(obj.Name,1,1) == "0" then
                    obj:Destroy()
                end
            end)
        )

    end

    if plr.Character then
        charAdded(plr.Character)
    end

    table.insert(_G.ESPSheriffConns,
        plr.CharacterAdded:Connect(charAdded)
    )

    table.insert(_G.ESPSheriffConns,
        plr:GetPropertyChangedSignal("Team"):Connect(function()
            checkSheriff(plr)
        end)
    )

end

if _G.ESPSheriffActivo then

    for _,plr in pairs(Players:GetPlayers()) do
        setupPlayer(plr)
    end

    table.insert(_G.ESPSheriffConns,
        Players.PlayerAdded:Connect(setupPlayer)
    )

else

    for _,c in pairs(_G.ESPSheriffConns) do
        pcall(function()
            c:Disconnect()
        end)
    end

    _G.ESPSheriffConns = {}

    for _,plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            local hl = plr.Character:FindFirstChild("ESP_SHERIFF")
            if hl then hl:Destroy() end
        end
    end

end
