<%@include file="../../api_common.jsp"%>
<%@include file="../../response_generator.jsp"%>
<%@include file="../routine__common.jsp"%>

<%@ page import="org.json.JSONObject"%>

<%!

private JSONObject processAddRoutineRequest(HttpServletRequest request, final String strType) {
    if (!request.getParameterMap().containsKey("device_id")
            || !request.getParameterMap().containsKey("title")
            || !request.getParameterMap().containsKey("start_time")
            || !request.getParameterMap().containsKey("repeat")) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_MISSING_PARAM);
    }

    final String strDeviceId = request.getParameter("device_id");
    final String strTitle = request.getParameter("title");
    final String strTime = request.getParameter("start_time");
    final String strRepeat = request.getParameter("repeat");

    if (!isValidDeviceId(strDeviceId)) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE, "Invalid device_id.");
    } else if (!hasValidTimeFormat(strTime)) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE, "Invalid time.");
    } else if (!isNotEmptyString(strTitle)) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE, "Invalid title.");
    } else if (!isValidRoutineRepeatValue(strRepeat)) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE, "Invalid repeat.");
    }

    final int nRepeat = Integer.parseInt(strRepeat.trim());
    JSONObject jobj;

    int nCountDevice = checkDeviceIdExistance(strDeviceId);

    if (nCountDevice < 1) {
        // Device not found
        switch (nCountDevice) {
        case 0:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_DATA_NOT_FOUND,
                    "device_id not found.");
            break;
        case ERR_EXCEPTION:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR);
            break;
        case ERR_INVALID_PARAMETER:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE, "Invalid device_id.");
            break;
        }

        Logs.showTrace("********error*********nCountDevice: " + nCountDevice);
        return jobj;
    }

    // Device exists, search for possibly duplicated routines
    int nCount = checkRoutineExistance(strDeviceId, strType, strTime);

    if (nCount != 0) {
        if (nCount > 0) {
            // there is already a routine scheduled at given time
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_CONFLICTS_WITH_EXISTING_DATA,
                    "brush teeth setting conflict.");
        } else {
            switch (nCount) {
            case ERR_EXCEPTION:
                jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR);
                break;
            case ERR_INVALID_PARAMETER:
                jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE);
                break;
            default:
                jobj = ApiResponse.getUnknownErrorResponse();
            }
        }
        

        Logs.showTrace("********error*********nCount: " + nCount);
        return jobj;
    }

    // routine not found, insert
    int nInsert = insertRoutineSetting(strDeviceId, strType, strTitle, strTime, nRepeat);
    
    if (nInsert < 1) {
        // routine insert failed
        switch (nInsert) {
        case ERR_EXCEPTION:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR);
            break;
        case ERR_INVALID_PARAMETER:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE);
            break;
        }

        return jobj;
    }

    // get the routine ID we have just added
    int nRoutineId = queryRoutineID(strDeviceId, strType, strTime);

    if (nRoutineId < 1) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR);
    }

    jobj = ApiResponse.getSuccessResponseTemplate();
    jobj.put("routine_id", nRoutineId);

    Logs.showTrace("**********************nInsert: " + nInsert + " nRoutineId: " + nRoutineId);
    return jobj;
}

private boolean isValidRoutineRepeatValue(String r) {
	if (r == null || r.length() < 1) {
		return false;
	}
	
    try {
        int nRepeat = Integer.parseInt(strRepeat.trim());
        return nRepeat == 0 || nRepeat == 1;
    } catch (Exception e) {
    	e.printStackTrace();
        return false;
    }
}

public int insertRoutineSetting(final String strDeviceId, final String strType,
        final String strTitle, final String strTime, final int nRepeat) {
    return insertUpdateDelete(
            "INSERT INTO routine_setting(device_id, routine_type, title, start_time, repeat)VALUES(?,?,?,?,?)",
            new Object[]{strDeviceId, strType, strTitle, strTime, Integer.valueOf(nRepeat)});
}

%>
