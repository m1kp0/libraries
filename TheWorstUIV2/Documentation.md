# Load Library
```lua
local TheWorstUIV2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/m1kp0/libraries/refs/heads/main/TheWorstUIV2.lua"))()
```

# Create Taskbar
```lua
UI:CreateTaskbar()
```
##### Example:
```lua
local TheWorstUIV2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/m1kp0/libraries/refs/heads/main/TheWorstUIV2.lua"))()
local Taskbar = TheWorstUIV2:CreateTaskbar({
    Icon = "home",
    Name = "My Hub",
    Description = "v0.0.1 Example",
    LoadedSound = "rbxassetid://6647897822"
})
```

##### Taskbar Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Icon? | string | "" |
| Name? | string | "Taskbar" |
| Description? | string | "Description" |
| LoadedSound? | string | "rbxassetid://6647897822" |

##### Taskbar Functions
| Function | Args | Type |
|----------|------|------|
| ToggleWindow | WindowName, Open | string, bool |
| ToggleStart | Open | bool |
| ToggleNotificationsHub | Open | bool |
| ToggleAutoClose | Enabled | bool |
| ConfigAutoClose | Config | table |
| CreateNotification | NotificationConfig | table |
| ConfigNotifications | Config | table |
| SetWindowsColor | Color, Transparency, ColorIndex | Color3, number, string |
| SetFont | Config | table |
| SetNoise | Config | table |
| SetBackground | Config | table |
| SetAutoUnlockMouse | Enabled | bool |
| SetVingette | Config | table |
| Init | - | - |

### Unload
```lua
UI:Unload()
```

### ToggleWindow
```lua
Taskbar:ToggleWindow("Settings", true)
```

### ToggleStart
```lua
Taskbar:ToggleStart(true)
```

### ToggleNotificationsHub
```lua
Taskbar:ToggleNotificationsHub(true)
```

### ToggleAutoClose
```lua
Taskbar:ToggleAutoClose(true)
```

### ConfigAutoClose
```lua
Taskbar:ConfigAutoClose({
    Speed = 0.5,
    Delay = 0.3
})
```

##### ConfigAutoClose Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Speed? | number | 0.3 |
| Delay? | number | 0.5 |

### CreateNotification
```lua
Taskbar:CreateNotification({
    Name = "Notification",
    Description = "Description",
    Duration = 3,
    Sound = "rbxassetid://9120371540",
    Volume = 0.5,
    Group = "Main"
})
```

##### Notification Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Notification" |
| Description? | string | "Description" |
| Duration? | number | 3 |
| Sound? | string | "" |
| Volume? | number | 1 |
| Group? | string | "DefaultNotification" |

### ConfigNotifications
```lua
Taskbar:ConfigNotifications({
    Enabled = true,
    Sound = "rbxassetid://9120371540",
    Volume = 0.5
})
```

##### ConfigNotifications Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Enabled? | bool | false |
| Sound? | string | "" |
| Volume? | number | 0 |

### SetWindowsColor
```lua
Taskbar:SetWindowsColor(Color3.fromRGB(30, 30, 30), 0.3, "Main")
```

##### ColorIndex Options
| Value | Description |
|-------|-------------|
| "Main" | Windows, taskbar, main frames |
| "Second" | Dividers, icons, secondary elements |
| "Third" | Input fields, dropdowns, textboxes |
| "Sections" | Section backgrounds |

### SetFont
```lua
Taskbar:SetFont({
    Color = Color3.fromRGB(240, 240, 240),
    Transparency = 0,
    Font = "Code",
    Type = "Main"
})
```

##### SetFont Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Color? | Color3 | Theme dependent |
| Transparency? | number | Theme dependent |
| Font? | string | "Code" |
| Type | string | - |

### SetNoise
```lua
Taskbar:SetNoise({
    Transparency = 0.8,
    Size = 2
})
```

##### SetNoise Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Transparency? | number | 0.8 |
| Size? | number | 1 |

### SetBackground
```lua
Taskbar:SetBackground({
    Image = "rbxassetid://1234567890",
    Transparency = 0.2
})
```

##### SetBackground Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Image? | string | "" |
| Transparency? | number | 0 |

### SetAutoUnlockMouse
```lua
Taskbar:SetAutoUnlockMouse(true)
```

### SetVingette
```lua
Taskbar:SetVingette({
    Transparency = 0.2
})
```

##### SetVingette Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Transparency? | number | 0 |

### Init
```lua
Taskbar:Init()
```

# Window
### Create Window
```lua
Taskbar:CreateWindow()
```

##### Example:
```lua
local Window = Taskbar:CreateWindow({
    Pinned = true,
    Icon = "home",
    Name = "Home",
    Description = "My Home Window"
})
```

##### Window Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Pinned? | bool | false |
| Icon? | string | "" |
| Name? | string | "Window" |
| Description? | string | "Description" |

##### Window Functions
| Function | Args | Type |
|----------|------|------|
| Toggle | Open | bool |
| MinimizeToggle | Open | bool |
| CreateTab | TabConfig | table |

### Toggle
```lua
Window:Toggle(true)
```

### MinimizeToggle
```lua
Window:MinimizeToggle(true)
```

### Create Tab
```lua
Window:CreateTab()
```

##### Example:
```lua
local Tab = Window:CreateTab({
    Name = "General",
    Icon = "settings"
})
```

##### Tab Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Tab" |
| Icon? | string | "" |

# Tab
### Create Section
```lua
Tab:CreateSection()
```

##### Example:
```lua
local Section = Tab:CreateSection({
    Name = "Main",
    Side = "Left",
    Group = "MainGroup"
})
```

##### Section Configuration
| Property | Value Type | Default | Possible Values |
|----------|------------|---------|-----------------|
| Name? | string | "Section" | Any |
| Side? | string | "Left" | "Left", "Right" |
| Group? | string | Name .. "_Group" | Any |

# Section
### Create Label
```lua
Section:CreateLabel()
```

##### Example:
local Label = Section:CreateLabel({
    Name = "This is a label"
})

##### Label Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Label" |

##### Label Functions
| Function | Args | Type |
|----------|------|------|
| Set | NewName | string |

### Create Button
```lua
Section:CreateButton()
```

##### Example:
```lua
local Button = Section:CreateButton({
    Name = "Click Me",
    DoubleTap = false,
    Callback = function()
        print("Button clicked!")
    end
})
```

##### Button Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Button" |
| DoubleTap? | bool | false |
| Callback? | function | function() end |

##### Button Functions
| Function | Args | Type |
|----------|------|------|
| Press | - | - |
| CreateBind | BindConfig | table |

### Create Toggle
```lua
Section:CreateToggle()
```

##### Example:
```lua
local Toggle = Section:CreateToggle({
    Name = "My Toggle",
    Default = false,
    Flag = "MyToggleFlag",
    Callback = function(state)
        print(state)
    end
})
```

##### Toggle Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Toggle" |
| Default? | bool | false |
| Flag? | string | "Toggle..." |
| Callback? | function | function() end |

##### Toggle Functions
| Function | Args | Type |
|----------|------|------|
| Set | Value | bool |
| CreateBind | BindConfig | table |
| CreateColorpicker | ColorpickerConfig | table |
| CreateSlider | SliderConfig | table |
| CreateDropdown | DropdownConfig | table |
| CreateToggle | ToggleConfig | table |
| CreateTextbox | TextboxConfig | table |

### Create Bind
```lua
Section:CreateBind()
```

##### Example:
```lua
local Bind = Section:CreateBind({
    Name = "My Bind",
    Default = "Q",
    Hold = false,
    Flag = "MyBindFlag",
    Callback = function(holding)
        if holding then
            print("Holding!")
        else
            print("Not Holding!")
        end
    end
})
```

##### Bind Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Bind" |
| Default? | string or Enum | "None" |
| Hold? | bool | false |
| Flag? | string | "Bind..." |
| Callback? | function | function() end |

##### Bind Functions
| Function | Args | Type |
|----------|------|------|
| Set | Key | string or Enum |

### Create Slider
```lua
Section:CreateSlider()
```

##### Example:
```lua
local Slider = Section:CreateSlider({
    Name = "Volume",
    Min = 0,
    Max = 100,
    Increment = 1,
    Default = 50,
    ValueName = "%",
    Flag = "MySliderFlag",
    Callback = function(value)
        print(value)
    end,
    InputEndedCallback = function(value)
        print("Input ended at:", value)
    end
})
```

##### Slider Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Slider" |
| Min? | number | 0 |
| Max? | number | 100 |
| Increment? | number | 1 |
| Default? | number | 50 |
| ValueName? | string | "" |
| Flag? | string | "Slider..." |
| Callback? | function | function() end |
| InputEndedCallback? | function | function() end |

##### Slider Functions
| Function | Args | Type |
|----------|------|------|
| Set | Value | number |

### Create Textbox
```lua
Section:CreateTextbox()
```

##### Example:
```lua
local Textbox = Section:CreateTextbox({
    Name = "Enter text",
    Default = "Hello",
    PlaceholderText = "Input",
    TextDisappear = true,
    Flag = "MyTextboxFlag",
    Callback = function(text)
        print(text)
    end
})
```

##### Textbox Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Textbox" |
| Default? | string | "" |
| PlaceholderText? | string | "Input" |
| TextDisappear? | bool | false |
| Flag? | string | "Textbox..." |
| Callback? | function | function() end |

##### Textbox Functions
| Function | Args | Type |
|----------|------|------|
| Set | Text | string |

### Create Dropdown
```lua
Section:CreateDropdown()
```

##### Example:
```lua
local Dropdown = Section:CreateDropdown({
    Name = "Select Option",
    Options = {"Option 1 ((Description))", "Option 2", "Option 3"},
    Multi = false,
    Default = "Option 1",
    Flag = "MyDropdownFlag",
    Callback = function(selected)
        print(selected)
    end
})
```

##### Dropdown Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Dropdown" |
| Options? | table | {} |
| Multi? | bool | false |
| Default? | string or table | "None" |
| Flag? | string | "Dropdown..." |
| Callback? | function | function() end |

##### Dropdown Functions
| Function | Args | Type |
|----------|------|------|
| Set | Value | string or table |
| Refresh | NewOptions | table |

### Create Colorpicker
```lua
Section:CreateColorpicker()
```

##### Example:
```lua
local Colorpicker = Section:CreateColorpicker({
    Name = "Pick a Color",
    DefaultColor = Color3.fromRGB(255, 0, 0),
    DefaultTransparency = 0.5,
    Flag = "MyColorpickerFlag",
    Callback = function(color, transparency)
        print(color, transparency)
    end
})
```

##### Colorpicker Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Colorpicker" |
| DefaultColor? | Color3 | Color3.fromRGB(255, 255, 255) |
| DefaultTransparency? | number | 0.5 |
| Flag? | string | "Colorpicker..." |
| Callback? | function | function() end |

##### Colorpicker Functions
| Function | Args | Type |
|----------|------|------|
| Set | Color, Transparency | Color3, number |


# Notification Documentation

### Create Notification
```lua
Taskbar:CreateNotification()
```

##### Example:
```lua
Taskbar:CreateNotification({
    Name = "Success",
    Description = "Action completed successfully!",
    Duration = 3,
    Sound = "rbxassetid://9120371540",
    Volume = 0.5,
    Group = "Main"
})
```

##### Notification Configuration
| Property | Value Type | Default | Description |
|----------|------------|---------|-------------|
| Name? | string | "Notification" | Title of the notification |
| Description? | string | "Description" | Content text of the notification |
| Duration? | number | 3 | How long to show (in seconds) |
| Sound? | string | "" | Sound ID to play |
| Volume? | number | 1 | Sound volume (0 to 1) |
| Group? | string | "DefaultNotification" | Group for stacking notifications |

### Config Notifications
```lua
Taskbar:ConfigNotifications()
```

##### Example:
```lua
Taskbar:ConfigNotifications({
    Enabled = true,
    Sound = "rbxassetid://9120371540",
    Volume = 0.5
})
```

##### ConfigNotifications Configuration
| Property | Value Type | Default | Description |
|----------|------------|---------|-------------|
| Enabled? | bool | false | Enable/disable all notifications |
| Sound? | string | "" | Default sound for all notifications |
| Volume? | number | 0 | Default volume for all notifications |

##### Arguments
| Arg | Type | Description |
|-----|------|-------------|
| Open | bool | true to open, false to close |

# Flags System
```lua
All elements with Flag property can be accessed through TheWorstUIV2.Flags[FlagName]
```

##### Example:
```lua
Section:CreateToggle({
    Name = "My Toggle",
    Flag = "MyToggle"
})

TheWorstUIV2.Flags["MyToggle"]:Set(true)
print(TheWorstUIV2.Flags["MyToggle"].Value)
```
