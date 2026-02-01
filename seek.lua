local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "🥚 Steal and Hatch a Brainrot Egg",
    LoadingTitle = "Brainrot Egg Hatching Tools",
    LoadingSubtitle = "by しゅう",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BrainrotEgg",
        FileName = "Settings"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Hello"}
    }
})

-- サービス取得
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")

-- メインページ
local MainTab = Window:CreateTab("🏠 メイン", 4483362458)

-- 自動孵化セクション
local AutoHatchSection = MainTab:CreateSection("自動孵化")

local AutoHatchToggle = MainTab:CreateToggle({
    Name = "自動孵化を有効化",
    CurrentValue = false,
    Flag = "AutoHatchToggle",
    Callback = function(Value)
        _G.AutoHatch = Value
        if Value then
            Rayfield:Notify({
                Title = "自動孵化",
                Content = "自動孵化を開始しました",
                Duration = 3,
                Image = 4483362458,
            })
            autoHatchLoop()
        else
            Rayfield:Notify({
                Title = "自動孵化",
                Content = "自動孵化を停止しました",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

function autoHatchLoop()
    spawn(function()
        while _G.AutoHatch do
            RemoteEvent:FireServer({"HatchEgg"}) -- ゲームの実際のリモートイベント名に合わせる
            wait(1) -- 孵化間隔
        end
    end)
end

-- アイテム増殖防止セクション
local AntiSection = MainTab:CreateSection("保護機能")

local AntiAFKToggle = MainTab:CreateToggle({
    Name = "AFKキック防止",
    CurrentValue = false,
    Flag = "AntiAFKToggle",
    Callback = function(Value)
        _G.AntiAFK = Value
        if Value then
            local vu = game:GetService("VirtualUser")
            game:GetService("Players").LocalPlayer.Idled:connect(function()
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
            Rayfield:Notify({
                Title = "AFK防止",
                Content = "AFKキック防止を有効化しました",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- ショップページ
local ShopTab = Window:CreateTab("🛒 ショップ", 4483362458)

local EggShopSection = ShopTab:CreateSection("エッグショップ")

-- エッグ購入ボタンを動的に生成
local eggTypes = {
    {"通常エッグ", 1},
    {"ゴールドエッグ", 2},
    {"ダイヤモンドエッグ", 3},
    {"ブラッドムーンエッグ", 4},
    {"陰陽エッグ", 5}
}

for _, eggData in pairs(eggTypes) do
    local eggName = eggData[1]
    local categoryId = eggData[2]
    
    ShopTab:CreateButton({
        Name = eggName .. "を購入",
        Callback = function()
            -- ショップフレームを開く処理（ゲームの既存機能をトリガー）
            local ScreenGui = LocalPlayer.PlayerGui:WaitForChild("ScreenGui")
            if ScreenGui then
                -- ショップを開く
                RemoteEvent:FireServer({"OpenShop", categoryId})
                Rayfield:Notify({
                    Title = "ショップ",
                    Content = eggName .. "の購入画面を開きました",
                    Duration = 3,
                    Image = 4483362458,
                })
            end
        end,
    })
end

-- ゲームパス購入セクション
local GamepassSection = ShopTab:CreateSection("ゲームパス")

local gamepasses = {
    {"ダブルハッチ", "DoubleHatch"},
    {"トリプルハッチ", "TripleHatch"},
    -- 必要に応じて追加
}

for _, passData in pairs(gamepasses) do
    local passName = passData[1]
    local passKey = passData[2]
    
    ShopTab:CreateButton({
        Name = passName .. "を購入",
        Callback = function()
            RemoteEvent:FireServer({"BuyGamePass_Request", passKey, 0})
            Rayfield:Notify({
                Title = "ゲームパス購入",
                Content = passName .. "の購入をリクエストしました",
                Duration = 3,
                Image = 4483362458,
            })
        end,
    })
end

-- プレイヤーページ
local PlayerTab = Window:CreateTab("👤 プレイヤー", 4483362458)

-- ギフト機能セクション
local GiftSection = PlayerTab:CreateSection("ギフト機能")

local playerList = {}
local selectedPlayer = nil

-- プレイヤーリストを更新
local function updatePlayerList()
    playerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
end

local PlayerDropdown = PlayerTab:CreateDropdown({
    Name = "プレイヤーを選択",
    Options = playerList,
    CurrentOption = "",
    Flag = "PlayerDropdown",
    Callback = function(Option)
        selectedPlayer = Option
    end,
})

PlayerTab:CreateButton({
    Name = "プレイヤーリストを更新",
    Callback = function()
        updatePlayerList()
        PlayerDropdown:Set(playerList)
        Rayfield:Notify({
            Title = "プレイヤーリスト",
            Content = "プレイヤーリストを更新しました",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- ギフト送信
local GiftItemDropdown = PlayerTab:CreateDropdown({
    Name = "贈るアイテムを選択",
    Options = {"通常エッグ", "ゴールドエッグ", "ダイヤモンドエッグ"},
    CurrentOption = "通常エッグ",
    Flag = "GiftItemDropdown",
    Callback = function(Option)
        _G.SelectedGiftItem = Option
    end,
})

PlayerTab:CreateButton({
    Name = "選択したプレイヤーにギフトを送る",
    Callback = function()
        if not selectedPlayer then
            Rayfield:Notify({
                Title = "エラー",
                Content = "プレイヤーを選択してください",
                Duration = 3,
                Image = 4483362458,
            })
            return
        end
        
        -- 対象プレイヤーを取得
        local targetPlayer = nil
        for _, player in pairs(Players:GetPlayers()) do
            if player.Name == selectedPlayer then
                targetPlayer = player
                break
            end
        end
        
        if targetPlayer then
            -- ゲームのギフト機能を使用
            local ScreenGui = LocalPlayer.PlayerGui:WaitForChild("ScreenGui")
            if ScreenGui then
                -- ギフト対象を設定
                ScreenGui.Shop_Frame.GiftPlayer_Frame.SelectedPlayer.UserId.Value = targetPlayer.UserId
                
                -- ギフト確認画面を表示
                RemoteEvent:FireServer({"GiftRequest", _G.SelectedGiftItem, targetPlayer.UserId})
                
                Rayfield:Notify({
                    Title = "ギフト送信",
                    Content = selectedPlayer .. "に" .. _G.SelectedGiftItem .. "を贈りました",
                    Duration = 5,
                    Image = 4483362458,
                })
            end
        end
    end,
})

-- リバースページ
local RebirthTab = Window:CreateTab("♻️ リバース", 4483362458)

local RebirthSection = RebirthTab:CreateSection("転生機能")

RebirthTab:CreateButton({
    Name = "リバースを実行",
    Callback = function()
        RemoteEvent:FireServer({"Rebirth_Request"})
        Rayfield:Notify({
            Title = "リバース",
            Content = "転生を実行しました",
            Duration = 5,
            Image = 4483362458,
        })
    end,
})

-- リバース統計情報（仮の例）
RebirthTab:CreateLabel("現在のリバース回数: 取得中...")
RebirthTab:CreateLabel("次のリバースボーナス: 計算中...")

-- 自動リバース機能
local AutoRebirthToggle = RebirthTab:CreateToggle({
    Name = "自動リバース",
    CurrentValue = false,
    Flag = "AutoRebirthToggle",
    Callback = function(Value)
        _G.AutoRebirth = Value
        if Value then
            spawn(function()
                while _G.AutoRebirth do
                    -- 条件をチェックしてリバース（ここでは仮に10秒ごと）
                    RemoteEvent:FireServer({"Rebirth_Request"})
                    wait(10)
                end
            end)
            Rayfield:Notify({
                Title = "自動リバース",
                Content = "自動リバースを開始しました",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- 設定ページ
local SettingsTab = Window:CreateTab("⚙️ 設定", 4483362458)

local UISettings = SettingsTab:CreateSection("UI設定")

SettingsTab:CreateLabel("UIテーマ設定")

local ThemeDropdown = SettingsTab:CreateDropdown({
    Name = "テーマを選択",
    Options = {"Default", "Dark", "Light", "Aqua"},
    CurrentOption = "Default",
    Flag = "ThemeDropdown",
    Callback = function(Option)
        Window:SetTheme(Option)
    end,
})

SettingsTab:CreateButton({
    Name = "UIを非表示",
    Callback = function()
        Rayfield:Destroy()
    end,
})

SettingsTab:CreateButton({
    Name = "UIを再表示",
    Callback = function()
        Rayfield:LoadConfiguration()
    end,
})

-- ゲーム設定セクション
local GameSettings = SettingsTab:CreateSection("ゲーム設定")

-- ゲーム内設定を同期
local settingsList = {
    {"効果音", "SoundEffects"},
    {"背景音楽", "BackgroundMusic"},
    {"パーティクル", "Particles"},
    {"画面シェイク", "ScreenShake"}
}

for _, setting in pairs(settingsList) do
    local settingName = setting[1]
    local settingKey = setting[2]
    
    SettingsTab:CreateToggle({
        Name = settingName .. "を有効化",
        CurrentValue = true,
        Flag = settingKey .. "Toggle",
        Callback = function(Value)
            RemoteEvent:FireServer({"Settings", settingKey, Value})
        end,
    })
end

-- 初期化時にプレイヤーリストを更新
updatePlayerList()
PlayerDropdown:Set(playerList)

-- 通知で完了を知らせる
Rayfield:Notify({
    Title = "🥚 Brainrot Egg ツール",
    Content = "しゅう様のツールが読み込まれました！",
    Duration = 6.5,
    Image = 4483362458,
})

-- 既存のゲーム機能との互換性を確保
local ScreenGui = LocalPlayer.PlayerGui:WaitForChild("ScreenGui")
if ScreenGui then
    -- ゲームの既存ボタンと競合しないように注意
    Rayfield:Notify({
        Title = "互換性",
        Content = "ゲームの既存UIと併用できます",
        Duration = 4,
        Image = 4483362458,
    })
end

-- キーバインド設定（オプション）
local Input = game:GetService("UserInputService")
Input.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.RightControl then
            Rayfield:Destroy()
        elseif input.KeyCode == Enum.KeyCode.RightShift then
            Rayfield:LoadConfiguration()
        end
    end
end)
