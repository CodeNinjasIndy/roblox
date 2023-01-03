-- Create a reference to our Tween service which is used to create animations.
-- More info can be found here: https://create.roblox.com/docs/reference/engine/classes/TweenService
local TweenService = game:GetService(("TweenService"))

-- SFX
local sfxDoorOpen = script.Parent["Door Opening"]
local sfxDoorClose = script.Parent["Door Close"]

-- Create a local variable for all of the pieces required in this script.
local door = script.Parent.Door
local hinge = script.Parent.Hinge
local window = script.Parent.Window
local prompt = window.ProximityPrompt

-- Create a variable to determine if this door is currently closed or opened.
local isDoorClosed = true
local autoCloseEnabled = script.Parent:GetAttribute("AutoCloseEnabled")
local autoCloseDelay = 3

local doorOpenedPosForward = {}
doorOpenedPosForward.CFrame = hinge.CFrame *  CFrame.Angles(0, math.rad(90), 0)

local doorOpenedPosBackward = {}
doorOpenedPosBackward.CFrame = hinge.CFrame *  CFrame.Angles(0, math.rad(-90), 0)

local doorClosedPos = {}
doorClosedPos.CFrame = hinge.CFrame *  CFrame.Angles(0, 0, 0)

local tweenInfo = TweenInfo.new(1)
local tweenOpenForward = TweenService:Create(hinge, tweenInfo, doorOpenedPosForward);
local tweenOpenBackward = TweenService:Create(hinge, tweenInfo, doorOpenedPosBackward);
local tweenClose = TweenService:Create(hinge, tweenInfo, doorClosedPos);

-- This function determines the position of our triggering player
-- If true, we will want to open the door forwards
-- If false, we will want to open the door backwards
local function isPositionInFront(position)
	return (door.Position - position).Unit:Dot(door.CFrame.LookVector) > 0
end

local function playOpenDoor()
	if not sfxDoorOpen.IsPlaying then
		sfxDoorOpen:Play()
	end
end

local function playCloseDoor()
	if not sfxDoorClose.IsPlaying then
		sfxDoorClose:Play()
	end
end

local function closeDoor()
	tweenClose:Play()
	playCloseDoor()
	isDoorClosed = not isDoorClosed
	prompt.ActionText = "Open"
end

local function openDoor(forward)
	playOpenDoor()
	if forward then
		tweenOpenForward:Play()
	else
		tweenOpenBackward:Play()
	end 

	isDoorClosed = not isDoorClosed
	prompt.ActionText = "Close"
	
	if autoCloseEnabled then
		-- Grab the countdown timer amount.
		local looper = autoCloseDelay;
		local loopTick = .5
		-- Check every "x" seconds to see if we should still close the door.
		-- If the door has already been closed, exit this loop.
		-- If the door is still open at the end of our countdown, close it.
		while looper > 0 and not isDoorClosed do
			task.wait(loopTick)
			looper -= loopTick
			print('Closing door in ' ..tostring(looper))
		end
		
		if not isDoorClosed then
			closeDoor()
		end
	end
	
end

-- This is the event that's fired when a player triggers the proximity prompt.
prompt.Triggered:Connect(function(player)
	if isDoorClosed then
		-- Determine if the door should swing 90 degrees or -90 degrees based on player location.
		local isPlayerInFront = isPositionInFront(player.Character.PrimaryPart.Position)
		openDoor(isPlayerInFront)
	else
		closeDoor()
	end
end)