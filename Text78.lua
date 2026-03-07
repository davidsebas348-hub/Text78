local Players = game:GetService("Players")

if _G.ESPSheriffActivo == nil then
    _G.ESPSheriffActivo = false
end

_G.ESPSheriffActivo = not _G.ESPSheriffActivo

if not _G.ESPSheriffConns then
    _G.ESPSheriffConns = {}
end

local function startsWithNumber(text)
    return tonumber(string.sub(text,1,1)) ~= nil
end

local function createESP(plr)

    if not _G.ESPSheriffActivo then return end
    if not plr.Character then return end
    if plr == Players.LocalPlayer then return end

    for _,v in pairs(workspace:GetChildren()) do
        if v:IsA("Highlight") and v.Name == "ESP_SHERIFF" and v.Adornee == plr.Character then
            return
        end
    end

    local hl = Instance.new("Highlight")
    hl.Name = "ESP_SHERIFF"
    hl.Adornee = plr.Character
    hl.FillColor = Color3.fromRGB(0,150,255)
    hl.OutlineColor = Color3.fromRGB(0,150,255)
    hl.FillTransparency = 0.5
    hl.Parent = workspace

end

local function removeNumberHighlights(plr)

    if not plr.Character then return end

    for _,v in pairs(plr.Character:GetChildren()) do
        if v:IsA("Highlight") and startsWithNumber(v.Name) then
            v:Destroy()
        end
    end

end

local function checkSheriff(plr)

    if not plr.Team then return end

    if plr.Team.Name == "Sheriffs" then
        createESP(plr)
    else
        for _,v in pairs(workspace:GetChildren()) do
            if v:IsA("Highlight") and v.Name == "ESP_SHERIFF" and v.Adornee == plr.Character then
                v:Destroy()
            end
        end
    end

end

local function setupPlayer(plr)

    if plr == Players.LocalPlayer then return end

    local function charAdded(char)

        removeNumberHighlights(plr)
        checkSheriff(plr)

        table.insert(_G.ESPSheriffConns,
            char.ChildAdded:Connect(function(obj)

                if obj:IsA("Highlight") and startsWithNumber(obj.Name) then
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

    print("ESP Sheriff ACTIVADO")

    for _,plr in pairs(Players:GetPlayers()) do
        setupPlayer(plr)
    end

    table.insert(_G.ESPSheriffConns,
        Players.PlayerAdded:Connect(setupPlayer)
    )

else

    print("ESP Sheriff DESACTIVADO")

    for _,c in pairs(_G.ESPSheriffConns) do
        pcall(function()
            c:Disconnect()
        end)
    end

    _G.ESPSheriffConns = {}

    -- destruir todos los ESP en workspace
    for _,v in pairs(workspace:GetChildren()) do
        if v:IsA("Highlight") and v.Name == "ESP_SHERIFF" then
            v:Destroy()
        end
    end

end
