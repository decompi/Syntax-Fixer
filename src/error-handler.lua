local SwitchModule = require(script.Parent:WaitForChild("switch"))
local ErrorHandler = {}
ErrorHandler.Errors = {
    [1] = "`(` expected",
    [2] = "`)` expected",
    [3] = "`,` expected",
    [4] = "`]` expected",
    [5] = "`then` expected",
    [6] = "`end` expected",
    [7] = "`do` expected",
    [8] = "for variable expected",
    [9] = "`in` expected",
    [10] = "`until` expected",
    [11] = "`=` expected",
    [12] = "`}` or table entry expected",
    [13] = "value expected"
}
function ErrorHandler:HandleCase(Line, Source, Char, CharErr)
    local SourceByLines = string.split(Source, "\n")
    local SourceLine = SourceByLines[Line]
    local NewLine = string.split(SourceLine, "")

    if(Char>#NewLine) then
        repeat table.insert(NewLine, "") until Char-#NewLine == 1
    end
    table.insert(NewLine, Char, CharErr)

    SourceByLines[Line] = table.concat(NewLine)
    return SourceByLines
end
function ErrorHandler:Handle(Line, Char, Msg, Source)
    Msg = Msg:lower()
    Msg = string.gsub(Msg, "%.", "")

    --print(Msg, Line, Char)
    
    local ReturnData = {}
    local switch = SwitchModule()
    :case(ErrorHandler.Errors[1], function()
        ReturnData = self:HandleCase(Line, Source, Char,  "(")
    end)
    :case(ErrorHandler.Errors[2], function()
        ReturnData = self:HandleCase(Line, Source, Char,  ")")
    end)
    :case(ErrorHandler.Errors[3], function()
        ReturnData = self:HandleCase(Line, Source, Char,  ",")
    end)
    :case(ErrorHandler.Errors[4], function()
        ReturnData = self:HandleCase(Line, Source, Char,  "]")
    end)
    :case(ErrorHandler.Errors[5], function()
        ReturnData = self:HandleCase(Line, Source, Char,  " then ")
    end)
    :case(ErrorHandler.Errors[6], function()
        ReturnData = self:HandleCase(Line, Source, Char,  " end")
    end)
    :case(ErrorHandler.Errors[7], function()
        ReturnData = self:HandleCase(Line, Source, Char,  " do ")
    end)
    :case(ErrorHandler.Errors[8], function()
        ReturnData = self:HandleCase(Line, Source, Char,  " for ")
    end)
    :case(ErrorHandler.Errors[9], function()
        ReturnData = self:HandleCase(Line, Source, Char,  " in ")
    end)
    :case(ErrorHandler.Errors[10], function()
        ReturnData = self:HandleCase(Line, Source, Char,  " until ")
    end)
    :case(ErrorHandler.Errors[11], function()
        ReturnData = self:HandleCase(Line, Source, Char,  "=")
    end)
    :case(ErrorHandler.Errors[12], function()
        ReturnData = self:HandleCase(Line, Source, Char,  "}")
    end)
    :case(ErrorHandler.Errors[13], function()
        ReturnData = self:HandleCase(Line, Source, Char,  "}")
    end)
    :default(function()
        ReturnData = {
            Error = "Unable to fix syntax at, Line: "..Line
        }
    end)
    switch(Msg)
    return ReturnData
end
return ErrorHandler
