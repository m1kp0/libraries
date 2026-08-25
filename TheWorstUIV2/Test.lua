local UI = loadfile("TheWorstUIV2/TheWorstUIV2.lua")()
local SettingsWindow = loadfile("TheWorstUIV2/Apps/Settings.lua")()

local Taskbar = UI:CreateTaskbar({ Icon = "rbxassetid://76062046097010", Name = "TheWorst", Description = "new ui testing 1.04 upd" })

local Window1 = Taskbar:CreateWindow({ 
    Name = "test1", Icon = "accessibility", Description = "description ez e", Pinned = true
})
    local Tab1 = Window1:CreateTab({ Name = "Tab" })
        local SectionTest = Tab1:CreateSection({ Name = "testttt11 left", Side = "Left", Group = "Ez" })
            SectionTest:CreateDividier()
            SectionTest:CreateLabel({ Name = "10 buttons here" })

            for i = 1, 10 do
                local ButtonText = `Test button {i}`
                SectionTest:CreateButton({ 
                    Name = ButtonText,
                    Callback = function() 
                        print(ButtonText) 
                    end
                })
            end

        local Section2Test2 = Tab1:CreateSection({ Name = "Right sect", Side = "Right", Group = "Ez" })
            Section2Test2:CreateDividier()
            Section2Test2:CreateButton({ 
                Name = "Button skid",
                Callback = function() 
                    print("ezzzz skid") 
                end
            })

            Section2Test2:CreateToggle({
                Name = "Toggle skid",
                Callback = function(bool)
                    print("Ez Skid:", bool)
                end
            }) 

            local ToggleBind = Section2Test2:CreateToggle({
                Name = "Bind toggle",
                Callback = function(bool)
                    print("Ez Skid Bind:", bool)
                end
            })
            ToggleBind:CreateBind()

            local ToggleColorpicker = Section2Test2:CreateToggle({
                Name = "Color toggle",
                Callback = function(bool)
                    print("Ez Color toggle:", bool)
                end
            })
            ToggleColorpicker:CreateColorpicker({Callback = function(Color, Transp) print("Color toggle:", Color, Transp) end})

            local ToggleColorpicker2 = Section2Test2:CreateToggle({
                Name = "Color 2 toggle",
                Callback = function(bool)
                    print("Ez Color2 toggle:", bool)
                end
            })
            ToggleColorpicker2:CreateColorpicker({Callback = function(Color, Transp) print("Color toggle:", Color, Transp) end})
            ToggleColorpicker2:CreateColorpicker({Callback = function(Color, Transp) print("Color 2toggle:", Color, Transp)end})

            local ToggleSettings = Section2Test2:CreateToggle({
                Name = "Toggle with settings",
                Callback = function(bool)
                    print("Ez Color toggle:", bool)
                end
            })
            ToggleSettings:CreateSlider({Callback = function(Value) print("Settings toggle slider:", Value) end})
            ToggleSettings:CreateDropdown({
                Options = {"ez", "2", "ESESESEESES", "niggaa"},
                Callback = function(Value) print("Settings toggle dropdownn:", Value) end
            })
            ToggleSettings:CreateToggle({
                Callback = function(Value) print("Settings toggle toggletoglelglg:", Value) end
            })
            ToggleSettings:CreateTextbox({
                Callback = function(Text) print(Text) end
            })

            local ButtonBind = Section2Test2:CreateButton({ 
                Name = "Button binndd",
                Callback = function() 
                    print("ezzzz skid") 
                end
            })

            ButtonBind:CreateBind()

            Section2Test2:CreateBind({
                Name = "Bind stop skidding",
                Value = Enum.KeyCode.F,
                Hold = false,
                Callback = function()
                    print("Bind pressed")
                end
            }) 

            Section2Test2:CreateBind({
                Name = "Holding bind",
                Value = Enum.KeyCode.G,
                Hold = true,
                Callback = function(bool)
                    print("Holding bind: ", bool)
                end
            }) 

            Section2Test2:CreateSlider({
                Name = "Slider",
                Callback = function(value)
                    print(value)
                end
            }) 

            Section2Test2:CreateDropdown({
                Name = "Dropdownnn",
                Options = {"1", "second", "3", "ezezzzz"},
                Callback = function(value)
                    print(value)
                end
            }) 

            Section2Test2:CreateDropdown({
                Name = "Multi dropdown",
                Options = {
                    "Plot1 ((Green))", 
                    "second", "3", 
                    "ezezzzz ((sex))", 
                    "m", "e", 
                    "treqw", "qwerx", "sex", 
                    "sedativ", 
                    "komik", "5", 
                    "balls", "lick"
                },
                Multi = true,
                Default = {"1", "second"},
                Callback = function(value)
                    print(table.concat(value))
                end
            }) 

            Section2Test2:CreateColorpicker({
                Name = "color picker ez",
                Callback = function(color, transparency)
                    print(color, transparency)
                end
            })

            local Section2Test23 = Tab1:CreateSection({ Name = "Right sectfds", Side = "Right", Group = "e" })
                local ButtonBind = Section2Test23:CreateButton({ 
                    Name = "Button",
                    Callback = function() 
                        print("ezzzz skid") 
                    end
                })

local AtakaWindow = Taskbar:CreateWindow({ Name = "Ataka", Icon = "sword", Pinned = true })
    local Tab2 = AtakaWindow:CreateTab({ Name = "Tab2" })
        local SectionTestAtakaL = Tab2:CreateSection({ Name = "and", Side = "Left" })
        local SectionTestAtakaR = Tab2:CreateSection({ Name = "here", Side = "Right" })
            local Left = true
            for i = 1, 400 do
                local ButtonText = `Test button {i}`
                if Left then
                    SectionTestAtakaL:CreateButton({ 
                        Name = ButtonText,
                        Callback = function() 
                            print(ButtonText) 
                        end
                    })
                else
                    SectionTestAtakaR:CreateButton({ 
                        Name = ButtonText,
                        Callback = function() 
                            print(ButtonText) 
                        end
                    })
                end
                Left = not Left
            end

local DefenseWindow = Taskbar:CreateWindow({ Name = "Defense", Icon = "shield", Pinned = true })
    local Tab3 = DefenseWindow:CreateTab({ Name = "Tab3" })
        local TestNotificationsSection = Tab3:CreateSection({ Name = "Notifications test", Side = "Left" })
            TestNotificationsSection:CreateButton({ 
                Name = "test notification",
                Callback = function() 
                    Taskbar:CreateNotification({Name = "Test notify", Description = "1.04 notification"})
                end
            })

        local TestNotificationsSection3 = Tab3:CreateSection({ Name = "Notifications test 2 sect", Side = "Right" })
            TestNotificationsSection3:CreateButton({ 
                Name = "test notification",
                Callback = function() 
                    Taskbar:CreateNotification({Name = "Test notify", Description = "1.04 notification"})
                end
            })

    local Tab4 = DefenseWindow:CreateTab({ Name = "Tab4" })
        local TestNotificationsSection22 = Tab4:CreateSection({ Name = "Notifications 222", Side = "Left" })
            TestNotificationsSection22:CreateButton({ 
                Name = "testing",
                Callback = function() 
                    Taskbar:CreateNotification({Name = "Test notify", Description = "1.04 notification"})
                end
            })

local OtherWindow = Taskbar:CreateWindow({ Name = "Other", Icon = "banana", Pinned = false })
local UnpinnedWindow = Taskbar:CreateWindow({ Name = "Unpinned yea", Icon = "pin", Pinned = false })


SettingsWindow:CreateWindow({ Folder = "TheWorstSaves", GameName = "FTAP" })
SettingsWindow:LoadAutoloadConfigs()
Taskbar:Init()
