-- Pazeee Animation Pack - Custom Category
-- Groups all pazeee emotes under a single menu category.

local ENABLED = true -- Set to false to disable this category
if not ENABLED then return end

Config.CustomCategories[('New Roleplay Emotes')] = {
    [EmoteType.SHARED] = {
        "pmotoraa", "pmotora", "pmotorb", "pmotorc", "pholdlega", "pholdlegb", "pstucklega", "pstucklegb",
        "pcartcementb", "pcartcementc", "pfunnypuncha", "pfunnypunchb"
    },
    [EmoteType.EMOTES] = {
        "parroganta", "parrogantb", "parrogantc", "parrogantd", "parrogante", "pbravea", "pbraveb", "pbravec", "pbraved",
        "pcheckpocketsa", "pdeada", "pdeadb", "pdeadc", "penjoyviewa", "penjoyviewb", "pfisthandskya", "pfisthandskyb",
        "pgamehanda", "pgamehandb", "phideandseeka", "phideandseekb", "phideandseekc", "phideandseekd", "pinhalea", "pmotord",
        "pmotore", "pmotorf", "pmotorg", "ppalmfistsalutea", "ppalmfistsaluteb", "ppickupa", "ppickupb", "ppickupc", "ppickupd",
        "ppickupe", "ppickupf", "ppickupg", "ppickuph", "ppickupi", "ppickupj", "ppickupk", "ppickupl", "ppickupm", "ppickupn",
        "psada", "psadb", "psadc", "psadd", "pteamdisc1a", "pteamdisc1b", "pteamdisc2a", "pteamdisc2b", "pteamdisc2c",
        "ptherea", "pwhatsthata", "pyappinga", "pyappingb", "pyappingc", "pyappingd",
        "pmonggoa", "pmonggob", "pmonggoc", "pmonggod", "pmonggoe", "pmonggof", "pexcusemewalka", "pexcusemewalkb", "ppoopa", "psitgrounda",
        "psitgroundb", "psitgroundc", "psitgroundd", "psitgrounde", "pmonkeya", "pmonkeyb", "pmonkeyc"
    },
    [EmoteType.PROP_EMOTES] = {
        "pcheckpocketsb", "pegranga", "pegrangb", "penjoyviewc", "penjoyviewd", "pfakeblinda",
        "pkingchaira", "pkingchairb", "pkingchairc", "pkingchaird", "pkingchaire", "pmastera", "pcartcementa",
        "ppoopb", "ppoopc", "ppoopd", "psitgroundf", "psitgroundg", "psitgroundh"
    }
}
