<%@include file="../../api_common.jsp"%>
<%@include file="../../response_generator.jsp"%>
<%@include file="../routine__common.jsp"%>

<%@ page import="java.util.Map" %>
<%@ page import="org.json.JSONObject" %>

<%!
// methods shared among /routine/delete/{brush, sleep}.jsp pages
// repeat-date.jsp is so special that almost nothing can be reused

private JSONObject processDeleteRoutineRequest(HttpServletRequest request, final String strType) {
    if (!request.getParameterMap().containsKey("device_id")
    		|| !request.getParameterMap().containsKey("routine_id")) {
        return ApiResponse.error(ApiResponse.STATUS_MISSING_PARAM);
    }

    final RoutineData rd = new RoutineData();
    if (!copyRequestParameterToRoutineData(request, rd)) {
        return ApiResponse.error(ApiResponse.STATUS_INVALID_PARAMETER);
    }

    final Connection conn = connect(Common.DB_URL, Common.DB_USER, Common.DB_PASS);
    if (conn == null) {
        return ApiResponse.error(ApiResponse.STATUS_INTERNAL_ERROR);
    }

    JSONObject jobj;

    int nCount = checkHasRoutineIdOwnership(conn, rd.device_id, rd.routine_id);
    if (nCount < 1) {
        switch (nCount) {
        case 0:
            // routine does not exist, or routine ID is owned by other device
            jobj = ApiResponse.error(ApiResponse.STATUS_INVALID_PARAMETER,
                    "invalid routine_id.");
            break;
        default:
            jobj = ApiResponse.byReturnStatus(nCount);
        }

        closeConn(conn);
        return jobj;
    }

    int nDelete = deleteRoutineSetting(conn, rd.device_id, rd.routine_id);
    if (0 < nDelete) {
        jobj = ApiResponse.successTemplate();
    } else {
        jobj = ApiResponse.byReturnStatus(nDelete);
    }

    closeConn(conn);
    return jobj;
}

public boolean hasRequiredParameters(final HttpServletRequest request) {
    Map paramMap = request.getParameterMap();
    return paramMap.containsKey("device_id") && paramMap.containsKey("routine_id");
}

public boolean copyRequestParameterToRoutineData(HttpServletRequest request, RoutineData rd) {
    rd.device_id = request.getParameter("device_id").trim();
    final String strRoutineId = request.getParameter("routine_id").trim();

    if (!isPositiveInteger(strRoutineId)) {
        return false;
    }

    rd.routine_id = Integer.parseInt(strRoutineId);
    return isValidDeviceId(rd.device_id);
}

public int deleteRoutineSetting(final Connection conn, final String deviceId, final int routineId) {
    return insertUpdateDelete(conn,
            "DELETE FROM `routine_setting` WHERE `routine_id`=? AND `device_id`=?",
            new Object[]{routineId, deviceId});
}
%>
