local VRService = game:GetService("VRService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

if not VRService.VREnabled then return end

local ArmScale = Vector3.new(0.6, 1.2, 0.6)
local ArmTransparency = 0.4
local ArmOrientation = CFrame.Angles(math.rad(90), 0, 0)
local ArmPositionOffset = CFrame.new(0, 0.4, 0)

local HipHeight = 2


local Player = game.Players.LocalPlayer
Player.CharacterAdded:Connect(function(Character)
	local Camera = workspace.CurrentCamera

	local Head = Character:WaitForChild("Head")
	local Torso = Character:WaitForChild("Torso")
	local LeftArm = Character:WaitForChild("Left Arm")
	local RightArm = Character:WaitForChild("Right Arm")

	local Humanoid = Character:WaitForChild("Humanoid")
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	Humanoid.RequiresNeck = false
	Humanoid.HipHeight = HipHeight

	Character:WaitForChild("Animate"):Remove()

	Character:WaitForChild("Left Leg"):Remove()
	Character:WaitForChild("Right Leg"):Remove()

	for i, v in pairs(Torso:GetChildren()) do
		if v.ClassName == "Motor6D" and v ~= nil then
			v:Remove()
		end
	end

	Head.Anchored = true
	LeftArm.Anchored = true
	RightArm.Anchored = true

	Head.CanCollide = false
	LeftArm.CanCollide = false
	RightArm.CanCollide = false

	Player.CameraMode = Enum.CameraMode.LockFirstPerson
	VRService.AutomaticScaling = Enum.VRScaling.World
	VRService:RecenterUserHeadCFrame()
	
	LeftArm.Size = ArmScale
	RightArm.Size = ArmScale

	StarterGui:SetCore("VRLaserPointerMode", 1)
	StarterGui:SetCore("VREnableControllerModels", false)

	local function UpdatePlayerPositions()
		Torso.CFrame = Torso.CFrame:Lerp(Camera.Focus * CFrame.new(0, -1, 0), 0)
		HumanoidRootPart.CFrame = HumanoidRootPart.CFrame:ToWorldSpace(Camera.Focus * CFrame.new(0, -1, 0))
		
		local LeftArmOffset = VRService:GetUserCFrame(Enum.UserCFrame.LeftHand).Rotation + VRService:GetUserCFrame(Enum.UserCFrame.LeftHand).Position * Camera.HeadScale
		local RightArmOffset = VRService:GetUserCFrame(Enum.UserCFrame.RightHand).Rotation + VRService:GetUserCFrame(Enum.UserCFrame.RightHand).Position * Camera.HeadScale

		Head.CFrame = Camera.Focus
		LeftArm.CFrame = Camera.CFrame * LeftArmOffset * ArmOrientation * ArmPositionOffset
		RightArm.CFrame = Camera.CFrame * RightArmOffset * ArmOrientation * ArmPositionOffset
	end

	local function SetPartTansparency()
		Torso.LocalTransparencyModifier = 0
		LeftArm.LocalTransparencyModifier = ArmTransparency
		RightArm.LocalTransparencyModifier = ArmTransparency
	end

	RunService.RenderStepped:Connect(UpdatePlayerPositions)
	RunService.RenderStepped:Connect(SetPartTansparency)
end)
