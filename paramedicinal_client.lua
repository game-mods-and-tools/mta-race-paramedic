g_Pickups = {}
g_State = nil
g_Rankings = nil

addEvent(g_PATIENT_PICKED_UP_EVENT, true)
addEventHandler(g_PATIENT_PICKED_UP_EVENT, resourceRoot, function(i)
	if not g_Pickups[i] then return end

	destroyElement(g_Pickups[i].marker)
	destroyElement(g_Pickups[i].blip)
	g_Pickups[i] = nil

	playSound("blip.wav")
end)

addEvent(g_NEW_PATIENT_MARKER_EVENT, true)
addEventHandler(g_NEW_PATIENT_MARKER_EVENT, resourceRoot, function(i)
	local x = getElementData(g_PATIENT_PICKUP_POSITIONS[i], "posX")
	local y = getElementData(g_PATIENT_PICKUP_POSITIONS[i], "posY")
	local z = getElementData(g_PATIENT_PICKUP_POSITIONS[i], "posZ")

	g_Pickups[i] = {
		marker = createMarker(x, y, z, "checkpoint", g_PATIENT_PICKUP_MARKER_SIZE, 0, 0, 200, 255),
		blip = createBlip(x, y, z, 0, 2, 0, 0, 200, 255)
	}
end)

addEvent(g_PLAYER_STATE_UPDATE_EVENT, true)
addEventHandler(g_PLAYER_STATE_UPDATE_EVENT, resourceRoot, function(state)
	g_State = state
end)

addEvent(g_PATIENTS_DROPPED_OFF_EVENT, true)
addEventHandler(g_PATIENTS_DROPPED_OFF_EVENT, resourceRoot, function(numDropOffs)
	playSound("bloop.wav")
end)

addEvent(g_PLAYERS_RANKING_UPDATE, true)
addEventHandler(g_PLAYERS_RANKING_UPDATE, resourceRoot, function(ranks) -- unused
	g_Rankings = ranks
end)

addEvent("onClientPlayerWasted")
addEventHandler("onClientPlayerWasted", localPlayer, function()
	for i, _ in pairs(g_Pickups) do
		destroyElement(g_Pickups[i].marker)
		destroyElement(g_Pickups[i].blip)
		g_Pickups[i] = nil
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	for _, hospital in pairs(g_HOSPITAL_POSITIONS) do
		local x = getElementData(hospital, "posX")
		local y = getElementData(hospital, "posY")
		local z = getElementData(hospital, "posZ")
		createMarker(x, y, z, "cylinder", g_PATIENT_PICKUP_MARKER_SIZE - 1, 254, 0, 0, 73)
		createMarker(x, y, z, "cylinder", g_PATIENT_PICKUP_MARKER_SIZE, 254, 0, 0, 65)
		createMarker(x, y, z, "cylinder", g_PATIENT_PICKUP_MARKER_SIZE + 1, 254, 0, 0, 51)
		createBlip(x, y, z, 22, 1, 0, 0, 0, 255)
	end
	
	addEventHandler("onClientRender", root, function()
		local screenWidth, screenHeight = guiGetScreenSize()

		if g_State then
			dxDrawText("LEVEL                " .. g_State.checkpoint .. "/" .. g_NUM_LEVELS, screenWidth * 0.65 + 2, screenHeight * 0.25 - 2, screenWidth, screenHeight, tocolor(0, 0, 0, 255), 1, "bankgothic")
			dxDrawText("LEVEL                " .. g_State.checkpoint .. "/" .. g_NUM_LEVELS, screenWidth * 0.65, screenHeight * 0.25, screenWidth, screenHeight, tocolor(190, 222, 222, 255), 1, "bankgothic")
			dxDrawText("PATIENTS              " .. #g_State.markers, screenWidth * 0.65 + 2, screenHeight * 0.28 - 2, screenWidth, screenHeight, tocolor(0, 0, 0, 255), 1, "bankgothic")
			dxDrawText("PATIENTS              " .. #g_State.markers, screenWidth * 0.65, screenHeight * 0.28, screenWidth, screenHeight, tocolor(190, 222, 222, 255), 1, "bankgothic")
			dxDrawText("SEATS FREE          " .. g_MAX_PATIENTS_IN_VEHICLE - g_State.pickups, screenWidth * 0.65 + 2, screenHeight * 0.33 - 2, screenWidth, screenHeight, tocolor(0, 0, 0, 255), 1, "bankgothic")
			dxDrawText("SEATS FREE          " .. g_MAX_PATIENTS_IN_VEHICLE - g_State.pickups, screenWidth * 0.65, screenHeight * 0.33, screenWidth, screenHeight, tocolor(190, 222, 222, 255), 1, "bankgothic")

			if g_State.speedCheckTimer then -- pickup timer visualisationicator
				local elapsed = getTickCount() - g_State.speedCheckTimer
				local timeToCheck = elapsed % g_SPEED_CHECK_INTERVAL
				local percent = timeToCheck / g_SPEED_CHECK_INTERVAL

				local x, y, z = getElementVelocity(getPedOccupiedVehicle(localPlayer))
				local completeVelocity = x * x + y * y + z * z
				local redScale = math.min(math.max(completeVelocity - g_PICKUP_SPEED_LIMIT, 0) / (3 * g_PICKUP_SPEED_LIMIT), 1)
				local color = tocolor(200 * redScale, 200 * (1 - redScale), 0)

				dxDrawRectangle(screenWidth / 2 - 126, screenHeight * 0.85, 252, 27, tocolor(0, 0, 0))
				dxDrawRectangle(screenWidth / 2 - 122, screenHeight * 0.85 + 4, 244, 19, tocolor(40, 40, 40))
				dxDrawRectangle(screenWidth / 2 - 122, screenHeight * 0.85 + 4, 244 * percent, 19, color)
			end
		end
	end)
end)