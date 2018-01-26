<%@ include file="../api_common.jsp"%>
<%@ include file="../response_generator.jsp"%>

<%@ page import="org.json.JSONObject"%>

<%! // methods used ONLY within this file

private JSONObject processRequest(HttpServletRequest request) {
	if (!request.getParameterMap().containsKey("device_id")) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_MISSING_PARAM);
    }

    final String strDeviceId = request.getParameter("device_id");

    if (!isValidDeviceId(strDeviceId)) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE, "Invalid device_id.");
    }

    DeviceData deviData = new DeviceData();
    JSONObject jobj;

    int nCount = queryDevice(strDeviceId, deviData);
    Logs.showTrace("**********************nCount: " + nCount);

    if (0 < nCount) {
        // Device record exists
        int nDelete = deleteSetting(strDeviceId);
        if (0 < nDelete) {
            jobj = ApiResponse.getSuccessResponseTemplate();
        } else {
            switch (nDelete) {
            case ERR_FAIL:
            case ERR_EXCEPTION:
                jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR);
                break;
            case ERR_INVALID_PARAMETER:
                jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE);
                break;
            default:
                jobj = ApiResponse.ApiResponse.getUnknownErrorResponse();
            }
        }
    } else {
        // Device not found
        switch (nCount) {
            case ERR_FAIL:
                jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_DATA_NOT_FOUND, "device_id not found.");
                break;
            case ERR_EXCEPTION:
                jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR);
                break;
            case ERR_INVALID_PARAMETER:
                jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE);
                break;
            default:
                jobj = ApiResponse.ApiResponse.getUnknownErrorResponse();
        }
    }

    return jobj;
}

public int deleteSetting(final String strDeviceId) {
    if (!StringUtility.isValid(strDeviceId)) {
        return ERR_INVALID_PARAMETER;
    }

    try {
    	Connection conn = connect(Common.DB_URL, Common.DB_USER, Common.DB_PASS);

        if (null != conn) {
        	Object[] vals = new Object[]{strDeviceId};

        	insertUpdateDelete(conn,
        			"DELETE FROM device_setting WHERE device_id = ?", vals);
        	insertUpdateDelete(conn,
        			"DELETE FROM routine_setting WHERE device_id = ?", vals);
        }

        closeConn(conn);
        return ERR_SUCCESS;
    } catch (Exception e) {
        e.printStackTrace();
        return ERR_EXCEPTION;
    }
}
%>

<%
	JSONObject jobj = processRequest(request);
	out.print(jobj.toString());
%>
