local ui = {}

function ui:createBackground()
    local Background = Instance.new("Frame")
    Background.Name = "Background"
    Background.BorderMode = Enum.BorderMode.Inset
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BorderColor3 = Color3.fromRGB(34, 34, 34)
    Background.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    return Background
end

function ui:createContainer(containerName, Size, Order)
    local Container = Instance.new("Frame")
    Container.LayoutOrder = Order or 0
    Container.Name = containerName.."Container"
    Container.Size = Size or UDim2.new(1, 0, 0, 121)
    Container.BackgroundTransparency = 1
    Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    return Container
end

function ui:createTextLabel(Text)
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, -45, 1, 0)
    Label.BackgroundTransparency = 1
    Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Label.FontSize = Enum.FontSize.Size18
    Label.TextTruncate = Enum.TextTruncate.AtEnd
    Label.TextSize = 18
    Label.TextColor3 = Color3.fromRGB(170, 170, 170)
    Label.Text = Text
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    return Label
end

function ui:createToggleButton()
    local ToggleButton = Instance.new("ImageButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 40, 1, 0)
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Position = UDim2.new(1, -45, 0, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.ImageColor3 = Color3.fromRGB(85, 85, 85)
    ToggleButton.Image = "http://www.roblox.com/asset/?id=4629474256"
    
    return ToggleButton
end

function ui:createNob()
    local Nob = Instance.new("ImageLabel")
    Nob.Name = "Nob"
    Nob.AnchorPoint = Vector2.new(0, 0.5)
    Nob.Size = UDim2.new(1, -6, 1, -6)
    Nob.SizeConstraint = Enum.SizeConstraint.RelativeYY
    Nob.BackgroundTransparency = 1
    Nob.Position = UDim2.new(0, 3, 0.5, 0)
    Nob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Nob.Image = "http://www.roblox.com/asset/?id=4629480363"
    return Nob
end

function ui:createListLayout()
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    return UIListLayout
end

function ui:createPadding(options)
    options = options or {}
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = options.PaddingTop or UDim.new(0,0)
    UIPadding.PaddingLeft = options.PaddingLeft or UDim.new(0, 5)
    UIPadding.PaddingRight = options.PaddingRight or UDim.new(0, 5)
    UIPadding.PaddingTop = options.PaddingTop or UDim.new(0,0)
    return UIPadding
end

function ui:createButton(TextName, Text)
    local Button = Instance.new("ImageButton")
    Button.Name = TextName.."Button"
    Button.AnchorPoint = Vector2.new(0.5, 0)
    Button.Size = UDim2.new(0.75, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Position = UDim2.new(0.5, 0, 0, 0)
    Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Button.ImageColor3 = Color3.fromRGB(255, 255, 51)
    Button.ScaleType = Enum.ScaleType.Slice
    Button.Image = "rbxassetid://2773204550"
    Button.ImageRectSize = Vector2.new(32, 32)
    Button.SliceCenter = Rect.new(4, 4, 4, 4)
    
    local Label = Instance.new("TextLabel")
    Label.Name = TextName.."Text"
    Label.AnchorPoint = Vector2.new(0.5, 0)
    Label.Size = UDim2.new(0.75, 0, 1, 0)
    Label.BorderColor3 = Color3.fromRGB(27, 42, 53)
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0.5, 0, 0, 0)
    Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Label.FontSize = Enum.FontSize.Size18
    Label.TextSize = 18
    Label.TextColor3 = Color3.fromRGB(27, 42, 53)
    Label.Text = Text
    Label.Font = Enum.Font.SourceSansBold

    return Button, Label
end

function ui:createOption(OptionName, OptionText)
    local Option = Instance.new("Frame")
    Option.Name = OptionName.."Option"
    Option.LayoutOrder = 1
    Option.Size = UDim2.new(1, 0, 0, 24)
    Option.BackgroundTransparency = 1
    Option.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    local ToggleButton = self:createToggleButton()
    ToggleButton.Parent = Option
    local Nob = self:createNob()
    Nob.Parent = ToggleButton
    local Label = self:createTextLabel(OptionText)
    Label.Parent = Option
    return Option
end
function ui:createHotKey()
    local HotKey = Instance.new("ImageLabel")
    HotKey.Name = "HotKey"
    HotKey.LayoutOrder = 1
    HotKey.Size = UDim2.new(1, 0, 0, 35)
    HotKey.BorderColor3 = Color3.fromRGB(27, 42, 53)
    HotKey.BackgroundTransparency = 1
    HotKey.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HotKey.ScaleType = Enum.ScaleType.Slice
    HotKey.ImageColor3 = Color3.fromRGB(38, 38, 38)
    HotKey.SliceScale = 0.05
    HotKey.Image = "rbxassetid://4641600283"
    HotKey.SliceCenter = Rect.new(128, 128, 128, 128)
    
    local Title = self:createTextLabel("File<Advanced<Custom ShortCuts")
    Title.Parent = HotKey
    
    --[[local Input = Instance.new("ImageButton")
    Input.Name = "Input"
    Input.Size = UDim2.new(0, 60, 0, 21)
    Input.BackgroundTransparency = 1
    Input.Position = UDim2.new(1, -67, 0, 7)
    Input.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Input.ImageColor3 = Color3.fromRGB(65, 65, 65)
    Input.ScaleType = Enum.ScaleType.Slice
    Input.Image = "rbxassetid://4608020054"
    Input.SliceScale = 0.03
    Input.SliceCenter = Rect.new(128, 128, 128, 128)
    Input.Parent = HotKey
    
    local Value = Instance.new("TextBox")
    Value.Name = "Value"
    Value.Size = UDim2.new(1, 0, 1, 0)
    Value.BackgroundTransparency = 1
    Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Value.CursorPosition = -1
    Value.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
    Value.PlaceholderText = "Alt+Shift+S"
    Value.FontSize = Enum.FontSize.Size14
    Value.TextSize = 14
    Value.TextWrapped = true
    Value.TextWrap = true
    Value.TextColor3 = Color3.fromRGB(216, 216, 216)
    Value.Text = ""
    Value.Font = Enum.Font.SourceSansBold
    Value.TextScaled = true
    Value.Parent = Input]]
    
    local Cap = Instance.new("ImageLabel")
    Cap.Name = "Cap"
    Cap.ZIndex = 3
    Cap.Size = UDim2.new(1, 0, 0, 5)
    Cap.BackgroundTransparency = 1
    Cap.Position = UDim2.new(0, 0, 1, -2)
    Cap.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Cap.ScaleType = Enum.ScaleType.Slice
    Cap.ImageColor3 = Color3.fromRGB(38, 38, 38)
    Cap.SliceScale = 0.05
    Cap.Image = "rbxassetid://4695358235"
    Cap.SliceCenter = Rect.new(128, 128, 128, 128)
    Cap.Parent = HotKey
    
    return HotKey
end
function ui:init()

    local Background = self:createBackground()
    local UIListLayout = self:createListLayout()
    local UIPadding = self:createPadding({
        PaddingLeft = UDim.new(0,0),
        PaddingRight = UDim.new(0,0),
        PaddingTop = UDim.new(0,5)
    })

    local OptionContainer = self:createContainer("Option")
    local UIListLayout1 = self:createListLayout()
    local UIPadding1 = self:createPadding()
    local ScriptOption = self:createOption("Script", "New Script")
    local MinifyOption = self:createOption("Minify", "Minify Output")
    
    local SyntaxContainer = self:createContainer("Syntax", UDim2.new(1,0,0,30), 1)
    local SyntaxButton, SyntaxText = self:createButton("Syntax", "Fix Syntax")
    --local SyntaxHotKey = self:createHotKey()

    UIListLayout.Parent = Background
    UIPadding.Parent = Background
    OptionContainer.Parent = Background
    UIListLayout1.Parent = OptionContainer
    UIPadding1.Parent = OptionContainer
    ScriptOption.Parent = OptionContainer
    MinifyOption.Parent = OptionContainer
    SyntaxContainer.Parent = Background
    SyntaxButton.Parent = SyntaxContainer
    SyntaxText.Parent = SyntaxContainer
    --SyntaxHotKey.Parent = OptionContainer
    return {
        ["Background"] = Background,
        ["OptionContainer"] = {
            ["ScriptOption"] = ScriptOption,
            ["MinifyOption"] = MinifyOption,
            --["HotKey"] = SyntaxHotKey
        },
        ["SyntaxContainer"] = {
            ["Button"] = SyntaxButton
        }
    }
end
return ui
