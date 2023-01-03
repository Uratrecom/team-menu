concommand.Add("ttt", function()
    local ICON_ALIGN = TeamMenu.ICON_ALIGN

    local window = vgui.Create("TeamMenu_Window")

    window:SetSize(300, 200)
    window:Center()
    window:MakePopup()

    local body = window:GetBody()

    local button = body:Add("TeamMenu_Button")
    button:SetText("lol")
    button:SetSize(200, 33)
    button:SetPos(40, 40)
    button:SetRadius(16)
    button:SetOutlineSize(1.9)

    button:SetIcon(Material("icon16/accept.png"))
    button:SetIconAlign(ICON_ALIGN.BEFORE_TEXT)

    local button = body:Add("TeamMenu_Button")
    button:SetText("daa")
    button:SetSize(200, 33)
    button:SetPos(40, 77)
    button:SetRadius(16)

    button:HideOutline()

    button:SetIcon(Material("icon16/add.png"))
    button:SetIconAlign(ICON_ALIGN.AFTER_TEXT)

    function button:DoDoubleClick()
        hook.Remove("HUDPaint", "TEAMS")
    end

    local Utils = TeamMenu.Utils
    local LINE_MODE = TeamMenu.LINE_MODE
    
    hook.Add("HUDPaint", "TEAMS", function()
        
        draw.NoTexture()
        surface.SetDrawColor(color_black)

        Utils.draw.RoundedRectangle(
            0.25,
            32,
            1,
            LINE_MODE.INNER,
            100,
            100,
            200,
            200
        )
    end)
end)
