local Utils = TeamMenu.Utils


local autoSave = GetConVar("team_menu_autosave")
local autoSaveTime = GetConVar("team_menu_autosave_time")
local delay = 0


hook.Add("Tick", "TeamMenu_AutoSaveTeams", function()
    if not autoSave:GetBool() or CurTime() < delay then
        return
    end

    file.CreateDir("uratrecom")
    Utils.SaveTeams("uratrecom/teams.json")

    delay = CurTime() + autoSaveTime:GetFloat()
end)