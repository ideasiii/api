<%@ include file="../api_common.jsp"%>
<%@ include file="../response_generator.jsp"%>

<%@ page import="org.json.JSONObject"%>

<%
    JSONObject jobj = processRequest(request);
    out.print(jobj.toString());
%>

<%! // methods used ONLY within this file

private JSONObject processRequest(HttpServletRequest request) {
    if (!request.getParameterMap().containsKey("device_id")
            || !request.getParameterMap().containsKey("device_os")) {
        return ApiResponse.error(ApiResponse.STATUS_MISSING_PARAM);
    }

    final String strDeviceId = request.getParameter("device_id").trim();
    final String strDeviceOs = request.getParameter("device_os").trim();

    if (!isValidDeviceId(strDeviceId)) {
        return ApiResponse.error(ApiResponse.STATUS_INVALID_PARAMETER, "Invalid device_id.");
    } else if (!isNotEmptyString(strDeviceOs)) {
        return ApiResponse.error(ApiResponse.STATUS_INVALID_PARAMETER, "Invalid device_os.");
    }

    final Connection conn = connect(Common.DB_URL, Common.DB_USER, Common.DB_PASS);
    if (conn == null) {
        return ApiResponse.error(ApiResponse.STATUS_INTERNAL_ERROR);
    }

    JSONObject jobj;
    int nInsert = insertDevice(conn, strDeviceId, strDeviceOs);

    if (0 < nInsert) {
        jobj = ApiResponse.successTemplate();
    } else {
        switch (nInsert) {
        case ERR_CONFLICT:
            jobj = ApiResponse.error(ApiResponse.STATUS_CONFLICTS_WITH_EXISTING_DATA,
                    "device_id conflict.");
            break;
        default:
            jobj = ApiResponse.byReturnStatus(nInsert);
        }
    }

    closeConn(conn);
    return jobj;
}

private int insertDevice(Connection conn, final String strDeviceId, final String strDeviceOs) {
    int nCount = checkDeviceIdExistance(conn, strDeviceId);
    if (nCount != 0) {
    	return (nCount > 0) ? ERR_CONFLICT : nCount;
    }

	return insertUpdateDelete(conn,
	        "INSERT INTO device_list(device_id, device_os) VALUES (?,?)",
	        new Object[]{strDeviceId, strDeviceOs});
}
%>
