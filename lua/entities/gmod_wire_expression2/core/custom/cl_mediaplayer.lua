local tbl = E2Helper.Descriptions
local function desc(name, description)
	tbl[name] = description
end

desc("mediaGetState(e:n)", "Returns the state of the Media Player. See the MEDIA_* constants")
desc("mediaHasListener(e:e)", "Returns if the player is currently listening to the Media Player")
desc("mediaAddListener(e:e)", "Adds the player as a listener to the Media Player")
desc("mediaRemoveListener(e:e)", "Removes the player as a listener from the Media Player")
desc("mediaRequest(e:s)", "Requests a url to the Media Player")
desc("mediaPlay(e:)", "If paused, starts playing the Media Player")
desc("mediaPause(e:)", "If playing, pauses the Media Player")
desc("mediaSkip(e:)", "Skips the current media on the Media Player")
desc("mediaSeek(e:n)", "Seeks time in seconds in the current media on the Media Player")
desc("mediaGetQueueRepeat(e:)", "Returns if the queue is set to repeat for the Media Player")
desc("mediaGetQueueShuffle(e:)", "Returns if the queue is set to shuffle for the Media Player")
desc("mediaGetQueueLocked(e:)", "Returns if the queue is set to locked for the Media Player")
desc("mediaSetQueueRepeat(e:n)", "Set the queue to repeat for the Media Player")
desc("mediaSetQueueShuffle(e:n)", "Set the queue to shuffle for the Media Player")
desc("mediaSetQueueLocked(e:n)", "Set the queue to be locked for the Media Player")
