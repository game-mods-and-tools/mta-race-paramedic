g_MAX_PICKUPS = 3
g_PICKUP_SIZE = 4
g_SPEED_CHECK_INTERVAL = 500
g_MAX_PICKUP_SPEED = 0.005

g_STATE_UPDATE_EVENT = "onStateUpdate"
g_NEW_PICKUP_EVENT = "onMarkerReceived"
g_PICKUP_PATIENT_EVENT = "onMarkerTouched"
g_HOSPITAL_LOCATION_EVENT = "onHospitalMarkerReceived"
g_PATIENT_DROPOFF_EVENT = "onPatientsDroppedOff"
g_PLAYER_RANKING_UPDATE = "onRanksUpdated"

g_NUM_LEVELS = #getElementsByType("checkpoint") / 2 -- why are checkpoints doubled? maybe bc name/type

g_PICKUPS_FOR_LEVEL_CACHE = {2, 3}
function g_PICKUPS_FOR_LEVEL(level)
	return level
end