    local UI = { 
        Connections = {},
        Elements = {},
        Window = nil
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

    function UI:CreateWindow(WindowConfig: table?): table
        WindowConfig = WindowConfig or {}
        WindowConfig.Name = WindowConfig.Name or "Window"
        WindowConfig.SizeX = WindowConfig.SizeX or 150
        WindowConfig.SizeY = WindowConfig.SizeY or 0
        WindowConfig.CanResize = WindowConfig.CanResize or "BOTH" -- Possible: "", "X", "Y", "BOTH"
        local Tab = {}
        local ScaleX, ScaleY

        local ScreenGui = CreateElement("ScreenGui", {
            Parent = CoreGui,
            Name = "TheWorstUI-"..WindowConfig.Name
        })

        local MainWindow = SetChildren(CreateElement("Frame", {
            Parent = ScreenGui,
            Name = "MainWindow",
            Transparency = 1,
            Size = UDim2.new(0, WindowConfig.SizeX, 0, WindowConfig.SizeY),
        }), {
            SetChildren(CreateElement("Frame", {
                Name = "MainWindowHolder",
                Transparency = 1,
                Size = UDim2.new(1, 0, 1, 0)
            }), {
                CreateElement("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 10)
                })
            }),
            CreateElement("UICorner", {CornerRadius = UDim.new(1, 0)})
        })

        local TopBar = SetChildren(CreateElement("Frame", {
            Parent = MainWindow.MainWindowHolder,
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
                Text = WindowConfig.Name,
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
            Parent = MainWindow.MainWindowHolder, 
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
            SetChildren(CreateElement("ScrollingFrame", {
                Name = "Holder",
                ScrollBarThickness = 8,
                ScrollBarImageTransparency = 1,
                Size = UDim2.new(1, -10, 1, -10),
                Position = UDim2.new(0, 5, 0, 5),
                Transparency = 1,
                ClipsDescendants = false,
            }), {CreateElement("UIListLayout", {Padding = UDim.new(0, 10)})})
        })

        local FakeResizingFrame = SetChildren(CreateElement("Frame", {
            Parent = MainWindow,
            Name = "FakeResizingFrame",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Transparency = 1,
            Active = true
        }), {
            SetChildren(CreateElement("Frame", {
                Name = "ResizingFrame",
                Size = UDim2.new(0, 10, 0, 10),
                Position = UDim2.new(0, 5, 0, 5),
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                Transparency = 0.5,
                Active = true,
                AnchorPoint = Vector2.new(0.5, 0.5)
            }), {
                CreateElement("UICorner", {CornerRadius = UDim.new(1, 0)}),
                CreateElement("UIStroke", {
                    Color = Color3.fromRGB(0, 0, 0),
                    Thickness = 2,
                    Transparency = 0.5
                })
            })
        })

        local Sizing = false
        if WindowConfig.CanResize == "" then
            FakeResizingFrame.Visible = false
        else
            AddConnection(FakeResizingFrame.MouseEnter, function()
                PlayTween(FakeResizingFrame.ResizingFrame, 0.2, {
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(0.5, 0, 0.5, 0)
                })
            end)
            AddConnection(FakeResizingFrame.MouseLeave, function()
                while Sizing do task.wait() end
                PlayTween(FakeResizingFrame.ResizingFrame, 0.2, {
                    Size = UDim2.new(0, 10, 0, 10),
                    Position = UDim2.new(0, 5, 0, 5)
                })
            end)
        end

        AddConnection(HolderFrame.Holder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            local SizeY = math.clamp(
                HolderFrame.Holder.UIListLayout.AbsoluteContentSize.Y + 55, 
                WindowConfig.SizeY ~= 0 and WindowConfig.SizeY or 50, 
                WindowConfig.SizeY ~= 0 and WindowConfig.SizeY or 9999
            ); PlayTween(MainWindow, 0.3, {Size = UDim2.new(
                0, WindowConfig.SizeX, 
                0, SizeY
            )})

            HolderFrame.Holder.CanvasSize = UDim2.new(0, 0, 0, HolderFrame.Holder.UIListLayout.AbsoluteContentSize.Y)
        end)

        Tab.Opened = true
        AddConnection(TopBar.Button.InputEnded, function(Input)
            if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then return end
            Tab.Opened = not Tab.Opened

            if not Tab.Opened then
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
                PlayTween(FakeResizingFrame, 0.05, {Position = UDim2.new(1, 10, 1, 10)})
                Tween1.Completed:Once(function() 
                    Tween2 = PlayTween(HolderFrame, 0.1, {Size = UDim2.new(0, 0, 0, 0)}) 
                    PlayTween(FakeResizingFrame, 0.1, {Position = UDim2.new(1, 0, 1, -MainWindow.AbsoluteSize.Y + 45)})
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
                PlayTween(FakeResizingFrame, 0.1, {Position = UDim2.new(1, 0, 1, 0)})
                Tween1.Completed:Once(function() 
                    Tween2 = PlayTween(HolderFrame, 0.05, {Size = UDim2.new(1, 10, 1, 10)}) 
                    PlayTween(FakeResizingFrame, 0.1, {Position = UDim2.new(1, 10, 1, 10)})
                    Tween2.Completed:Once(function() 
                        PlayTween(HolderFrame, 0.1, {Size = UDim2.new(1, 0, 1, 0)}) 
                        PlayTween(FakeResizingFrame, 0.1, {Position = UDim2.new(1, 0, 1, 0)})
                    end)
                end)
            end
        end)

        local function AddDraggingFunctionality(DragPoint: Instance, Main: Instance)
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
                    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then 
                        DragInput = Input 
                    end
                end)
                UserInputService.InputChanged:Connect(function(Input)
                    if Input == DragInput and Dragging then
                        local Delta = Input.Position - MousePos
                        PlayTween(Main, {0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out}, {
                            Position  = UDim2.new(FramePos.X.Scale,FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
                        }):Play()
                    end
                end)
            end)
        end; AddDraggingFunctionality(TopBar, MainWindow)

        local function AddResizingFunctionality(ResizePoint: Instance, Main: Instance)
            pcall(function()  
                local Dragging, DragInput, MousePos, FrameSize = false
                local Clamp, Sized = false, false
                
                ResizePoint.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                        MousePos = Input.Position
                        FrameSize = Main.Size
                        Clamp = false

                        Input.Changed:Connect(function()
                            if Input.UserInputState == Enum.UserInputState.End then
                                Dragging = false 
                                Sizing = false
                                Clamp = false
                            end
                        end)
                    end
                end)
                
                ResizePoint.InputChanged:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then 
                        DragInput = Input 
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(Input)
                    if Input == DragInput and Dragging then
                        Sizing = true
                        local Delta = Input.Position - MousePos
                        
                        local X, Y = FrameSize.X.Offset, FrameSize.Y.Offset
                        if WindowConfig.CanResize == "BOTH" or WindowConfig.CanResize == "X" then X = math.clamp(FrameSize.X.Offset + Delta.X, 160, 9999) end
                        if WindowConfig.CanResize == "BOTH" or WindowConfig.CanResize == "Y" then 
                            if Tab.Opened then Y = FrameSize.Y.Offset + Delta.Y end
                        end

                        local HolderSizeY = HolderFrame.Holder.UIListLayout.AbsoluteContentSize.Y + 55
                        local SizeChanged = false
                        
                        if WindowConfig.CanResize == "BOTH" or WindowConfig.CanResize == "Y" then
                            if not Clamp then
                                if math.abs(Y - HolderSizeY) <= 20 then
                                    Y = HolderSizeY
                                    Sized = true
                                    Clamp = true
                                    SizeChanged = true
                                else
                                    Y = math.clamp(Y, 50, 9999)
                                end
                            else
                                if math.abs(Delta.Y) > 30 then
                                    Sized = false
                                    Y = math.clamp(HolderSizeY + Delta.Y, 50, 9999)
                                    Clamp = false
                                    SizeChanged = true
                                else
                                    Y = HolderSizeY
                                    WindowConfig.SizeY = 0
                                end
                            end
                        end

                        local size = UDim2.new(
                            FrameSize.X.Scale, X,
                            FrameSize.Y.Scale, Y
                        ); PlayTween(Main, {0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out}, {Size = size})

                        WindowConfig.Size = size
                        WindowConfig.SizeX = X
                        if WindowConfig.CanResize == "BOTH" or WindowConfig.CanResize == "Y" then 
                            if not Sized then WindowConfig.SizeY = Y end 
                        end
                        if SizeChanged then FrameSize = size; MousePos = Input.Position end
                    end
                end)
            end)
        end; AddResizingFunctionality(FakeResizingFrame.ResizingFrame, MainWindow)

        function Tab:ScrollToBottom() 
            HolderFrame.Holder.CanvasPosition = Vector2.new(0, HolderFrame.Holder.UIListLayout.AbsoluteContentSize.Y) 
        end

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

        function Tab:CreateBind(BindConfig: table?): table
            BindConfig = BindConfig or {}
            BindConfig.Name = BindConfig.Name or "Bind"
            BindConfig.Default = BindConfig.Default or ""
            BindConfig.Hold = BindConfig.Hold or false
            BindConfig.Callback = BindConfig.Callback or function() end

            local MouseKeys = {
                Enum.UserInputType.MouseButton1,
                Enum.UserInputType.MouseButton2,
                Enum.UserInputType.MouseButton3,
                "MouseButton1", 
                "MouseButton2",
                "MouseButton3"
            }; local function GetBind(Key)
                if typeof(Key) == "string" then
                    if Key == "" then return "" end
                    if table.find(MouseKeys, Key) then
                        return Enum.UserInputType[Key]
                    else
                        return Enum.KeyCode[Key]
                    end
                end
                return Key
            end

            local Bind = {
                Name = BindConfig.Name, 
                Key = GetBind(BindConfig.Default)
            }
            local BindNumber = #UI.Elements + 1
            local Holding = false

            local BindFrame = SetChildren(CreateElement("Frame", {
                Parent = HolderFrame.Holder,
                Name = "Bind",
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
                    Text = BindConfig.Name..": "..(Bind.Key and Bind.Key.Name or "None"),
                    TextColor3 = Color3.fromRGB(240, 240, 240),
                    TextSize = 15,
                    Font = Enum.Font.GothamBlack,
                    TextWrapped = true
                }),
                CreateElement("UICorner", {CornerRadius = UDim.new(0, 20)}),
                CreateElement("UIStroke", {
                    Color = Color3.fromRGB(0, 0, 0),
                    Thickness = 1,
                    Transparency = 0.5
                })
            }); UI.Elements[BindNumber] = BindFrame

            function Bind:Set(Key: Enum)
                if Key == Enum.KeyCode.Backspace or Key == "Backspace" or Key == nil then
                    Bind.Key = ""
                    BindFrame.Title.Text = BindConfig.Name..": None"
                    return
                end
                Bind.Key = GetBind(Key)
                BindFrame.Title.Text = BindConfig.Name..": "..tostring(Bind.Key.Name)
            end

            AddConnection(BindFrame.InputEnded, function(Input)
                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then return end

                PlayTween(BindFrame.UIStroke, 0.15, {Color = Color3.fromRGB(240, 240, 240)})
                Bind.Binding = true; while Bind.Binding do task.wait() end
                PlayTween(BindFrame.UIStroke, 0.15, {Color = Color3.fromRGB(0, 0, 0)})
            end)

            AddConnection(UserInputService.InputBegan, function(Input)
                if UserInputService:GetFocusedTextBox() then return end
                if Bind.Binding then
                    Bind:Set(Input.UserInputType ~= Enum.UserInputType.Keyboard and Input.UserInputType or Input.KeyCode)
                    Bind.Binding = false
                else
                    if Input.KeyCode ~= Bind.Key and Input.UserInputType ~= Bind.Key then return end
                    if BindConfig.Hold then
                        Holding = true
                        BindConfig.Callback(Holding)
                    else
                        BindConfig.Callback()
                    end
                end
            end)

            AddConnection(UserInputService.InputEnded, function(Input)
                if Input.KeyCode ~= Bind.Key and Input.UserInputType ~= Bind.Key then return end
                if BindConfig.Hold and Holding then
                    Holding = false
                    BindConfig.Callback(Holding)
                end
            end)

            local function AnimateSizeNearBinds(Size)
                if BindNumber - 1 ~= 0 then
                    PlayTween(UI.Elements[BindNumber-1], 0.1, {Size = UDim2.new(1, 0, 0, Size)})
                end; if BindNumber + 1 <= #UI.Elements then
                    PlayTween(UI.Elements[BindNumber+1], 0.1, {Size = UDim2.new(1, 0, 0, Size)})
                end
            end

            AddConnection(BindFrame.MouseEnter, function() 
                PlayTween(BindFrame, 0.2, {Size = UDim2.new(1, 0, 0, 40)}) 
                PlayTween(BindFrame.Title, 0.2, {TextSize = 18}) 
                AnimateSizeNearBinds(25)
            end)

            AddConnection(BindFrame.MouseLeave, function() 
                PlayTween(BindFrame, 0.2, {Size = UDim2.new(1, 0, 0, 30)}) 
                PlayTween(BindFrame.Title, 0.2, {TextSize = 15}) 
                AnimateSizeNearBinds(30)
            end)

            return Bind
        end

        function Tab:CreateLabel(LabelText: string?): table
            local Label = { Text = LabelText }

            local LabelFrame = SetChildren(CreateElement("Frame", {
                Parent = HolderFrame.Holder,
                Name = "LabelFrame",
                Size = UDim2.new(1, 0, 0, 10),
                Transparency = 1,
                BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            }), {
                CreateElement("TextLabel", {
                    Size = UDim2.new(1, -5, 1, 0),
                    Position = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    RichText = true,
                    TextColor3 = Color3.fromRGB(240, 240, 240),
                    TextSize = 14,
                    Font = Enum.Font.GothamBlack
                }),
                CreateElement("UICorner", {CornerRadius = UDim.new(0, 20)})
            }); LabelFrame.TextLabel.Text = LabelText
        end

        UI.Window = Tab
        return Tab
    end

return UI
