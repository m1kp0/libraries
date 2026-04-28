for _, ui in game.CoreGui:GetChildren() do
  if ui.Name == "TheWorstUI" then 
     ui:Destroy()
     task.wait()
  end
end

local UI = { 
  Connections = {},
  Elements = {}
}
UI.__index = UI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game.CoreGui

local function AddConnection(Connection, Function, Name)
  local Conn = Connection:Connect(Function)
  UI.Connections[Name ~= nil and Name or #UI.Connections+1] = Conn
  return Conn
end

local function RemoveConnection(Connection)
  if UI.Connections[Connection] ~= nil then
     UI.Connections[Connection]:Disconnect()
     UI.Connections[Connection] = nil
  end
end

local function CreateElement(Name, Props)
  local Element = Instance.new(Name)
  for i, v in Props or {} do Element[i] = v end
  return Element
end

local function SetChildren(Parent, Children)
  for i, v in Children do v.Parent = Parent end
  return Parent
end

local function PlayTween(...)
  local Parent, Info, Args = table.unpack({...})
  Info = TweenInfo.new(typeof(Info) == "table" and table.unpack(Info) or Info)
  
  local Tween = TweenService:Create(Parent, Info, Args); Tween:Play()
  return Tween
end

function UI:CreateWindow(Name: string?, Size: UDim2?): table
  Name = Name or "Window"
  Size = Size or UDim2.new(0, 150, 0, 200)
  local Tab = {}

  local ScreenGui = CreateElement("ScreenGui", {
     Parent = CoreGui,
     Name = "TheWorstUI"
  })

  local MainWindow = SetChildren(CreateElement("Frame", {
     Parent = ScreenGui,
     Name = "MainWindow",
     Transparency = 1,
     Size = UDim2.new(0, 150, 0, 200),
  }), {
     CreateElement("UICorner", {CornerRadius = UDim.new(1, 0)}),
     CreateElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
     })
  })

  local TopBar = SetChildren(CreateElement("Frame", {
     Parent = MainWindow,
     Name = "TopBar",
     Size = UDim2.new(1, 0, 0, 40),
     Transparency = 0.5,
     BackgroundColor3 = Color3.fromRGB(20, 20, 20),
     Active = true,
  }), {
     CreateElement("UICorner", {CornerRadius = UDim.new(0, 20)}),
     CreateElement("UIStroke", {
        Color = Color3.fromRGB(0, 0, 0),
        Thickness = 2,
        Transparency = 0.5
     }),
     CreateElement("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = Name,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextSize = 18,
        Font = Enum.Font.GothamBlack,
        BackgroundTransparency = 1
     }),
     CreateElement("ImageLabel", {
        Name = "Button",
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -35, 0, 8),
        BackgroundTransparency = 1,
        Image = "rbxassetid://7072719338",
        ImageColor3 = Color3.fromRGB(240, 240, 240)
     })
  })

  local FakeHolder = CreateElement("Frame", {
     Parent = MainWindow, 
     Name = "FakeHolder",
     Size = UDim2.new(1, 0, 1, -45),
     Transparency = 1
  })

  local HolderFrame = SetChildren(CreateElement("Frame", {
     Parent = FakeHolder, 
     Name = "HolderFrame",
     Size = UDim2.new(1, 0, 1, 0),
     Transparency = 0.5,
     BackgroundColor3 = Color3.fromRGB(20, 20, 20),
     Active = true,
     AnchorPoint = Vector2.new(0.5, 0.5),
     Position = UDim2.new(0.5, 0, 0.5, 0),
     ClipsDescendants = true
  }), {
     CreateElement("UICorner", {CornerRadius = UDim.new(0, 20)}),
     CreateElement("UIStroke", {
        Color = Color3.fromRGB(0, 0, 0),
        Thickness = 2,
        Transparency = 0.5
     }),
     SetChildren(CreateElement("Frame", {
        Name = "Holder",
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        Transparency = 1
     }), {CreateElement("UIListLayout", {Padding = UDim.new(0, 10)})})
  })

  AddConnection(HolderFrame.Holder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
     MainWindow.Size = UDim2.new(Size.X.Scale, Size.X.Offset, Size.Y.Scale, HolderFrame.Holder.UIListLayout.AbsoluteContentSize.Y + 55)
  end)

  local Opened = true
  AddConnection(TopBar.Button.InputEnded, function(Input)
     if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then return end
     Opened = not Opened

     if not Opened then
        local TweenButton = PlayTween(TopBar.Button, 0.1, {
           Size = UDim2.new(0, 0, 0, 0),
           Position = UDim2.new(1, -25, 0, 25)
        }); TweenButton.Completed:Once(function() 
           TopBar.Button.Image = "rbxassetid://7072720870" 
           PlayTween(TopBar.Button, 0.1, {
              Size = UDim2.new(0, 25, 0, 25),
              Position = UDim2.new(1, -35, 0, 8)
           })
        end)

        local Tween1, Tween2
        Tween1 = PlayTween(HolderFrame, 0.05, {Size = UDim2.new(1, 10, 1, 10)})
        Tween1.Completed:Once(function() 
           Tween2 = PlayTween(HolderFrame, 0.1, {Size = UDim2.new(0, 0, 0, 0)}) 
           Tween2.Completed:Once(function() HolderFrame.Visible = false end)
        end)
     else
        local TweenButton = PlayTween(TopBar.Button, 0.1, {
           Size = UDim2.new(0, 0, 0, 0),
           Position = UDim2.new(1, -25, 0, 25)
        }); TweenButton.Completed:Once(function() 
           TopBar.Button.Image = "rbxassetid://7072719338" 
           PlayTween(TopBar.Button, 0.1, {
              Size = UDim2.new(0, 25, 0, 25),
              Position = UDim2.new(1, -35, 0, 8)
           })
        end)

        HolderFrame.Visible = true
        local Tween1, Tween2
        Tween1 = PlayTween(HolderFrame, 0.1, {Size = UDim2.new(1, 0, 1, 0)})
        Tween1.Completed:Once(function() 
           Tween2 = PlayTween(HolderFrame, 0.05, {Size = UDim2.new(1, 10, 1, 10)}) 
           Tween2.Completed:Once(function() PlayTween(HolderFrame, 0.1, {Size = UDim2.new(1, 0, 1, 0)}) end)
        end)
     end
  end)

  local function AddDraggingFunctionality(DragPoint, Main)
     -- функция из ориона // a function from orion ui lib
     pcall(function()
        local Dragging, DragInput, MousePos, FramePos = false
        DragPoint.InputBegan:Connect(function(Input)
           if Input.UserInputType == Enum.UserInputType.MouseButton1  or Input.UserInputType == Enum.UserInputType.Touch then
              Dragging = true
              MousePos = Input.Position
              FramePos = Main.Position

              Input.Changed:Connect(function()
                 if Input.UserInputState == Enum.UserInputState.End then Dragging = false end
              end)
           end
        end)
        DragPoint.InputChanged:Connect(function(Input)
           if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then DragInput = Input end
        end)
        UserInputService.InputChanged:Connect(function(Input)
           if Input == DragInput and Dragging then
              local Delta = Input.Position - MousePos
              TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                 Position  = UDim2.new(FramePos.X.Scale,FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
              }):Play()
           end
        end)
     end)
  end; AddDraggingFunctionality(TopBar, MainWindow)

  function Tab:CreateButton(ButtonConfig: table?): table
     ButtonConfig = ButtonConfig or {}
     ButtonConfig.Name = ButtonConfig.Name or "Button"
     ButtonConfig.Callback = ButtonConfig.Callback or function() end

     local Button = { Name = ButtonConfig.Name }
     local ButtonNumber = #UI.Elements + 1
     
     local ButtonFrame = SetChildren(CreateElement("Frame", {
        Parent = HolderFrame.Holder,
        Name = "Button",
        BackgroundTransparency = 0.9,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 0, 30),
        AnchorPoint = Vector2.new(0.5, 0.5)
     }), {
        CreateElement("TextLabel", {
           Name = "Title",
           Size = UDim2.new(1, 0, 1, 0),
           BackgroundTransparency = 1,
           TextXAlignment = Enum.TextXAlignment.Center,
           TextYAlignment = Enum.TextYAlignment.Center,
           Text = ButtonConfig.Name,
           TextColor3 = Color3.fromRGB(240, 240, 240),
           TextSize = 15,
           Font = Enum.Font.GothamBlack
        }),
        CreateElement("UICorner", {CornerRadius = UDim.new(0, 20)}),
        CreateElement("UIStroke", {
           Color = Color3.fromRGB(0, 0, 0),
           Thickness = 1,
           Transparency = 0.5
        })
     }); UI.Elements[ButtonNumber] = ButtonFrame

     AddConnection(ButtonFrame.InputEnded, function(Input)
        if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then return end
        local Tween = PlayTween(ButtonFrame.UIStroke, 0.15, {Color = Color3.fromRGB(240, 240, 240)}); Tween.Completed:Once(function() 
           PlayTween(ButtonFrame.UIStroke, 0.15, {Color = Color3.fromRGB(0, 0, 0)}) 
        end)
        ButtonConfig.Callback()
     end)

     local function AnimateSizeNearButtons(Size)
        if ButtonNumber - 1 ~= 0 then
           PlayTween(UI.Elements[ButtonNumber-1], 0.1, {Size = UDim2.new(1, 0, 0, Size)})
        end; if ButtonNumber + 1 <= #UI.Elements then
           PlayTween(UI.Elements[ButtonNumber+1], 0.1, {Size = UDim2.new(1, 0, 0, Size)})
        end
     end

     AddConnection(ButtonFrame.MouseEnter, function() 
        PlayTween(ButtonFrame, 0.2, {Size = UDim2.new(1, 0, 0, 40)}) 
        PlayTween(ButtonFrame.Title, 0.2, {TextSize = 20}) 
        AnimateSizeNearButtons(25)
     end)

     AddConnection(ButtonFrame.MouseLeave, function() 
        PlayTween(ButtonFrame, 0.2, {Size = UDim2.new(1, 0, 0, 30)}) 
        PlayTween(ButtonFrame.Title, 0.2, {TextSize = 15}) 
        AnimateSizeNearButtons(30)
     end)

     return Button
  end

  function Tab:CreateToggle(ToggleConfig: table?): table
     ToggleConfig = ToggleConfig or {}
     ToggleConfig.Name = ToggleConfig.Name or "Toggle"
     ToggleConfig.Default = ToggleConfig.Default or false
     ToggleConfig.Callback = ToggleConfig.Callback or function() end

     local Toggle = { Name = ToggleConfig.Name, State = ToggleConfig.Default }
     local ToggleNumber = #UI.Elements + 1

     local ToggleFrame = SetChildren(CreateElement("Frame", {
        Parent = HolderFrame.Holder,
        Name = "Toggle",
        BackgroundTransparency = 0.9,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 0, 30)
     }), {
        CreateElement("TextLabel", {
           Name = "Title",
           Size = UDim2.new(1, 0, 1, 0),
           BackgroundTransparency = 1,
           TextXAlignment = Enum.TextXAlignment.Center,
           TextYAlignment = Enum.TextYAlignment.Center,
           Text = ToggleConfig.Name,
           TextColor3 = Color3.fromRGB(240, 240, 240),
           TextSize = 15,
           Font = Enum.Font.GothamBlack
        }),
        CreateElement("UICorner", {CornerRadius = UDim.new(0, 20)}),
        CreateElement("UIStroke", {
           Color = Color3.fromRGB(0, 0, 0),
           Thickness = 1,
           Transparency = 0.5
        })
     }); UI.Elements[ToggleNumber] = ToggleFrame

     function Toggle:Set(State: boolean)
        Toggle.State = State
        ToggleConfig.Callback(Toggle.State)
     end

     AddConnection(ToggleFrame.InputEnded, function(Input)
        if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then return end
        Toggle.State = not Toggle.State; PlayTween(ToggleFrame.UIStroke, 0.15, {
           Color = Toggle.State and Color3.fromRGB(240, 240, 240) or Color3.fromRGB(0, 0, 0)
        }); Toggle:Set(Toggle.State)
     end)

     local function AnimateSizeNearToggles(Size)
        if ToggleNumber - 1 ~= 0 then
           PlayTween(UI.Elements[ToggleNumber-1], 0.1, {Size = UDim2.new(1, 0, 0, Size)})
        end; if ToggleNumber + 1 <= #UI.Elements then
           PlayTween(UI.Elements[ToggleNumber+1], 0.1, {Size = UDim2.new(1, 0, 0, Size)})
        end
     end

     AddConnection(ToggleFrame.MouseEnter, function() 
        PlayTween(ToggleFrame, 0.2, {Size = UDim2.new(1, 0, 0, 40)}) 
        PlayTween(ToggleFrame.Title, 0.2, {TextSize = 20}) 
        AnimateSizeNearToggles(25)
     end)

     AddConnection(ToggleFrame.MouseLeave, function() 
        PlayTween(ToggleFrame, 0.2, {Size = UDim2.new(1, 0, 0, 30)}) 
        PlayTween(ToggleFrame.Title, 0.2, {TextSize = 15}) 
        AnimateSizeNearToggles(30)
     end)

     return Toggle
  end

  return Tab
end

return UI
