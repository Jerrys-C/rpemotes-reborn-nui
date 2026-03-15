-- Pazeee Animation Pack
-- Drop-in addon for custom_emotes/ auto-loading

local ENABLED = false -- Set to false to disable this pack

if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Expressions = {}
CustomDP.Walks = {}
CustomDP.Shared = {
    ["pmotoraa"] = {
        "pazeee@motoraa@animations",
        "pazeee@motoraa@clip",
        "骑摩托 A 驾驶",
        "pmotora",
        AnimationOptions = {
        }
    },
    ["pmotora"] = {
        "pazeee@motora@animations",
        "pazeee@motora@clip",
        "骑摩托 A 乘客",
        "pmotoraa",
        AnimationOptions = {
            EmoteLoop = true,
            Attachto = true,
            bone = 11816,
            xPos = 0.5500,
            yPos = 0.1500,
            zPos = -0.1200,
            xRot = 0.000,
            yRot = 0.000,
            zRot = -14.000
        }
    },
    ["pmotorb"] = {
        "pazeee@motorb@animations",
        "pazeee@motorb@clip",
        "骑摩托 B",
        "pmotorc",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["pmotorc"] = {
        "pazeee@motorc@animations",
        "pazeee@motorc@clip",
        "骑摩托 C",
        "pmotorb",
        AnimationOptions = {
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.3200,
            yPos = -0.1300,
            zPos = -0.2800,
            xRot = 0.000,
            yRot = 0.000,
            zRot = -28.000
        }
    },
    ["pholdlega"] = {
        "pazeee@holdlega@animations",
        "pazeee@holdlega@clip",
        "抬腿 A",
        "pholdlegb",
        AnimationOptions = {
            Flag = 33
        }
    },
    ["pholdlegb"] = {
        "pazeee@holdlegb@animations",
        "pazeee@holdlegb@clip",
        "抬腿 B",
        "pholdlega",
        AnimationOptions = {
            EmoteLoop = true,
            Attachto = true,
            bone = 52301,
            xPos = -0.4100,
            yPos = -0.1700,
            zPos = 1.1300,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pstucklega"] = {
        "pazeee@stucklega@animations",
        "pazeee@stucklega@clip",
        "卡腿 A",
        "pstucklegb",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["pstucklegb"] = {
        "pazeee@stucklegb@animations",
        "pazeee@stucklegb@clip",
        "卡腿 B",
        "pstucklega",
        AnimationOptions = {
            EmoteLoop = true,
            Attachto = true,
            bone = 16335,
            xPos = 0.4100,
            yPos = -0.1700,
            zPos = 0.1300,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcartcementb"] = {
        "pazeee@cartcementb@animations",
        "pazeee@cartcementb@clip",
        "推水泥车 B",
        "pcartcementc",
        AnimationOptions = {
            Prop = 'prop_wheelbarrow01a',
            PropBone = 28422,
            PropPlacement = {
                0.8500, 0.62, 0.0,
                -36.633, -51.309, 60.93
            },
            Flag = 33
        }
    },
    ["pcartcementc"] = {
        "pazeee@cartcementc@animations",
        "pazeee@cartcementc@clip",
        "推水泥车 C",
        "pcartcementb",
        AnimationOptions = {
            EmoteLoop = true,
            Attachto = true,
            bone = 28422,
            xPos = 0.1800,
            yPos = 0.7100,
            zPos = -0.0500,
            xRot = 0.000,
            yRot = 0.000,
            zRot = -10.000
        }
    },
    ["pfunnypuncha"] = {
        "pazeee@funnypuncha@animations",
        "pazeee@funnypuncha@clip",
        "搞笑出拳 A",
        "pfunnypunchb",
        AnimationOptions = {
            SyncOffsetFront = 1.35,
            SyncOffsetSide = -0.15,
            EmoteLoop = true
        }
    },
    ["pfunnypunchb"] = {
        "pazeee@funnypunchb@animations",
        "pazeee@funnypunchb@clip",
        "搞笑出拳 B",
        "pfunnypuncha",
        AnimationOptions = {
            SyncOffsetFront = 1.35,
            SyncOffsetSide = -0.15,
            EmoteLoop = true
        }
    },
}

CustomDP.Dances = {}
CustomDP.AnimalEmotes = {}
CustomDP.Exits = {}
CustomDP.Emotes = {
    ["pmonkeya"] = {
        "pazeee@monkeya@animations",
        "pazeee@monkeya@clip",
        "猴子 A",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["pmonkeyb"] = {
        "pazeee@monkeyb@animations",
        "pazeee@monkeyb@clip",
        "猴子 B",
        AnimationOptions = {
            Flag = 33
        }
    },
    ["pmonkeyc"] = {
        "pazeee@monkeyc@animations",
        "pazeee@monkeyc@clip",
        "猴子 C",
        AnimationOptions = {
        }
    },
    ["pmonggoa"] = {
        "pazeee@monggoa@animations",
        "pazeee@monggoa@clip",
        "搏击 A",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["pmonggob"] = {
        "pazeee@monggob@animations",
        "pazeee@monggob@clip",
        "搏击 B",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["pmonggoc"] = {
        "pazeee@monggoc@animations",
        "pazeee@monggoc@clip",
        "搏击 C",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["pmonggod"] = {
        "pazeee@monggod@animations",
        "pazeee@monggod@clip",
        "搏击 D",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["pmonggoe"] = {
        "pazeee@monggoe@animations",
        "pazeee@monggoe@clip",
        "搏击 E",
        AnimationOptions = {
            Flag = 2
        }
    },
    ["pmonggof"] = {
        "pazeee@monggof@animations",
        "pazeee@monggof@clip",
        "搏击 F",
        AnimationOptions = {
            Flag = 2
        }
    },
    ["pexcusemewalka"] = {
        "pazeee@excusemewalka@animations",
        "pazeee@excusemewalka@clip",
        "借过走路 A",
        AnimationOptions = {
            Flag = 33
        }
    },
    ["pexcusemewalkb"] = {
        "pazeee@excusemewalkb@animations",
        "pazeee@excusemewalkb@clip",
        "借过走路 B",
        AnimationOptions = {
            Flag = 33
        }
    },
    ["ppoopa"] = {
        "pazeee@poopa@animations",
        "pazeee@poopa@clip",
        "蹲坑 A",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psitgrounda"] = {
        "pazeee@sitgrounda@animations",
        "pazeee@sitgrounda@clip",
        "坐地上 A",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psitgroundb"] = {
        "pazeee@sitgroundb@animations",
        "pazeee@sitgroundb@clip",
        "坐地上 B",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psitgroundc"] = {
        "pazeee@sitgroundc@animations",
        "pazeee@sitgroundc@clip",
        "坐地上 C",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psitgroundd"] = {
        "pazeee@sitgroundd@animations",
        "pazeee@sitgroundd@clip",
        "坐地上 D",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psitgrounde"] = {
        "pazeee@sitgrounde@animations",
        "pazeee@sitgrounde@clip",
        "坐地上 E",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["parroganta"] = {
        "pazeee@arroganta@animations",
        "pazeee@arroganta@clip",
        "傲慢 A",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["parrogantb"] = {
        "pazeee@arrogantb@animations",
        "pazeee@arrogantb@clip",
        "傲慢 B",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["parrogantc"] = {
        "pazeee@arrogantc@animations",
        "pazeee@arrogantc@clip",
        "傲慢 C",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["parrogantd"] = {
        "pazeee@arrogantd@animations",
        "pazeee@arrogantd@clip",
        "傲慢 D",
        AnimationOptions = {
            Flag = 33
        }
    },
    ["parrogante"] = {
        "pazeee@arrogante@animations",
        "pazeee@arrogante@clip",
        "傲慢 E",
        AnimationOptions = {
            Flag = 33
        }
    },
    ["pbravea"] = {
        "pazeee@bravea@animations",
        "pazeee@bravea@clip",
        "勇敢 A",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["pbraveb"] = {
        "pazeee@braveb@animations",
        "pazeee@braveb@clip",
        "勇敢 B",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["pbravec"] = {
        "pazeee@bravec@animations",
        "pazeee@bravec@clip",
        "勇敢 C",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["pbraved"] = {
        "pazeee@braved@animations",
        "pazeee@braved@clip",
        "勇敢 D",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["pcheckpocketsa"] = {
        "pazeee@checkpocketsa@animations",
        "pazeee@checkpocketsa@clip",
        "翻口袋 A",
        AnimationOptions = {
        }
    },
    ["pdeada"] = {
        "pazeee@deada@animations",
        "pazeee@deada@clip",
        "倒地 A 不想死",
        AnimationOptions = {
        }
    },
    ["pdeadb"] = {
        "pazeee@deadb@animations",
        "pazeee@deadb@clip",
        "倒地 B 发呆",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["pdeadc"] = {
        "pazeee@deadc@animations",
        "pazeee@deadc@clip",
        "倒地 C 飞天",
        AnimationOptions = {
            Flag = 2
        }
    },
    ["penjoyviewa"] = {
        "pazeee@enjoyviewa@animations",
        "pazeee@enjoyviewa@clip",
        "欣赏风景 A",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["penjoyviewb"] = {
        "pazeee@enjoyviewb@animations",
        "pazeee@enjoyviewb@clip",
        "欣赏风景 B",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["pfisthandskya"] = {
        "pazeee@fisthandskya@animations",
        "pazeee@fisthandskya@clip",
        "举拳向天 A",
        AnimationOptions = {
            Flag = 50
        }
    },
    ["pfisthandskyb"] = {
        "pazeee@fisthandskyb@animations",
        "pazeee@fisthandskyb@clip",
        "举拳向天 B",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["pgamehanda"] = {
        "pazeee@gamehanda@animations",
        "pazeee@gamehanda@clip",
        "猜拳 A",
        AnimationOptions = {
            Flag = 50
        }
    },
    ["pgamehandb"] = {
        "pazeee@gamehandb@animations",
        "pazeee@gamehandb@clip",
        "猜拳 B",
        AnimationOptions = {
            Flag = 50
        }
    },
    ["phideandseeka"] = {
        "pazeee@hideandseeka@animations",
        "pazeee@hideandseeka@clip",
        "躲猫猫 A",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["phideandseekb"] = {
        "pazeee@hideandseekb@animations",
        "pazeee@hideandseekb@clip",
        "躲猫猫 B",
        AnimationOptions = {
        }
    },
    ["phideandseekc"] = {
        "pazeee@hideandseekc@animations",
        "pazeee@hideandseekc@clip",
        "躲猫猫 C",
        AnimationOptions = {
        }
    },
    ["phideandseekd"] = {
        "pazeee@hideandseekd@animations",
        "pazeee@hideandseekd@clip",
        "躲猫猫 D",
        AnimationOptions = {
        }
    },
    ["pinhalea"] = {
        "pazeee@inhalea@animations",
        "pazeee@inhalea@clip",
        "深呼吸",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["pmotord"] = {
        "pazeee@motord@animations",
        "pazeee@motord@clip",
        "摩托 D",
        AnimationOptions = {
            Flag = 1
        }
    },
    ["pmotore"] = {
        "pazeee@motore@animations",
        "pazeee@motore@clip",
        "摩托 E",
        AnimationOptions = {
            Flag = 1
        }
    },
    ["pmotorf"] = {
        "pazeee@motorf@animations",
        "pazeee@motorf@clip",
        "摩托 F",
        AnimationOptions = {
            Flag = 1
        }
    },
    ["pmotorg"] = {
        "pazeee@motorg@animations",
        "pazeee@motorg@clip",
        "摩托 G",
        AnimationOptions = {
            Flag = 1
        }
    },
    ["ppalmfistsalutea"] = {
        "pazeee@palmfistsalutea@animations",
        "pazeee@palmfistsalutea@clip",
        "抱拳行礼 A",
        AnimationOptions = {
            Flag = 50
        }
    },
    ["ppalmfistsaluteb"] = {
        "pazeee@palmfistsaluteb@animations",
        "pazeee@palmfistsaluteb@clip",
        "抱拳行礼 B",
        AnimationOptions = {
            Flag = 50
        }
    },
    ["ppickupa"] = {
        "pazeee@pickupa@animations",
        "pazeee@pickupa@clip",
        "捡东西 A",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["ppickupb"] = {
        "pazeee@pickupb@animations",
        "pazeee@pickupb@clip",
        "捡东西 B",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["ppickupc"] = {
        "pazeee@pickupc@animations",
        "pazeee@pickupc@clip",
        "捡东西 C",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["ppickupd"] = {
        "pazeee@pickupd@animations",
        "pazeee@pickupd@clip",
        "捡东西 D",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["ppickupe"] = {
        "pazeee@pickupe@animations",
        "pazeee@pickupe@clip",
        "捡东西 E",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["ppickupf"] = {
        "pazeee@pickupf@animations",
        "pazeee@pickupf@clip",
        "捡东西 F",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["ppickupg"] = {
        "pazeee@pickupg@animations",
        "pazeee@pickupg@clip",
        "捡东西 G",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["ppickuph"] = {
        "pazeee@pickuph@animations",
        "pazeee@pickuph@clip",
        "捡东西 H",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["ppickupi"] = {
        "pazeee@pickupi@animations",
        "pazeee@pickupi@clip",
        "捡东西 I",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["ppickupj"] = {
        "pazeee@pickupj@animations",
        "pazeee@pickupj@clip",
        "捡东西 J",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["ppickupk"] = {
        "pazeee@pickupk@animations",
        "pazeee@pickupk@clip",
        "捡东西 K",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["ppickupl"] = {
        "pazeee@pickupl@animations",
        "pazeee@pickupl@clip",
        "捡东西 L",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["ppickupm"] = {
        "pazeee@pickupm@animations",
        "pazeee@pickupm@clip",
        "捡东西 M",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["ppickupn"] = {
        "pazeee@pickupn@animations",
        "pazeee@pickupn@clip",
        "捡东西 N",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psada"] = {
        "pazeee@sada@animations",
        "pazeee@sada@clip",
        "伤心 A",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psadb"] = {
        "pazeee@sadb@animations",
        "pazeee@sadb@clip",
        "伤心 B",
        AnimationOptions = {
            Flag = 2
        }
    },
    ["psadc"] = {
        "pazeee@sadc@animations",
        "pazeee@sadc@clip",
        "伤心 C",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psadd"] = {
        "pazeee@sadd@animations",
        "pazeee@sadd@clip",
        "伤心 D",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["pteamdisc1a"] = {
        "pazeee@teamdisc1a@animations",
        "pazeee@teamdisc1a@clip",
        "团队讨论 1A",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["pteamdisc1b"] = {
        "pazeee@teamdisc1b@animations",
        "pazeee@teamdisc1b@clip",
        "团队讨论 1B",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["pteamdisc2a"] = {
        "pazeee@teamdisc2a@animations",
        "pazeee@teamdisc2a@clip",
        "团队讨论 2A",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["pteamdisc2b"] = {
        "pazeee@teamdisc2b@animations",
        "pazeee@teamdisc2b@clip",
        "团队讨论 2B",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["pteamdisc2c"] = {
        "pazeee@teamdisc2c@animations",
        "pazeee@teamdisc2c@clip",
        "团队讨论 2C",
        AnimationOptions = {
        }
    },
    ["ptherea"] = {
        "pazeee@therea@animations",
        "pazeee@therea@clip",
        "看那边",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["pwhatsthata"] = {
        "pazeee@whatsthata@animations",
        "pazeee@whatsthata@clip",
        "那是什么",
        AnimationOptions = {
        }
    },
    ["pyappinga"] = {
        "pazeee@yappinga@animations",
        "pazeee@yappinga@clip",
        "唠叨 A",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["pyappingb"] = {
        "pazeee@yappingb@animations",
        "pazeee@yappingb@clip",
        "唠叨 B",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["pyappingc"] = {
        "pazeee@yappingc@animations",
        "pazeee@yappingc@clip",
        "唠叨 C",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["pyappingd"] = {
        "pazeee@yappingd@animations",
        "pazeee@yappingd@clip",
        "唠叨 D",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
}

CustomDP.PropEmotes = {
    ["ppoopb"] = {
        "pazeee@poopb@animations",
        "pazeee@poopb@clip",
        "蹲坑 B",
        AnimationOptions = {
            EmoteLoop = true,
            Prop = 'prop_toilet_01',
            PropBone = 52301,
            PropPlacement = {
                -0.2900, -0.20, -0.04,
                -109.955, 93.759, -1.367
            },
        }
    },
    ["ppoopc"] = {
        "pazeee@poopc@animations",
        "pazeee@poopc@clip",
        "蹲坑 C",
        AnimationOptions = {
            EmoteLoop = true,
            Prop = 'prop_toilet_01',
            PropBone = 52301,
            PropPlacement = {
                -0.3600, -0.240, -0.04,
                -109.955, 93.759, -1.367
            },
            SecondProp = 'prop_cs_newspaper',
            SecondPropBone = 57005,
            SecondPropPlacement = {
                0.1200, 0.280, -0.35,
                -51.531, -87.427, -33.627
            },
        }
    },
    ["ppoopd"] = {
        "pazeee@poopd@animations",
        "pazeee@poopd@clip",
        "蹲坑 D",
        AnimationOptions = {
            EmoteLoop = true,
            Prop = 'prop_toilet_01',
            PropBone = 52301,
            PropPlacement = {
                0.0700, -0.550, -0.14,
                -109.955, 93.759, -1.367
            },
        }
    },
    ["psitgroundf"] = {
        "pazeee@sitgroundf@animations",
        "pazeee@sitgroundf@clip",
        "坐地上 F",
        AnimationOptions = {
            EmoteLoop = true,
            Prop = 'ng_proc_cigarette01a',
            PropBone = 64097,
            PropPlacement = {
                0.0240, 0.010, 0.013,
                -136.062, -117.953, 1.510
            },
        }
    },
    ["psitgroundg"] = {
        "pazeee@sitgroundg@animations",
        "pazeee@sitgroundg@clip",
        "坐地上 G",
        AnimationOptions = {
            EmoteLoop = true,
            Prop = 'ng_proc_cigarette01a',
            PropBone = 64097,
            PropPlacement = {
                0.020, 0.0160, -0.004,
                90.0, -90.0, 79.99
            },
        }
    },
    ["psitgroundh"] = {
        "pazeee@sitgroundh@animations",
        "pazeee@sitgroundh@clip",
        "坐地上 H",
        AnimationOptions = {
            EmoteLoop = true,
            Prop = 'prop_player_phone_02',
            PropBone = 57005,
            PropPlacement = {
                0.1520, 0.07, -0.05,
                166.383, 150.432, -3.719
            },
        }
    },
    ["pcheckpocketsb"] = {
        "pazeee@checkpocketsb@animations",
        "pazeee@checkpocketsb@clip",
        "翻口袋 B",
        AnimationOptions = {
            Flag = 48,
            Prop = 'bkr_prop_money_sorted_01',
            PropBone = 57005,
            PropPlacement = {
                0.1600, -0.030, -0.03,
                9.851, -9.8510, -1.7279
            },
        }
    },
    ["pegranga"] = {
        "pazeee@egranga@animations",
        "pazeee@egranga@clip",
        "踩高跷 A",
        AnimationOptions = {
            EmoteLoop = true,
            Prop = 'a3d_egrang1',
            PropBone = 52301,
            PropPlacement = {
                0.3100, -0.010, -0.03,
                -110.7639, 98.637, -5.438
            },
            SecondProp = 'a3d_egrang1',
            SecondPropBone = 14201,
            SecondPropPlacement = {
                0.3100, -0.010, 0.03,
                -112.9874, 88.1588, 0.7813
            },
        }
    },
    ["pegrangb"] = {
        "pazeee@egrangb@animations",
        "pazeee@egrangb@clip",
        "踩高跷 B",
        AnimationOptions = {
            Flag = 33,
            Prop = 'a3d_egrang1',
            PropBone = 52301,
            PropPlacement = {
                0.3100, -0.010, -0.03,
                -110.7639, 98.637, -5.438
            },
            SecondProp = 'a3d_egrang1',
            SecondPropBone = 14201,
            SecondPropPlacement = {
                0.3100, -0.010, 0.03,
                -112.9874, 88.1588, 0.7813
            },
        }
    },
    ["penjoyviewc"] = {
        "pazeee@enjoyviewc@animations",
        "pazeee@enjoyviewc@clip",
        "欣赏风景 C",
        AnimationOptions = {
            EmoteLoop = true,
            Prop = 'prop_skid_chair_03',
            PropBone = 14201,
            PropPlacement = {
                -0.3700, 0.35, -0.14,
                -77.8344, 44.84, 19.809
            },
        }
    },
    ["penjoyviewd"] = {
        "pazeee@enjoyviewd@animations",
        "pazeee@enjoyviewd@clip",
        "欣赏风景 D",
        AnimationOptions = {
            EmoteLoop = true,
            Prop = 'prop_skid_chair_03',
            PropBone = 14201,
            PropPlacement = {
                -0.3100, 0.35, -0.14,
                -77.8344, 44.84, 19.809
            },
        }
    },
    ["pfakeblinda"] = {
        "pazeee@fakeblinda@animations",
        "pazeee@fakeblinda@clip",
        "装瞎 A",
        AnimationOptions = {
            EmoteLoop = true,
            Prop = 'prop_cs_sol_glasses',
            PropBone = 31086,
            PropPlacement = {
                0.050, 0.05, 0.0,
                -180.0, -90.0, 0.0
            },
            SecondProp = 'prop_cs_walking_stick',
            SecondPropBone = 57005,
            SecondPropPlacement = {
                0.110, 0.05, -0.01,
                -180.0, 90.0, 20.0
            },
        }
    },
    ["pkingchaira"] = {
        "pazeee@kingchaira@animations",
        "pazeee@kingchaira@clip",
        "王座 A",
        AnimationOptions = {
            EmoteLoop = true,
            Prop = 'paze_kingchair1',
            PropBone = 52301,
            PropPlacement = {
                -0.2300, -1.28, 0.59,
                -92.2377, 98.943, -28.329
            },
        }
    },
    ["pkingchairb"] = {
        "pazeee@kingchairb@animations",
        "pazeee@kingchairb@clip",
        "王座 B",
        AnimationOptions = {
            EmoteLoop = true,
            Prop = 'paze_kingchair1',
            PropBone = 57005,
            PropPlacement = {
                0.8700, 0.65, -1.81,
                84.6822, -112.759, 80.429
            },
        }
    },
    ["pkingchairc"] = {
        "pazeee@kingchairc@animations",
        "pazeee@kingchairc@clip",
        "王座 C",
        AnimationOptions = {
            EmoteLoop = true,
            Prop = 'paze_kingchair1',
            PropBone = 52301,
            PropPlacement = {
                0.4800, -1.76, -0.36,
                -107.078, 135.068, -4.95
            },
        }
    },
    ["pkingchaird"] = {
        "pazeee@kingchaird@animations",
        "pazeee@kingchaird@clip",
        "王座 D",
        AnimationOptions = {
            EmoteLoop = true,
            Prop = 'paze_kingchair1',
            PropBone = 14201,
            PropPlacement = {
                -0.9600, -1.83, -1.0,
                -112.87, -104.84, -23.328
            },
        }
    },
    ["pkingchaire"] = {
        "pazeee@kingchaire@animations",
        "pazeee@kingchaire@clip",
        "王座 E",
        AnimationOptions = {
            EmoteLoop = true,
            Prop = 'paze_kingchair1',
            PropBone = 52301,
            PropPlacement = {
                0.5600, -1.7, -0.490,
                -108.37, 93.757, 11.404
            },
        }
    },
    ["pmastera"] = {
        "pazeee@mastera@animations",
        "pazeee@mastera@clip",
        "大师 A",
        AnimationOptions = {
            EmoteLoop = true,
            Prop = 'a3d_egrang1',
            PropBone = 57005,
            PropPlacement = {
                0.0200, -0.26, -0.18,
                109.68, 70.768, 25.407
            },
        }
    },
    ["pcartcementa"] = {
        "pazeee@cartcementa@animations",
        "pazeee@cartcementa@clip",
        "推水泥车 A",
        AnimationOptions = {
            EmoteLoop = true,
            Flag = 33,
            Prop = 'prop_wheelbarrow01a',
            PropBone = 28422,
            PropPlacement = {
                0.8500, 0.62, 0.0,
                -36.633, -51.309, 60.93
            },
        }
    },
}

RegisterAddonEmotes(CustomDP)
