script.Parent.ButtonAni:TweenSize(UDim2.new(0, 0, 0, 0), "InOut", "Sine", 0.3, true)
                end)
            end
            coroutine.wrap(ZNVYM_fake_script)()
        end
        
        function Lib:Toggle(name, callback)
            local ToggleContainer = Instance.new("Frame")
            local ToggleName = Instance.new("TextLabel")
            local Toggle = Instance.new("TextButton")
            local UICorner_3 = Instance.new("UICorner")
            local Off = Instance.new("ImageLabel")
            local On = Instance.new("ImageLabel")
            
            ToggleContainer.Name = "ToggleContainer"
            ToggleContainer.Parent = Container
            ToggleContainer.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            ToggleContainer.BorderSizePixel = 0
            ToggleContainer.Size = UDim2.new(0, 204, 0, 30)
        ToggleContainer.BackgroundTransparency = 0.5
            
            ToggleName.Name = "ToggleName"
            ToggleName.Parent = ToggleContainer
            ToggleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleName.BackgroundTransparency = 1.000
            ToggleName.Position = UDim2.new(0.0245098043, 0, 0.142857105, 0)
            ToggleName.Size = UDim2.new(0, 169, 0, 20)
            ToggleName.Font = Enum.Font.GothamSemibold
            ToggleName.Text = name
            ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleName.TextScaled = true
            ToggleName.TextSize = 14.000
            ToggleName.TextWrapped = true
            ToggleName.TextXAlignment = Enum.TextXAlignment.Left
            
            Toggle.Name = "Toggle"
            Toggle.Parent = ToggleContainer
            Toggle.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
            Toggle.BorderColor3 = Color3.fromRGB(27, 42, 53)
            Toggle.Position = UDim2.new(0.852941215, 0, 0.0666666627, 0)
            Toggle.Size = UDim2.new(0, 25, 0, 23)
            Toggle.AutoButtonColor = false
            Toggle.Font = Enum.Font.SourceSans
            Toggle.Text = ""
            Toggle.TextColor3 = Color3.fromRGB(0, 0, 0)
            Toggle.TextSize = 14.000
        Toggle.BackgroundTransparency = 1
            local Toggled = false
            Toggle.MouseButton1Click:Connect(function()
                if Toggled == false then
                    Toggled = true
                else
                    Toggled = false
                end
                callback(Toggled)
            end)
            
            UICorner_3.CornerRadius = UDim.new(0, 3)
            UICorner_3.Parent = Toggle
            
            Off.Name = "Off"
            Off.Parent = Toggle
            Off.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Off.BackgroundTransparency = 1.000
            Off.Size = UDim2.new(0, 25, 0, 25)
            Off.Image = "rbxassetid://3926305904"
            Off.ImageColor3 = Color3.fromRGB(255, 0, 68)
            Off.ImageRectOffset = Vector2.new(924, 724)
            Off.ImageRectSize = Vector2.new(36, 36)
            
            On.Name = "On"
            On.Parent = Toggle
            On.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            On.BackgroundTransparency = 1.000
            On.Size = UDim2.new(0, 25, 0, 25)
            On.Visible = false
            On.Image = "rbxassetid://3926305904"
            On.ImageColor3 = Color3.fromRGB(0, 255, 102)
            On.ImageRectOffset = Vector2.new(312, 4)
            On.ImageRectSize = Vector2.new(24, 24)
            
            local function XLZZDX_fake_script() -- Toggle.Script 
                local script = Instance.new('Script', Toggle)
                
                script.Parent.MouseButton1Click:Connect(function()
                    if script.Parent.Off.Rotation == 0 then
                        script.Parent.On.Rotation = 0
                        game:GetService("TweenService"):Create(script.Parent.Off, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 360}):Play();
                        wait(0.3)
                        script.Parent.Off.Visible = false
                        script.Parent.On.Visible = true
                    else
                        script.Parent.Off.Rotation = 0
                        game:GetService("TweenService"):Create(script.Parent.On, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = -360}):Play();
                        wait(0.3)
                        script.Parent.On.Visible = false
                        script.Parent.Off.Visible = true
                    end
                end)
            end
            coroutine.wrap(XLZZDX_fake_script)()
        end
        
        return Lib
        
    end

    return Library
