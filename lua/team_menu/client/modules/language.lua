Module("TeamMenu.Language")


-- current = nil


-- PostRequire(function()
--     current = Require("TeamMenu.ConVars").GetConVar("language")
--     print(current)
-- end)

-- TeamMenu.Language = TeamMenu.Language or {}

-- local Utils = TeamMenu.Utils
-- local Language = TeamMenu.Language

-- Language.languages = {
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
-- }

-- local cache = {}

-- function Language.GetCache()
--     return cache
-- end

-- function Language.SetCurrentLanguage(lang)
--     language.currentLanguage = lang
-- end

-- Utils.AddArguments(Language.SetCurrentLanguage, {
--     { name = "lang", required = false, type = { "string", "nil" } }
-- })

-- function Language.GetCurrentLanguage()
--     return Language.currentLanguage
-- end

-- function Language.GetAvailableLanguages(filename)
--     if not Utils.CheckArguments(filename) then
--         return
--     end

--     local availableLanguages = {}

--     for lang in pairs(Language.languages) do
--         if file.Exists("resource/localization/" .. lang .. "/" .. filename) then
--             table.insert(availableLanguages, lang)
--         end
--     end

--     return availableLanguages
-- end

-- Utils.AddArguments(Language.GetAvailableLanguages, {
--     { name = "filename", required = true, type = "string" }
-- })

-- function Language.IsValid(lang)
--     return Language.languages[lang] ~= nil
-- end

-- function Language.GetFullName(lang)
--     if not Utils.CheckArguments(lang) then
--         return
--     end

--     return Language.languages[lang]
-- end

-- Utils.AddArguments(Language.GetFullName, {
--     { name = "lang", required = true, type = "string", validator = Utils.LanguageValidator }
-- })

-- function Language.GetLanguageCodes()
--     return table.GetKeys(Language.languages)
-- end

-- function Language.GetPhrase(phrase)
--     if not Utils.CheckArguments(phrase) then
--         return
--     end

--     local currentLanguage = Language.GetCurrentLanguage()

--     if not currentLanguage then
--         return language.GetPhrase(phrase)
--     end

--     local languagePhrase = cache[currentLanguage] and cache[currentLanguage][phrase]
--     local englishPhrase = cache["en"] and cache["en"][phrase]

--     if languagePhrase then
--         return languagePhrase
--     end

--     if englishPhrase then
--         return englishPhrase
--     end

--     return phrase
-- end

-- Utils.AddArguments(Language.GetPhrase, {
--     { name = "phrase", required = true, type = "string" }
-- })

-- function Language.ParseFile(filename, tbl)
--     if not Utils.CheckArguments(filename, tbl) then
--         return
--     end

--     tbl = tbl or {}
    
--     filename = "resource/localization/" .. filename

--     local fp = file.Open(filename, "r", "GAME")

--     if not fp then
--         return
--     end

--     local content = fp:Read()

--     fp:Close()

--     for line in content:gmatch("[^\r\n]+") do
--         local start = line:find("=")

--         if not line:StartWith("#") and start then
--             local key = line:sub(1, start-1)
--             local value = line:sub(start+1, -1):gsub("\\n", "\n")

--             for hex in value:gmatch("\\u(%x%x%x%x)") do
--                 local code = tonumber(hex, 16)
--                 value = value:gsub("\\u" .. hex, utf8.char(code))
--             end

--             tbl[key] = value    
--         end
--     end

--     return tbl
-- end


-- function Parse(lang)
--     local tbl = {}

--     for _, filename in pairs(file.Find("resource/localization/" .. lang .. "/*", "GAME")) do
--         language.ParseFile(lang .. "/" .. filename, tbl)
--     end

--     return tbl
-- end



-- function Refresh(lang)
--     cache[lang] = language.ParseLanguage(lang)
-- end


-- function RefreshAll()
--     for lang in pairs(Language.languages) do
--         cache[lang] = language.ParseLanguage(lang)
--     end
-- end