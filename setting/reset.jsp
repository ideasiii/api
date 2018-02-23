<%@ include file="../api_common.jsp"%>
<%@ include file="../response_generator.jsp"%>

<%@ page import="org.json.JSONObject"%>

<%
    request.setCharacterEncoding("UTF-8");
    JSONObject jobj = processRequest(request);
    out.print(jobj.toString());
%>

<%!
private JSONObject processRequest(HttpServletRequest request) {
	if (!request.getParameterMap().containsKey("device_id")) {
        return ApiResponse.error(ApiResponse.STATUS_MISSING_PARAM);
    }

    String strDeviceId = request.getParameter("device_id");

    if (strDeviceId == null) {
        return ApiResponse.error(ApiResponse.STATUS_MISSING_PARAM);
    }

    strDeviceId = strDeviceId.trim();
    if (!isValidDeviceId(strDeviceId)) {
        return ApiResponse.error(ApiResponse.STATUS_INVALID_PARAMETER);
    }

    final Connection conn = connect(Common.DB_URL, Common.DB_USER, Common.DB_PASS);
    if (conn == null) {
        return ApiResponse.error(ApiResponse.STATUS_INTERNAL_ERROR);
    }

    JSONObject jobj = tryIfDeviceNotExistInList(conn, strDeviceId);
    if (jobj != null) {
    	closeConn(conn);
    	return jobj;
    }

    int nDelete = deleteSetting(conn, strDeviceId);
    if (0 < nDelete) {
        jobj = ApiResponse.successTemplate();
    } else {
        jobj = ApiResponse.byReturnStatus(nDelete);
    }

    closeConn(conn);
    return jobj;
}

public int deleteSetting(Connection conn, final String strDeviceId) {
    Object[] vals = new Object[]{strDeviceId};

    int ret = insertUpdateDelete(conn,
    	    "DELETE FROM `device_setting` WHERE `device_id`=?", vals);

    if (ret == ERR_SUCCESS) {
        ret = insertUpdateDelete(conn,
                "DELETE FROM `routine_setting` WHERE `device_id`=?", vals);
    }

    return ret;
}
%>
