getgenv().SettingsWindow = {}
SettingsWindow.__index = SettingsWindow

getgenv().SettingsWindowLoaded = false

-- Services
    local HttpService = game:GetService("HttpService")

-- Local Functions
    _isfolder = function(...) return isfolder(table.concat({...}, "/")) end
    _makefolder = function(...) makefolder(table.concat({...}, "/")) end
    _readfile = function(...) return readfile(table.concat({...}, "/")) end
    _writefile = function(File, Content) writefile(table.concat(File, "/"), Content) end
    _listfiles = function(...) return listfiles(table.concat({...}, "/")) end
    _getcustomasset = function(...) return getcustomasset(table.concat({...}, "/")) end
    _isfile = function(...) return isfile(table.concat({...}, "/")) end

    local function JSONDecode(Data) 
        if typeof(Data) == "table" then return HttpService:JSONDecode(Data) end
        if not _isfile(Data) then return nil end
        if readfile(Data) == "" then return nil end

        return HttpService:JSONDecode(readfile(Data))
    end

    local function JSONEncode(Data) 
        return HttpService:JSONEncode(Data) 
    end

    local function LoadPhotoFromUrl(Url)
        if Url == "" or Url == nil then return nil end
        
        local FileName = string.format("customasset_%s", tostring(math.random(1, 99999)))
        _writefile({FileName}, game:HttpGet(Url))
        task.delay(10, delfile, FileName)

        return getcustomasset(FileName)
    end

    local GetConfigs, LoadConfig, SaveConfig, DeleteConfig, MakeConfigAutoload, CheckAllFiles

function SettingsWindow:CreateWindow(FilesConfig: { Folder: string, GameName: string }) 
    local UI = getgenv().UI
    local Taskbar = UI and UI.Taskbar
    if not Taskbar then
        error("[TheWorstUI V2]: Missing UI / Taskbar")
        return
    end

    local SelectedConfig, ConfigName, ConfigToImport = "", "", ""
    local SelectedTheme, ThemeName, ThemeToImport = "", "", ""
    local SelectedBackground, BackgroundName, ImageLink = "", "", "", "", "", ""

    -- Config Functions

        CheckAllFiles = function()
            if not _isfolder("TheWorstUIV2") then _makefolder("TheWorstUIV2") end
            if not _isfolder(FilesConfig.Folder) then _makefolder(FilesConfig.Folder) end
            if not _isfolder(FilesConfig.Folder, FilesConfig.GameName) then _makefolder(FilesConfig.Folder, FilesConfig.GameName) end
            if not _isfolder(FilesConfig.Folder, FilesConfig.GameName, "Configurations/Config") then _makefolder(FilesConfig.Folder, FilesConfig.GameName, "Configurations/Config") end
            if not _isfile(FilesConfig.Folder, FilesConfig.GameName, "Configurations/PinnedWindows.json") then _writefile({FilesConfig.Folder, FilesConfig.GameName, "Configurations/PinnedWindows.json"}, "{}") end
            
            for _, FolderName in { 
                "Themes", "Backgrounds", "Backgrounds/Images",
                "Autoload", "SizesAndPositions"
            } do if not _isfolder("TheWorstUIV2", FolderName) then 
                _makefolder("TheWorstUIV2", FolderName) 
            end end

            for _, FileName in {
                "SizesAndPositions/Windows.json",
                "Autoload/Autoload.json",
                "Backgrounds/Config.json"
            } do if not _isfile("TheWorstUIV2", FileName) then 
                _writefile({"TheWorstUIV2", FileName}, "") 
            end end
        end; CheckAllFiles()

        GetConfigs = function(Type) CheckAllFiles()
            local Folder = _isfolder(FilesConfig.Folder)
            local ConfigFolder, ConfigList

            if Type == "Config" then ConfigList = _listfiles(FilesConfig.Folder, FilesConfig.GameName, "Configurations/Config")
            elseif Type == "Theme" then ConfigList = _listfiles("TheWorstUIV2/Themes")
            elseif Type == "Background" then ConfigList = _listfiles("TheWorstUIV2/Backgrounds/Images")
            end

            local Data = {}
            for i = 1, #ConfigList do
                local Position = ConfigList[i]:find(".json", 1, true) or ConfigList[i]:find(".png", 1, true)
                local StartPosition = Position
                local Char = ConfigList[i]:sub(Position, Position)

                while Char ~= "/" and Char ~= "\\" and Char ~= "" do
                    Position -= 1
                    Char = ConfigList[i]:sub(Position, Position)
                end

                if Char == "/" or Char == "\\" then
                    local FileName = ConfigList[i]:sub(Position + 1, StartPosition - 1)
                    if FileName ~= "" then Data[#Data+1] = FileName end
                end
            end
            return Data
        end

        LoadConfig = function(Name, Type, Autoload) CheckAllFiles()
			if Type == "Config" then
				local Data, ConfigFileName = nil, string.format("%s/%s/Configurations/Config/%s.json", FilesConfig.Folder, FilesConfig.GameName, Name)

				Data = JSONDecode(ConfigFileName)
				if not Data then return end

                for Element, Value in Data do if UI.Flags[Element] then task.spawn(function()
                    if Value.Type == "Colorpicker" then
                        pcall(function() UI.Flags[Element]:Set(Color3.fromHex(Value.Value), Value.TransparencyValue) end)
                    else
                        pcall(function() UI.Flags[Element]:Set(Value.Value) end)
                    end
                end) end end
			elseif Type == "Theme" then
				local Data, ConfigFileName = nil, string.format("TheWorstUIV2/Themes/%s.json", Name)

				Data = JSONDecode(ConfigFileName)
				if not Data then return end

                for Element, Value in Data do if UI.Flags[Element] then task.spawn(function()
                    if Value.Type == "Colorpicker" then
                        pcall(function() UI.Flags[Element]:Set(Color3.fromHex(Value.Value), Value.TransparencyValue) end)
                    else
                        pcall(function() UI.Flags[Element]:Set(Value.Value) end)
                    end
                end) end end
			elseif Type == "Background" then
                local Config = JSONDecode("TheWorstUIV2/Backgrounds/Config.json")
                local FileName = string.format("TheWorstUIV2/Backgrounds/Images/%s.png", Name)

                Taskbar:SetBackground({ 
                    Image = isfile(FileName) and getcustomasset(FileName) or "",
                    Transparency = Config and Config.Transparency or nil
                })
			end
		end

        SaveConfig = function(Name, Type) CheckAllFiles()
            local FlagsSaveOnly = {
                "MainColorColorpickerSettingsFrame", "SecondColorColorpickerSettingsFrame", "ThirdColorColorpickerSettingsFrame",
                "SectionsColorColorpickerSettingsFrame", "MainFontDropdopwnSettingsFrame", "MainFontColorColorpickerSettingsFrame",
                "LittleFontDropdownSettingsFrame", "LittleFontColorColorpickerSettingsFrame",
                "NoiseTransparencySliderSettingsWindow", "NoiseSizeSliderSettingsWindow"
            }
            
			if Type == "Config" then
				local Data = {}

                for Element, Value in UI.Flags do 
                    if table.find(FlagsSaveOnly, Element) then continue end

                    local ValueData = {}; for Index, Item in Value do
                        if typeof(Item) == "Color3" then
                            ValueData[Index] = Color3.new(Item.R, Item.G, Item.B):ToHex()
                        elseif typeof(Item) ~= "function" then 
                            ValueData[Index] = Item
                        end
                    end

                    Data[Element] = ValueData
                end
                
				writefile(string.format(
                    "%s/%s/Configurations/Config/%s.json", FilesConfig.Folder, FilesConfig.GameName, Name
                ), tostring(JSONEncode(Data)))
			elseif Type == "Theme" then
				local Data = {}

				for Element, Value in UI.Flags do 
                    if not table.find(FlagsSaveOnly, Element) then continue end

                    local ValueData = {}; for Index, Item in Value do
                        if typeof(Item) == "Color3" then
                            ValueData[Index] = Color3.new(Item.R, Item.G, Item.B):ToHex()
                        elseif typeof(Item) ~= "function" then 
                            ValueData[Index] = Item
                        end
                    end

                    Data[Element] = ValueData
                end

                writefile(string.format("TheWorstUIV2/Themes/%s.json", Name), tostring(JSONEncode(Data)))
			elseif Type == "Background" then
                local FileName = string.format("TheWorstUIV2/Backgrounds/Images/%s.png", Name)
                local Config = JSONDecode("TheWorstUIV2/Backgrounds/Config.json")
                local LoadedImage = game:HttpGet(ImageLink)

				writefile(FileName, LoadedImage)

                Taskbar:SetBackground({ Image = getcustomasset(FileName), Transparency = Config and Config.Transparency or nil })
			end
		end

        DeleteConfig = function(Name, Type) CheckAllFiles()
            local FileString = ""

            if Type == "Config" then 
                FileString = string.format("%s/%s/Configurations/Config/%s.json", FilesConfig.Folder, FilesConfig.GameName, Name)
            elseif Type == "Theme" then
                FileString = string.format("TheWorstUIV2/Themes/%s.json", Name)
            elseif Type == "Background" then
                FileString = string.format("TheWorstUIV2/Backgrounds/Images/%s.png", Name)
            end

            if isfile(FileString) then delfile(FileString) end
        end

        MakeConfigAutoload = function(Name, Type, Remove) CheckAllFiles()
            local TableAutoload = JSONDecode("TheWorstUIV2/Autoload/Autoload.json") or {}

            if not Remove then
                if Type == "Config" then
                    TableAutoload.Configs = TableAutoload.Configs or {}
                    TableAutoload.Configs[tostring(game.PlaceId)] = Name
                elseif Type == "Theme" then
                    TableAutoload["Theme"] = Name
                else
                    TableAutoload["Background"] = Name
                end
            else
                if Type == "Config" then
                    TableAutoload.Configs = TableAutoload.Configs or {}
                    TableAutoload.Configs[tostring(game.PlaceId)] = nil
                elseif Type == "Theme" then
                    TableAutoload["Theme"] = nil
                else
                    TableAutoload["Background"] = nil
                end
            end

            writefile("TheWorstUIV2/Autoload/Autoload.json", JSONEncode(TableAutoload))
        end

    -- Elements
        local Elements = {
            Window = nil,
            Tabs = {},
            Sections = {},
            Dropdowns = {},
            Labels = {},
            Sliders = {},
            Toggles = {}
        }

        local SelectedNotifications = {}
        local SelectedWindows = {}
        local MouseUnlockConnection, OldMouseBehavior, OldMouseIconEnabled = nil, nil, nil

        local FontsList = {
            "Legacy", "Arial", "ArialBold", "SourceSans", "SourceSansBold", "SourceSansLight", "SourceSansItalic", "Bodoni", 
            "Garamond", "Cartoon", "Code", "Highway", "SciFi", "Arcade", "Fantasy", "Antique", "SourceSansSemibold", "Gotham", 
            "GothamMedium", "GothamBold", "GothamBlack", "AmaticSC", "Bangers", "Creepster", "DenkOne", "Fondamento", "FredokaOne",
            "GrenzeGotisch", "IndieFlower", "JosefinSans", "Jura", "Kalam", "LuckiestGuy", "Merriweather", "Michroma", "Nunito",
            "Oswald", "PatrickHand", "PermanentMarker", "Roboto", "RobotoCondensed", "RobotoMono", "Sarpanch", "SpecialElite",
            "TitilliumWeb", "Ubuntu", "BuilderSans", "BuilderSansMedium", "BuilderSansBold", "BuilderSansExtraBold", "Arimo", "ArimoBold"
        }

        Elements.Window = Taskbar:CreateWindow({ 
            Name = "Settings",
            Icon = "settings",
            Description = "UI Theme and Configuration settings",
            Pinned = false
        })
        
        Elements.Tabs.ConfigTab = Elements.Window:CreateTab({ Name = "Config" })
            Elements.Sections.ConfigSavingSection = Elements.Tabs.ConfigTab:CreateSection({ Name = "Save", Side = "Right", Group = "SaveImportConfig" })
                Elements.Sections.ConfigSavingSection:CreateDividier()

                Elements.Dropdowns.ConfigListSave = Elements.Sections.ConfigSavingSection:CreateDropdown({
                    Name = "Config List",
                    Options = GetConfigs("Config"),
                    Callback = function(Option) 
                        SelectedConfig = Option
                    end
                })

                Elements.Sections.ConfigSavingSection:CreateTextbox({
                    Name = "Config Name",
                    Callback = function(Text)
                        Text = Text:gsub(" ", "_")
                        ConfigName = Text
                    end
                })

                Elements.Sections.ConfigSavingSection:CreateDividier()

                Elements.Sections.ConfigSavingSection:CreateButton({
                    Name = "Load",
                    Callback = function()
                        if SelectedConfig == "" then 
                            Taskbar:CreateNotification({ Name = "Select a Config", Description = "Use 'Config List'", Group = "SelectAConfigNotify" })
                            return 
                        end

                        local ConfigToLoad = SelectedConfig
                        LoadConfig(SelectedConfig, "Config", false)
                        Taskbar:CreateNotification({ Name = "Loaded Config", Description = ConfigToLoad, Group = "LoadConfigNotify" })
                    end
                })

                Elements.Sections.ConfigSavingSection:CreateButton({
                    Name = "Save",
                    DoubleTap = true,
                    Callback = function()
                        if ConfigName == "" then 
                            Taskbar:CreateNotification({ Name = "Enter a Name", Description = "Use 'Config Name'", Group = "EnterANameNotify" })
                            return 
                        end

                        SaveConfig(ConfigName, "Config")
                        Taskbar:CreateNotification({ Name = "Saved Config", Description = ConfigName, Group = "SaveConfigNotify" })

                        Elements.Dropdowns.ConfigListImport:Refresh(GetConfigs("Config"))
                        Elements.Dropdowns.ConfigListSave:Refresh(GetConfigs("Config"))
                    end
                })

                Elements.Sections.ConfigSavingSection:CreateButton({
                    Name = "Overwrite",
                    DoubleTap = true,
                    Callback = function()
                        if SelectedConfig == "" then 
                            Taskbar:CreateNotification({ Name = "Select a Config", Description = "Use 'Config List'", Group = "SelectAConfigNotify" })
                            return 
                        end

                        SaveConfig(SelectedConfig, "Config")
                        Taskbar:CreateNotification({ Name = "Overwrited Config", Description = SelectedConfig, Group = "OverwriteConfigNotify" })

                        Elements.Dropdowns.ConfigListImport:Refresh(GetConfigs("Config"))
                        Elements.Dropdowns.ConfigListSave:Refresh(GetConfigs("Config"))
                    end
                })

                Elements.Sections.ConfigSavingSection:CreateButton({
                    Name = "Rename",
                    DoubleTap = true,
                    Callback = function()
                        if ConfigName == "" then 
                            Taskbar:CreateNotification({ Name = "Enter a Name", Description = "Use 'Config Name'", Group = "EnterANameNotify" })
                            return 
                        end

                        if SelectedConfig == "" then 
                            Taskbar:CreateNotification({ Name = "Select a Config", Description = "Use 'Config List'", Group = "SelectAConfigNotify" })
                            return 
                        end

                        DeleteConfig(SelectedConfig, "Config")
                        SaveConfig(ConfigName, "Config")

                        Taskbar:CreateNotification({ 
                            Name = "Renamed Config", 
                            Description = string.format("%s --> %s", SelectedConfig, ConfigName), 
                            Group = "RenameConfigNotify" 
                        })

                        Elements.Dropdowns.ConfigListImport:Refresh(GetConfigs("Config"))
                        Elements.Dropdowns.ConfigListSave:Refresh(GetConfigs("Config"))
                    end
                })

                Elements.Sections.ConfigSavingSection:CreateButton({
                    Name = "Delete",
                    DoubleTap = true,
                    Callback = function()
                        if SelectedConfig == "" then 
                            Taskbar:CreateNotification({ Name = "Select a Config", Description = "Use 'Config List'", Group = "SelectAConfigNotify" })
                        end

                        DeleteConfig(SelectedConfig, "Config")
                        Taskbar:CreateNotification({ Name = "Deleted Config", Description = SelectedConfig, Group = "DeleteAConfigNotify" })

                        Elements.Dropdowns.ConfigListImport:Refresh(GetConfigs("Config"))
                        Elements.Dropdowns.ConfigListSave:Refresh(GetConfigs("Config"))
                    end
                })

                Elements.Sections.ConfigSavingSection:CreateDividier()

                Elements.Labels.ConfigAutoloadLabel = Elements.Sections.ConfigSavingSection:CreateLabel({
                    Name = string.format(
                        "Autoload: %s", 
                        ((JSONDecode("TheWorstUIV2/Autoload/Autoload.json") or {}).Configs or {})[tostring(game.PlaceId)] or "None"
                    )
                })

                Elements.Sections.ConfigSavingSection:CreateButton({
                    Name = "Add To Autoload",
                    DoubleTap = true,
                    Callback = function()
                        MakeConfigAutoload(SelectedConfig, "Config", false)
                        Elements.Labels.ConfigAutoloadLabel:Set(string.format("Autoload: %s", SelectedConfig))
                    end
                })

                Elements.Sections.ConfigSavingSection:CreateButton({
                    Name = "Remove Autoload",
                    DoubleTap = true,
                    Callback = function()
                        MakeConfigAutoload(SelectedConfig, "Config", true)
                        Elements.Labels.ConfigAutoloadLabel:Set("Autoload: None")
                    end
                })

                Elements.Sections.ConfigSavingSection:CreateDividier()

                Elements.Sections.ConfigSavingSection:CreateButton({
                    Name = "Refresh List",
                    Callback = function()
                        Elements.Dropdowns.ConfigListImport:Refresh(GetConfigs("Config"))
                        Elements.Dropdowns.ConfigListSave:Refresh(GetConfigs("Config"))
                    end
                })

            Elements.Sections.ConfigImportSection = Elements.Tabs.ConfigTab:CreateSection({ Name = "Export & Import", Side = "Right", Group = "SaveImportConfig" })
                Elements.Sections.ConfigImportSection:CreateDividier()

                Elements.Dropdowns.ConfigListImport = Elements.Sections.ConfigImportSection:CreateDropdown({
                    Name = "Config List",
                    Options = GetConfigs("Config"),
                    Callback = function(Option) 
                        SelectedConfig = Option
                    end
                })

                Elements.Sections.ConfigImportSection:CreateTextbox({
                    Name = "Config Name",
                    Callback = function(Text)
                        Text = Text:gsub(" ", "_")
                        ConfigName = Text
                    end
                })

                Elements.Sections.ConfigImportSection:CreateTextbox({
                    Name = "Config (Import)",
                    Callback = function(Text)
                        ConfigToImport = Text
                    end
                })

                Elements.Sections.ConfigImportSection:CreateDividier()

                Elements.Sections.ConfigImportSection:CreateButton({
                    Name = "Import",
                    DoubleTap = true,
                    Callback = function()
                        if ConfigToImport == "" then
                            Taskbar:CreateNotification({ Name = "Enter a Config", Description = "Use 'Config (Import)'", Group = "EnterAConfigNotify" }) 
                            return
                        end

                        writefile(
                            string.format("%s/%s/Configurations/Config/%s.json", FilesConfig.Folder, FilesConfig.GameName, ConfigName), 
                            ConfigToImport
                        )

                        Taskbar:CreateNotification({ Name = "Imported", Description = ConfigName, Group = "ImportedConfigNotify" })

                        Elements.Dropdowns.ConfigListImport:Refresh(GetConfigs("Config"))
                        Elements.Dropdowns.ConfigListSave:Refresh(GetConfigs("Config"))
                    end
                })

                Elements.Sections.ConfigImportSection:CreateButton({
                    Name = "Export",
                    DoubleTap = true,
                    Callback = function()
                        if SelectedConfig == "" then 
                            Taskbar:CreateNotification({ Name = "Select a Config", Description = "Use 'Config List'", Group = "SelectAConfigNotify" })
                            return 
                        end

                        local ConfigString = readfile(string.format(
                            "%s/%s/Configurations/Config/%s.json", FilesConfig.Folder, FilesConfig.GameName, SelectedConfig
                        )); setclipboard(ConfigString)

                        Taskbar:CreateNotification({ Name = "Exported", Description = "To your clipboard.", Group = "ExportedConfigNotify" })
                    end
                })

                Elements.Sections.ConfigImportSection:CreateDividier()

                Elements.Sections.ConfigImportSection:CreateButton({
                    Name = "Refresh List",
                    Callback = function()
                        Elements.Dropdowns.ConfigListImport:Refresh(GetConfigs("Config"))
                        Elements.Dropdowns.ConfigListSave:Refresh(GetConfigs("Config"))
                    end
                })

            Elements.Sections.NotifySection = Elements.Tabs.ConfigTab:CreateSection({ Name = "Notifications", Side = "Left" })
                Elements.Sections.NotifySection:CreateDividier()

                Elements.Sections.NotifySection:CreateToggle({
                    Name = "Enable Notifications",
                    Flag = "GlobalNotificationsToggleSettingsWindow",
                    Callback = function(Bool)
                        Taskbar:ConfigNotifications({ Enabled = Bool })
                    end
                })

                Elements.Sections.NotifySection:CreateSlider({
                    Name = "Sounds Volume",
                    Min = 0, 
                    Max = 5,
                    Default = 1,
                    Flag = "GlobalSoundsVolumeSettingsWindow",
                    Callback = function(Value)
                        Taskbar:ConfigNotifications({ Volume = Value })
                    end
                })

                Elements.Sections.NotifySection:CreateDropdown({
                    Name = "Sounds List",
                    Options = {
                        "TheWorst ((default))", "Neverlose", 
                        "CS:GO Headshot", "Half-life button", 
                        "Smack", "EZ", 
                        "Steam notification", "Steam notification ((2))",
                        "Pizza scream", "Skeleton roar"
                    },
                    Default = "TheWorst ((default))",
                    Callback = function(Option) 
                        local Sounds = {
                            ["TheWorst ((default))"] = "96867813755421",
                            ["Neverlose"] = "97643101798871",
                            ["CS:GO Headshot"] = "5764885315",
                            ["Half-life button"] = "8470808181",
                            ["Smack"] = "6509749580",
                            ["EZ"] = "18603736229",
                            ["Steam notification"] = "195868961",
                            ["Steam notification 2"] = "18317665126",
                            ["Pizza scream"] = "154157563",
                            ["Skeleton roar"] = "139143665558961",
                        }

                        Taskbar:ConfigNotifications({ Sound = Sounds[Option] or "" })
                    end
                })

            Elements.Sections.TaskbarSettingsSection = Elements.Tabs.ConfigTab:CreateSection({ Name = "Taskbar", Side = "Left" })
                Elements.Sections.TaskbarSettingsSection:CreateDividier()

                Elements.Sections.TaskbarSettingsSection:CreateToggle({
                    Name = "Auto Close",
                    Flag = "AutoCloseTaskbarToggle",
                    Callback = function(Bool)
                        Taskbar:ToggleAutoClose(Bool)
                    end
                })

                Elements.Sections.TaskbarSettingsSection:CreateSlider({
                    Name = "Speed",
                    Min = 0, 
                    Max = 2,
                    Default = 0.3,
                    Increment = 0.1,
                    Flag = "CloseSpeedSliderSettingsWindow",
                    Callback = function(Value)
                        Taskbar:ConfigAutoClose({ Speed = Value })
                    end
                })

                Elements.Sections.TaskbarSettingsSection:CreateSlider({
                    Name = "Delay",
                    Min = 0, 
                    Max = 1,
                    Default = 0.2,
                    Increment = 0.1,
                    Flag = "CloseDelaySliderSettingsWindow",
                    Callback = function(Value)
                        Taskbar:ConfigAutoClose({ Delay = Value })
                    end
                })

            Elements.Sections.OtherSection = Elements.Tabs.ConfigTab:CreateSection({ Name = "Other", Side = "Left" })
                Elements.Sections.OtherSection:CreateDividier()

                Elements.Sections.OtherSection:CreateToggle({
                    Name = "Unlock Mouse",
                    Flag = "UnlockMouseToggle",
                    Callback = function(Bool)
                        local RunService = game:GetService("RunService")
                        local UserInputService = game:GetService("UserInputService")

                        if Bool then
                            OldMouseBehavior = UserInputService.MouseBehavior
                            OldMouseIconEnabled = UserInputService.MouseIconEnabled

                            MouseUnlockConnection = RunService.RenderStepped:Connect(function()
                                if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
                                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                                UserInputService.MouseIconEnabled = true
                            end)
                        else
                            if MouseUnlockConnection then
                                MouseUnlockConnection:Disconnect(); MouseUnlockConnection = nil
                                UserInputService.MouseBehavior = OldMouseBehavior
                                UserInputService.MouseIconEnabled = OldMouseIconEnabled
                            end
                        end
                    end
                }):CreateBind()

                Elements.Sections.OtherSection:CreateToggle({
                    Name = "Auto Unlock Mouse",
                    Flag = "AutoUnlockMouseToggle",
                    Callback = function(Bool)
                        Taskbar:SetAutoUnlockMouse(Bool)
                    end
                })


        Elements.Tabs.ThemeTab = Elements.Window:CreateTab({ Name = "Theme" })
            Elements.Sections.ThemeSavingSection = Elements.Tabs.ThemeTab:CreateSection({ Name = "Save", Side = "Right", Group = "SaveImportTheme" })
                Elements.Sections.ThemeSavingSection:CreateDividier()

                Elements.Dropdowns.ThemesListSave = Elements.Sections.ThemeSavingSection:CreateDropdown({
                    Name = "Themes List",
                    Options = GetConfigs("Theme"),
                    Callback = function(Option) 
                        SelectedTheme = Option
                    end
                })

                Elements.Sections.ThemeSavingSection:CreateTextbox({
                    Name = "Theme Name",
                    Callback = function(Text)
                        Text = Text:gsub(" ", "_")
                        ThemeName = Text
                    end
                })

                Elements.Sections.ThemeSavingSection:CreateDividier()

                Elements.Sections.ThemeSavingSection:CreateButton({
                    Name = "Load",
                    Callback = function()
                        if SelectedTheme == "" then 
                            Taskbar:CreateNotification({ Name = "Select a Theme", Description = "Use 'Themes List'", Group = "SelectAConfigNotify" })
                            return 
                        end

                        local ConfigToLoad = SelectedTheme
                        LoadConfig(SelectedTheme, "Theme", false)
                        Taskbar:CreateNotification({ Name = "Loaded Theme", Description = ConfigToLoad, Group = "LoadConfigNotify" })
                    end
                })

                Elements.Sections.ThemeSavingSection:CreateButton({
                    Name = "Save",
                    DoubleTap = true,
                    Callback = function()
                        if ThemeName == "" then 
                            Taskbar:CreateNotification({ Name = "Enter a Name", Description = "Use 'Theme Name'", Group = "EnterANameNotify" })
                            return 
                        end

                        SaveConfig(ThemeName, "Theme")
                        Taskbar:CreateNotification({ Name = "Saved Theme", Description = ThemeName, Group = "SaveConfigNotify" })

                        Elements.Dropdowns.ThemesListImport:Refresh(GetConfigs("Theme"))
                        Elements.Dropdowns.ThemesListSave:Refresh(GetConfigs("Theme"))
                    end
                })

                Elements.Sections.ThemeSavingSection:CreateButton({
                    Name = "Overwrite",
                    DoubleTap = true,
                    Callback = function()
                        if SelectedTheme == "" then 
                            Taskbar:CreateNotification({ Name = "Select a Theme", Description = "Use 'Themes List'", Group = "SelectAConfigNotify" })
                            return 
                        end

                        SaveConfig(SelectedTheme, "Theme")
                        Taskbar:CreateNotification({ Name = "Overwrited Theme", Description = SelectedTheme, Group = "OverwriteConfigNotify" })

                        Elements.Dropdowns.ThemesListImport:Refresh(GetConfigs("Theme"))
                        Elements.Dropdowns.ThemesListSave:Refresh(GetConfigs("Theme"))
                    end
                })

                Elements.Sections.ThemeSavingSection:CreateButton({
                    Name = "Rename",
                    DoubleTap = true,
                    Callback = function()
                        if ThemeName == "" then 
                            Taskbar:CreateNotification({ Name = "Enter a Name", Description = "Use 'Theme Name'", Group = "EnterANameNotify" })
                            return 
                        end

                        if SelectedTheme == "" then 
                            Taskbar:CreateNotification({ Name = "Select a Theme", Description = "Use 'Themes List'", Group = "SelectAConfigNotify" })
                            return 
                        end

                        DeleteConfig(SelectedTheme, "Theme")
                        SaveConfig(ThemeName, "Theme")

                        Taskbar:CreateNotification({ 
                            Name = "Renamed Theme", 
                            Description = string.format("%s --> %s", SelectedTheme, ThemeName), 
                            Group = "RenameConfigNotify" 
                        })

                        Elements.Dropdowns.ThemesListImport:Refresh(GetConfigs("Theme"))
                        Elements.Dropdowns.ThemesListSave:Refresh(GetConfigs("Theme"))
                    end
                })

                Elements.Sections.ThemeSavingSection:CreateButton({
                    Name = "Delete",
                    DoubleTap = true,
                    Callback = function()
                        if SelectedTheme == "" then 
                            Taskbar:CreateNotification({ Name = "Select a Theme", Description = "Use 'Themes List'", Group = "SelectAConfigNotify" })
                        end

                        DeleteConfig(SelectedTheme, "Theme")
                        Taskbar:CreateNotification({ Name = "Deleted Theme", Description = SelectedTheme, Group = "DeleteAConfigNotify" })

                        Elements.Dropdowns.ThemesListImport:Refresh(GetConfigs("Theme"))
                        Elements.Dropdowns.ThemesListSave:Refresh(GetConfigs("Theme"))
                    end
                })

                Elements.Sections.ThemeSavingSection:CreateDividier()

                Elements.Labels.ThemeAutoloadLabel = Elements.Sections.ThemeSavingSection:CreateLabel({
                    Name = string.format(
                        "Autoload: %s", 
                        ((JSONDecode("TheWorstUIV2/Autoload/Autoload.json") or {}).Theme) or "None"
                    )
                })

                Elements.Sections.ThemeSavingSection:CreateButton({
                    Name = "Add To Autoload",
                    DoubleTap = true,
                    Callback = function()
                        MakeConfigAutoload(SelectedTheme, "Theme", false)
                        Elements.Labels.ThemeAutoloadLabel:Set(string.format("Autoload: %s", SelectedTheme))
                    end
                })

                Elements.Sections.ThemeSavingSection:CreateButton({
                    Name = "Remove Autoload",
                    DoubleTap = true,
                    Callback = function()
                        MakeConfigAutoload(SelectedTheme, "Theme", true)
                        Elements.Labels.ThemeAutoloadLabel:Set("Autoload: None")
                    end
                })

                Elements.Sections.ThemeSavingSection:CreateDividier()

                Elements.Sections.ThemeSavingSection:CreateButton({
                    Name = "Refresh List",
                    Callback = function()
                        Elements.Dropdowns.ThemesListImport:Refresh(GetConfigs("Theme"))
                        Elements.Dropdowns.ThemesListSave:Refresh(GetConfigs("Theme"))
                    end
                })

            Elements.Sections.ThemeImportSection = Elements.Tabs.ThemeTab:CreateSection({ Name = "Export & Import", Side = "Right", Group = "SaveImportTheme" })
                Elements.Sections.ThemeImportSection:CreateDividier()

                Elements.Dropdowns.ThemesListImport = Elements.Sections.ThemeImportSection:CreateDropdown({
                    Name = "Theme List",
                    Options = GetConfigs("Theme"),
                    Callback = function(Option) 
                        SelectedTheme = Option
                    end
                })

                Elements.Sections.ThemeImportSection:CreateTextbox({
                    Name = "Theme Name",
                    Callback = function(Text)
                        Text = Text:gsub(" ", "_")
                        ThemeName = Text
                    end
                })

                Elements.Sections.ThemeImportSection:CreateTextbox({
                    Name = "Theme (Import)",
                    Callback = function(Text)
                        ThemeToImport = Text
                    end
                })

                Elements.Sections.ThemeImportSection:CreateDividier()

                Elements.Sections.ThemeImportSection:CreateButton({
                    Name = "Import",
                    DoubleTap = true,
                    Callback = function()
                        if ThemeToImport == "" then
                            Taskbar:CreateNotification({ Name = "Enter a Theme", Description = "Use 'Theme (Import)'", Group = "EnterAConfigNotify" }) 
                            return
                        end

                        writefile(
                            string.format("TheWorstUIV2/Themes/%s.json", ThemeName), 
                            ThemeToImport
                        )

                        Taskbar:CreateNotification({ Name = "Imported", Description = ThemeName, Group = "ImportedConfigNotify" })

                        Elements.Dropdowns.ThemesListImport:Refresh(GetConfigs("Theme"))
                        Elements.Dropdowns.ThemesListSave:Refresh(GetConfigs("Theme"))
                    end
                })

                Elements.Sections.ThemeImportSection:CreateButton({
                    Name = "Export",
                    DoubleTap = true,
                    Callback = function()
                        if SelectedTheme == "" then 
                            Taskbar:CreateNotification({ Name = "Select a Theme", Description = "Use 'Themes List'", Group = "SelectAConfigNotify" })
                            return 
                        end

                        local ThemeString = readfile(string.format(
                            "TheWorstUIV2/Themes/%s.json", SelectedTheme
                        )); setclipboard(ThemeString)

                        Taskbar:CreateNotification({ Name = "Exported", Description = "To your clipboard.", Group = "ExportedConfigNotify" })
                    end
                })

                Elements.Sections.ThemeImportSection:CreateDividier()

                Elements.Sections.ThemeImportSection:CreateButton({
                    Name = "Refresh List",
                    Callback = function()
                        Elements.Dropdowns.ThemesListImport:Refresh(GetConfigs("Theme"))
                        Elements.Dropdowns.ThemesListSave:Refresh(GetConfigs("Theme"))
                    end
                })

            Elements.Sections.ThemeEditSection = Elements.Tabs.ThemeTab:CreateSection({ Name = "General", Side = "Left" })
                Elements.Sections.ThemeEditSection:CreateDividier()

                Elements.Sections.ThemeEditSection:CreateColorpicker({
                    Name = "Main Color",
                    DefaultColor = Color3.fromRGB(20, 20, 20),
                    DefaultTransparency = 0.4,
                    Flag = "MainColorColorpickerSettingsFrame",
                    Callback = function(Color, Transparency)
                        if not getgenv().SettingsWindowLoaded then return end
                        Taskbar:SetWindowsColor(Color, Transparency, "Main")
                    end
                })

                Elements.Sections.ThemeEditSection:CreateColorpicker({
                    Name = "Second Color",
                    DefaultColor = Color3.fromRGB(240, 240, 240),
                    DefaultTransparency = 0.5,
                    Flag = "SecondColorColorpickerSettingsFrame",
                    Callback = function(Color, Transparency)
                        if not getgenv().SettingsWindowLoaded then return end
                        Taskbar:SetWindowsColor(Color, Transparency, "Second")
                    end
                })

                Elements.Sections.ThemeEditSection:CreateColorpicker({
                    Name = "Third Color",
                    DefaultColor = Color3.fromRGB(0, 0, 0),
                    DefaultTransparency = 0.7,
                    Flag = "ThirdColorColorpickerSettingsFrame",
                    Callback = function(Color, Transparency)
                        if not getgenv().SettingsWindowLoaded then return end
                        Taskbar:SetWindowsColor(Color, Transparency, "Third")
                    end
                })

                Elements.Sections.ThemeEditSection:CreateColorpicker({
                    Name = "Sections Color",
                    DefaultColor = Color3.fromRGB(0, 0, 0),
                    DefaultTransparency = 0.85,
                    Flag = "SectionsColorColorpickerSettingsFrame",
                    Callback = function(Color, Transparency)
                        if not getgenv().SettingsWindowLoaded then return end
                        Taskbar:SetWindowsColor(Color, Transparency, "Sections")
                    end
                })

                Elements.Sections.ThemeEditSection:CreateDividier()

                Elements.Sections.ThemeEditSection:CreateDropdown({
                    Name = "Main Font Face",
                    Options = FontsList,
                    Default = "Code",
                    Flag = "MainFontDropdopwnSettingsFrame",
                    Callback = function(Option) 
                        if not getgenv().SettingsWindowLoaded then return end
                        if Option == "" then return end
                        Taskbar:SetFont({ Font = Option, Type = "Main" })
                    end
                })

                Elements.Sections.ThemeEditSection:CreateColorpicker({
                    Name = "Main Font Color",
                    DefaultColor = Color3.fromRGB(240, 240, 240),
                    DefaultTransparency = 0,
                    Flag = "MainFontColorColorpickerSettingsFrame",
                    Callback = function(Color, Transparency)
                        if not getgenv().SettingsWindowLoaded then return end
                        Taskbar:SetFont({ Color = Color, Transparency = Transparency, Type = "Main" })
                    end
                })

                Elements.Sections.ThemeEditSection:CreateDropdown({
                    Name = "Little Font Face",
                    Options = FontsList,
                    Default = "Code",
                    Flag = "LittleFontDropdownSettingsFrame",
                    Callback = function(Option) 
                        if not getgenv().SettingsWindowLoaded then return end
                        if Option == "" then return end
                        Taskbar:SetFont({ Font = Option, Type = "Little" })
                    end
                })

                Elements.Sections.ThemeEditSection:CreateColorpicker({
                    Name = "Little Font Color",
                    DefaultColor = Color3.fromRGB(240, 240, 240),
                    DefaultTransparency = 0.5,
                    Flag = "LittleFontColorColorpickerSettingsFrame",
                    Callback = function(Color, Transparency)
                        if not getgenv().SettingsWindowLoaded then return end
                        Taskbar:SetFont({ Color = Color, Transparency = Transparency, Type = "Little" })
                    end
                })

                Elements.Sections.ThemeEditSection:CreateDividier()

                Elements.Sections.ThemeEditSection:CreateSlider({
                    Name = "Noise Transparency",
                    Min = 0, 
                    Max = 1,
                    Default = 0.8,
                    Increment = 0.01,
                    Flag = "NoiseTransparencySliderSettingsWindow",
                    Callback = function(Value)
                        if not getgenv().SettingsWindowLoaded then return end
                        Taskbar:SetNoise({ Transparency = Value })
                    end
                })

                Elements.Sections.ThemeEditSection:CreateSlider({
                    Name = "Noise Size",
                    Min = 0.1, 
                    Max = 10,
                    Default = 1,
                    Increment = 0.1,
                    Flag = "NoiseSizeSliderSettingsWindow",
                    Callback = function(Value)
                        if not getgenv().SettingsWindowLoaded then return end
                        Taskbar:SetNoise({ Size = Value })
                    end
                })

        Elements.Tabs.BackgroundTab = Elements.Window:CreateTab({ Name = "Background" })
            Elements.Sections.SavingBackgroundSection = Elements.Tabs.BackgroundTab:CreateSection({ Name = "Save", Side = "Right" })
                Elements.Sections.SavingBackgroundSection:CreateDividier()

                Elements.Dropdowns.BackgroundsListSave = Elements.Sections.SavingBackgroundSection:CreateDropdown({
                    Name = "Images List",
                    Options = GetConfigs("Background"),
                    Callback = function(Option) 
                        SelectedBackground = Option
                    end
                })

                Elements.Sections.SavingBackgroundSection:CreateTextbox({
                    Name = "Image Name",
                    Callback = function(Text)
                        Text = Text:gsub(" ", "_")
                        BackgroundName = Text
                    end
                })

                Elements.Sections.SavingBackgroundSection:CreateTextbox({
                    Name = "Image Link",
                    Callback = function(Text)
                        ImageLink = Text
                    end
                })

                Elements.Sections.SavingBackgroundSection:CreateDividier()

                Elements.Sections.SavingBackgroundSection:CreateButton({
                    Name = "Load",
                    Callback = function()
                        if SelectedBackground == "" then 
                            Taskbar:CreateNotification({ Name = "Select an Image", Description = "Use 'Images List'", Group = "SelectAConfigNotify" })
                            return 
                        end

                        local ConfigToLoad = SelectedBackground
                        LoadConfig(SelectedBackground, "Background", false)
                        Taskbar:CreateNotification({ Name = "Loaded Image", Description = ConfigToLoad, Group = "LoadConfigNotify" })
                    end
                })

                Elements.Sections.SavingBackgroundSection:CreateButton({
                    Name = "Save",
                    DoubleTap = true,
                    Callback = function()
                        if BackgroundName == "" then 
                            Taskbar:CreateNotification({ Name = "Enter a Name", Description = "Use 'Image Name'", Group = "EnterANameNotify" })
                            return 
                        end

                        SaveConfig(BackgroundName, "Background")
                        Taskbar:CreateNotification({ Name = "Saved Image", Description = BackgroundName, Group = "SaveConfigNotify" })

                        Elements.Dropdowns.BackgroundsListSave:Refresh(GetConfigs("Background"))
                    end
                })

                Elements.Sections.SavingBackgroundSection:CreateButton({
                    Name = "Delete",
                    DoubleTap = true,
                    Callback = function()
                        if SelectedBackground == "" then 
                            Taskbar:CreateNotification({ Name = "Select an Image", Description = "Use 'Images List'", Group = "SelectAConfigNotify" })
                        end

                        DeleteConfig(SelectedBackground, "Background")
                        Taskbar:CreateNotification({ Name = "Deleted Image", Description = SelectedBackground, Group = "DeleteAConfigNotify" })

                        Elements.Dropdowns.BackgroundsListSave:Refresh(GetConfigs("Background"))
                    end
                })

                Elements.Sections.SavingBackgroundSection:CreateDividier()

                Elements.Labels.ConfigAutoloadLabel = Elements.Sections.SavingBackgroundSection:CreateLabel({
                    Name = string.format(
                        "Autoload: %s", 
                        ((JSONDecode("TheWorstUIV2/Autoload/Autoload.json") or {}).Background) or "None"
                    )
                })

                Elements.Sections.SavingBackgroundSection:CreateButton({
                    Name = "Add To Autoload",
                    DoubleTap = true,
                    Callback = function()
                        MakeConfigAutoload(SelectedBackground, "Background", false)
                        Elements.Labels.ConfigAutoloadLabel:Set(string.format("Autoload: %s", SelectedBackground))
                    end
                })

                Elements.Sections.SavingBackgroundSection:CreateButton({
                    Name = "Remove Autoload",
                    DoubleTap = true,
                    Callback = function()
                        MakeConfigAutoload(SelectedBackground, "Background", true)
                        Elements.Labels.ConfigAutoloadLabel:Set("Autoload: None")
                    end
                })

                Elements.Sections.SavingBackgroundSection:CreateDividier()

                Elements.Sections.SavingBackgroundSection:CreateButton({
                    Name = "Refresh List",
                    Callback = function()
                        Elements.Dropdowns.BackgroundsListSave:Refresh(GetConfigs("Background"))
                    end
                })
            
            Elements.Sections.EditBackgroundSection = Elements.Tabs.BackgroundTab:CreateSection({ Name = "Edit Background", Side = "Left" })
                Elements.Sections.EditBackgroundSection:CreateDividier()

                Elements.Sliders.BackgroundTransparencySlider = Elements.Sections.EditBackgroundSection:CreateSlider({
                    Name = "Transparency",
                    Min = 0, 
                    Max = 1,
                    Default = 0.1,
                    Increment = 0.01,
                    Flag = "BackgroundTransparencySliderSettingsWindow",
                    Callback = function(Value)
                        if not getgenv().SettingsWindowLoaded then return end
                        Taskbar:SetBackground({ Transparency = Value })
                    end,
                    InputEndedCallback = function(Value)
                        local Config = {Transparency = Value}
                        writefile("TheWorstUIV2/Backgrounds/Config.json", JSONEncode(Config))
                        Taskbar:CreateNotification({ Name = "Saved Transparency", Description = tostring(Value), Group = "SaveConfigNotify" })
                    end
                })

                do
                    local Config = JSONDecode("TheWorstUIV2/Backgrounds/Config.json")
                    Elements.Sliders.BackgroundTransparencySlider:Set(Config and Config.Transparency or 0.1)
                end


    getgenv().SettingsWindowLoaded = true
end

function SettingsWindow:LoadAutoloadConfigs() CheckAllFiles()
    local UI = getgenv().UI
    local Taskbar = UI and UI.Taskbar
    if not Taskbar then
        error("[TheWorstUI V2]: Missing UI / Taskbar")
        return
    end

    local TableAutoload = JSONDecode("TheWorstUIV2/Autoload/Autoload.json") or {}

    task.spawn(function()
        TableAutoload.Configs = TableAutoload.Configs or {}; if TableAutoload.Configs[tostring(game.PlaceId)] ~= nil then 
            task.spawn(LoadConfig, TableAutoload.Configs[tostring(game.PlaceId)], "Config")
        end

        if TableAutoload["Theme"] ~= nil then task.spawn(LoadConfig, TableAutoload.Theme, "Theme") end
        if TableAutoload["Background"] ~= nil then task.spawn(LoadConfig, TableAutoload.Background, "Background") end
    end)

    local Data = JSONDecode("TheWorstUIV2/SizesAndPositions/Windows.json") or {}
    local DataToSave = Data

    for _, Window in UI.Windows do
        Window.Frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
            if not Window.CanSaveSize then return end
            DataToSave[Window.WindowName] = DataToSave[Window.WindowName] or {}
            DataToSave[Window.WindowName].Position = { X = Window.Frame.AbsolutePosition.X, Y = Window.Frame.AbsolutePosition.Y }
        end)

        Window.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            if not Window.CanSaveSize then return end
            DataToSave[Window.WindowName] = DataToSave[Window.WindowName] or {}
            DataToSave[Window.WindowName].Size = { X = Window.Frame.AbsoluteSize.X, Y = Window.Frame.AbsoluteSize.Y }
        end)

        Window.Frame.InputEnded:Connect(function()
            writefile("TheWorstUIV2/SizesAndPositions/Windows.json", JSONEncode(DataToSave))
        end)

        if Data ~= {} and Data[Window.WindowName] ~= nil and Data[Window.WindowName].Position ~= nil and Data[Window.WindowName].Size ~= nil then
            Window.OldPosition = UDim2.new(0, Data[Window.WindowName].Position.X, 0, Data[Window.WindowName].Position.Y)
            Window.OldSize = UDim2.new(0, Data[Window.WindowName].Size.X, 0, Data[Window.WindowName].Size.Y)
        end
    end
end

return SettingsWindow
