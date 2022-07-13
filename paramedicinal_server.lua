pickupPositions = {{
    posX = "-2159.6816",
    posY = "-2244.3206",
    posZ = "29.50715"
}, {
    posX = "-2139.9207",
    posY = "-2233.2187",
    posZ = "29.50715"
}, {
    posX = "-2132.3328",
    posY = "-2247.9009",
    posZ = "29.50715"
}, {
    posX = "-2115.843",
    posY = "-2250.4824",
    posZ = "29.50715"
}, {
    posX = "-2089.8545",
    posY = "-2271.5955",
    posZ = "29.50715"
}, {
    posX = "-2075.1992",
    posY = "-2288.686",
    posZ = "29.50715"
}, {
    posX = "-2092.7029",
    posY = "-2317.939",
    posZ = "29.50715"
}, {
    posX = "-2118.9805",
    posY = "-2335.9609",
    posZ = "29.50715"
}, {
    posX = "-2122.6348",
    posY = "-2270.5508",
    posZ = "29.50715"
}, {
    posX = "-2138.3113",
    posY = "-2304.3687",
    posZ = "29.50715"
}, {
    posX = "-2136.2776",
    posY = "-2333.7444",
    posZ = "29.50715"
}, {
    posX = "-2102.5715",
    posY = "-2355.8171",
    posZ = "29.50715"
}, {
    posX = "-2114.5393",
    posY = "-2377.9639",
    posZ = "29.50715"
}, {
    posX = "-2133.2964",
    posY = "-2388.4546",
    posZ = "29.50715"
}, {
    posX = "-2159.6116",
    posY = "-2395.0969",
    posZ = "29.50715"
}, {
    posX = "-2181.6904",
    posY = "-2367.3984",
    posZ = "29.50715"
}, {
    posX = "-2168.2336",
    posY = "-2340.9944",
    posZ = "29.50715"
}, {
    posX = "-2164.1111",
    posY = "-2301.2283",
    posZ = "29.50715"
}, {
    posX = "-2165.7083",
    posY = "-2324.2825",
    posZ = "29.50715"
}, {
    posX = "-2225.9204",
    posY = "-2347.4812",
    posZ = "29.50715"
}, {
    posX = "-2195.6978",
    posY = "-2386.0054",
    posZ = "29.50715"
}, {
    posX = "-2209.4436",
    posY = "-2411.9771",
    posZ = "29.50715"
}, {
    posX = "-2217.2271",
    posY = "-2434.9563",
    posZ = "29.50715"
}, {
    posX = "-2228.3694",
    posY = "-2466.1243",
    posZ = "29.50715"
}, {
    posX = "-2210.9248",
    posY = "-2469.0176",
    posZ = "29.50715"
}, {
    posX = "-2250.0762",
    posY = "-2555.2937",
    posZ = "30.9099"
}, {
    posX = "-2189.5339",
    posY = "-2496.4224",
    posZ = "29.50715"
}, {
    posX = "-2151.0454",
    posY = "-2526.7122",
    posZ = "29.50715"
}, {
    posX = "-2121.7263",
    posY = "-2531.845",
    posZ = "29.50715"
}, {
    posX = "-2073.8025",
    posY = "-2559.511",
    posZ = "29.50715"
}, {
    posX = "-2074.2107",
    posY = "-2535.070",
    posZ = "29.50715"
}, {
    posX = "-2024.8549",
    posY = "-2544.3938",
    posZ = "29.50715"
}, {
    posX = "-2051.7187",
    posY = "-2493.0918",
    posZ = "29.50715"
}, {
    posX = "-2062.1001",
    posY = "-2472.1995",
    posZ = "29.50715"
}, {
    posX = "-2088.6318",
    posY = "-2489.8562",
    posZ = "29.50715"
}, {
    posX = "-2116.1477",
    posY = "-2493.1907",
    posZ = "29.50715"
}, {
    posX = "-2117.2732",
    posY = "-2511.7234",
    posZ = "29.50715"
}, {
    posX = "-2156.0754",
    posY = "-2502.9546",
    posZ = "29.50715"
}, {
    posX = "-2145.283",
    posY = "-2474.0486",
    posZ = "29.50715"
}, {
    posX = "-2147.7742",
    posY = "-2446.4675",
    posZ = "29.50715"
}, {
    posX = "-2191.0562",
    posY = "-2459.95",
    posZ = "29.50715"
}, {
    posX = "-2196.3093",
    posY = "-2436.2522",
    posZ = "29.50715"
}, {
    posX = "-2169.5371",
    posY = "-2433.938",
    posZ = "29.50715"
}, {
    posX = "-2151.1074",
    posY = "-2424.801",
    posZ = "29.50715"
}, {
    posX = "-2101.9861",
    posY = "-2451.5305",
    posZ = "29.50715"
}, {
    posX = "-2070.0906",
    posY = "-2434.1392",
    posZ = "29.50715"
}, {
    posX = "-2020.8298",
    posY = "-2501.4529",
    posZ = "31.457"
}, {
    posX = "-2125.9285",
    posY = "-2464.7393",
    posZ = "29.50715"
}}

hospitalPos = {
	posX = "-2199.0518",
	posY = "-2290.6426",
	posZ = "29.6634"
}

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
	triggerClientEvent(player, g_STATE_UPDATE_EVENT, resourceRoot, {
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
	triggerClientEvent(player, g_STATE_UPDATE_EVENT, resourceRoot, {
		markers = state.markers,
		pickups = state.pickups,
		checkpoint = state.checkpoint,
		speedCheckTimer = timeToCheck
	})
end

function getNewMarkersFor(player)
	local state = g_PlayerStates[player]
	state.markers = uniqueRandoms(#pickupPositions, g_PICKUPS_FOR_LEVEL(state.checkpoint))

	local timeToCheck = state.speedCheck and getTimerDetails(state.speedCheck) or false
	triggerClientEvent(player, g_STATE_UPDATE_EVENT, resourceRoot, {
		markers = state.markers,
		pickups = state.pickups,
		checkpoint = state.checkpoint,
		speedCheckTimer = timeToCheck
	})

	for _, id in ipairs(state.markers) do
		triggerClientEvent(player, g_NEW_PICKUP_EVENT, resourceRoot, id, pickupPositions[id].posX, pickupPositions[id].posY, pickupPositions[id].posZ, 0, 0, 200, 255)
	end
end

function triggerSpeedCheckFor(player, onSuccessFn)
	local state = g_PlayerStates[player]
	local vehicle = getPedOccupiedVehicle(player)

	-- check state.speedCheck for existing timer (shouldn't happen)
	state.speedCheck = {
		timer = setTimer(function()
			local x, y, z = getElementVelocity(vehicle)
			local completeVelocity = x * x + y * y + z * z
			if completeVelocity < g_MAX_PICKUP_SPEED then
				removeSpeedCheckFor(player)
				onSuccessFn()
				return
			end
		end, g_SPEED_CHECK_INTERVAL, 0),
		start = getTickCount()
	}

	triggerClientEvent(player, g_STATE_UPDATE_EVENT, resourceRoot, {
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

	triggerClientEvent(player, g_STATE_UPDATE_EVENT, resourceRoot, {
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

	-- fake ranking for testing
	states[#states + 1] = {
		player = getRandomPlayer(),
		checkpoint = 1,
		pickups = 1,
	}
	states[#states + 1] = {
		player = getRandomPlayer(),
		checkpoint = 2,
		pickups = 0,
	}
	states[#states + 1] = {
		player = getRandomPlayer(),
		checkpoint = 1,
		pickups = 2,
	}

	table.sort(states, function(s1, s2)
		if s1.checkpoint == s2.checkpoint then return s1.pickups > s2.pickups end
		return s1.checkpoint > s2.checkpoint
	end)

	triggerClientEvent(root, g_PLAYER_RANKING_UPDATE, resourceRoot, states)
end

addEvent("onColShapeHit")
-- one time initiaization, set up global pickups
for i, p in ipairs(pickupPositions) do
	local col = createColCircle(p.posX, p.posY, g_PICKUP_SIZE)

	addEventHandler("onColShapeHit", col, function(element)
		-- start timer for player to listen to checkpoint to stop
		local player, vehicle = toPlayer(element)
		if not player then return end

		local state = g_PlayerStates[player]
		if not state then return end

		if state.pickups >= g_MAX_PICKUPS then return end

		for i2, v in ipairs(state.markers) do
			if v == i then
				triggerSpeedCheckFor(player, function()
					-- need state event?
					local id = table.remove(state.markers, i)
					triggerClientEvent(player, g_PICKUP_PATIENT_EVENT, resourceRoot, i)

					updatePickupsFor(player, 1)
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

addEvent("onRaceStateChanging")
addEventHandler("onRaceStateChanging", getRootElement(), function(state)
	if state == "LoadingMap" then
		for _, p in pairs(getElementsByType("player")) do
			g_PlayerStates[p] = initializeState()
		end

		g_Hospital = {
			col = createColCircle(hospitalPos.posX, hospitalPos.posY, 5)
		}

		addEventHandler("onColShapeHit", g_Hospital.col, function(element)
			local player, vehicle = toPlayer(element)
			if not player then return end

			local state = g_PlayerStates[player]
			if not state then return end

			if state.pickups == 0 then return end

			triggerSpeedCheckFor(player, function()
				triggerClientEvent(player, g_PATIENT_DROPOFF_EVENT, resourceRoot, state.pickups)
				updatePickupsFor(player, -g_MAX_PICKUPS)

				if #state.markers == 0 then
					-- internal race implementation details that makes things work
					triggerClientEvent(player, "onClientCall_race", root, "checkpointReached", vehicle)
					-- triggerEvent("onPlayerReachCheckpointInternal", player, state.checkpoint)

					updateCheckpointFor(player, 1)
					getNewMarkersFor(player)
				end
			end)
		end)

		addEventHandler("onColShapeLeave", g_Hospital.col, function(element)
			local player, vehicle = toPlayer(element)
			if not player then return end

			local state = g_PlayerStates[player]
			if not state then return end

			if not state.speedCheck then return end
			removeSpeedCheckFor(player)
		end)
	end

	if state == "GridCountdown" then
		for p, state in pairs(g_PlayerStates) do
			getNewMarkersFor(p)
		end
		triggerClientEvent(root, g_HOSPITAL_LOCATION_EVENT, resourceRoot, hospitalPos.posX, hospitalPos.posY, hospitalPos.posZ)
	end
end)

addEvent("onPlayerWasted")
addEventHandler("onPlayerWasted", getRootElement(), function()
	local player = source

	local state = g_PlayerStates[player]
	if not state then return end

	updateCheckpointFor(player, -1)
	getNewMarkersFor(player)
end)