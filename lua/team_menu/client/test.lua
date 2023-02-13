-- concommand.Add("ttt", function()
--     local ICON_ALIGN = TeamMenu.ICON_ALIGN

--     local window = vgui.Create("TeamMenu_Window")

--     window:SetSize(300, 200)
--     window:Center()
--     window:MakePopup()

--     local body = window:GetBody()

--     local button = body:Add("TeamMenu_Button")
--     button:SetText("lol")
--     button:SetSize(200, 33)
--     button:SetPos(40, 40)
--     button:SetRadius(16)
--     button:SetOutlineSize(1.9)

--     button:SetIcon(Material("icon16/accept.png"))
--     button:SetIconAlign(ICON_ALIGN.BEFORE_TEXT)

--     local button = body:Add("TeamMenu_Button")
--     button:SetText("daa")
--     button:SetSize(200, 33)
--     button:SetPos(40, 77)
--     button:SetRadius(16)

--     button:HideOutline()

--     button:SetIcon(Material("icon16/add.png"))
--     button:SetIconAlign(ICON_ALIGN.AFTER_TEXT)

--     function button:DoDoubleClick()
--         hook.Remove("HUDPaint", "TEAMS")
--     end
-- end)

-- local insert = table.insert

-- function WriteLittleEndian(number, size)
--     local bytes = {}


--     for index=0, size - 1 do
--         insert(bytes, number >> index * 8 & 0xFF)
--     end


--     return bytes
-- end


-- function ReadLittleEndian(bytes)
--     local number = 0


--     for index, byte in ipairs(bytes) do
--         number = number | byte << (index - 1) * 8
-- 	end


--     return number
-- end


-- local value = WriteLittleEndian(13, 4)

-- for k, v in ipairs(value) do
--     print(k,v)
-- end

-- value = ReadLittleEndian(value)

-- print(value)