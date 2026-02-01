local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Brainrot Egg - Full Remote Execution",
   LoadingTitle = "しゅう様 専用 完全版",
   LoadingSubtitle = "All Remote Functions Unlocked",
   ConfigurationSaving = { Enabled = true, FolderName = "BrainrotFull" },
   KeySystem = false
})

-- サービス・リモート取得
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 管理用変数
local Flags = {
    AutoFlip = false,
    AutoRebirth = false,
    AutoBuyGear = false,
    SelectedGear = "Basic Gear",
    TargetPlayer = ""
}

-- タブ構成
local MainTab = Window:CreateTab("自動化", 4483362458)
local ShopTab = Window:CreateTab("ショップ/ギフト", 4483362458)
local SettingTab = Window:CreateTab("サーバー設定操作", 4483362458)

--- ### 1. メイン自動化 (Flip & Rebirth) ### ---
MainTab:CreateSection("基本ループ")

MainTab:CreateToggle({
   Name = "自動フリップ (Flip_Request)",
   CurrentValue = false,
   Flag = "Flip",
   Callback = function(v)
      Flags.AutoFlip = v
      task.spawn(function()
         while Flags.AutoFlip do
            RemoteEvent:FireServer({"Flip_Request"})
            task.wait(0.05) -- 最速
         end
      end)
   end,
})

MainTab:CreateToggle({
   Name = "自動転生 (Rebirth_Request)",
   CurrentValue = false,
   Flag = "Rebirth",
   Callback = function(v)
      Flags.AutoRebirth = v
      task.spawn(function()
         while Flags.AutoRebirth do
            RemoteEvent:FireServer({"Rebirth_Request"})
            task.wait(1)
         end
      end)
   end,
})

--- ### 2. ショップ・ギフト (BuyGear/GamePass/Gift) ### ---
ShopTab:CreateSection("ギア・購入")

ShopTab:CreateInput({
   Name = "購入/自動購入するギア名",
   PlaceholderText = "Gear Name...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text) Flags.SelectedGear = Text end,
})

ShopTab:CreateButton({
   Name = "即時購入 (BuyGear_Request)",
   Callback = function()
      RemoteEvent:FireServer({"BuyGear_Request", Flags.SelectedGear})
   end,
})

ShopTab:CreateToggle({
   Name = "ギア自動購入トグル",
   CurrentValue = false,
   Callback = function(v)
      Flags.AutoBuyGear = v
      task.spawn(function()
         while Flags.AutoBuyGear do
            RemoteEvent:FireServer({"Toggle_AutobuyGear_Request", Flags.SelectedGear})
            task.wait(5)
         end
      end)
   end,
})

ShopTab:CreateSection("ギフト攻撃/送信")
ShopTab:CreateInput({
   Name = "ターゲットプレイヤー名",
   PlaceholderText = "Username...",
   Callback = function(t) Flags.TargetPlayer = t end,
})

ShopTab:CreateButton({
   Name = "プレイヤーリスト取得リクエスト",
   Callback = function()
      RemoteEvent:FireServer({"GetPlrList_Request"})
   end,
})

ShopTab:CreateButton({
   Name = "選択したギアをギフト送信",
   Callback = function()
      local target = Players:FindFirstChild(Flags.TargetPlayer)
      if target then
         RemoteEvent:FireServer({"BuyGamePass_Request", Flags.SelectedGear, target.UserId})
      end
   end,
})

--- ### 3. サーバー設定・メタ操作 (Settings/Index) ### ---
SettingTab:CreateSection("クライアント/サーバー設定の強制上書き")

local settingsList = {"Music", "Sfx", "Trade", "Notification"} -- コード内のAttributeから推測
for _, sName in pairs(settingsList) do
    SettingTab:CreateButton({
       Name = "設定強制変更: " .. sName,
       Callback = function()
          RemoteEvent:FireServer({"Settings", sName, true})
          Rayfield:Notify({Title = "Setting Changed", Content = sName .. " を強制有効化しました"})
       end,
    })
end

SettingTab:CreateSection("インデックス操作")
SettingTab:CreateButton({
   Name = "全アイテムIndex通知を既読にする",
   Callback = function()
      -- Index_FrameのNotiを消去する挙動をエミュレート
      RemoteEvent:FireServer({"Settings", "IndexNoti", false})
   end,
})
