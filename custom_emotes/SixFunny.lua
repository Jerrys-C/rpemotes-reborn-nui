-- SixFunny Animation Pack
-- Drop-in addon for custom_emotes/ auto-loading

local ENABLED = false -- Set to false to disable this pack

if not ENABLED then return end

local CustomDP = {}

CustomDP.Expressions = {}
CustomDP.Walks = {}
CustomDP.Shared = {}
CustomDP.Dances = {}
CustomDP.AnimalEmotes = {}
CustomDP.Exits = {}
CustomDP.Emotes = {
    ["psixf"] = {
        "pazeee@sixf@animations",
        "pazeee@sixf@clip",
        "坐地 1",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixg"] = {
        "pazeee@sixg@animations",
        "pazeee@sixg@clip",
        "坐地 2",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixj"] = {
        "pazeee@sixj@animations",
        "pazeee@sixj@clip",
        "看手机 震惊",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixy"] = {
        "pazeee@sixy@animations",
        "pazeee@sixy@clip",
        "街头合照 1",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixz"] = {
        "pazeee@sixz@animations",
        "pazeee@sixz@clip",
        "街头合照 2",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixza"] = {
        "pazeee@sixza@animations",
        "pazeee@sixza@clip",
        "街头合照 3",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzb"] = {
        "pazeee@sixzb@animations",
        "pazeee@sixzb@clip",
        "街头合照 4",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzr"] = {
        "pazeee@sixzr@animations",
        "pazeee@sixzr@clip",
        "我爱你",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzs"] = {
        "pazeee@sixzs@animations",
        "pazeee@sixzs@clip",
        "超爱你",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzt"] = {
        "pazeee@sixzt@animations",
        "pazeee@sixzt@clip",
        "看呆了",
        AnimationOptions = {
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["psixzu"] = {
        "pazeee@sixzu@animations",
        "pazeee@sixzu@clip",
        "挥手 朝左",
        AnimationOptions = {
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["psixzv"] = {
        "pazeee@sixzv@animations",
        "pazeee@sixzv@clip",
        "挥手 正面",
        AnimationOptions = {
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["psixzw"] = {
        "pazeee@sixzw@animations",
        "pazeee@sixzw@clip",
        "双手挥手",
        AnimationOptions = {
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["psixzx"] = {
        "pazeee@sixzx@animations",
        "pazeee@sixzx@clip",
        "可爱挥手",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzy"] = {
        "pazeee@sixzy@animations",
        "pazeee@sixzy@clip",
        "坐边缘 1 女",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzy2"] = {
        "pazeee@sixzy2@animations",
        "pazeee@sixzy2@clip",
        "坐边缘 1 男",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzz"] = {
        "pazeee@sixzz@animations",
        "pazeee@sixzz@clip",
        "坐边缘 2 女",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzz2"] = {
        "pazeee@sixzz2@animations",
        "pazeee@sixzz2@clip",
        "坐边缘 2 男",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzza"] = {
        "pazeee@sixzza@animations",
        "pazeee@sixzza@clip",
        "坐边缘 3 女",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzza2"] = {
        "pazeee@sixzza2@animations",
        "pazeee@sixzza2@clip",
        "坐边缘 3 男",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzzb"] = {
        "pazeee@sixzzb@animations",
        "pazeee@sixzzb@clip",
        "坐边缘 4 女",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzzb2"] = {
        "pazeee@sixzzb2@animations",
        "pazeee@sixzzb2@clip",
        "坐边缘 4 男",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzzd"] = {
        "pazeee@sixzzd@animations",
        "pazeee@sixzzd@clip",
        "靠墙 1",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzze"] = {
        "pazeee@sixzze@animations",
        "pazeee@sixzze@clip",
        "靠墙 2",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzzf"] = {
        "pazeee@sixzzf@animations",
        "pazeee@sixzzf@clip",
        "靠吧台 按铃",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzzg"] = {
        "pazeee@sixzzg@animations",
        "pazeee@sixzzg@clip",
        "桌前讨论 1",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzzh"] = {
        "pazeee@sixzzh@animations",
        "pazeee@sixzzh@clip",
        "桌前讨论 2",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzzi"] = {
        "pazeee@sixzzi@animations",
        "pazeee@sixzzi@clip",
        "桌前讨论 3",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzzl"] = {
        "pazeee@sixzzl@animations",
        "pazeee@sixzzl@clip",
        "酷姿势 Lucia",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzzp"] = {
        "pazeee@sixzzp@animations",
        "pazeee@sixzzp@clip",
        "扶墙投降",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzzq"] = {
        "pazeee@sixzzq@animations",
        "pazeee@sixzzq@clip",
        "搜身",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzzr"] = {
        "pazeee@sixzzr@animations",
        "pazeee@sixzzr@clip",
        "嘟嘟嘟",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzzs"] = {
        "pazeee@sixzzs@animations",
        "pazeee@sixzzs@clip",
        "好好好 求你了",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzzze"] = {
        "pazeee@sixzzze@animations",
        "pazeee@sixzzze@clip",
        "搞笑走路",
        AnimationOptions = {
            EmoteLoop = true,
			Flag = 47
        }
    },
    ["psixzzzm"] = {
        "pazeee@sixzzzm@animations",
        "pazeee@sixzzzm@clip",
        "对讲机 2",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzzzn"] = {
        "pazeee@sixzzzn@animations",
        "pazeee@sixzzzn@clip",
        "对讲机 3",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzzzo"] = {
        "pazeee@sixzzzo@animations",
        "pazeee@sixzzzo@clip",
        "对讲机 4",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["psixzzzp"] = {
        "pazeee@sixzzzp@animations",
        "pazeee@sixzzzp@clip",
        "车内享受 1",
        AnimationOptions = {
            EmoteLoop = true,
			Flag = 1
        }
    },
    ["psixzzzq"] = {
        "pazeee@sixzzzq@animations",
        "pazeee@sixzzzq@clip",
        "车内享受 2",
        AnimationOptions = {
            EmoteLoop = true,
			Flag = 1
        }
    },
    ["psixzzzr"] = {
        "pazeee@sixzzzr@animations",
        "pazeee@sixzzzr@clip",
        "车内享受 3",
        AnimationOptions = {
            EmoteLoop = true,
			Flag = 1
        }
    },
    ["psixzzzc"] = {
        "pazeee@sixzzzc@animations",
        "pazeee@sixzzzc@clip",
        "可爱拖拽 Lucia",
        "psixzzzd",
        AnimationOptions = {
            EmoteLoop = true,
			Flag = 47
        }
    },
}
CustomDP.PropEmotes = {
    ["psixa"] = {
        "pazeee@sixa@animations",
        "pazeee@sixa@clip",
        "流浪汉 1",
        AnimationOptions = {
            Prop = "v_ret_gc_cup",
            PropBone = 57005,
            PropPlacement = {
                0.110,
                0.04,
                -0.04,
                -60.0,
                0.0,
                0.0,
            },
            EmoteLoop = true
        }
    },
    ["psixb"] = {
        "pazeee@sixb@animations",
        "pazeee@sixb@clip",
        "流浪汉 2",
        AnimationOptions = {
            Prop = "v_ret_gc_cup",
            PropBone = 57005,
            PropPlacement = {
                0.110,
                0.04,
                -0.04,
                -60.0,
                0.0,
                0.0,
            },
            EmoteLoop = true
        }
    },
    ["psixc"] = {
        "pazeee@sixc@animations",
        "pazeee@sixc@clip",
        "流浪汉 3",
        AnimationOptions = {
            Prop = "v_ret_gc_cup",
            PropBone = 57005,
            PropPlacement = {
                0.110,
                0.04,
                -0.04,
                -60.0,
                0.0,
                0.0,
            },
            EmoteLoop = true
        }
    },
    ["psixd"] = {
        "pazeee@sixd@animations",
        "pazeee@sixd@clip",
        "流浪汉 4",
        AnimationOptions = {
            Prop = "v_ret_gc_cup",
            PropBone = 18905,
            PropPlacement = {
                0.110,
                0.04,
                0.04,
                -115.4,
                -16.012,
                -37.158,
            },
            EmoteLoop = true
        }
    },
    ["psixe"] = {
        "pazeee@sixe@animations",
        "pazeee@sixe@clip",
        "流浪汉 5",
        AnimationOptions = {
            Prop = "v_ret_gc_cup",
            PropBone = 52301,
            PropPlacement = {
                0.330,
                0.060,
                -0.560,
                -90.0,
                0.0,
                20.0,
            },
            EmoteLoop = true
        }
    },
    ["psixh"] = {
        "pazeee@sixh@animations",
        "pazeee@sixh@clip",
        "看手机 1",
        AnimationOptions = {
            Prop = "prop_player_phone_02",
            PropBone = 57005,
            PropPlacement = {
                0.150,
                0.06,
                -0.05,
                -176.3,
                -10.6,
                19.6,
            },
            EmoteLoop = true
        }
    },
    ["psixi"] = {
        "pazeee@sixi@animations",
        "pazeee@sixi@clip",
        "看手机 2 震惊",
        AnimationOptions = {
            Prop = "prop_player_phone_02",
            PropBone = 57005,
            PropPlacement = {
                0.130,
                0.04,
                -0.08,
                -176.3,
                -10.6,
                19.6,
            },
            EmoteLoop = true
        }
    },
    ["psixk"] = {
        "pazeee@sixk@animations",
        "pazeee@sixk@clip",
        "看手机 刷抖音",
        AnimationOptions = {
            Prop = "prop_player_phone_02",
            PropBone = 57005,
            PropPlacement = {
                0.150,
                0.069,
                -0.0240,
                -126.4,
                -112.6,
                20.3,
            },
            EmoteLoop = true
        }
    },
    ["psixl"] = {
        "pazeee@sixl@animations",
        "pazeee@sixl@clip",
        "收垃圾 1",
        AnimationOptions = {
            Prop = "a3d_grabber",
            PropBone = 57005,
            PropPlacement = {
                0.10,
                0.01,
                -0.01,
                -113.3,
                -153.4,
                14.6,
            },
            SecondProp = 'a3d_trashbag',
            SecondPropBone = 18905,
            SecondPropPlacement = {
                0.0100,
                0.2500,
                0.160,
                -5.0,
                -120.3,
                -8.6,
            },
            EmoteLoop = true
        }
    },
    ["psixm"] = {
        "pazeee@sixm@animations",
        "pazeee@sixm@clip",
        "收垃圾 2",
        AnimationOptions = {
            Prop = "a3d_grabber",
            PropBone = 57005,
            PropPlacement = {
                0.10,
                0.01,
                -0.01,
                -113.3,
                -153.4,
                14.6,
            },
            SecondProp = 'a3d_trashbag',
            SecondPropBone = 18905,
            SecondPropPlacement = {
                0.100,
                0.100,
                0.260,
                0.0,
                -90.0,
                -90.0,
            },
            EmoteLoop = true
        }
    },
    ["psixn"] = {
        "pazeee@sixn@animations",
        "pazeee@sixn@clip",
        "收垃圾 3",
        AnimationOptions = {
            Prop = "a3d_grabber",
            PropBone = 57005,
            PropPlacement = {
                0.10,
                0.01,
                -0.01,
                -113.3,
                -153.4,
                14.6,
            },
            SecondProp = 'a3d_trashbag',
            SecondPropBone = 18905,
            SecondPropPlacement = {
                0.3100,
                -0.0700,
                -0.090,
                -5.24,
                -148.0,
                52.0,
            },
            EmoteLoop = true
        }
    },
    ["psixo"] = {
        "pazeee@sixo@animations",
        "pazeee@sixo@clip",
        "收垃圾 4",
        AnimationOptions = {
            Prop = "a3d_grabber",
            PropBone = 57005,
            PropPlacement = {
                0.10,
                0.01,
                -0.01,
                -113.3,
                -153.4,
                14.6,
            },
            SecondProp = 'a3d_trashbag',
            SecondPropBone = 18905,
            SecondPropPlacement = {
                0.100,
                0.200,
                0.240,
                0.0,
                -90.0,
                -90.0,
            },
            EmoteLoop = true
        }
    },
    ["psixp"] = {
        "pazeee@sixp@animations",
        "pazeee@sixp@clip",
        "手机拍照 1",
        AnimationOptions = {
            Prop = "prop_player_phone_02",
            PropBone = 57005,
            PropPlacement = {
                0.130,
                0.07,
                -0.02,
                -119.5,
                -103.6,
                -3.7,
            },
            EmoteLoop = true
        }
    },
    ["psixq"] = {
        "pazeee@sixq@animations",
        "pazeee@sixq@clip",
        "手机拍照 2",
        AnimationOptions = {
            Prop = "prop_player_phone_02",
            PropBone = 57005,
            PropPlacement = {
                0.130,
                0.07,
                -0.02,
                -119.5,
                -103.6,
                -3.7,
            },
            EmoteLoop = true
        }
    },
    ["psixr"] = {
        "pazeee@sixr@animations",
        "pazeee@sixr@clip",
        "手机拍照 3",
        AnimationOptions = {
            Prop = "prop_player_phone_02",
            PropBone = 57005,
            PropPlacement = {
                0.130,
                0.11,
                -0.05,
                -102.7,
                -39.4,
                -5.4,
            },
            EmoteLoop = true
        }
    },
    ["psixs"] = {
        "pazeee@sixs@animations",
        "pazeee@sixs@clip",
        "手机拍照 4",
        AnimationOptions = {
            Prop = "prop_player_phone_02",
            PropBone = 57005,
            PropPlacement = {
                0.140,
                0.06,
                -0.06,
                -129.8,
                -31.4,
                -19.3,
            },
            SecondProp = 'prop_player_phone_02',
            SecondPropBone = 18905,
            SecondPropPlacement = {
                0.120,
                0.060,
                0.040,
                -72.8,
                -162.8,
                32.2,
            },
            EmoteLoop = true
        }
    },
    ["psixt"] = {
        "pazeee@sixt@animations",
        "pazeee@sixt@clip",
        "手机拍照 5",
        AnimationOptions = {
            Prop = "prop_player_phone_02",
            PropBone = 57005,
            PropPlacement = {
                0.1280,
                0.06,
                -0.03,
                -139.2,
                -111.6,
                -5.4,
            },
            EmoteLoop = true
        }
    },
    ["psixu"] = {
        "pazeee@sixu@animations",
        "pazeee@sixu@clip",
        "手机拍照 6",
        AnimationOptions = {
            Prop = "prop_player_phone_02",
            PropBone = 57005,
            PropPlacement = {
                0.120,
                0.08,
                -0.06,
                -113.3,
                -26.5,
                -14.66,
            },
            EmoteLoop = true
        }
    },
    ["psixv"] = {
        "pazeee@sixv@animations",
        "pazeee@sixv@clip",
        "手机拍照 7",
        AnimationOptions = {
            Prop = "prop_player_phone_02",
            PropBone = 18905,
            PropPlacement = {
                0.140,
                0.05,
                0.02,
                -83.16,
                -5.31,
                -20.2,
            },
            EmoteLoop = true
        }
    },
    ["psixw"] = {
        "pazeee@sixw@animations",
        "pazeee@sixw@clip",
        "手机拍照 8 移动",
        AnimationOptions = {
            Prop = "prop_player_phone_02",
            PropBone = 57005,
            PropPlacement = {
                0.160,
                0.07,
                -0.02,
                -144.9,
                -117.3,
                6.1,
            },
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["psixx"] = {
        "pazeee@sixx@animations",
        "pazeee@sixx@clip",
        "手机拍照 9 躺着",
        AnimationOptions = {
            Prop = "prop_player_phone_02",
            PropBone = 57005,
            PropPlacement = {
                0.160,
                0.07,
                -0.02,
                -144.9,
                -117.3,
                6.1,
            },
            EmoteLoop = true
        }
    },
    ["psixzc"] = {
        "pazeee@sixzc@animations",
        "pazeee@sixzc@clip",
        "搬箱子 1 移动",
        AnimationOptions = {
            Prop = "hei_prop_heist_wooden_box",
            PropBone = 57005,
            PropPlacement = {
                0.180,
                -0.120,
                -0.350,
                -70.07,
                -6.79,
                8.8,
            },
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["psixzd"] = {
        "pazeee@sixzd@animations",
        "pazeee@sixzd@clip",
        "搬箱子 2",
        AnimationOptions = {
            Prop = "hei_prop_heist_wooden_box",
            PropBone = 57005,
            PropPlacement = {
                0.50,
                0.130,
                -0.09,
                -1.01,
                -30.5,
                72.7,
            },
            EmoteLoop = true,
			Flag = 47
        }
    },
    ["psixze"] = {
        "pazeee@sixze@animations",
        "pazeee@sixze@clip",
        "搬箱子 3 慌张",
        AnimationOptions = {
            Prop = "hei_prop_heist_wooden_box",
            PropBone = 57005,
            PropPlacement = {
                0.50,
                0.130,
                -0.09,
                -1.01,
                -30.5,
                72.7,
            },
            EmoteLoop = true,
			Flag = 47
        }
    },
    ["psixzf"] = {
        "pazeee@sixzf@animations",
        "pazeee@sixzf@clip",
        "拖箱子 4",
        AnimationOptions = {
            Prop = "hei_prop_heist_ammo_box",
            PropBone = 57005,
            PropPlacement = {
                0.430,
                0.210,
                -0.220,
                -103.4,
                5.25,
                49.6,
            },
            EmoteLoop = true,
			Flag = 47
        }
    },
    ["psixzg"] = {
        "pazeee@sixzg@animations",
        "pazeee@sixzg@clip",
        "拖箱子 5 慌张",
        AnimationOptions = {
            Prop = "hei_prop_heist_ammo_box",
            PropBone = 57005,
            PropPlacement = {
                0.430,
                0.210,
                -0.220,
                -103.4,
                5.25,
                49.6,
            },
            EmoteLoop = true,
			Flag = 47
        }
    },
    ["psixzh"] = {
        "pazeee@sixzh@animations",
        "pazeee@sixzh@clip",
        "搬箱子 6 移动",
        AnimationOptions = {
            Prop = "hei_prop_heist_wooden_box",
            PropBone = 57005,
            PropPlacement = {
                0.210,
                0.270,
                -0.28,
                9.9,
                0.0,
                -30.0,
            },
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["psixzi"] = {
        "pazeee@sixzi@animations",
        "pazeee@sixzi@clip",
        "搬大箱子 7 移动",
        AnimationOptions = {
            Prop = "prop_box_wood06a",
            PropBone = 24818,
            PropPlacement = {
                -0.310,
                -0.50,
                0.0,
                10.0,
                90.0,
                0.0,
            },
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["psixzj"] = {
        "pazeee@sixzj@animations",
        "pazeee@sixzj@clip",
        "搬大箱子 8 移动",
        AnimationOptions = {
            Prop = "prop_box_wood08a",
            PropBone = 24818,
            PropPlacement = {
                0.150,
                -0.150,
                0.0,
                79.9,
                -90.0,
                0.0,
            },
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["psixzk"] = {
        "pazeee@sixzk@animations",
        "pazeee@sixzk@clip",
        "健身杠铃 1",
        AnimationOptions = {
            Prop = "prop_barbell_02",
            PropBone = 18905,
            PropPlacement = {
                0.120,
                0.20,
                -0.02,
                -14.35,
                40.54,
                75.98,
            },
            SecondProp = 'prop_muscle_bench_03',
            SecondPropBone = 52301,
            SecondPropPlacement = {
                -0.690,
                0.420,
                0.110,
                -107.4,
                118.4,
                -9.84,
            },
            EmoteLoop = true
        }
    },
    ["psixzl"] = {
        "pazeee@sixzl@animations",
        "pazeee@sixzl@clip",
        "健身杠铃 2",
        AnimationOptions = {
            Prop = "prop_barbell_02",
            PropBone = 57005,
            PropPlacement = {
                0.110,
                0.060,
                0.0,
                25.5,
                -27.2,
                67.7,
            },
            SecondProp = 'prop_muscle_bench_01',
            SecondPropBone = 52301,
            SecondPropPlacement = {
                -0.590,
                -0.050,
                0.0,
                -108.8,
                108.8,
                -6.7,
            },
            EmoteLoop = true
        }
    },
    ["psixzm"] = {
        "pazeee@sixzm@animations",
        "pazeee@sixzm@clip",
        "健身杠铃 3",
        AnimationOptions = {
            Prop = "prop_barbell_02",
            PropBone = 18905,
            PropPlacement = {
                0.080,
                0.0,
                0.03,
                25.5,
                -27.2,
                67.7,
            },
            SecondProp = 'prop_muscle_bench_01',
            SecondPropBone = 52301,
            SecondPropPlacement = {
                -0.480,
                -0.030,
                0.360,
                -100.3,
                148.4,
                -17.2,
            },
            EmoteLoop = true
        }
    },
    ["psixzn"] = {
        "pazeee@sixzn@animations",
        "pazeee@sixzn@clip",
        "健身杠铃 4",
        AnimationOptions = {
            Prop = "prop_barbell_02",
            PropBone = 18905,
            PropPlacement = {
                0.080,
                -0.060,
                0.01,
                44.56,
                -45.4,
                75.8,
            },
            SecondProp = 'prop_barbell_02',
            SecondPropBone = 57005,
            SecondPropPlacement = {
                0.110,
                0.050,
                -0.03,
                16.73,
                -19.42,
                58.52,
            },
            EmoteLoop = true
        }
    },
    ["psixzo"] = {
        "pazeee@sixzo@animations",
        "pazeee@sixzo@clip",
        "健身杠铃 5",
        AnimationOptions = {
            Prop = "prop_barbell_02",
            PropBone = 57005,
            PropPlacement = {
                0.250,
                0.250,
                0.07,
                43.02,
                -27.08,
                52.88,
            },
            EmoteLoop = true
        }
    },
    ["psixzp"] = {
        "pazeee@sixzp@animations",
        "pazeee@sixzp@clip",
        "健身杠铃 6 大师移动",
        AnimationOptions = {
            Prop = "prop_barbell_02",
            PropBone = 57005,
            PropPlacement = {
                0.250,
                0.250,
                0.07,
                43.02,
                -27.08,
                52.88,
            },
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["psixzq"] = {
        "pazeee@sixzq@animations",
        "pazeee@sixzq@clip",
        "健身杠铃 7 轻松",
        AnimationOptions = {
            Prop = "prop_barbell_02",
            PropBone = 57005,
            PropPlacement = {
                0.110,
                0.060,
                0.0,
                25.50,
                -27.27,
                67.73,
            },
            EmoteLoop = true
        }
    },
    ["psixzzc"] = {
        "pazeee@sixzzc@animations",
        "pazeee@sixzzc@clip",
        "坐边缘 5 手机 女",
        AnimationOptions = {
            Prop = "prop_player_phone_02",
            PropBone = 57005,
            PropPlacement = {
                0.10,
                0.050,
                -0.05,
                -99.52,
                -5.05,
                -9.5,
            },
            EmoteLoop = true
        }
    },
    ["psixzzc2"] = {
        "pazeee@sixzzc2@animations",
        "pazeee@sixzzc2@clip",
        "坐边缘 5 手机 男",
        AnimationOptions = {
            Prop = "prop_player_phone_02",
            PropBone = 57005,
            PropPlacement = {
                0.10,
                0.050,
                -0.05,
                -99.52,
                -5.05,
                -9.5,
            },
            EmoteLoop = true
        }
    },
    ["psixzzj"] = {
        "pazeee@sixzzj@animations",
        "pazeee@sixzzj@clip",
        "拿笔记板评估",
        AnimationOptions = {
            Prop = "p_amb_clipboard_01",
            PropBone = 60309,
            PropPlacement = {
                0.150,
                0.060,
                0.1,
                -164.42,
                -51.74,
                12.7,
            },
            SecondProp = 'bkr_prop_fakeid_penclipboard',
            SecondPropBone = 28422,
            SecondPropPlacement = {
                0.070,
                0.070,
                0.01,
                70.0,
                0.0,
                0.0,
            },
            EmoteLoop = true
        }
    },
    ["psixzzk"] = {
        "pazeee@sixzzk@animations",
        "pazeee@sixzzk@clip",
        "酷姿势 Jason",
        AnimationOptions = {
            Prop = "w_pi_pistol50",
            PropBone = 60309,
            PropPlacement = {
                0.10,
                0.060,
                -0.01,
                -118.62,
                -5.07,
                11.274,
            },
            EmoteLoop = true
        }
    },
    ["psixzzm"] = {
        "pazeee@sixzzm@animations",
        "pazeee@sixzzm@clip",
        "持枪酷姿势 Jason",
        AnimationOptions = {
            Prop = "w_pi_pistol50",
            PropBone = 28422,
            PropPlacement = {
                0.0980,
                0.0620,
                -0.01,
                -57.70,
                12.55,
                -20.62,
            },
            EmoteLoop = true
        }
    },
    ["psixzzn"] = {
        "pazeee@sixzzn@animations",
        "pazeee@sixzzn@clip",
        "持枪酷姿势 Lucia",
        AnimationOptions = {
            Prop = "w_pi_pistol50",
            PropBone = 28422,
            PropPlacement = {
                0.0990,
                0.050,
                0.0,
                -57.70,
                12.55,
                -20.62,
            },
            SecondProp = 'ch_prop_ch_security_case_02a',
            SecondPropBone = 60309,
            SecondPropPlacement = {
                -0.130,
                0.160,
                0.28,
                -54.46,
                7.569,
                32.08,
            },
            EmoteLoop = true
        }
    },
    ["psixzzo"] = {
        "pazeee@sixzzo@animations",
        "pazeee@sixzzo@clip",
        "持枪酷姿势 Lucia 低位",
        AnimationOptions = {
            Prop = "w_pi_pistol50",
            PropBone = 28422,
            PropPlacement = {
                0.0990,
                0.050,
                0.0,
                -57.70,
                12.55,
                -20.62,
            },
            SecondProp = 'ch_prop_ch_security_case_02a',
            SecondPropBone = 60309,
            SecondPropPlacement = {
                -0.130,
                0.160,
                0.28,
                -54.46,
                7.569,
                32.08,
            },
            EmoteLoop = true
        }
    },
    ["psixzzt"] = {
        "pazeee@sixzzt@animations",
        "pazeee@sixzzt@clip",
        "持枪疯狂",
        AnimationOptions = {
            Prop = "w_mg_mg",
            PropBone = 57005,
            PropPlacement = {
                0.130,
                0.06,
                0.0,
                -50.0,
                0.0,
                0.0,
            },
            EmoteLoop = true
        }
    },
    ["psixzzu"] = {
        "pazeee@sixzzu@animations",
        "pazeee@sixzzu@clip",
        "棒球 1",
        AnimationOptions = {
            Prop = "p_cs_bbbat_01",
            PropBone = 57005,
            PropPlacement = {
                0.110,
                0.03,
                0.0,
                -68.82,
                7.09,
                -18.74,
            },
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["psixzzv"] = {
        "pazeee@sixzzv@animations",
        "pazeee@sixzzv@clip",
        "棒球 2",
        AnimationOptions = {
            Prop = "p_cs_bbbat_01",
            PropBone = 57005,
            PropPlacement = {
                0.110,
                0.04,
                0.0,
                -63.65,
                4.41,
                -8.97,
            },
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["psixzzw"] = {
        "pazeee@sixzzw@animations",
        "pazeee@sixzzw@clip",
        "棒球 3",
        AnimationOptions = {
            Prop = "p_cs_bbbat_01",
            PropBone = 57005,
            PropPlacement = {
                0.090,
                0.06,
                0.0,
                -70.0,
                0.0,
                0.0,
            },
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["psixzzx"] = {
        "pazeee@sixzzx@animations",
        "pazeee@sixzzx@clip",
        "棒球 4",
        AnimationOptions = {
            Prop = "p_cs_bbbat_01",
            PropBone = 57005,
            PropPlacement = {
                0.090,
                0.06,
                0.0,
                -70.0,
                0.0,
                0.0,
            },
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["psixzzy"] = {
        "pazeee@sixzzy@animations",
        "pazeee@sixzzy@clip",
        "高尔夫球杆",
        AnimationOptions = {
            Prop = "prop_golf_iron_01",
            PropBone = 57005,
            PropPlacement = {
                0.140,
                0.07,
                0.0,
                52.99,
                -112.7,
                -33.82,
            },
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["psixzzz"] = {
        "pazeee@sixzzz@animations",
        "pazeee@sixzzz@clip",
        "提袋子 1",
        AnimationOptions = {
            Prop = "prop_big_bag_01",
            PropBone = 57005,
            PropPlacement = {
                0.260,
                -0.04,
                -0.08,
                -45.55,
                -31.31,
                64.97,
            },
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["psixzzza"] = {
        "pazeee@sixzzza@animations",
        "pazeee@sixzzza@clip",
        "提袋子 2",
        AnimationOptions = {
            Prop = "prop_big_bag_01",
            PropBone = 18905,
            PropPlacement = {
                0.240,
                -0.07,
                -0.07,
                -118.59,
                64.091,
                62.655,
            },
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["psixzzzb"] = {
        "pazeee@sixzzzb@animations",
        "pazeee@sixzzzb@clip",
        "搬啤酒箱",
        AnimationOptions = {
            Prop = "v_ret_ml_beerbar",
            PropBone = 18905,
            PropPlacement = {
                0.1890,
                0.08,
                0.09,
                13.59,
                -133.82,
                -28.66,
            },
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["psixzzzf"] = {
        "pazeee@sixzzzf@animations",
        "pazeee@sixzzzf@clip",
        "工人锤子 1",
        AnimationOptions = {
            Prop = "w_me_hammer",
            PropBone = 57005,
            PropPlacement = {
                0.080,
                -0.01,
                -0.02,
                -76.832,
                41.763,
                -15.18,
            },
            EmoteLoop = true
        }
    },
    ["psixzzzg"] = {
        "pazeee@sixzzzg@animations",
        "pazeee@sixzzzg@clip",
        "工人锤子 2 锤手",
        AnimationOptions = {
            Prop = "w_me_hammer",
            PropBone = 57005,
            PropPlacement = {
                0.080,
                -0.01,
                -0.02,
                -77.241,
                39.48,
                -5.44,
            },
            EmoteLoop = true
        }
    },
    ["psixzzzh"] = {
        "pazeee@sixzzzh@animations",
        "pazeee@sixzzzh@clip",
        "工人双锤 移动",
        AnimationOptions = {
            Prop = "w_me_hammer",
            PropBone = 57005,
            PropPlacement = {
                0.080,
                -0.01,
                -0.02,
                -70.0,
                0.0,
                0.0,
            },
            SecondProp = 'w_me_hammer',
            SecondPropBone = 18905,
            SecondPropPlacement = {
                0.080,
                -0.02,
                0.03,
                -110.0,
                0.0,
                0.0,
            },
			EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["psixzzzi"] = {
        "pazeee@sixzzzi@animations",
        "pazeee@sixzzzi@clip",
        "搞笑锤子舞 1",
        AnimationOptions = {
            Prop = "w_me_hammer",
            PropBone = 57005,
            PropPlacement = {
                0.080,
                -0.01,
                -0.02,
                -76.832,
                41.763,
                -15.18,
            },
            SecondProp = 'w_me_hammer',
            SecondPropBone = 18905,
            SecondPropPlacement = {
                0.080,
                -0.02,
                0.03,
                -110.0,
                0.0,
                0.0,
            },
            EmoteLoop = true
        }
    },
    ["psixzzzj"] = {
        "pazeee@sixzzzj@animations",
        "pazeee@sixzzzj@clip",
        "搞笑锤子舞 2",
        AnimationOptions = {
            Prop = "w_me_hammer",
            PropBone = 57005,
            PropPlacement = {
                0.080,
                -0.01,
                -0.02,
                -76.832,
                41.763,
                -15.18,
            },
            SecondProp = 'w_me_hammer',
            SecondPropBone = 18905,
            SecondPropPlacement = {
                0.080,
                -0.02,
                0.03,
                -110.0,
                0.0,
                0.0,
            },
            EmoteLoop = true
        }
    },
    ["psixzzzk"] = {
        "pazeee@sixzzzk@animations",
        "pazeee@sixzzzk@clip",
        "锤子倒退",
        AnimationOptions = {
            Prop = "w_me_hammer",
            PropBone = 57005,
            PropPlacement = {
                0.080,
                -0.01,
                -0.02,
                -76.832,
                41.763,
                -15.18,
            },
            EmoteLoop = true
        }
    },
    ["psixzzzl"] = {
        "pazeee@sixzzzl@animations",
        "pazeee@sixzzzl@clip",
        "对讲机 1 拿手机",
        AnimationOptions = {
            Prop = "prop_player_phone_02",
            PropBone = 18905,
            PropPlacement = {
                0.130,
                0.05,
                0.01,
                -99.99,
                -3.45,
                -9.70,
            },
            EmoteLoop = true
        }
    },
    ["psixzzzd"] = {
        "pazeee@sixzzzd@animations",
        "pazeee@sixzzzd@clip",
        "醉酒拖拽 Jason",
        "pcarrya1",
        AnimationOptions = {
            Prop = "prop_amb_beer_bottle",
            PropBone = 18905,
            PropPlacement = {
                0.110,
                0.05,
                0.01,
                -120.0,
                0.0,
                0.0,
            },
            EmoteLoop = true,
			Flag = 47
        }
    },
}


RegisterAddonEmotes(CustomDP)