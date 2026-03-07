local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/magbux/BorealisUiLib/refs/heads/main/MobileUI"))()

local Window = Library:Window("殺脚本被遗弃 - 动画播放器")

local FengYu = Window:Tab("〖使用方法】")
local Feng = Window:Tab("〖动画】")
local FengTab = Window:Tab("〖另外】")

local Exclusive_Emotes = {}
local Gettable_Emotes = {}
local Emotes = {}
local Camera = workspace.CurrentCamera
local lplr = game.Players.LocalPlayer
local lchr = nil
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = ReplicatedStorage.Assets
local emotes = Assets.Emotes

local ExtraEmotes = {
	MinionBreakdown = {
		["DisplayName"] = "Minion Breakdown",
		["Description"] = "3 Million Orb",
		["AssetID"] = "rbxassetid://89449841864319",
		["SFX"] = "rbxassetid://1838457617",
		["CUSTOMASSET"] = "https://raw.githubusercontent.com/1MP3LT3/ScriptHub/refs/heads/main/Sounds/ILLIT%20(%EC%95%84%EC%9D%B4%EB%A6%BF)%20'NOT%20CUTE%20ANYMORE%E2%80%99%20Official%20MV.mp3",
		["SFXProperties"] = {
			["Looped"] = false,
		},
		["CreatedServer"] = function(p4)
			local v5 = p4.Character
			if v5 then
				local v_u_6 =
					game:GetService("ReplicatedStorage").Assets.Skins.Killers["1x1x1x1"].Abyss1x1x1x1.Config.ZombieEmote
						:Clone()
				v_u_6.Name = "EmoteZombie"
				v_u_6.PrimaryPart.Anchored = true
				for _, v7 in v_u_6:GetDescendants() do
					if v7:IsA("BasePart") then
						v7.CanCollide = false
						v7.CanQuery = false
						v7.CanTouch = false
					end
				end
				v_u_6:SetPrimaryPartCFrame(v5.PrimaryPart.CFrame)
				v_u_6.Parent = workspace.Misc
				v_u_6.Dummy:FindFirstChildOfClass("Animator"):LoadAnimation(v_u_6.Animation):Play()
				task.delay(20.4, function()
					if v_u_6 ~= nil then
						v_u_6:Destroy()
					end
				end)
			end
		end,
		["DestroyedServer"] = function(p4)
			local v5 = workspace.Misc
			if v5 then
				if v5:FindFirstChild("EmoteZombie") then
					v5:FindFirstChild("EmoteZombie"):Destroy()
				end
			end
		end,
	},
	AnnhilationGuitar = {
		["DisplayName"] = "Guitar",
		["Description"] = "Guitar",
		["AssetID"] = "rbxassetid://77434400165211",
		["SFX"] = "rbxassetid://101986282901846",
		["SFXProperties"] = {
			["Looped"] = false,
		},
		["Created"] = function(p4)
			local chr = p4.Character
			local Guitar =
				game:GetService("ReplicatedStorage").Assets.Skins.Killers.JohnDoe.AnnihilationJohnDoe.Rig.Guitar:Clone()
			Guitar.Name = "Guitar"
			Guitar.Parent = chr
			Guitar.Transparency = 0
		end,
		["Destroyed"] = function(p7)
			local v8 = p7.Character
			local v9 = v8 and v8:FindFirstChild("Guitar")
			if v9 then
				v9.Transparency = 1
			end
		end,
	},
	bluudanc = {
		["DisplayName"] = "bluudanc",
		["Description"] = "yayyy wahooo weeeeee",
		["AssetID"] = "rbxassetid://70756604276888",
		["SFX"] = "rbxassetid://128124155529803",
		["SFXProperties"] = {
			["Looped"] = true,
		},
	},
	prettydanc = {
		["DisplayName"] = "pretty dance",
		["Description"] = "yayyy wahooo weeeeee",
		["AssetID"] = "rbxassetid://85315044663872",
		["SFX"] = "rbxassetid://119720647959535",
		["SFXProperties"] = {
			["Looped"] = true,
			["Volume"] = 0.7,
		},
	},
	Snap = {
		["DisplayName"] = "Snap",
		["Description"] = " ",
		["Speed"] = 6,
		["AssetID"] = "rbxassetid://132946177664650",
		["SFX"] = "rbxassetid://128566549159266",
		["SFXProperties"] = {
			["Looped"] = true,
		},
	},
}

local function safecall(func)
	task.spawn(function()
		pcall(func)
	end)
end

local function GetMAX(Table)
	local MAX = 0
	for _, _ in pairs(Table) do
		MAX = MAX + 1
	end
	if MAX == 0 then
		MAX = 1
	end
	return MAX
end

local function SetupUpdateCharacter()
	if lplr.Character then
		lchr = lplr.Character
	end

	lplr.CharacterAdded:Connect(function(chrA)
		lchr = chrA
	end)
	lplr.CharacterRemoving:Connect(function()
		lchr = nil
	end)
end
SetupUpdateCharacter()

local function LoadEmote(Emote, RequiredEmoteS)
	local RequiredEmote = RequiredEmoteS or table.clone(require(Emote))
	local AudioProps = RequiredEmote.SFXProperties

	local AnimId = RequiredEmote.AssetID
	local AudioId = RequiredEmote.SFX

	local Audios = {}
	local AnimTracks = {}

	local function AnimTP(AnimationId)
		local Anim = Instance.new("Animation")
		Anim.AnimationId = AnimationId
		local AnimT = lchr:WaitForChild("Humanoid", 5):WaitForChild("Animator", 5):LoadAnimation(Anim)
		return AnimT
	end

	local function CreateAudio(SoundId, IsLooped)
		local Audio = Instance.new("Sound", lchr.PrimaryPart)
		Audio.Looped = IsLooped or false
		Audio.Name = Emote.Name

		if RequiredEmote.CUSTOMASSET then
			local response = request({
				Url = RequiredEmote.CUSTOMASSET,
				Method = "GET",
			})
			writefile("CustomMusic.mp3", response.Body)
			Audio.SoundId = getcustomasset("CustomMusic.mp3", false)
		else
			Audio.SoundId = SoundId
		end
		return Audio
	end

	if typeof(AnimId) == "string" then
		local Number = 1
		local AnimT = AnimTP(AnimId)
		AnimTracks[tostring(Number)] = AnimT
	elseif typeof(AnimId) == "table" then
		for Number, Anim in ipairs(AnimId) do
			local AnimT = AnimTP(Anim)
			AnimTracks[tostring(Number)] = AnimT
		end
	end

	if typeof(AudioId) == "string" then
		local Number = 1
		Audios[tostring(Number)] = CreateAudio(AudioId)
	elseif typeof(AudioId) == "table" then
		for Number, Audio in pairs(AudioId) do
			Audios[tostring(Number)] = CreateAudio(Audio)
		end
	end

	if AudioProps then
		for _, Audio in pairs(Audios) do
			for AudioPropName, AudioPropVal in AudioProps do
				if typeof(AudioPropVal) == "number" and AudioPropVal == 0 then
					continue
				end
				Audio[AudioPropName] = AudioPropVal
			end
		end
	end

	Emotes[Emote.Name] = {
		StartFunction = RequiredEmote.Created or RequiredEmote.CreatedServer or nil,
		EndFunction = RequiredEmote.Destroyed or RequiredEmote.DestroyedServer or nil,
		LoopedFunction = RequiredEmote.Looped or RequiredEmote.LoopedServer or nil,

		StartAnimation = RequiredEmote.AssetID.Start and AnimTP(RequiredEmote.AssetID.Start),
		StartAudio = RequiredEmote.SFX.Start and CreateAudio(RequiredEmote.SFX.Start),

		LoopAnimation = RequiredEmote.AssetID.Loop and AnimTP(RequiredEmote.AssetID.Loop),
		LoopAudio = RequiredEmote.SFX.Loop and CreateAudio(RequiredEmote.SFX.Loop, true),

		Audios = Audios,
		AnimTracks = AnimTracks,
		RequiredEmote = RequiredEmote,
	}
end

local function UpdateEmotes()
	repeat
		task.wait()
	until lchr and lchr.PrimaryPart

	for EmoteName, ExtraEmote in ExtraEmotes do
		LoadEmote({ Name = tostring(EmoteName) }, ExtraEmote)
	end

	for _, Emote in emotes:GetChildren() do
		safecall(function()
			LoadEmote(Emote)
		end)
	end
end

local function EmoteUseNormal(mobile)
	local Hum = lchr:FindFirstChild("Humanoid")
	local EmoteName = nil

	if not Hum then return end

	for _, Emote in emotes:GetChildren() do
		local requireEmote = require(Emote)
		if requireEmote.DisplayName == _G.Emotes then
			EmoteName = Emote.Name
		end
	end
	for ExtraEmoteName, ExtraEmote in ExtraEmotes do
		if ExtraEmote.DisplayName == _G.Emotes then
			EmoteName = ExtraEmoteName
		end
	end
	if not EmoteName then return end

	local SpeedMultipliers = lchr:FindFirstChild("SpeedMultipliers")
	if not SpeedMultipliers then return end
	local EmoteHACK = SpeedMultipliers:FindFirstChild("EmoteHACK")

	if EmoteHACK then
		if getgenv().StopEmoting then
			getgenv().StopEmoting()
		end
		EmoteHACK:Destroy()
	end

	local TableForFunctions = nil
	local ADEmote = Emotes[EmoteName]

	EmoteHACK = Instance.new("NumberValue")
	EmoteHACK.Value = 0
	EmoteHACK.Name = "EmoteHACK"
	EmoteHACK.Parent = SpeedMultipliers

	local Audios = ADEmote.Audios
	local AnimTracks = ADEmote.AnimTracks
	local Audio = nil
	local AnimTrack = nil

	Camera.CameraSubject = lchr:FindFirstChild("Head")

	local Connections = {}
	local RequiredEmote = ADEmote.RequiredEmote

	if RequiredEmote.Speed then
		EmoteHACK.Value = RequiredEmote.Speed / (Hum.WalkSpeed or 12)
		if RequiredEmote.Speed > Hum.WalkSpeed then
			EmoteHACK.Value = 1
		end
	end

	local LoopedAnimT = ADEmote.LoopAnimation
	local LoopSound = ADEmote.LoopAudio
	local StartAnimT = ADEmote.StartAnimation
	local StartSound = ADEmote.StartAudio

	if StartAnimT and LoopSound and StartSound and LoopedAnimT then
		StartAnimT:Play()
		StartSound:Play()
	end

	local RandomNumber = math.random(1, GetMAX(AnimTracks))
	for Number, AnimTrackP in pairs(AnimTracks) do
		if RandomNumber == tonumber(Number) then
			AnimTrack = AnimTrackP
			AnimTrack:Play()
		end
	end

	RandomNumber = ((GetMAX(AnimTracks) == GetMAX(Audios)) and RandomNumber) or math.random(1, GetMAX(Audios))
	for Number, AudioP in pairs(Audios) do
		if RandomNumber == tonumber(Number) then
			Audio = AudioP
			Audio.Name = "PlayerEmoteSFX"
			Audio:Play()
		end
	end

	TableForFunctions = {
		Character = lchr,
		Emote = {
			Animation = AnimTrack and AnimTrack.Animation,
			KeyframeReached = (ADEmote.LoopAnimation and ADEmote.LoopAnimation.KeyframeReached) or AnimTrack.KeyframeReached,
			SFX = Audio,
		},
	}

	safecall(function()
		if ADEmote.StartFunction then
			ADEmote.StartFunction(TableForFunctions)
		end
	end)

	getgenv().StopEmoting = function()
		Camera.CameraSubject = lchr:FindFirstChild("Humanoid")

		safecall(function() AnimTrack:Stop() end)
		safecall(function() StartAnimT:Stop() end)
		safecall(function() StartSound:Stop() end)
		safecall(function() LoopedAnimT:Stop() end)
		safecall(function() LoopSound:Stop() end)
		safecall(function() Audio:Stop(); Audio.Name = EmoteName end)
		safecall(function() EmoteHACK:Destroy() end)

		for _, Connection in Connections do
			Connection:Disconnect()
		end

		safecall(function()
			if ADEmote.EndFunction then
				ADEmote.EndFunction(TableForFunctions)
			end
		end)

		getgenv().StopEmoting = nil
	end

	local StartAnimTConnection = StartAnimT and StartAnimT.Stopped:Connect(function()
		task.wait()
		if getgenv().StopEmoting then
			LoopedAnimT:Play()
			AnimTrack:Play()
			if ADEmote.LoopedFunction then
				ADEmote.LoopedFunction(TableForFunctions)
			end
		end
	end)

	local LoopedAnimTConnection = LoopedAnimT and LoopedAnimT.Stopped:Connect(function()
		task.wait()
		if getgenv().StopEmoting then
			getgenv().StopEmoting()
		end
	end)

	local JumpConnection = Hum.Jumping:Connect(function()
		task.wait()
		if getgenv().StopEmoting then
			getgenv().StopEmoting()
		end
	end)

	local DiedConnection = Hum.Died:Connect(function()
		task.wait()
		if getgenv().StopEmoting then
			getgenv().StopEmoting()
		end
	end)

	local HealthChangedConnection = Hum.HealthChanged:Connect(function()
		task.wait()
		if getgenv().StopEmoting then
			getgenv().StopEmoting()
		end
	end)

	table.insert(Connections, HealthChangedConnection)
	table.insert(Connections, DiedConnection)
	table.insert(Connections, LoopedAnimTConnection)
	table.insert(Connections, StartAnimTConnection)
	table.insert(Connections, JumpConnection)
end

local function EmoteUseCopy(mobile)
	local EmoteName = nil

	for _, Emote in emotes:GetChildren() do
		local requireEmote = require(Emote)
		if requireEmote.DisplayName == _G.Emotes then
			EmoteName = Emote.Name
		end
	end

	if _G.SepecialDropdownForE == "Force" then
		local args = {
			[1] = "PlayEmote",
			[2] = "Animations",
			[3] = EmoteName,
		}
		game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):FindFirstChild("Network"):FindFirstChild("RemoteEvent"):FireServer(unpack(args))

		if mobile then
			task.spawn(function()
				while true do
					task.wait(0.1)
					if _G.OFF then
						safecall(function()
							local args = { [1] = "PlayEmote", [2] = "Animations", [3] = EmoteName }
							game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):FindFirstChild("Network"):FindFirstChild("RemoteEvent"):FireServer(unpack(args))
						end)
						safecall(function()
							local args = { "PlayEmote", { buffer.fromstring('"Animations"'), buffer.fromstring('"' .. EmoteName .. '"') } }
							game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
						end)
						break
					end
				end
			end)
		else
			local Endput = game:GetService("UserInputService").InputBegan:Connect(function(input)
				if input.KeyCode == _G.KeybindStop then
					safecall(function()
						local args = { [1] = "StopEmote", [2] = "Animations", [3] = EmoteName }
						game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):FindFirstChild("Network"):FindFirstChild("RemoteEvent"):FireServer(unpack(args))
					end)
					safecall(function()
						local args = { "StopEmote", { buffer.fromstring('"Animations"'), buffer.fromstring('"' .. EmoteName .. '"') } }
						game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
					end)
					Endput:Disconnect()
				end
			end)
		end
	end
end

function PlayEmote(mobile)
	if _G.SepecialDropdownForE == "Original" then
		EmoteUseNormal(mobile)
	else
		EmoteUseCopy(mobile)
	end
end

safecall(UpdateEmotes)
lplr.CharacterAdded:Connect(UpdateEmotes)

for _, Emote in emotes:GetChildren() do
	local requireEmote = require(Emote)
	if requireEmote.Exclusive then
		table.insert(Exclusive_Emotes, requireEmote.DisplayName)
	else
		table.insert(Gettable_Emotes, requireEmote.DisplayName)
	end
end

for _, ExtraEmote in ExtraEmotes do
	table.insert(Exclusive_Emotes, ExtraEmote.DisplayName)
end

FengYu:Label("两个下拉式动画")
FengYu:Label("先选择播放模式再选动画")
FengYu:Label("作者：风御 X")

Feng:Dropdown("普通动画", Gettable_Emotes, function(selected)
    _G.Emotes = selected
end)

Feng:Dropdown("专属动画", Exclusive_Emotes, function(selected)
    _G.Emotes = selected
end)

Feng:Dropdown("播放模式", {"Original", "Force"}, function(selected)
    _G.SepecialDropdownForE = selected
end)

Feng:Button("播放动画", function()
    _G.OFF = false
    PlayEmote(true)
end)

Feng:Button("停止动画", function()
    _G.OFF = true
    if getgenv().StopEmoting then
        getgenv().StopEmoting()
    end
end)

FengTab:Button("滚出去", function()
    game:GetService("CoreGui"):FindFirstChild("BorealisPurple"):Destroy()
end)