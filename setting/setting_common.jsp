<%@ include file="../api_common.jsp"%>
<%@ include file="../response_generator.jsp"%>
<%@ include file="setting__common.jsp"%>

<%@ page import="org.json.JSONObject"%>

<%! // methods shared among /setting/*.jsp pages

public JSONObject processPutSettingRequest(HttpServletRequest request, String strType) {
	if (!request.getParameterMap().containsKey("device_id")
			|| !request.getParameterMap().containsKey("action")) {
		return ApiResponse.getErrorResponse(ApiResponse.STATUS_MISSING_PARAM);
    }

	final String strDeviceId = request.getParameter("device_id");
	final String strAction = request.getParameter("action");

    if (!isValidDeviceId(strDeviceId)) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_PARAMETER, "Invalid device_id.");
    } else if (!isInteger(strAction)) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_PARAMETER, "Invalid action.");
    }

    int nAction = Integer.parseInt(strAction.trim());

    // actionIsInRange() is defined in each JSPs which included this file
    if (!actionIsInRange(nAction)) {
    	return ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_PARAMETER, "Invalid action.");
    }

    DeviceData deviData = new DeviceData();
    DeviceSetData deviSetData = new DeviceSetData();
    int nCountDevice = queryDevice(strDeviceId, deviData);
    JSONObject jobj;

    if (0 < nCountDevice) {
        // Device exists

        int nCount = querySetting(strDeviceId, strType, deviSetData);
        int nRet;
        if (0 < nCount) {
            // setting exists, do update
            nRet = updateSetting(strDeviceId, strType, nAction);
        } else {
            //setting not found, insert setting
            nRet = insertSetting(strDeviceId, strType, nAction);
        }

        if (0 < nRet) {
            jobj = ApiResponse.getSuccessResponseTemplate();
        } else {
            switch (nRet) {
            case ERR_EXCEPTION:
                jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR);
                break;
            default:
                jobj = ApiResponse.getUnknownErrorResponse();
            }
        }
    } else {
        // Device not found
        switch (nCountDevice) {
        case 0:
            jobj = ApiResponse.deviceIdNotFoundResponse();
            break;
        case ERR_EXCEPTION:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR);
            break;
        default:
            jobj = ApiResponse.getUnknownErrorResponse();
        }
    }

    return jobj;
}

// Inserts setting into database, the caller of this method
// is responsible for checking the validity of nAction and strType!
public int insertSetting(final String strDeviceId, final String strType, final int nAction) {
	return insertUpdateDelete(
			"INSERT INTO device_setting(device_id, setting_type, action) VALUES (?,?,?)",
			new Object[]{strDeviceId, strType, Integer.valueOf(nAction)});
}

// Updates setting in database, the caller of this method
// is responsible for checking the validity of nAction and strType!
public int updateSetting(final String strDeviceId, final String strType, final int nAction) {
   return insertUpdateDelete(
            "UPDATE device_setting SET action=? WHERE device_id=? AND setting_type=?",
            new Object[]{Integer.valueOf(nAction), strDeviceId, strType});
}

%>
