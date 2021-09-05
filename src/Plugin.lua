--|| SERVICES ||--
local SelectionService = game:GetService("Selection")
local HttpService = game:GetService("HttpService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local StudioService = game:GetService("StudioService")
--|| MODULES ||--
local UILibrary = require(script:WaitForChild("ui"))
local functions = require(script:WaitForChild("functions"))
local luaParser = require(script:WaitForChild("lua-parser"))
local errHandler = require(script:WaitForChild("error-handler"))
local formatter = require(script:WaitForChild("formatter"))
--|| OBJECTS ||--
local Options = {
    newscript = false,
    minify = false,
}
local PluginGui = plugin:CreateDockWidgetPluginGui("Syntax Formatter [BETA]", DockWidgetPluginGuiInfo.new(
    Enum.InitialDockState.Right, --initDockState
    false, --initEnabled
    false, --overrideEnabledRestore
    250, 200,--floatXSize, floatYSize
    0, 0 --minWidth, minHeight
))
PluginGui:BindToClose(function()
    PluginGui.Enabled = false
end)
PluginGui.Name = "Syntax Formatter [BETA]"
PluginGui.Title = "Syntax Formatter"
local UIObject = UILibrary:init()
UIObject.Background.Parent = PluginGui
--|| PLUGIN CREATION||--
local PluginBar = plugin:CreateToolbar("Syntax")
local PluginButton = PluginBar:CreateButton("Syntax Fixer", "Fix your Syntax Errors", "rbxassetid://7367926104")
--|| PLUGIN DATA||--
--[[local StudioIcons = {
    ["Dark"] = "rbxassetid://7362640681",
    ["Light"] = "rbxassetid://7362648472"
}]]
local BackgroundColors = {
    ["Light"] = Color3.fromRGB(255, 255, 255),
    ["Dark"] = Color3.fromRGB(46, 46, 46),
}
--[[if(StudioIcons[settings().Studio.Theme.Name]) then
	PluginButton.Icon = StudioIcons[settings().Studio.Theme.Name]
end
settings().Studio.ThemeChanged:Connect(function()
    PluginButton.Icon = StudioIcons[settings().Studio.Theme.Name]
end)]]
--|| EVENTS ||--
local ScriptOption = UIObject.OptionContainer.ScriptOption
ScriptOption.ToggleButton.MouseButton1Click:Connect(function()
    Options.newscript = not Options.newscript
    if(Options.newscript == true) then
        functions:turnNobOn(ScriptOption.ToggleButton.Nob)
    else
        functions:turnNobOff(ScriptOption.ToggleButton.Nob)
    end
end)
local MinifyOption = UIObject.OptionContainer.MinifyOption
MinifyOption.ToggleButton.MouseButton1Click:Connect(function()
    Options.minify = not Options.minify
    if(Options.minify == true) then
        functions:turnNobOn(MinifyOption.ToggleButton.Nob)
    else
        functions:turnNobOff(MinifyOption.ToggleButton.Nob)
    end
end)
--[[local HotKey = UIObject.OptionContainer.HotKey
local HotKeyBind = plugin:GetSetting("HotKey")
if(HotKeyBind) then
    HotKey.Input.Value.PlaceholderText = "Alt+Shift+"..HotKeyBind
else
    HotKey.Input.Value.PlaceholderText = "Alt+Shift+".."S"
    plugin:SetSetting("HotKey", "S")
end
HotKey.Input.Value:GetPropertyChangedSignal("Text"):Connect(function()
    if HotKey.Input.Value.Text == "" then return end
    local key = string.sub(HotKey.Input.Value.Text,1,1)
    key = string.upper(key)
    HotKey.Input.Value.Text = ""
    HotKey.Input.Value.PlaceholderText = "Alt+Shift+"..key
    HotKey.Input.Value.CursorPosition = -1
    plugin:SetSetting("HotKey", key)
end)]]

local function convertComments(str)
	return (str:gsub("--(-.-)\n",function(c)
		local commentData = string.split(c, "")
		if(commentData[1] == "-" and commentData[2] == "-" and commentData[3] ~= "[") then
			table.insert(commentData,3, "[")
			table.insert(commentData, 4,'[')
			table.insert(commentData,(#commentData+1), "]")
			table.insert(commentData,(#commentData+1), "]")
		end
		return table.concat(commentData).."\n"
	end))
end

local SyntaxContainer = UIObject.SyntaxContainer
local function fixSyntaxWithFormat(Source)
    local OldSyntax = Source
    local NewSyntax = convertComments(OldSyntax)
    while true do
        local b = formatter:Minify(NewSyntax)
        if(typeof(b) == "table") then
            return NewSyntax
        else
            b = HttpService:JSONDecode(b)
            local handlederr = errHandler:Handle(b.Line, b.Char, b.msg, NewSyntax)
            if(handlederr.Error) then
                return nil;
            else
                NewSyntax = table.concat(handlederr)
            end
        end
        task.wait()
    end
end
local function fixSyntax(Source)
    local OldSyntax = Source
    local NewSyntax = convertComments(OldSyntax)
    while true do
        local a,b = luaParser(NewSyntax)
        if(typeof(b) == "table") then
            return NewSyntax
        else
            b = HttpService:JSONDecode(b)
            local handlederr = errHandler:Handle(b.Line, b.Char, b.msg, NewSyntax)
            if(handlederr.Error) then
                return nil;
            else
                NewSyntax = table.concat(handlederr)
            end
        end
        task.wait()
    end
end

local ActiveScript = StudioService.ActiveScript
StudioService:GetPropertyChangedSignal("ActiveScript"):Connect(function(newActiveScript)
    newActiveScript = ActiveScript
end)

--[[local pluginAction = plugin:CreatePluginAction("FixSyntaxError", "Fix Syntax Errors", "Fixes Syntax Errors in the current script!", "rbxassetid://7367926104", false)
 
pluginAction.Triggered:Connect(function()
    local OldScript = ActiveScript
    if(OldScript and OldScript:IsA("Script")) then
        local NewSyntax = fixSyntax(OldScript.Source)
        task.spawn(function()
            local ContinueSyntaxFix = true
            if(NewSyntax == nil) then 
                local s,e = pcall(function()
                    local fixedSyntax = fixSyntaxWithFormat(OldScript.Source)
                    NewSyntax = fixedSyntax
                end)
                if(e) then
                    assert(false == true, "Failed to fix syntax error, must be manually fixed!") 
                    return 
                else
                    ContinueSyntaxFix = false
                end
            end

            ChangeHistoryService:SetWaypoint("Updating Syntax")
            local Formatted = formatter:Minify(NewSyntax)
            if(ContinueSyntaxFix) then
                pcall(function()
                    local decoded = HttpService:JSONDecode(Formatted)
                    if(decoded.Error) then
                        local fixedSyntax = fixSyntaxWithFormat(NewSyntax)
                        NewSyntax = fixedSyntax
                        Formatted = formatter:Minify(fixedSyntax)
                    end
                end)
            end
            if(Options.minify == false) then
                Formatted = formatter:Beautify(NewSyntax)
                table.remove(Formatted, 1)
            end
            if(Options.newscript == true) then
                local Output = Instance.new(OldScript.ClassName)
                Output.Source = table.concat(Formatted)
                Output.Name = OldScript.Name.."-FIXED"
                Output.Parent = OldScript.Parent
                SelectionService:Set({Output})
                plugin:OpenScript(Output)
            else
                OldScript.Source = table.concat(Formatted)
                SelectionService:Set({OldScript})
                plugin:OpenScript(OldScript)
            end
            ChangeHistoryService:SetWaypoint("Updated Syntax")
        end)
    end
end)]]

SyntaxContainer.Button.MouseButton1Click:Connect(function()
    local Selection = SelectionService:Get()
    if #Selection == 0 then
        assert(false == true, "An Instance must be selected.")
    elseif #Selection > 1 then
        local NewSelection = {}
        for _, v in ipairs(Selection) do
            if(v:IsA("Script")) then
                task.spawn(function()
                    local OldSyntax = v.Source
                    local NewSyntax = fixSyntax(OldSyntax)

                    task.spawn(function()
                        local ContinueSyntaxFix = true
                        if(NewSyntax == nil) then 
                            local s,e = pcall(function()
                                local fixedSyntax = fixSyntaxWithFormat(OldSyntax)
                                NewSyntax = fixedSyntax
                            end)
                            if(e) then
                                assert(false == true, "Failed to fix syntax error, must be manually fixed!") 
                                return 
                            else
                                ContinueSyntaxFix = false
                            end
                        end

                        ChangeHistoryService:SetWaypoint("Updating Syntax")                        
                        local Formatted = formatter:Minify(NewSyntax)
                        if(ContinueSyntaxFix) then
                            pcall(function()
                                local decoded = HttpService:JSONDecode(Formatted)
                                if(decoded.Error) then
                                    local fixedSyntax = fixSyntaxWithFormat(NewSyntax)
                                    NewSyntax = fixedSyntax
                                    Formatted = formatter:Minify(fixedSyntax)
                                end
                            end)
                        end
            
                        if(Options.minify == false) then
                            Formatted = formatter:Beautify(NewSyntax)
                            table.remove(Formatted, 1)
                        end
                        if(Options.newscript == true) then
                            local Output = Instance.new(v.ClassName)
                            Output.Source = table.concat(Formatted)
                            Output.Name = v.Name.."-FIXED"
                            Output.Parent = v.Parent
                            table.insert(NewSelection, Output)
                        else
                            v.Source = table.concat(Formatted)
                        end
                        ChangeHistoryService:SetWaypoint("Updated Syntax")
                    end)
                end)                
            end
        end
        SelectionService:Set(NewSelection)
    else
        local OldScript = Selection[1]
        if(OldScript:IsA("Script")) then
            local NewSyntax = fixSyntax(OldScript.Source)
            task.spawn(function()
                local ContinueSyntaxFix = true
                if(NewSyntax == nil) then 
                    local s,e = pcall(function()
                        local fixedSyntax = fixSyntaxWithFormat(OldScript.Source)
                        NewSyntax = fixedSyntax
                    end)
                    if(e) then
                        assert(false == true, "Failed to fix syntax error, must be manually fixed!") 
                        return 
                    else
                        ContinueSyntaxFix = false
                    end
                end

                ChangeHistoryService:SetWaypoint("Updating Syntax")
                local Formatted = formatter:Minify(NewSyntax)
                if(ContinueSyntaxFix) then
                    pcall(function()
                        local decoded = HttpService:JSONDecode(Formatted)
                        if(decoded.Error) then
                            local fixedSyntax = fixSyntaxWithFormat(NewSyntax)
                            NewSyntax = fixedSyntax
                            Formatted = formatter:Minify(fixedSyntax)
                        end
                    end)
                end
                if(Options.minify == false) then
                    Formatted = formatter:Beautify(NewSyntax)
                    table.remove(Formatted, 1)
                end
                if(Options.newscript == true) then
                    local Output = Instance.new(OldScript.ClassName)
                    Output.Source = table.concat(Formatted)
                    Output.Name = OldScript.Name.."-FIXED"
                    Output.Parent = OldScript.Parent
                    SelectionService:Set({Output})
                    plugin:OpenScript(Output)
                else
                    OldScript.Source = table.concat(Formatted)
                    SelectionService:Set({OldScript})
                    plugin:OpenScript(OldScript)
                end
                ChangeHistoryService:SetWaypoint("Updated Syntax")
            end)
        end
    end
end)
PluginGui:GetPropertyChangedSignal("Enabled"):Connect(function()
    PluginButton:SetActive(PluginGui.Enabled)
end)
PluginButton.Click:Connect(function()
    PluginGui.Enabled = not PluginGui.Enabled
end)
