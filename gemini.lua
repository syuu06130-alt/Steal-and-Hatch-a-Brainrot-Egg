local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Steal and Hatch a Brainrot Egg - 専用ハック",
   LoadingTitle = "しゅう様 専用スクリプト",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BrainrotEggConfig",
      FileName = "MainGui"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false
})

-- 変数設定
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")
local AutoFlip = false
local AutoRebirth = false
local AutoBuyGear = false
local SelectedGear = "Basic Gear" -- デフォルト

-- タブ作成
local MainTab = Window:CreateTab("メイン機能", 4483362458)
local ShopTab = Window:CreateTab("ショップ・転生", 4483362458)

--- ### メイン機能セクション ### ---

MainTab:CreateSection("オート機能")

MainTab:CreateToggle({
   Name = "オートクリック (Auto Flip)",
   CurrentValue = false,
   Flag = "AutoFlip",
   Callback = function(Value)
      AutoFlip = Value
      task.spawn(function()
         while AutoFlip do
            RemoteEvent:FireServer({"Flip_Request"})
            task.wait(0.1) -- 負荷調整用
         end
      end)
   end,
})

--- ### ショップ・転生セクション ### ---

ShopTab:CreateSection("自動転生")

ShopTab:CreateToggle({
   Name = "自動転生 (Auto Rebirth)",
   CurrentValue = false,
   Flag = "AutoRebirth",
   Callback = function(Value)
      AutoRebirth = Value
      task.spawn(function()
         while AutoRebirth do
            RemoteEvent:FireServer({"Rebirth_Request"})
            task.wait(1)
         end
      end)
   end,
})

ShopTab:CreateSection("ギア購入")

ShopTab:CreateDropdown({
   Name = "購入するギアを選択",
   Options = {"Basic Gear", "Pro Gear", "God Gear"}, -- ゲーム内の名前に合わせて調整してください
   CurrentOption = {"Basic Gear"},
   MultipleOptions = false,
   Flag = "GearSelection",
   Callback = function(Option)
      SelectedGear = Option[1]
   end,
})

ShopTab:CreateToggle({
   Name = "ギアを自動購入",
   CurrentValue = false,
   Flag = "AutoBuyGear",
   Callback = function(Value)
      AutoBuyGear = Value
      task.spawn(function()
         while AutoBuyGear do
            RemoteEvent:FireServer({"BuyGear_Request", SelectedGear})
            task.wait(2)
         end
      end)
   end,
})

--- ### その他 ### ---
local MiscTab = Window:CreateTab("その他", 4483362458)

MiscTab:CreateButton({
   Name = "UIを閉じる",
   Callback = function()
      Rayfield:Destroy()
   end,
})

Rayfield:Notify({
   Title = "実行完了",
   Content = "しゅう様、スクリプトの読み込みが正常に完了しました。",
   Duration = 5,
   Image = 4483362458,
})
