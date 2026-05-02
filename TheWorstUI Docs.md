# Load library
```lua
local TheWorstUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/m1kp0/libraries/refs/heads/main/TheWorstUI.lua"))()
```

# Create a window
```lua
local Window = TheWorstUI:CreateWindow({
  Name = "Window",
  SizeX = 200,
  SizeY = 0, -- 0 if you want to automate your Y size
  CanResize = "X", -- users can size your ui only by x
})

--[[
Property  | Possible value | Type
-----------------------------------
Name      |      any       | string
SizeX     |      any       | number
SizeY     |      any       | number
CanResize |   X, Y, BOTH   | string
]]
```

# Window functions
### Scroll to bottom
```lua
Window:ScrollToBottom()
```

### Create button
```lua
local Button = Window:CreateButton({
  Name = "Button",
  Callback = function() 
    print("Button pressed")
  end
})
```

### Create toggle
```lua
local Toggle = Window:CreateToggle({
  Name = "Toggle",
  Default = true,
  Callback = function(bool)
    print("Toggle pressed:", bool)
  end
})
```

##### Set toggle
```lua
Toggle:Set(false or true)
```

### Create bind
```lua
local Bind = Window:CreateBind({
  Name = "Bind",
  Default = "F", -- also you can use Enum.KeyCode
  Hold = true,
  Callback = function(Holding)
    print("Bind pressed:", Holding)
  end
})
```

##### Set bind
```lua
Bind:Set("E")
```

##### Remove bind
```lua
Bind:Set()
```

### Create label
```lua
Window:CreateLabel("Hello, World!")
```
