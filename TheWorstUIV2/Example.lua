local TheWorstUIV2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/m1kp0/libraries/refs/heads/main/TheWorstUIV2/LibraryV2.lua"))()
local SettingsWindow = loadstring(game:HttpGet("https://raw.githubusercontent.com/m1kp0/libraries/refs/heads/main/TheWorstUIV2/SettingsWindow.lua"))()

local Taskbar = TheWorstUIV2:CreateTaskbar({
    Icon = "rbxassetid://110286022859955",
    Name = "My Hub",
    Description = "v1.0.0 Example",
    LoadedSound = "rbxassetid://6647897822"
})

local MainWindow = Taskbar:CreateWindow({
    Name = "Main",
    Icon = "settings",
    Description = "Main configuration window",
    Pinned = true
})

local GeneralTab = MainWindow:CreateTab({
    Name = "General",
    Icon = "sliders"
})

local BasicSection = GeneralTab:CreateSection({
    Name = "Basic Elements",
    Side = "Left",
    Group = "MainGroup"
})

BasicSection:CreateDividier()

BasicSection:CreateLabel({
    Name = "Interactive Elements"
})

local Button = BasicSection:CreateButton({
    Name = "Click Me",
    DoubleTap = false,
    Callback = function()
        print("Button clicked!")
        Taskbar:CreateNotification({
            Name = "Button",
            Description = "Button was clicked!",
            Duration = 2
        })
    end
})

local ButtonWithBind = BasicSection:CreateButton({
    Name = "Button with Bind (R)",
    Callback = function()
        print("Button with bind pressed!")
    end
})

ButtonWithBind:CreateBind({
    Default = "R",
    Flag = "ButtonBind"
})

local Toggle = BasicSection:CreateToggle({
    Name = "Toggle",
    Default = false,
    Flag = "MainToggle",
    Callback = function(state)
        print("Toggle:", state)
    end
})

local ToggleWithBind = BasicSection:CreateToggle({
    Name = "Toggle with Bind (E)",
    Flag = "ToggleWithBind",
    Callback = function(state)
        print("Toggle with bind:", state)
    end
})

ToggleWithBind:CreateBind({
    Default = "E",
    Flag = "ToggleBind"
})

local ToggleWithColor = BasicSection:CreateToggle({
    Name = "Toggle with Colorpicker",
    Callback = function(state)
        print("Toggle with color:", state)
    end
})

ToggleWithColor:CreateColorpicker({
    DefaultColor = Color3.fromRGB(255, 0, 0),
    DefaultTransparency = 0.5,
    Flag = "Colorpicker1",
    Callback = function(color, transparency)
        print("Color picked:", color, transparency)
    end
})

local ToggleWithSettings = BasicSection:CreateToggle({
    Name = "Toggle with Settings",
    Callback = function(state)
        print("Toggle with settings:", state)
    end
})

ToggleWithSettings:CreateToggle({
    Name = "Nested Toggle",
    Default = false,
    Flag = "NestedToggle",
    Callback = function(state)
        print("Nested toggle:", state)
    end
})

ToggleWithSettings:CreateSlider({
    Name = "Nested Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Flag = "NestedSlider",
    Callback = function(value)
        print("Nested slider:", value)
    end
})

ToggleWithSettings:CreateDropdown({
    Name = "Nested Dropdown",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Flag = "NestedDropdown",
    Callback = function(selected)
        print("Nested dropdown:", selected)
    end
})

ToggleWithSettings:CreateTextbox({
    Name = "Nested Textbox",
    Default = "Hello",
    PlaceholderText = "Type something...",
    Flag = "NestedTextbox",
    Callback = function(text)
        print("Nested textbox:", text)
    end
})

local Bind = BasicSection:CreateBind({
    Name = "Press F to Pay Respects",
    Default = "F",
    Hold = false,
    Flag = "BindF",
    Callback = function()
        print("F pressed!")
        Taskbar:CreateNotification({
            Name = "Bind",
            Description = "F key pressed!",
            Duration = 2
        })
    end
})

local HoldBind = BasicSection:CreateBind({
    Name = "Hold G (Hold)",
    Default = "G",
    Hold = true,
    Flag = "HoldBind",
    Callback = function(holding)
        print("Hold bind:", holding)
    end
})

local Slider = BasicSection:CreateSlider({
    Name = "Volume",
    Min = 0,
    Max = 100,
    Increment = 1,
    Default = 50,
    ValueName = "%",
    Flag = "VolumeSlider",
    Callback = function(value)
        print("Volume:", value)
    end,
    InputEndedCallback = function(value)
        print("Volume final:", value)
    end
})

local Textbox = BasicSection:CreateTextbox({
    Name = "Enter Username",
    Default = "Player",
    PlaceholderText = "Type username...",
    TextDisappear = true,
    Flag = "UsernameTextbox",
    Callback = function(text)
        print("Username:", text)
    end
})

local AdvancedSection = GeneralTab:CreateSection({
    Name = "Advanced Elements",
    Side = "Right",
    Group = "MainGroup"
})

AdvancedSection:CreateDividier()

local Dropdown = AdvancedSection:CreateDropdown({
    Name = "Select Option",
    Options = {"Option 1", "Option 2", "Option 3", "Option 4"},
    Default = "Option 1",
    Flag = "Dropdown1",
    Callback = function(selected)
        print("Dropdown selected:", selected)
    end
})

local MultiDropdown = AdvancedSection:CreateDropdown({
    Name = "Multi Select",
    Options = {
        "Red ((Color))",
        "Green ((Color))",
        "Blue ((Color))",
        "Yellow ((Color))",
        "Purple ((Color))"
    },
    Multi = true,
    Default = {"Red", "Blue"},
    Flag = "MultiDropdown",
    Callback = function(selected)
        print("Multi selected:", table.concat(selected, ", "))
    end
})

local Colorpicker = AdvancedSection:CreateColorpicker({
    Name = "Pick a Color",
    DefaultColor = Color3.fromRGB(255, 255, 255),
    DefaultTransparency = 0.5,
    Flag = "MainColorpicker",
    Callback = function(color, transparency)
        print("Color:", color, "Transparency:", transparency)
    end
})

local NotifyWindow = Taskbar:CreateWindow({
    Name = "Notifications",
    Icon = "bell",
    Description = "Test notifications",
    Pinned = true
})

local NotifyTab = NotifyWindow:CreateTab({
    Name = "Tests",
    Icon = "test-tube"
})

local NotifySection = NotifyTab:CreateSection({
    Name = "Notification Tests",
    Side = "Left"
})

NotifySection:CreateButton({
    Name = "Simple Notification",
    Callback = function()
        Taskbar:CreateNotification({
            Name = "Simple",
            Description = "This is a simple notification!",
            Duration = 3
        })
    end
})

NotifySection:CreateButton({
    Name = "Notification with Sound",
    Callback = function()
        Taskbar:CreateNotification({
            Name = "With Sound",
            Description = "This notification has sound!",
            Duration = 3,
            Sound = "rbxassetid://9120371540",
            Volume = 0.5
        })
    end
})

NotifySection:CreateButton({
    Name = "Grouped Notifications",
    Callback = function()
        for i = 1, 5 do
            task.wait(0.3)
            Taskbar:CreateNotification({
                Name = string.format("Group %d", i),
                Description = string.format("Notification number %d", i),
                Duration = 3,
                Group = "GroupTest"
            })
        end
    end
})

NotifySection:CreateButton({
    Name = "Long Notification",
    Callback = function()
        Taskbar:CreateNotification({
            Name = "Very Long Notification Title That Might Wrap",
            Description = "This is a very long description that will definitely wrap to multiple lines to test the notification system's layout and text wrapping functionality.",
            Duration = 5
        })
    end
})

local PerfWindow = Taskbar:CreateWindow({
    Name = "Performance",
    Icon = "gauge",
    Description = "Stress test",
    Pinned = false
})

local PerfTab = PerfWindow:CreateTab({
    Name = "Test",
    Icon = "test-tube"
})

local PerfLeft = PerfTab:CreateSection({
    Name = "Left Side",
    Side = "Left"
})

local PerfRight = PerfTab:CreateSection({
    Name = "Right Side",
    Side = "Right"
})

local Left = true
for i = 1, 100 do
    local ButtonText = string.format("Button %d", i)
    if Left then
        PerfLeft:CreateButton({
            Name = ButtonText,
            Callback = function()
                print(ButtonText)
            end
        })
    else
        PerfRight:CreateButton({
            Name = ButtonText,
            Callback = function()
                print(ButtonText)
            end
        })
    end
    Left = not Left
end

local UnpinnedWindow = Taskbar:CreateWindow({
    Name = "Unpinned",
    Icon = "pin-off",
    Description = "This window is not pinned",
    Pinned = false
})

local UnpinnedTab = UnpinnedWindow:CreateTab({
    Name = "Tab"
})

local UnpinnedSection = UnpinnedTab:CreateSection({
    Name = "Section",
    Side = "Left"
})

UnpinnedSection:CreateLabel({
    Name = "This window is unpinned"
})

UnpinnedSection:CreateButton({
    Name = "Toggle Window",
    Callback = function()
        UnpinnedWindow:Toggle(false)
        task.wait(0.5)
        UnpinnedWindow:Toggle(true)
    end
})

SettingsWindow:CreateWindow({ Folder = "MyHub", GameName = "MyGame" })
SettingsWindow:LoadAutoloadConfigs()
Taskbar:Init()
