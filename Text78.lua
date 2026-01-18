--// HIGHLIGHT AUTO-REAPLICABLE Toggle: jugadores con Tools
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Toggle global
if _G.ESPToolsActivo == nil then
    _G.ESPToolsActivo = false
end

-- Cambiar estado
_G.ESPToolsActivo = not _G.ESPToolsActivo

-- Guardar loop para poder detenerlo
if not _G.ESPToolsLoop then
    _G.ESPToolsLoop = nil
end

-- Función principal de highlights
local function applyHighlights()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            local hasTool = false
            -- Revisar Tools en Character
            for _, item in pairs(plr.Character:GetChildren()) do
                if item:IsA("Tool") then
                    hasTool = true
                    break
                end
            end
            -- Revisar Tools en Backpack
            if not hasTool and plr:FindFirstChild("Backpack") then
                for _, item in pairs(plr.Backpack:GetChildren()) do
                    if item:IsA("Tool") then
                        hasTool = true
                        break
                    end
                end
            end

            -- Crear Highlight si tiene Tool y toggle activo
            if hasTool and _G.ESPToolsActivo then
                if not plr.Character:FindFirstChild("ESP_Highlight") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ESP_Highlight"
                    hl.Adornee = plr.Character
                    hl.FillColor = Color3.fromRGB(0, 150, 255)
                    hl.OutlineColor = Color3.fromRGB(0, 150, 255)
                    hl.FillTransparency = 0.5
                    hl.OutlineTransparency = 0
                    hl.Parent = workspace
                end
            else
                -- Quitar Highlight si no tiene Tool o toggle desactivado
                local hl = plr.Character:FindFirstChild("ESP_Highlight")
                if hl then hl:Destroy() end
            end
        end
    end
end

-- Activar o desactivar loop
if _G.ESPToolsActivo then
    print("ESP de Tools ACTIVADO ✅")
    -- Solo crear un loop si no existe
    if not _G.ESPToolsLoop then
        _G.ESPToolsLoop = task.spawn(function()
            while _G.ESPToolsActivo do
                applyHighlights()
                task.wait(2.5)
            end
            _G.ESPToolsLoop = nil
        end)
    end
else
    print("ESP de Tools DESACTIVADO ❌")
    -- Eliminar todos los highlights existentes
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            local hl = plr.Character:FindFirstChild("ESP_Highlight")
            if hl then hl:Destroy() end
        end
    end
    -- Detener loop si existe
    if _G.ESPToolsLoop then
        _G.ESPToolsActivo = false
        _G.ESPToolsLoop = nil
    end
end
