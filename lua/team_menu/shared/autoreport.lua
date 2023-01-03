TeamMenu.AutoReport = TeamMenu.AutoReport or {}

local Utils = TeamMenu.Utils
local AutoReport = TeamMenu.AutoReport

AutoReport.frame = nil
AutoReport.frameWidth = 400
AutoReport.frameHeight = 160

AutoReport.buttonWidth = 88
AutoReport.buttonHeight = 22
AutoReport.buttonPadding = 5

AutoReport.lastError = nil

local isEnabled = GetConVar("team_menu_autoreport")
local showPopup = GetConVar("team_menu_autoreport_show_popup")

hook.Add("InitPostEntity", "TeamMenu_AutoReport_Initialize", function()
    AutoReport:Initialize()
end)

function AutoReport:Initialize()
    if not Utils.CheckArguments(self) then
        return
    end

    if showPopup:GetBool() then
        RunConsoleCommand("team_menu_autoreport_show_popup", "0")
        RunConsoleCommand("team_menu_autoreport_popup")
    end
end

Utils.AddArguments(AutoReport.Initialize, {
    { name = "self", required = true, type = "table" }
})

function AutoReport:Popup()
    if not Utils.CheckArguments(self) then
        return
    end

    if IsValid(self.frame) then
        self.frame:Center()
        self.frame:MakePopup()
        return
    end

    local L = TeamMenu.Language.GetPhrase
    local frame = vgui.Create("DFrame")

    self.frame = frame

    frame.btnMaxim:SetCursor("arrow")
    frame.btnMinim:SetCursor("arrow")

    frame:SetSize(self.frameWidth, self.frameHeight)
    frame:Center()
    frame:SetTitle(L"uratrecom.autoreport.title")
    frame:MakePopup()
    frame:SetBackgroundBlur(true)

    local descriptionLabel = frame:Add("DLabel")

    descriptionLabel:SetPos(10, 24)
    descriptionLabel:SetSize(self.frameWidth-10, self.frameHeight-54)
    descriptionLabel:SetWrap(true)
    descriptionLabel:SetText(L"uratrecom.autoreport.description")

    local agreeButton = frame:Add("DButton")

    agreeButton:SetPos(FRAME_W/2-BUTTON_W-BUTTON_P, self.frameHeight-30)
    agreeButton:SetSize(BUTTON_W, BUTTON_H)
    agreeButton:SetText(L"uratrecom.autoreport.agree")

    function agreeButton:DoClick()
        RunConsoleCommand("team_menu_autoreport", "1")
        frame:Close()
    end

    local disagreeButton = frame:Add("DButton")

    disagreeButton:SetPos(self.frameWidth/2-BUTTON_W/2+BUTTON_W/2+BUTTON_P, self.frameHeight-30)
    disagreeButton:SetSize(BUTTON_W, BUTTON_H)
    disagreeButton:SetText(L"uratrecom.autoreport.disagree")    

    function disagreeButton:DoClick()
        RunConsoleCommand("team_menu_autoreport", "0")
        frame:Close()
    end
end

Utils.AddArguments(AutoReport.Popup, {
    { name = "self", required = true, type = "table" }
})

function AutoReport:Report(errorMessage)
    if not Utils.CheckArguments(self, errorMessage) then
        return
    end

    if not isEnabled:GetBool() or self.lastError == errorMessage then
        return 
    end

    self.lastError = errorMessage

    local data = util.TableToJSON({
        error = errorMessage,
        mountedAddons = Utils.engine.GetMountedAddons(),
        isServer = SERVER,
        traceback = debug.traceback(),
        addon = "TeamMenu",
        gamemode = engine.ActiveGamemode()
    }, false)

    http.Post(
        util.Base64Decode("aHR0cHM6Ly9yZXBvcnQudXVyYXRyZWNvbS5yZXBsLmNv"),
        { json = data },
        function(reason)
            if reason == "good" then
                print("The error report was successfully sent.")
                return
            end

            print("Failure to send the error report.\nReason:\n" .. reason)
        end
    )
end

Utils.AddArguments(AutoReport.Report, {
    { name = "self", required = true, type = "table" },
    { name = "errorMessage", required = true, type = "string" }
})

if CLIENT then
    concommand.Add("team_menu_autoreport_popup", function()
        AutoReport:Popup()
    end)
end