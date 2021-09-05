local functions = {}
--|| SERVICES ||--
local TweenService = game:GetService("TweenService")
--|| VARS ||--
local NOB_TWEEN_INFO = TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local OFF_PROPERTIES = { Position = UDim2.new(0, 3, 0.5, 0) }
local ON_PROPERTIES = { Position = UDim2.new(1, -21, 0.5, 0) } -- Magic numbers? No, just the size of the nob-3
local onTweens = {}
local offTweens = {}

--|| FUNCTIONS ||--
function functions:turnNobOn(nob)
    local tween = onTweens[nob]
    if not tween then
        tween = TweenService:Create(nob, NOB_TWEEN_INFO, ON_PROPERTIES)
        tween.Completed:Connect(function()
            nob.Parent.ImageColor3 = Color3.fromRGB(255, 255, 51)
        end)
        onTweens[nob] = tween
    end
    
    tween:Play()
end

function functions:turnNobOff(nob)
    local tween = offTweens[nob]
    if not tween then
        tween = TweenService:Create(nob, NOB_TWEEN_INFO, OFF_PROPERTIES)
        tween.Completed:Connect(function()
            nob.Parent.ImageColor3 = Color3.fromRGB(85, 85, 85)
        end)
        offTweens[nob] = tween
    end

    tween:Play()
end
return functions
