<%@ include file="../api_common.jsp"%>
<%@ include file="../response_generator.jsp"%>

<%@ page import="org.json.JSONObject"%>

<%
    JSONObject jobj = processRequest(request);
    out.println(jobj.toString());
%>

<%! // methods used ONLY within this file

private JSONObject processRequest(HttpServletRequest request) {
    if (!request.getParameterMap().containsKey("device_id")
            || !request.getParameterMap().containsKey("device_os")) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_MISSING_PARAM);
    }
    
    final String strDeviceId = request.getParameter("device_id");
    final String strDeviceOs = request.getParameter("device_os");

    if (!isValidDeviceId(strDeviceId)) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE, "Invalid device_id.");
    } else if (!isNotEmptyString(strDeviceOs)) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE, "Invalid device_os.");
    }
    
    Logs.showTrace("********" + strDeviceId + " os: " + strDeviceOs);
    JSONObject jobj;

    int nInsert = insertDevice(strDeviceId, strDeviceOs);

    if (0 < nInsert) {
        jobj = ApiResponse.getSuccessResponseTemplate();
    } else {
        switch (nInsert) {
        case ERR_FAIL:
        case ERR_EXCEPTION:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR);
            break;
        case ERR_INVALID_PARAMETER:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE);
            break;
        case ERR_CONFLICT:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_CONFLICTS_WITH_EXISTING_DATA,
                    "device_id conflict.");
            break;
        default:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR, "Unknown error.");
        }
    }
    
    return jobj;
}

private int insertDevice(final String strDeviceId, final String strDeviceOs) {
	DeviceData deviData = new DeviceData();
	int nCount = queryDevice(strDeviceId, deviData);
	
	if (0 < nCount) {
	    return ERR_CONFLICT;
	}

	return insertUpdateDelete(
	        "INSERT INTO device_list(device_id, device_os) VALUES (?,?)",
	        new Object[]{strDeviceId, strDeviceOs});
}
%>
