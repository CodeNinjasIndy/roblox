-- Create a reference to our Tween service which is used to create animations.
-- More info can be found here: https://create.roblox.com/docs/reference/engine/classes/TweenService
local TweenService = game:GetService(("TweenService"))

-- Create a local variable for all of the pieces required in this script.
local door = script.Parent.Door
local hinge = script.Parent.Hinge
local window = script.Parent.Window
local prompt = window.ProximityPrompt
local isDoorClosed = true

local doorOpenedPosForward = {}
doorOpenedPosForward.CFrame = hinge.CFrame *  CFrame.Angles(0, math.rad(90), 0)

local doorClosedPos = {}
doorClosedPos.CFrame = hinge.CFrame *  CFrame.Angles(0, 0, 0)

local tweenInfo = TweenInfo.new(1)
local tweenOpenForward = TweenService:Create(hinge, tweenInfo, doorOpenedPosForward);
local tweenClose = TweenService:Create(hinge, tweenInfo, doorClosedPos);

-- This is the event that's fired when a player triggers the proximity prompt.
prompt.Triggered:Connect(function(player)
	if isDoorClosed then
		tweenOpenForward:Play()
		prompt.ActionText = "Close"
	else
		tweenClose:Play()
		prompt.ActionText = "Open"
	end
	isDoorClosed = not isDoorClosed
end)