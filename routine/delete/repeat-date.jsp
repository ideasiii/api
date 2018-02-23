<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@include file="../../api_common.jsp"%>
<%@include file="../../response_generator.jsp"%>
<%@include file="../routine__common.jsp"%>

<%@ page import="java.util.Map"%>
<%@ page import="org.json.JSONObject"%>

<%
    request.setCharacterEncoding("UTF-8");
    JSONObject jobj = processDeleteRepeatDayRequest(request);
    out.print(jobj.toString());
%>

<%!
private JSONObject processDeleteRepeatDayRequest(HttpServletRequest request) {
    if (!hasRequiredParameters(request)) {
        return ApiResponse.error(ApiResponse.STATUS_MISSING_PARAM);
    }

    final RepeatData rd = new RepeatData();
    if (!copyRequestParameter(request, rd)) {
        return ApiResponse.error(ApiResponse.STATUS_INVALID_PARAMETER);
    }

    final Connection conn = connect(Common.DB_URL, Common.DB_USER, Common.DB_PASS);
    if (conn == null) {
        return ApiResponse.error(ApiResponse.STATUS_INTERNAL_ERROR);
    }

    JSONObject jobj = tryIfDeviceNotExistInList(conn, rd.device_id);
    if (jobj != null) {
        closeConn(conn);
        return jobj;
    }

    int nCount = checkHasRoutineSeqOwnership(conn, rd.device_id, rd.routine_seq);
    if (nCount < 1) {
        switch (nCount) {
        case 0:
            // routine does not exist, or routine ID is owned by other device
            jobj = ApiResponse.error(ApiResponse.STATUS_INVALID_PARAMETER,
                    "invalid routine_seq.");
            break;
        default:
            jobj = ApiResponse.byReturnStatus(nCount);
        }

        closeConn(conn);
        return jobj;
    }

    int nDelete = deleteRepeatWeekday(conn, rd.device_id, rd.routine_seq);
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
    return paramMap.containsKey("device_id") && paramMap.containsKey("routine_seq");
}

public boolean copyRequestParameter(HttpServletRequest request, RepeatData rd) {
    rd.device_id = request.getParameter("device_id");
    String strRoutineSeq = request.getParameter("routine_seq");

    if (rd.device_id == null || strRoutineSeq == null) {
        return false;
    }

    rd.device_id = rd.device_id.trim();
    strRoutineSeq = strRoutineSeq.trim();

    if (!isPositiveInteger(strRoutineSeq)) {
        return false;
    }

    rd.routine_seq = Integer.parseInt(strRoutineSeq);

    return isValidDeviceId(rd.device_id);
}

private int deleteRepeatWeekday(Connection conn, final String strDeviceId, final int routineSeq) {
	return insertUpdateDelete(conn,
	        "DELETE FROM `routine_repeat` WHERE `routine_seq`=?",
	        new Object[]{Integer.valueOf(routineSeq)});
}
%>
