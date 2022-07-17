g_MAX_PATIENTS_IN_VEHICLE = 3
g_PATIENT_PICKUP_MARKER_SIZE = 7.5
g_SPEED_CHECK_INTERVAL = 1000
g_PICKUP_SPEED_LIMIT = 0.005
g_HOSPITAL_MARKER_SIZE = 5.5

g_NUM_LEVELS = #getElementsByType("checkpoint", resourceRoot)
g_PATIENT_PICKUP_POSITIONS = getElementsByType("patient", resourceRoot)
g_HOSPITAL_POSITIONS = getElementsByType("hospital", resourceRoot)

function g_PATIENTS_FOR_LEVEL(level)
	if g_NUM_LEVELS == 1 then return 12 end
	return level
end