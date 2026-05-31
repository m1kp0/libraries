# Load Library
```lua
local TheWorstUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/m1kp0/libraries/refs/heads/main/TheWorstUI.lua"))()
```

# Important
#### 1. All properties are optional
#### 2. Example script
```lua
local TheWorstUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/m1kp0/libraries/refs/heads/main/TheWorstUI.lua"))()
local Window = TheWorstUI:CreateWindow({Name = "My Hub", SizeX = 200, CanResize = "BOTH"})

Window:CreateButton({
    Name = "Button", 
    Callback = function() 
        print("Pressed") 
    end
})

Window:CreateToggle({
    Name = "Toggle", 
    Default = false, 
    Callback = function(bool) 
        print(bool) 
    end
})

Window:CreateBind({
    Name = "Bind", 
    Default = "Q", 
    Hold = false, 
    Toggle = false, 
    Callback = function() 
        print("Pressed") 
    end
})

Window:CreateSlider({
    Name = "Slider", 
    Min = 0, 
    Max = 100, 
    Default = 50, 
    Callback = function(value) 
        print(value) 
    end
})

Window:CreateDropdown({
    Name = "Dropdown", 
    Options = {"Option 1", "Option 2"}, 
    Default = "Option 1", 
    Callback = function(option) 
        print(option) 
    end
})

Window:CreateColorpicker({
    Name = "Colorpicker", 
    Default = Color3.fromRGB(255, 255, 255), 
    DefaultTransparency = 0, 
    Callback = function(color, transparency) 
        print(color, transparency) 
    end
})

Window:CreateLabel("Label Text")
```

# Window
### Create Window
```lua
UI:CreateWindow()
```

Example:
```lua
local Window = UI:CreateWindow({
    Name = "My Hub",
    SizeX = 200,
    SizeY = 0,
    CanResize = "BOTH"
})
```

##### Window Configuration
| Property | Value Type | Default | Possible Values |
|----------|------------|---------|-----------------|
| Name? | string | "Window" | Any |
| SizeX? | number | 150 | Any number |
| SizeY? | number | 0 | Any number |
| CanResize? | string | "BOTH" | "", "X", "Y", "BOTH" |

##### Window Functions
| Function | Description |
|----------|-------------|
| ScrollToBottom | Scrolls the window to the bottom |

### Create Button
```lua
Window:CreateButton()
```

Example:
```lua
Window:CreateButton({
    Name = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})
```

##### Button Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Button" |
| Callback? | function | function() end |

### Create Toggle
```lua
Window:CreateToggle()
```
Example:
```lua
Window:CreateToggle({
    Name = "My Toggle",
    Default = true,
    Callback = function(state)
        print("Toggle is now:", state)
    end
})
```
##### Toggle Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Toggle" |
| Default? | bool | false |
| Callback? | function | function() end |

##### Toggle Functions
| Function | Args | Type |
|----------|------|------|
| Set | State | bool |

### Create Bind
```lua
Window:CreateBind()
```

Example:
```lua
Window:CreateBind({
    Name = "My Bind",
    Default = "Q",
    Hold = false,
    Toggle = false,
    Callback = function()
        print("Bind pressed")
    end
})
```

##### Bind Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Bind" |
| Default? | string or Enum | "" |
| Hold? | bool | false |
| Toggle? | bool | false |
| Callback? | function | function() end |

Note: If Toggle is true, Hold is automatically disabled.

##### Bind Functions
| Function | Args | Type |
|----------|------|------|
| Set | Key | string or Enum |

### Create Slider
```lua
Window:CreateSlider()
```

Example:
```lua
Window:CreateSlider({
    Name = "Volume",
    Min = 0,
    Max = 100,
    Increment = 1,
    Default = 50,
    Callback = function(value)
        print("Volume:", value)
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
| Default? | number | Min value |
| Callback? | function | function() end |

### Create Dropdown
```lua
Window:CreateDropdown()
```

Example:
```lua
Window:CreateDropdown({
    Name = "Options",
    Options = {"Option A", "Option B", "Option C"},
    Default = "Option A",
    Callback = function(selected)
        print("Selected:", selected)
    end
})
```

##### Dropdown Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Dropdown" |
| Options? | table | {} |
| Default? | string | "" |
| Callback? | function | function() end |

##### Dropdown Functions
| Function | Args | Type |
|----------|------|------|
| Set | Value | string |

### Create Colorpicker
```lua
Window:CreateColorpicker()
```

Example:
```lua
Window:CreateColorpicker({
    Name = "Color",
    Default = Color3.fromRGB(255, 0, 0),
    DefaultTransparency = 0,
    Callback = function(color, transparency)
        print(color, transparency)
    end
})
```

##### Colorpicker Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Colorpicker" |
| Default? | Color3 | Color3.fromRGB(255, 255, 255) |
| DefaultTransparency? | number | 0 |
| Callback? | function | function() end |

##### Colorpicker Functions
| Function | Args | Type |
|----------|------|------|
| Set | Color, Transparency | Color3, number |

### Create Label
```lua
Window:CreateLabel()
```

Example:
```lua
Window:CreateLabel("This is a label")
```

##### Label Configuration
| Arg | Value Type | Default |
|-----|------------|---------|
| LabelText? | string | nil |

# Global Functions
### Unload
```lua
UI:Unload()
```
