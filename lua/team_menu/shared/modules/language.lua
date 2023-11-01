-- Module("TeamMenu.Language")


-- local Utils = Require("TeamMenu.Utils")


-- local GetConVar = _G.GetConVar
-- local table = _G.table
-- local file = _G.file
-- local utf8 = _G.utf8
-- local tonumber = _G.tonumber
-- local pairs = _G.pairs
-- local ipairs = _G.ipairs
-- local table = _G.table
-- local hook = _G.hook
-- local CreateConVar = _G.CreateConVar
-- local CreateClientConVar = _G.CreateClientConVar


-- if SERVER then
--     local flags = _G.bit.bor(
--         _G.FCVAR_ARCHIVE,
--         _G.FCVAR_GAMEDLL,
--         _G.FCVAR_REPLICATED
--     )


--     languageConVar = CreateConVar(
--         "team_menu_sv_language",
--         "auto",
--         flags,
--         ""
--     )


--     rawLanguageConVar = CreateConVar(
--         "team_menu_sv_raw_language",
--         "0",
--         flags,
--         "",
--         0,
--         1
--     )
-- else
--     languageConVar = CreateClientConVar(
--         "team_menu_language",
--         "auto",
--         true,
--         true,
--         ""
--     )

--     rawLanguageConVar = CreateClientConVar(
--         "team_menu_raw_language",
--         "0",
--         true,
--         true,
--         "",
--         0,
--         1
--     )
-- end


-- languages = Utils.Table.GetValue(_G, "Uratrecom.Language.languages", {
--     bg = "Bulgarian",
--     cs = "Czech",
--     da = "Danish",
--     de = "German",
--     el = "Greek",
--     en = "English",
--     ["en-PT"] = "Pirate English",
--     ["es-ES"] = "Spanish",
--     et = "Estonian",
--     fi = "Finnish",
--     fr = "French",
--     he = "Hebrew",
--     hr = "Croatian",
--     hu = "Hungarian",
--     it = "Italian",
--     ja = "Japanese",
--     ko = "Korean",
--     lt = "Lithuanian",
--     nl = "Dutch",
--     no = "Norwegian",
--     pl = "Polish",
--     ["pt-BR"] = "Portuguese (Brazil)",
--     ["pt-PT"] = "Portuguese (Portugal)",
--     ru = "Russian",
--     sk = "Slovak",
--     ["sv-SE"] = "Swedish",
--     th = "Thai",
--     tr = "Turkish",
--     uk = "Ukrainian",
--     vi = "Vietnamese",
--     ["zh-CN"] =	"Chinese Simplified",
--     ["zh-TW"] = "Chinese Traditional"
-- })


-- cache = Utils.Table.GetValue(_G, "Uratrecom.Language.cache", {})


-- function GetGameLanguage()
--     return GetConVar("gmod_language"):GetString()
-- end


-- function SetCurrentLanguage(language)
--     languageConVar:SetString(language)
-- end


-- function GetCurrentLanguage()
--     return languageConVar:GetString()
-- end


-- function GetLanguageCodes()
--     return table.GetKeys(languages)
-- end


-- function IsValid(language)
--     return table.HasValue(GetLanguageCodes(), language)
-- end


-- function LocalizationFile(filename, language)
--     return "resource/localization/" .. language ..  "/" .. filename
-- end


-- function LocalizationFileExists(filename, language)
--     return file.Exists(
--         LocalizationFile(filename, language),
--         "GAME"
--     )
-- end


-- function WhereLocalizationFileExists(filename)
--     local tbl = {}


--     for language in pairs(languages) do
--         if LocalizationFileExists(filename, language) then
--             table.insert(tbl, language)
--         end
--     end


--     return tbl
-- end


-- function GetFullName(language)
--     return languages[language]
-- end


-- function ParseFile(filename, language)
--     local tbl = {}
--     local filePath = LocalizationFile(filename, language)
--     local content = file.Read(filePath, "GAME")


--     if not content then
--         return
--     end


--     for line in content:gmatch("[^\r\n]+") do
--         if not line:StartWith("#") and line:len() then
--             local key, value = line:match("([%w_%.]+)%s*=%s*(.*)")


--             value = value:Trim()


--             for hex in value:gmatch("\\u(%x%x%x%x)") do
--                 value = value:gsub("\\u" .. hex, utf8.char(tonumber(hex, 16)))
--             end


--             tbl[key] = value    
--         end
--     end


--     return tbl
-- end


-- function GetPhrase(phrase, language)
--     if rawLanguageConVar:GetBool() then
--         return phrase
--     end


--     local currentLanguage = GetCurrentLanguage()


--     if currentLanguage == "auto" and language == nil or language == "auto" then
--         return GetPhrase(phrase, GetGameLanguage())
--     end


--     language = language or currentLanguage


--     if not IsValid(language) then
--         return phrase
--     end


--     local languagePhrase = Utils.Table.GetValue(cache, language, {})[phrase]
--     local englishPhrase = Utils.Table.GetValue(cache, "en", {})[phrase]


--     if languagePhrase ~= nil then
--         return languagePhrase
--     end


--     if englishPhrase ~= nil then
--         return englishPhrase
--     end


--     return phrase
-- end


-- function CacheFile(filename)
--     local tbl = WhereLocalizationFileExists(filename)

--     for _, language in ipairs(tbl) do
--         table.Merge(
--             Utils.Table.GetValue(cache, language, {}),
--             ParseFile(filename, language)
--         )
--     end
-- end


-- CacheFile("team_menu.properties")


-- function Initialize()
--     print("Initialize!", __INITIALIZED)
--     CacheFile("team_menu.properties")
-- end