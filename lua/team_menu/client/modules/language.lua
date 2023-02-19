Module("TeamMenu.Language")


local Utils = Require("TeamMenu.Utils")


local GetConVar = _G.GetConVar
local table = _G.table
local file = _G.file
local utf8 = _G.utf8
local tonumber = _G.tonumber
local pairs = _G.pairs
local ipairs = _G.ipairs
local table = _G.table
local hook = _G.hook


languages = Utils.Table.GetValue(_G, "Uratrecom.Language.languages", {
    bg = "Bulgarian",
    cs = "Czech",
    da = "Danish",
    de = "German",
    el = "Greek",
    en = "English",
    ["en-PT"] = "Pirate English",
    ["es-ES"] = "Spanish",
    et = "Estonian",
    fi = "Finnish",
    fr = "French",
    he = "Hebrew",
    hr = "Croatian",
    hu = "Hungarian",
    it = "Italian",
    ja = "Japanese",
    ko = "Korean",
    lt = "Lithuanian",
    nl = "Dutch",
    no = "Norwegian",
    pl = "Polish",
    ["pt-BR"] = "Portuguese (Brazil)",
    ["pt-PT"] = "Portuguese (Portugal)",
    ru = "Russian",
    sk = "Slovak",
    ["sv-SE"] = "Swedish",
    th = "Thai",
    tr = "Turkish",
    uk = "Ukrainian",
    vi = "Vietnamese",
    ["zh-CN"] =	"Chinese Simplified",
    ["zh-TW"] = "Chinese Traditional"
})


cache = Utils.Table.GetValue(_G, "Uratrecom.Language.cache", {})


function SetCurrentLanguage(language)
    GetConVar("team_menu_language"):SetString(language)
end


function GetCurrentLanguage()
    return GetConVar("team_menu_language"):GetString()
end


function GetLanguageCodes()
    return table.GetKeys(languages)
end


function IsValid(language)
    return table.HasValue(GetLanguageCodes(), language)
end


function LocalizationFile(filename, language)
    return "resource/localization/" .. language ..  "/" .. filename
end


function LocalizationFileExists(filename, language)
    return file.Exists(
        LocalizationFile(filename, language),
        "GAME"
    )
end


function WhereLocalizationFileExists(filename)
    local tbl = {}


    for language in pairs(languages) do
        if LocalizationFileExists(filename, language) then
            table.insert(tbl, language)
        end
    end


    return tbl
end


function GetFullName(language)
    return languages[language]
end


function ParseFile(filename, language)
    local tbl = {}
    local filePath = LocalizationFile(filename, language)
    local content = file.Read(filePath, "GAME")


    if not content then
        return
    end


    for line in content:gmatch("[^\r\n]+") do
        if not line:StartWith("#") and line:len() then
            local key, value = line:match("([%w_%.]+)%s*=%s*(.*)")


            value = value:Trim()


            for hex in value:gmatch("\\u(%x%x%x%x)") do
                value = value:gsub("\\u" .. hex, utf8.char(tonumber(hex, 16)))
            end


            tbl[key] = value    
        end
    end


    return tbl
end


function GetPhrase(phrase, language)
    local currentLanguage = GetCurrentLanguage()


    if currentLanguage == "auto" and language == nil or language == "auto" then
        return _G.language.GetPhrase(phrase)
    end


    language = language or currentLanguage


    if not IsValid(language) then
        return phrase
    end


    local languagePhrase = Utils.Table.GetValue(cache, language, {})[phrase]
    local englishPhrase = Utils.Table.GetValue(cache, "en", {})[phrase]


    if languagePhrase ~= nil then
        return languagePhrase
    end


    if englishPhrase ~= nil then
        return englishPhrase
    end


    return phrase
end


function CacheFile(filename)
    local tbl = WhereLocalizationFileExists(filename)

    for _, language in ipairs(tbl) do
        table.Merge(
            Utils.Table.GetValue(cache, language, {}),
            ParseFile(filename, language)
        )
    end
end


CacheFile("team_menu.properties")


hook.Add("InitPostEntity", "TeamMenu_LoadLocalization", function()
    CacheFile("team_menu.properties")
end)