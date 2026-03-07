local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/magbux/BorealisUiLib/refs/heads/main/MobileUI"))()

local Window = Library:Window("殺脚本被遗弃 - 动画播放器")

local informTab = Window:Tab("〖使用方法】")
local AnimTab = Window:Tab("〖动画】")
local actionTab = Window:Tab("〖FE动作】")
local animationTab = Window:Tab("〖动作包整合】")
local OtherTab = Window:Tab("〖其他动作】")
local kickTab = Window:Tab("〖另外】")

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

--通知
informTab:Label("两个下拉式动画")
informTab:Label("先选择播放模式再选动画")
informTab:Label("作者：风御 X")

--动画播放器
AnimTab:Dropdown("普通动画", Gettable_Emotes, function(selected)
    _G.Emotes = selected
end)

AnimTab:Dropdown("专属动画", Exclusive_Emotes, function(selected)
    _G.Emotes = selected
end)

AnimTab:Dropdown("播放模式", {"Original", "Force"}, function(selected)
    _G.SepecialDropdownForE = selected
end)

AnimTab:Button("播放动画", function()
    _G.OFF = false
    PlayEmote(true)
end)

AnimTab:Button("停止动画", function()
    _G.OFF = true
    if getgenv().StopEmoting then
        getgenv().StopEmoting()
    end
end)

--FE动作
local vu710 = nil

actionTab:Toggle("撸管", false, function(p711)
    local v712 = game.Players.LocalPlayer
    local v713 = (v712.Character or v712.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
    if v713 then
        if p711 then
            if not (vu710 and vu710.IsPlaying) then
                local v714 = Instance.new("Animation")
                v714.AnimationId = "rbxassetid://72042024"
                vu710 = v713:LoadAnimation(v714)
                vu710.Looped = true
                vu710:Play()
            end
        elseif vu710 and vu710.IsPlaying then
            vu710:Stop()
        end
    end
end)

actionTab:Toggle("张开手臂旋转", false, function(p715)
    local v716 = game.Players.LocalPlayer
    local v717 = (v716.Character or v716.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
    if v717 then
        if p715 then
            if not (vu710 and vu710.IsPlaying) then
                local v718 = Instance.new("Animation")
                v718.AnimationId = "rbxassetid://235542946"
                vu710 = v717:LoadAnimation(v718)
                vu710:Play()
            end
        elseif vu710 and vu710.IsPlaying then
            vu710:Stop()
        end
    end
end)

actionTab:Toggle("旋转手", false, function(p719)
    local v720 = game.Players.LocalPlayer
    local v721 = (v720.Character or v720.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
    if v721 then
        if p719 then
            if not (vu710 and vu710.IsPlaying) then
                local v722 = Instance.new("Animation")
                v722.AnimationId = "rbxassetid://259438880"
                vu710 = v721:LoadAnimation(v722)
                vu710.Looped = true
                vu710:Play()
            end
        elseif vu710 and vu710.IsPlaying then
            vu710:Stop()
        end
    end
end)

--动作包整合
local animationControllers = {}
local animationStates = {}

local function createAnimationController(p740, p741, p742, toggleName)
    local controller = {
        active = false,
        connection = nil,
        characterConnection = nil,
        animations = {},
        animIds = {idle = p740, walk = p741, run = p742},
        toggleName = toggleName
    }
    
    local function setupAnimations(character)
        if not character or not controller.active then return end
        
        local humanoid = character:WaitForChild("Humanoid", 5)
        local rootPart = character:WaitForChild("HumanoidRootPart", 5)
        local animator = humanoid and humanoid:WaitForChild("Animator", 5)
        
        if not humanoid or not rootPart or not animator then return end
        
        for _, anim in pairs(controller.animations) do
            if anim then
                anim:Stop(0.2)
            end
        end
        controller.animations = {}
        
        local function loadAnimation(animId)
            local anim = Instance.new("Animation")
            anim.AnimationId = animId
            return animator:LoadAnimation(anim)
        end
        
        controller.animations.idle = loadAnimation(p740)
        controller.animations.walk = loadAnimation(p741)
        controller.animations.run = loadAnimation(p742)
        
        if controller.connection then
            controller.connection:Disconnect()
        end
        
        controller.connection = game:GetService("RunService").Heartbeat:Connect(function()
            if not controller.active then return end
            if not controller.animations.idle or not controller.animations.walk or not controller.animations.run then return end
            
            local velocity = rootPart.Velocity.Magnitude
            if velocity < 1 then
                if not controller.animations.idle.IsPlaying then
                    controller.animations.idle:Play()
                    controller.animations.walk:Stop(0.2)
                    controller.animations.run:Stop(0.2)
                end
            elseif velocity >= 20 then
                if not controller.animations.run.IsPlaying then
                    controller.animations.run:Play()
                    controller.animations.idle:Stop(0.2)
                    controller.animations.walk:Stop(0.2)
                end
            elseif not controller.animations.walk.IsPlaying then
                controller.animations.walk:Play()
                controller.animations.idle:Stop(0.2)
                controller.animations.run:Stop(0.2)
            end
        end)
    end
    
    local function startAnimation()
        if controller.active then return end
        
        controller.active = true
        animationStates[controller.toggleName] = true
        
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        
        if controller.characterConnection then
            controller.characterConnection:Disconnect()
        end
        
        controller.characterConnection = player.CharacterAdded:Connect(function(newCharacter)
            if controller.active then
                wait(1)
                setupAnimations(newCharacter)
            end
        end)
        
        setupAnimations(character)
    end
    
    local function stopAnimation()
        if not controller.active then return end
        
        controller.active = false
        animationStates[controller.toggleName] = false
        
        if controller.connection then
            controller.connection:Disconnect()
            controller.connection = nil
        end
        
        if controller.characterConnection then
            controller.characterConnection:Disconnect()
            controller.characterConnection = nil
        end
        
        for _, anim in pairs(controller.animations) do
            if anim then
                anim:Stop(0.2)
            end
        end
        controller.animations = {}
    end
    
    return {
        start = startAnimation,
        stop = stopAnimation,
        isActive = function() return controller.active end,
        getToggleName = function() return controller.toggleName end
    }
end

local animationPacks = {
    ["2017动画包"] = {
        idle = "rbxassetid://124622205682529",
        walk = "rbxassetid://99127941563341",
        run = "rbxassetid://99159420513149"
    },
    ["狗王🐶动画包"] = {
        idle = "rbxassetid://135419935358802",
        walk = "rbxassetid://95469909855529",
        run = "rbxassetid://109671225388655"
    },
    ["放松动画包"] = {
        idle = "rbxassetid://132811450080149",
        walk = "rbxassetid://90163253241107",
        run = "rbxassetid://96194626828153"
    },
    ["约翰.多动画包"] = {
        idle = "rbxassetid://105880087711722",
        walk = "rbxassetid://81193817424328",
        run = "rbxassetid://132653655520682"
    },
    ["酷小孩动画包"] = {
        idle = "rbxassetid://18885903667",
        walk = "rbxassetid://18885906143",
        run = "rbxassetid://96571077893813"
    },
    ["诺利动画包"] = {
        idle = "rbxassetid://83465205704188",
        walk = "rbxassetid://116353529220765",
        run = "rbxassetid://117451341682452"
    },
    ["酷动画包"] = {
        idle = "rbxassetid://115268929362938",
        walk = "rbxassetid://123678890237669",
        run = "rbxassetid://132086389849889"
    },
    ["蓝小孩动画包"] = {
        idle = "rbxassetid://115268929362938",
        walk = "rbxassetid://18885906143",
        run = "rbxassetid://96571077893813"
    },
    ["里程四斩首者动画包"] = {
        idle = "rbxassetid://111915677103210",
        walk = "rbxassetid://92337314320765",
        run = "rbxassetid://86125526846131"
    }
}

for packName, animData in pairs(animationPacks) do
    animationControllers[packName] = createAnimationController(
        animData.idle,
        animData.walk,
        animData.run,
        packName
    )
    
    animationTab:Toggle(packName, false, function(state)
        if state then
            animationControllers[packName]:start()
        else
            animationControllers[packName]:stop()
        end
    end)
end

local jeffController = {
    active = false,
    runningAnim = nil,
    idleAnim = nil,
    runningConnection = nil,
    characterConnection = nil
}

local function setupJeffAnimations(character)
    if not jeffController.active then return end
    
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    
    if jeffController.runningAnim then
        jeffController.runningAnim:Stop()
    end
    if jeffController.idleAnim then
        jeffController.idleAnim:Stop()
    end
    
    local runningAnim = Instance.new("Animation")
    runningAnim.AnimationId = "rbxassetid://252557606"
    local idleAnim = Instance.new("Animation")
    idleAnim.AnimationId = "rbxassetid://124622205682529"
    
    jeffController.runningAnim = humanoid:LoadAnimation(runningAnim)
    jeffController.idleAnim = humanoid:LoadAnimation(idleAnim)
    
    if jeffController.runningConnection then
        jeffController.runningConnection:Disconnect()
    end
    
    jeffController.runningConnection = humanoid.Running:Connect(function(speed)
        if not jeffController.active then return end
        if speed > 0 then
            if jeffController.idleAnim and jeffController.idleAnim.IsPlaying then
                jeffController.idleAnim:Stop()
            end
            if jeffController.runningAnim and not jeffController.runningAnim.IsPlaying then
                jeffController.runningAnim.Looped = true
                jeffController.runningAnim:Play()
            end
        else
            if jeffController.runningAnim and jeffController.runningAnim.IsPlaying then
                jeffController.runningAnim:Stop()
            end
            if jeffController.idleAnim and not jeffController.idleAnim.IsPlaying then
                jeffController.idleAnim.Looped = true
                jeffController.idleAnim:Play()
            end
        end
    end)
end

animationTab:Toggle("Jeff the killer动画包", false, function(state)
    if state then
        jeffController.active = true
        
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        
        if jeffController.characterConnection then
            jeffController.characterConnection:Disconnect()
        end
        
        jeffController.characterConnection = player.CharacterAdded:Connect(function(newCharacter)
            if jeffController.active then
                wait(1)
                setupJeffAnimations(newCharacter)
            end
        end)
        
        setupJeffAnimations(character)
    else
        jeffController.active = false
        
        if jeffController.characterConnection then
            jeffController.characterConnection:Disconnect()
            jeffController.characterConnection = nil
        end
        
        if jeffController.runningConnection then
            jeffController.runningConnection:Disconnect()
            jeffController.runningConnection = nil
        end
        
        if jeffController.runningAnim then
            jeffController.runningAnim:Stop()
            jeffController.runningAnim = nil
        end
        
        if jeffController.idleAnim then
            jeffController.idleAnim:Stop()
            jeffController.idleAnim = nil
        end
    end
end)

--其他动作
OtherTab:Toggle("Silly Billy", false, function(state)
    local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local rootPart = char:WaitForChild("HumanoidRootPart")
    local soundName = "Sound_SillyBilly"
    
    if state then
        local oldSound = rootPart:FindFirstChild(soundName)
        if oldSound then oldSound:Destroy() end
        
        humanoid.PlatformStand = true
        humanoid.JumpPower = 0
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Velocity = Vector3.zero
        bodyVelocity.Parent = rootPart
        
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://107464355830477"
        local animationTrack = humanoid:LoadAnimation(animation)
        animationTrack:Play()
        
        local sound = Instance.new("Sound")
        sound.Name = soundName
        sound.SoundId = "rbxassetid://77601084987544"
        sound.Parent = rootPart
        sound.Volume = 0.5
        sound.Looped = false
        sound:Play()
        
        animationTrack.Stopped:Connect(function()
            humanoid.PlatformStand = false
            if bodyVelocity and bodyVelocity.Parent then
                bodyVelocity:Destroy()
            end
            
            local s = rootPart:FindFirstChild(soundName)
            if s then
                s:Stop()
                s:Destroy()
            end
            
            for _, assetName in ipairs({"EmoteHatAsset", "EmoteLighting", "PlayerEmoteHand"}) do
                local asset = char:FindFirstChild(assetName)
                if asset then asset:Destroy() end
            end
        end)
    else
        humanoid.PlatformStand = false
        humanoid.JumpPower = 0
        
        for _, assetName in ipairs({"EmoteHatAsset", "EmoteLighting", "PlayerEmoteHand"}) do
            local asset = char:FindFirstChild(assetName)
            if asset then asset:Destroy() end
        end
        
        local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
        if bodyVelocity then bodyVelocity:Destroy() end
        
        local sound = rootPart:FindFirstChild(soundName)
        if sound then
            sound:Stop()
            sound:Destroy()
        end
        
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            if track.Animation.AnimationId == "rbxassetid://107464355830477" then
                track:Stop()
            end
        end
    end
end)

OtherTab:Toggle("Silly of it", false, function(state)
    local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local rootPart = char:WaitForChild("HumanoidRootPart")
    local soundName = "Sound_SillyOfIt"
    
    if state then
        local oldSound = rootPart:FindFirstChild(soundName)
        if oldSound then oldSound:Destroy() end
        
        humanoid.PlatformStand = true
        humanoid.JumpPower = 0
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Velocity = Vector3.zero
        bodyVelocity.Parent = rootPart
        
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://107464355830477"
        local animationTrack = humanoid:LoadAnimation(animation)
        animationTrack:Play()
        
        local sound = Instance.new("Sound")
        sound.Name = soundName
        sound.SoundId = "rbxassetid://120176009143091"
        sound.Parent = rootPart
        sound.Volume = 0.5
        sound.Looped = false
        sound:Play()
        
        animationTrack.Stopped:Connect(function()
            humanoid.PlatformStand = false
            if bodyVelocity and bodyVelocity.Parent then
                bodyVelocity:Destroy()
            end
            
            local s = rootPart:FindFirstChild(soundName)
            if s then
                s:Stop()
                s:Destroy()
            end
            
            for _, assetName in ipairs({"EmoteHatAsset", "EmoteLighting", "PlayerEmoteHand"}) do
                local asset = char:FindFirstChild(assetName)
                if asset then asset:Destroy() end
            end
        end)
    else
        humanoid.PlatformStand = false
        humanoid.JumpPower = 0
        
        for _, assetName in ipairs({"EmoteHatAsset", "EmoteLighting", "PlayerEmoteHand"}) do
            local asset = char:FindFirstChild(assetName)
            if asset then asset:Destroy() end
        end
        
        local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
        if bodyVelocity then bodyVelocity:Destroy() end
        
        local sound = rootPart:FindFirstChild(soundName)
        if sound then
            sound:Stop()
            sound:Destroy()
        end
        
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            if track.Animation.AnimationId == "rbxassetid://107464355830477" then
                track:Stop()
            end
        end
    end
end)

OtherTab:Toggle("Subterfuge", false, function(state)
    local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local rootPart = char:WaitForChild("HumanoidRootPart")
    local soundName = "Sound_Subterfuge"
    
    if state then
        local oldSound = rootPart:FindFirstChild(soundName)
        if oldSound then oldSound:Destroy() end
        
        humanoid.PlatformStand = true
        humanoid.JumpPower = 0
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Velocity = Vector3.zero
        bodyVelocity.Parent = rootPart
        
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://87482480949358"
        local animationTrack = humanoid:LoadAnimation(animation)
        animationTrack:Play()
        
        local sound = Instance.new("Sound")
        sound.Name = soundName
        sound.SoundId = "rbxassetid://132297506693854"
        sound.Parent = rootPart
        sound.Volume = 2
        sound.Looped = false
        sound:Play()
        
        local args = {
            [1] = "PlayEmote",
            [2] = "Animations",
            [3] = "_Subterfuge"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
        
        animationTrack.Stopped:Connect(function()
            humanoid.PlatformStand = false
            if bodyVelocity and bodyVelocity.Parent then
                bodyVelocity:Destroy()
            end
            
            local s = rootPart:FindFirstChild(soundName)
            if s then
                s:Stop()
                s:Destroy()
            end
        end)
    else
        humanoid.PlatformStand = false
        humanoid.JumpPower = 0
        
        local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
        if bodyVelocity then bodyVelocity:Destroy() end
        
        local sound = rootPart:FindFirstChild(soundName)
        if sound then
            sound:Stop()
            sound:Destroy()
        end
        
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            if track.Animation.AnimationId == "rbxassetid://87482480949358" then
                track:Stop()
            end
        end
    end
end)

OtherTab:Toggle("Aw Shucks", false, function(state)
    local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local rootPart = char:WaitForChild("HumanoidRootPart")
    local soundName = "Sound_AwShucks"
    
    if state then
        local oldSound = rootPart:FindFirstChild(soundName)
        if oldSound then oldSound:Destroy() end
        
        humanoid.PlatformStand = true
        humanoid.JumpPower = 0
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Velocity = Vector3.zero
        bodyVelocity.Parent = rootPart
        
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://74238051754912"
        local animationTrack = humanoid:LoadAnimation(animation)
        animationTrack:Play()
        
        local sound = Instance.new("Sound")
        sound.Name = soundName
        sound.SoundId = "rbxassetid://123236721947419"
        sound.Parent = rootPart
        sound.Volume = 0.5
        sound.Looped = false
        sound:Play()
        
        local args = {
            [1] = "PlayEmote",
            [2] = "Animations",
            [3] = "Shucks"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
        
        animationTrack.Stopped:Connect(function()
            humanoid.PlatformStand = false
            if bodyVelocity and bodyVelocity.Parent then
                bodyVelocity:Destroy()
            end
            
            local s = rootPart:FindFirstChild(soundName)
            if s then
                s:Stop()
                s:Destroy()
            end
        end)
    else
        humanoid.PlatformStand = false
        humanoid.JumpPower = 0
        
        local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
        if bodyVelocity then bodyVelocity:Destroy() end
        
        local sound = rootPart:FindFirstChild(soundName)
        if sound then
            sound:Stop()
            sound:Destroy()
        end
        
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            if track.Animation.AnimationId == "rbxassetid://74238051754912" then
                track:Stop()
            end
        end
    end
end)

OtherTab:Toggle("Miss The Quiet", false, function(state)
    local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local rootPart = char:WaitForChild("HumanoidRootPart")
    local soundName = "Sound_MissTheQuiet"
    
    if state then
        local oldSound = rootPart:FindFirstChild(soundName)
        if oldSound then oldSound:Destroy() end
        
        humanoid.PlatformStand = true
        humanoid.JumpPower = 0
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Velocity = Vector3.zero
        bodyVelocity.Parent = rootPart
        
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://100986631322204"
        local animationTrack = humanoid:LoadAnimation(animation)
        animationTrack:Play()
        
        local sound = Instance.new("Sound")
        sound.Name = soundName
        sound.SoundId = "rbxassetid://131936418953291"
        sound.Parent = rootPart
        sound.Volume = 0.5
        sound.Looped = false
        sound:Play()
        
        animationTrack.Stopped:Connect(function()
            humanoid.PlatformStand = false
            if bodyVelocity and bodyVelocity.Parent then
                bodyVelocity:Destroy()
            end
            
            local s = rootPart:FindFirstChild(soundName)
            if s then
                s:Stop()
                s:Destroy()
            end
            
            for _, assetName in ipairs({"EmoteHatAsset", "EmoteLighting", "PlayerEmoteHand"}) do
                local asset = char:FindFirstChild(assetName)
                if asset then asset:Destroy() end
            end
        end)
    else
        humanoid.PlatformStand = false
        humanoid.JumpPower = 0
        
        for _, assetName in ipairs({"EmoteHatAsset", "EmoteLighting", "PlayerEmoteHand"}) do
            local asset = char:FindFirstChild(assetName)
            if asset then asset:Destroy() end
        end
        
        local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
        if bodyVelocity then bodyVelocity:Destroy() end
        
        local sound = rootPart:FindFirstChild(soundName)
        if sound then
            sound:Stop()
            sound:Destroy()
        end
        
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            if track.Animation.AnimationId == "rbxassetid://100986631322204" then
                track:Stop()
            end
        end
    end
end)

OtherTab:Toggle("VIP (新音频)", false, function(state)
    local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local rootPart = char:WaitForChild("HumanoidRootPart")
    local soundName = "Sound_VIPNew"
    
    if state then
        local oldSound = rootPart:FindFirstChild(soundName)
        if oldSound then oldSound:Destroy() end
        
        humanoid.PlatformStand = true
        humanoid.JumpPower = 0
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Velocity = Vector3.zero
        bodyVelocity.Parent = rootPart
        
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://138019937280193"
        local animationTrack = humanoid:LoadAnimation(animation)
        animationTrack:Play()
        
        local sound = Instance.new("Sound")
        sound.Name = soundName
        sound.SoundId = "rbxassetid://109474987384441"
        sound.Parent = rootPart
        sound.Volume = 0.5
        sound.Looped = true
        sound:Play()
        
        local effect = game:GetService("ReplicatedStorage").Assets.Emotes.HakariDance.HakariBeamEffect:Clone()
        effect.Name = "PlayerEmoteVFX"
        effect.CFrame = char.PrimaryPart.CFrame * CFrame.new(0, -1, -0.3)
        effect.WeldConstraint.Part0 = char.PrimaryPart
        effect.WeldConstraint.Part1 = effect
        effect.Parent = char
        effect.CanCollide = false
        
        local args = {
            [1] = "PlayEmote",
            [2] = "Animations",
            [3] = "HakariDance"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
        
        animationTrack.Stopped:Connect(function()
            humanoid.PlatformStand = false
            if bodyVelocity and bodyVelocity.Parent then
                bodyVelocity:Destroy()
            end
            
            local s = rootPart:FindFirstChild(soundName)
            if s then
                s:Stop()
                s:Destroy()
            end
        end)
    else
        humanoid.PlatformStand = false
        humanoid.JumpPower = 0
        
        local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
        if bodyVelocity then bodyVelocity:Destroy() end
        
        local sound = rootPart:FindFirstChild(soundName)
        if sound then
            sound:Stop()
            sound:Destroy()
        end
        
        local effect = char:FindFirstChild("PlayerEmoteVFX")
        if effect then effect:Destroy() end
        
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            if track.Animation.AnimationId == "rbxassetid://138019937280193" then
                track:Stop()
            end
        end
    end
end)

OtherTab:Toggle("VIP (旧音频)", false, function(state)
    local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local rootPart = char:WaitForChild("HumanoidRootPart")
    local soundName = "Sound_VIPOld"
    
    if state then
        local oldSound = rootPart:FindFirstChild(soundName)
        if oldSound then oldSound:Destroy() end
        
        humanoid.PlatformStand = true
        humanoid.JumpPower = 0
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Velocity = Vector3.zero
        bodyVelocity.Parent = rootPart
        
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://138019937280193"
        local animationTrack = humanoid:LoadAnimation(animation)
        animationTrack:Play()
        
        local sound = Instance.new("Sound")
        sound.Name = soundName
        sound.SoundId = "rbxassetid://87166578676888"
        sound.Parent = rootPart
        sound.Volume = 0.5
        sound.Looped = true
        sound:Play()
        
        local effect = game:GetService("ReplicatedStorage").Assets.Emotes.HakariDance.HakariBeamEffect:Clone()
        effect.Name = "PlayerEmoteVFX"
        effect.CFrame = char.PrimaryPart.CFrame * CFrame.new(0, -1, -0.3)
        effect.WeldConstraint.Part0 = char.PrimaryPart
        effect.WeldConstraint.Part1 = effect
        effect.Parent = char
        effect.CanCollide = false
        
        local args = {
            [1] = "PlayEmote",
            [2] = "Animations",
            [3] = "HakariDance"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
        
        animationTrack.Stopped:Connect(function()
            humanoid.PlatformStand = false
            if bodyVelocity and bodyVelocity.Parent then
                bodyVelocity:Destroy()
            end
            
            local s = rootPart:FindFirstChild(soundName)
            if s then
                s:Stop()
                s:Destroy()
            end
        end)
    else
        humanoid.PlatformStand = false
        humanoid.JumpPower = 0
        
        local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
        if bodyVelocity then bodyVelocity:Destroy() end
        
        local sound = rootPart:FindFirstChild(soundName)
        if sound then
            sound:Stop()
            sound:Destroy()
        end
        
        local effect = char:FindFirstChild("PlayerEmoteVFX")
        if effect then effect:Destroy() end
        
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            if track.Animation.AnimationId == "rbxassetid://138019937280193" then
                track:Stop()
            end
        end
    end
end)

--UI的设置
kickTab:Button("滚出去", function()
    game:GetService("CoreGui"):FindFirstChild("BorealisPurple"):Destroy()
end)