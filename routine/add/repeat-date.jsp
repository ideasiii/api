<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@include file="../../api_common.jsp"%>
<%@include file="../../response_generator.jsp"%>
<%@include file="../routine__common.jsp"%>

<%@ page import="java.util.Map"%>
<%@ page import="org.json.JSONObject"%>

<%
    request.setCharacterEncoding("UTF-8");
    JSONObject jobj = processAddRepeatDayRequest(request);
    out.print(jobj.toString());
%>

<%!
private JSONObject processAddRepeatDayRequest(HttpServletRequest request) {
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

   // check if routine_id already has the weekday already been set
    int nRoutineSeq = queryRepeatRoutineSequence(conn, rd.routine_id, rd.weekday);
    if (nRoutineSeq != 0) {
        if (nRoutineSeq > 0) {
            // routine_id has already been set to repeat on given weekday
            // report ok to client
            jobj = ApiResponse.successTemplate();
            jobj.put("routine_seq", nRoutineSeq);
        } else {
            jobj = ApiResponse.byReturnStatus(nRoutineSeq);
        }

        closeConn(conn);
        return jobj;
    }

    // routine_seq not found, insert
    int nInsert = insertRepeatWeekday(conn, rd.routine_id, rd.weekday);
    if (nInsert < 1) {
        // routine insert failed
        jobj = ApiResponse.byReturnStatus(nInsert);

        closeConn(conn);
        return jobj;
    }

    nRoutineSeq = queryRepeatRoutineSequence(conn, rd.routine_id, rd.weekday);
    if (nRoutineSeq > 0) {
        jobj = ApiResponse.successTemplate();
        jobj.put("routine_seq", nRoutineSeq);
    } else {
        jobj = ApiResponse.byReturnStatus(nRoutineSeq);
    }

    closeConn(conn);
    return jobj;
}

public boolean hasRequiredParameters(final HttpServletRequest request) {
    Map paramMap = request.getParameterMap();
    return paramMap.containsKey("device_id") && paramMap.containsKey("routine_id")
            && paramMap.containsKey("weekday");
}

public boolean copyRequestParameter(HttpServletRequest request, RepeatData rd) {
    rd.device_id = request.getParameter("device_id").trim();
    final String strRoutineId = request.getParameter("routine_id").trim();
    final String strWeekday = request.getParameter("weekday").trim();

    if (!isPositiveInteger(strRoutineId) || !isPositiveInteger(strWeekday)) {
        return false;
    }

    rd.routine_id = Integer.parseInt(strRoutineId);
    rd.weekday = Integer.parseInt(strWeekday);

    return isValidDeviceId(rd.device_id) && isValidWeekday(rd.weekday);
}

private int insertRepeatWeekday(Connection conn, final int routineId, final int repeatWeekday) {
	return insertUpdateDelete(conn,
	        "INSERT INTO `routine_repeat`(`routine_id`,`weekday`) VALUES (?,?);",
	        new Object[]{Integer.valueOf(routineId), Integer.valueOf(repeatWeekday)});
}
%>
