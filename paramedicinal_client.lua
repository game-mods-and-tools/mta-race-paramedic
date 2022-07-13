g_Pickups = {}
g_State = {}
g_Rankings = {}

addEvent(g_PICKUP_PATIENT_EVENT, true)
addEventHandler(g_PICKUP_PATIENT_EVENT, resourceRoot, function(i)
	if not g_Pickups[i] then return end

	destroyElement(g_Pickups[i].marker)
	destroyElement(g_Pickups[i].blip)

	local vehicle = getPedOccupiedVehicle(localPlayer)
	g_Pickups[i] = nil

	playSound("blip.wav")
end)

addEvent(g_NEW_PICKUP_EVENT, true)
addEventHandler(g_NEW_PICKUP_EVENT, resourceRoot, function(i, x, y, z, r, g, b, a)
	g_Pickups[i] = {
		marker = createMarker(x, y, z, "checkpoint", g_PICKUP_SIZE, r, g, b, a),
		blip = createBlip(x, y, z, 0, 2, r, g, b, a)
	}
end)

addEvent(g_HOSPITAL_LOCATION_EVENT, true)
addEventHandler(g_HOSPITAL_LOCATION_EVENT, resourceRoot, function(x, y, z)
	createBlip(x, y, z, 22, 1, 0, 0, 0, 255)
end)

addEvent(g_STATE_UPDATE_EVENT, true)
addEventHandler(g_STATE_UPDATE_EVENT, resourceRoot, function(state)
	g_State = state
end)

addEvent(g_PATIENT_DROPOFF_EVENT, true)
addEventHandler(g_PATIENT_DROPOFF_EVENT, resourceRoot, function(numDropOffs)
	playSound("bloop.wav")
end)

addEvent(g_PLAYER_RANKING_UPDATE, true)
addEventHandler(g_PLAYER_RANKING_UPDATE, resourceRoot, function(ranks)
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
	addEventHandler("onClientRender", root, function()
		local screenWidth, screenHeight = guiGetScreenSize()
		dxDrawRectangle(screenWidth - 100, screenHeight - 120, 90, 80) -- shitty hack to cover normal race ui

		if g_State then
			dxDrawText("LEVEL                  " .. g_State.checkpoint .. "/" .. g_NUM_LEVELS, screenWidth * 0.65 + 2, screenHeight * 0.25 - 2, screenWidth, screenHeight, tocolor(0, 0, 0, 255), 1, "bankgothic")
			dxDrawText("LEVEL                  " .. g_State.checkpoint .. "/" .. g_NUM_LEVELS, screenWidth * 0.65, screenHeight * 0.25, screenWidth, screenHeight, tocolor(190, 222, 222, 255), 1, "bankgothic")
			dxDrawText("PATIENTS             " .. #g_State.markers, screenWidth * 0.65 + 2, screenHeight * 0.28 - 2, screenWidth, screenHeight, tocolor(0, 0, 0, 255), 1, "bankgothic")
			dxDrawText("PATIENTS             " .. #g_State.markers, screenWidth * 0.65, screenHeight * 0.28, screenWidth, screenHeight, tocolor(190, 222, 222, 255), 1, "bankgothic")
			dxDrawText("SEATS FREE         " .. g_MAX_PICKUPS - g_State.pickups, screenWidth * 0.65 + 2, screenHeight * 0.33 - 2, screenWidth, screenHeight, tocolor(0, 0, 0, 255), 1, "bankgothic")
			dxDrawText("SEATS FREE         " .. g_MAX_PICKUPS - g_State.pickups, screenWidth * 0.65, screenHeight * 0.33, screenWidth, screenHeight, tocolor(190, 222, 222, 255), 1, "bankgothic")

			if g_State.speedCheckTimer then
				local elapsed = getTickCount() - g_State.speedCheckTimer
				local timeToCheck = elapsed % g_SPEED_CHECK_INTERVAL
				local percent = timeToCheck / g_SPEED_CHECK_INTERVAL

				local x, y, z = getElementVelocity(getPedOccupiedVehicle(localPlayer))
				local completeVelocity = x * x + y * y + z * z
				local color = completeVelocity < g_MAX_PICKUP_SPEED and tocolor(0, 255, 0, 255) or tocolor(255, 0, 0, 255)

				dxDrawRectangle(screenWidth - 100, screenHeight - 120, 90, 80 * percent, color)
			end
		end

		if g_Rankings then
			for i, v in pairs(g_Rankings) do
				dxDrawText(tostring(i) .. ": " .. getPlayerName(v.player) .. " cp: " .. v.checkpoint .. " pickups: " .. v.pickups, screenWidth * 0.65 + 2, screenHeight * 0.4 + i * 20)
			end
		end
	end)
end)

