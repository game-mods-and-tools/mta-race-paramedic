g_PlayerStates = {}

---- state
function initializeState()
	return {
		markers = {},
		pickups = 0,
		checkpoint = 1,
		speedCheck = nil
	}
end

function updateCheckpointFor(player, delta)
	local state = g_PlayerStates[player]
	state.checkpoint = math.max(state.checkpoint + delta, 1)

	local timeToCheck = state.speedCheck and state.speedCheck.start or false
	triggerClientEvent(player, g_PLAYER_STATE_UPDATE_EVENT, resourceRoot, {
		markers = state.markers,
		pickups = state.pickups,
		checkpoint = state.checkpoint,
		speedCheckTimer = timeToCheck
	})
end

function updatePickupsFor(player, delta)
	local state = g_PlayerStates[player]
	state.pickups = math.max(state.pickups + delta, 0)

	local timeToCheck = state.speedCheck and state.speedCheck.start or false
	triggerClientEvent(player, g_PLAYER_STATE_UPDATE_EVENT, resourceRoot, {
		markers = state.markers,
		pickups = state.pickups,
		checkpoint = state.checkpoint,
		speedCheckTimer = timeToCheck
	})
end

function getNewMarkersFor(player)
	local state = g_PlayerStates[player]

	state.markers = uniqueRandoms(#g_PATIENT_PICKUP_POSITIONS, g_PICKUPS_FOR_LEVEL(state.checkpoint))

	local timeToCheck = state.speedCheck and getTimerDetails(state.speedCheck) or false
	triggerClientEvent(player, g_PLAYER_STATE_UPDATE_EVENT, resourceRoot, {
		markers = state.markers,
		pickups = state.pickups,
		checkpoint = state.checkpoint,
		speedCheckTimer = timeToCheck
	})

	for _, id in ipairs(state.markers) do
		triggerClientEvent(player, g_NEW_PATIENT_MARKER_EVENT, resourceRoot, id)
	end
end

function triggerSpeedCheckFor(player, onSuccessFn)
	local state = g_PlayerStates[player]
	local vehicle = getPedOccupiedVehicle(player)

	-- check state.speedCheck for existing timer? (shouldn't happen)
	state.speedCheck = {
		timer = setTimer(function()
			local x, y, z = getElementVelocity(vehicle)
			local completeVelocity = x * x + y * y + z * z
			if completeVelocity < g_PICKUP_SPEED_LIMIT then
				removeSpeedCheckFor(player)
				onSuccessFn()
				return
			end
		end, g_SPEED_CHECK_INTERVAL, 0),
		start = getTickCount()
	}

	triggerClientEvent(player, g_PLAYER_STATE_UPDATE_EVENT, resourceRoot, {
		markers = state.markers,
		pickups = state.pickups,
		checkpoint = state.checkpoint,
		speedCheckTimer = state.speedCheck.start
	})
end

function removeSpeedCheckFor(player)
	local state = g_PlayerStates[player]

	killTimer(state.speedCheck.timer)
	state.speedCheck = nil

	triggerClientEvent(player, g_PLAYER_STATE_UPDATE_EVENT, resourceRoot, {
		markers = state.markers,
		pickups = state.pickups,
		checkpoint = state.checkpoint,
		speedCheckTimer = false
	})
end

---- util
function uniqueRandoms(range, num)
	local numbers = {}
	local numbersSet = {}

	while #numbers < num do
		local rand = math.random(range)
		if not numbersSet[rand] then
			numbersSet[rand] = true
			numbers[#numbers + 1] = rand
		end
	end

	return numbers
end

function toPlayer(element)
	if getElementType(element) ~= "vehicle" then return false end
	return getVehicleOccupant(element), element
end

---- logic
function updatePlayerRanks() -- unused
	local states = {}
	for p, v in pairs(g_PlayerStates) do
		states[#states + 1] = {
			player = p,
			checkpoint = v.checkpoint,
			pickups = g_PICKUPS_FOR_LEVEL(v.checkpoint) - #v.markers
		}
	end

	table.sort(states, function(s1, s2)
		if s1.checkpoint == s2.checkpoint then return s1.pickups > s2.pickups end
		return s1.checkpoint > s2.checkpoint
	end)

	triggerClientEvent(root, g_PLAYERS_RANKING_UPDATE, resourceRoot, states)
end

function initializePickups()
	for i, p in ipairs(g_PATIENT_PICKUP_POSITIONS) do
		local col = createColCircle(getElementData(p, "posX"), getElementData(p, "posY"), g_PATIENT_PICKUP_MARKER_SIZE)

		addEventHandler("onColShapeHit", col, function(element)
			-- start timer for player to listen to checkpoint to stop
			local player, vehicle = toPlayer(element)
			if not player then return end

			local state = g_PlayerStates[player]
			if not state then return end

			for i2, v in ipairs(state.markers) do
				if v == i then
					if state.pickups >= g_MAX_PATIENTS_IN_VEHICLE then
						triggerClientEvent(player, g_AMBULANCE_FULL_EVENT, resourceRoot)
						return
					end
					triggerSpeedCheckFor(player, function()
						-- need state event?
						local id = table.remove(state.markers, i2)
						triggerClientEvent(player, g_PATIENT_PICKED_UP_EVENT, resourceRoot, i)

						updatePickupsFor(player, 1)
						if state.pickups == g_MAX_PATIENTS_IN_VEHICLE then
							triggerClientEvent(player, g_AMBULANCE_FULL_EVENT, resourceRoot)
						end
					end)
					return
				end
			end
		end)

		addEventHandler("onColShapeLeave", col, function(element)
			local player, vehicle = toPlayer(element)
			if not player then return end

			local state = g_PlayerStates[player]
			if not state then return end

			if not state.speedCheck then return end
			removeSpeedCheckFor(player)
		end)
	end
end

function initializeHospitals()
	for _, h in ipairs(g_HOSPITAL_POSITIONS) do
		local collision = createColCircle(getElementData(h, "posX"), getElementData(h, "posY"), g_HOSPITAL_MARKER_SIZE)

		addEventHandler("onColShapeHit", collision, function(element)
			local player, vehicle = toPlayer(element)
			if not player then return end

			local state = g_PlayerStates[player]
			if not state then return end

			if state.pickups == 0 then return end

			triggerSpeedCheckFor(player, function()
				triggerClientEvent(player, g_PATIENTS_DROPPED_OFF_EVENT, resourceRoot, state.pickups)
				updatePickupsFor(player, -g_MAX_PATIENTS_IN_VEHICLE)

				if #state.markers == 0 then
					-- internal race implementation details that makes things work
					local internalCheckpoint = getElementData(player, "race.checkpoint")
					if state.checkpoint == internalCheckpoint then -- only increment if these are equal in case of deaths rolling back checkpoints
						triggerClientEvent(player, "onClientCall_race", root, "checkpointReached", vehicle)
					end
					-- triggerEvent("onPlayerReachCheckpointInternal", player, state.checkpoint)

					if state.checkpoint == g_NUM_LEVELS then return end

					updateCheckpointFor(player, 1)
					getNewMarkersFor(player)
				end
			end)
		end)

		addEventHandler("onColShapeLeave", collision, function(element)
			local player, vehicle = toPlayer(element)
			if not player then return end

			local state = g_PlayerStates[player]
			if not state then return end

			if not state.speedCheck then return end
			removeSpeedCheckFor(player)
		end)
	end
end

addEvent("onRaceStateChanging")
addEventHandler("onRaceStateChanging", root, function(state)
	if state == "LoadingMap" then
		-- what if player joins in middle
		for _, p in pairs(getElementsByType("player")) do
			g_PlayerStates[p] = initializeState()
		end

		initializePickups()
		initializeHospitals()
	elseif state == "GridCountdown" then
		for p, state in pairs(g_PlayerStates) do
			getNewMarkersFor(p)
		end
	end
end)

addEventHandler("onPlayerWasted", root, function()
	local player = source

	local state = g_PlayerStates[player]
	if not state then return end

	updateCheckpointFor(player, -1)
	updatePickupsFor(player, -g_MAX_PATIENTS_IN_VEHICLE)
	getNewMarkersFor(player)
end)

addEventHandler("onPlayerJoin", root, function()
	local player = source

	if g_PlayerStates[player] then return end

	g_PlayerStates[player] = initializeState()
	getNewMarkersFor(player)
end)