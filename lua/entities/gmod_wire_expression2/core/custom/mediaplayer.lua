E2Lib.RegisterExtension("mediaplayer", true, "E2 functions for interacting with the Media Player addon.")

local mpClasses = {
	mediaplayer_base = true,
	mediaplayer_tv = true
}

local function isMediaPlayer(ent)
	return mpClasses[ent:GetClass()] or false
end

E2Lib.registerConstant("MEDIA_ENDED", MP_STATE_ENDED)
E2Lib.registerConstant("MEDIA_PLAYING", MP_STATE_PLAYING)
E2Lib.registerConstant("MEDIA_PAUSED", MP_STATE_PAUSED)

__e2setcost(2)

registerFunction("mediaGetState", "e:", "n", function(self, args)
	local op1 = args[2]
	local this = op1[1](self, op1)

	if not IsValid(this) then return self:throw("Invalid entity!", 0) end
	if not isMediaPlayer(this) then return self:throw("Expected Media Player, got Entity!", 0) end

	local mp = this:GetMediaPlayer()

	return mp:GetPlayerState()
end)

__e2setcost(30)

registerFunction("mediaHasListener", "e:e", "n", function(self, args)
	local op1, op2 = args[2], args[3]
	local this = op1[1](self, op1)
	local target = op2[1](self, op2)

	if not IsValid(this) then return self:throw("Invalid entity!", 0) end
	if not isMediaPlayer(this) then return self:throw("Expected Media Player, got Entity!", 0) end
	if not IsValid(target) then return self:throw("Invalid player to check is listening!", 0) end
	if not target:IsPlayer() then return self:throw("Expected Player, got Entity!", 0) end

	local mp = this:GetMediaPlayer()

	return mp:HasListener(target) and 1 or 0
end)

__e2setcost(200)

registerFunction("mediaAddListener", "e:e", "", function(self, args)
	local op1, op2 = args[2], args[3]
	local this = op1[1](self, op1)
	local target = op2[1](self, op2)

	if not IsValid(this) then return self:throw("Invalid entity!") end
	if not isMediaPlayer(this) then return self:throw("Expected Media Player, got Entity!") end
	if not IsValid(target) then return self:throw("Invalid player to add listener!") end
	if not target:IsPlayer() then return self:throw("Expected Player, got Entity!") end
	if not E2Lib.isFriend(self.player, target) then return self:throw("You cannot target this player!") end

	local mp = this:GetMediaPlayer()

	if not mp:HasListener(target) then
		mp:AddListener(target)
	end
end)

registerFunction("mediaRemoveListener", "e:e", "", function(self, args)
	local op1, op2 = args[2], args[3]
	local this = op1[1](self, op1)
	local target = op2[1](self, op2)

	if not IsValid(this) then return self:throw("Invalid entity!") end
	if not isMediaPlayer(this) then return self:throw("Expected Media Player, got Entity!") end
	if not IsValid(target) then return self:throw("Invalid player to remove listener") end
	if not target:IsPlayer() then return self:throw("Expected Player, got Entity!") end
	if not E2Lib.isFriend(self.player, target) then return self:throw("You cannot target this player!") end

	local mp = this:GetMediaPlayer()

	if mp:HasListener(target) then
		mp:RemoveListener(target)
	end
end)

registerFunction("mediaRequest", "e:s", "n", function(self, args)
	local op1, op2 = args[2], args[3]
	local this = op1[1](self, op1)
	local url = op2[1](self, op2)

	if not IsValid(this) then return self:throw("Invalid entity!", 0) end
	if not isMediaPlayer(this) then return self:throw("Expected Media Player, got Entity!", 0) end

	local allowWebpage = MediaPlayer.Cvars.AllowWebpages:GetBool()

	local mp = this:GetMediaPlayer()

	if not MediaPlayer.ValidUrl(url) and not allowWebpage then return self:throw("The requested URL was invalid!", 0) end

	local media = MediaPlayer.GetMediaForUrl(url, allowWebpage)

	mp:RequestMedia(media, self.player)

	return 1
end)

registerFunction("mediaPlay", "e:", "", function(self, args)
	local op1 = args[2]
	local this = op1[1](self, op1)

	if not IsValid(this) then return self:throw("Invalid entity!") end
	if not isMediaPlayer(this) then return self:throw("Expected Media Player, got Entity!") end
	if not E2Lib.isOwner(self, this) then return self:throw("You do not own this entity!") end

	local mp = this:GetMediaPlayer()
	if mp:GetPlayerState() ~= MP_STATE_PAUSED then return end

	mp:PlayPause()
end)

registerFunction("mediaPause", "e:", "", function(self, args)
	local op1 = args[2]
	local this = op1[1](self, op1)

	if not IsValid(this) then return self:throw("Invalid entity!") end
	if not isMediaPlayer(this) then return self:throw("Expected Media Player, got Entity!") end
	if not E2Lib.isOwner(self, this) then return self:throw("You do not own this entity!") end

	local mp = this:GetMediaPlayer()
	if mp:GetPlayerState() ~= MP_STATE_PLAYING then return end

	mp:PlayPause()
end)

registerFunction("mediaSkip", "e:", "", function(self, args)
	local op1 = args[2]
	local this = op1[1](self, op1)

	if not IsValid(this) then return self:throw("Invalid entity!") end
	if not isMediaPlayer(this) then return self:throw("Expected Media Player, got Entity!") end
	if not E2Lib.isOwner(self, this) then return self:throw("You do not own this entity!") end

	local mp = this:GetMediaPlayer()
	if mp:GetPlayerState() == MP_STATE_ENDED then return end

	mp:OnMediaFinished()
end)

registerFunction("mediaSeek", "e:n", "", function(self, args)
	local op1, op2 = args[2], args[3]
	local this = op1[1](self, op1)
	local seekTime = op2[1](self, op2)

	if not IsValid(this) then return self:throw("Invalid entity!") end
	if not isMediaPlayer(this) then return self:throw("Expected Media Player, got Entity!") end
	if not E2Lib.isOwner(self, this) then return self:throw("You do not own this entity!") end

	local mp = this:GetMediaPlayer()

	mp:RequestSeek(self.player, math.max(seekTime, 0))
end)

-- TODO: need to add method for getting current media and media uids
--[[registerFunction("mediaRemove", "e:s", "", function(self, args)

end)]]

__e2setcost(2)

registerFunction("mediaGetQueueRepeat", "e:", "n", function(self, args)
	local op1 = args[2]
	local this = op1[1](self, op1)

	if not IsValid(this) then return self:throw("Invalid entity!") end
	if not isMediaPlayer(this) then return self:throw("Expected Media Player, got Entity!") end

	local mp = this:GetMediaPlayer()

	return mp:GetQueueRepeat() and 1 or 0
end)

registerFunction("mediaGetQueueShuffle", "e:", "n", function(self, args)
	local op1 = args[2]
	local this = op1[1](self, op1)

	if not IsValid(this) then return self:throw("Invalid entity!") end
	if not isMediaPlayer(this) then return self:throw("Expected Media Player, got Entity!") end

	local mp = this:GetMediaPlayer()

	return mp:GetQueueShuffle() and 1 or 0
end)

registerFunction("mediaGetQueueLocked", "e:", "n", function(self, args)
	local op1 = args[2]
	local this = op1[1](self, op1)

	if not IsValid(this) then return self:throw("Invalid entity!") end
	if not isMediaPlayer(this) then return self:throw("Expected Media Player, got Entity!") end

	local mp = this:GetMediaPlayer()

	return mp:GetQueueLocked() and 1 or 0
end)

__e2setcost(200)

registerFunction("mediaSetQueueRepeat", "e:n", "", function(self, args)
	local op1, op2 = args[2], args[3]
	local this = op1[1](self, op1)
	local repeat_ = op2[1](self, op2)

	if not IsValid(this) then return self:throw("Invalid entity!") end
	if not isMediaPlayer(this) then return self:throw("Expected Media Player, got Entity!") end
	if not E2Lib.isOwner(self, this) then return self:throw("You do not own this entity!") end

	local mp = this:GetMediaPlayer()

	mp:SetQueueRepeat(repeat_ == 1)
	mp:BroadcastUpdate()
end)

registerFunction("mediaSetQueueShuffle", "e:n", "", function(self, args)
	local op1, op2 = args[2], args[3]
	local this = op1[1](self, op1)
	local shuffle = op2[1](self, op2)

	if not IsValid(this) then return self:throw("Invalid entity!") end
	if not isMediaPlayer(this) then return self:throw("Expected Media Player, got Entity!") end
	if not E2Lib.isOwner(self, this) then return self:throw("You do not own this entity!") end

	local mp = this:GetMediaPlayer()

	mp:SetQueueShuffle(shuffle == 1)
	mp:BroadcastUpdate()
end)

registerFunction("mediaSetQueueLocked", "e:n", "", function(self, args)
	local op1, op2 = args[2], args[3]
	local this = op1[1](self, op1)
	local locked = op2[1](self, op2)

	if not IsValid(this) then return self:throw("Invalid entity!") end
	if not isMediaPlayer(this) then return self:throw("Expected Media Player, got Entity!") end
	if not E2Lib.isOwner(self, this) then return self:throw("You do not own this entity!") end

	local mp = this:GetMediaPlayer()

	mp:SetQueueLocked(locked == 1)
	mp:BroadcastUpdate()
end)
