<%@include file="../../api_common.jsp"%>
<%@include file="../../response_generator.jsp"%>
<%@include file="../routine__common.jsp"%>

<%@ page import="org.json.JSONObject"%>

<%!
// methods shared among /routine/add/{brush, sleep}.jsp pages
// repeat-date.jsp is so special that almost nothing can be reused   

private JSONObject processAddRoutineRequest(HttpServletRequest request) {
    if (!hasRequiredParameters(request)) {
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

    JSONObject jobj = tryIfDeviceNotExistInList(conn, rd.device_id);
    if (jobj != null) {
    	closeConn(conn);
    	return jobj;
    }

    // Device exists, search for possibly duplicated routines
    int nCount = checkRoutineExistance(conn, rd.device_id, rd.routine_type, rd.start_time);

    if (nCount != 0) {
        if (nCount > 0) {
            // there is already a routine scheduled at given time
            jobj = ApiResponse.error(ApiResponse.STATUS_CONFLICTS_WITH_EXISTING_DATA,
            		"start_time conflict.");
        } else {
            jobj = ApiResponse.byReturnStatus(nCount);
        }

        closeConn(conn);
        return jobj;
    }

    // routine not found, insert
    int nInsert = insertRoutineSetting(conn, rd);

    if (nInsert < 1) {
        // routine insert failed
        jobj = ApiResponse.byReturnStatus(nInsert);

        closeConn(conn);
        return jobj;
    }

    // get the routine ID we have just added
    int nRoutineId = queryRoutineID(conn, rd.device_id, rd.routine_type, rd.start_time);

    if (nRoutineId < 1) {
        return ApiResponse.error(ApiResponse.STATUS_INTERNAL_ERROR);
    }

    jobj = ApiResponse.successTemplate();
    jobj.put("routine_id", nRoutineId);

    closeConn(conn);
    return jobj;
}

public int insertRoutineSetting(final Connection conn, final RoutineData rd) {
    return insertUpdateDelete(conn,
            "INSERT INTO `routine_setting` (`device_id`, `routine_type`, `title`, `start_time`, `repeat`, `meta_id`)VALUES(?,?,?,?,?,?)",
            new Object[]{rd.device_id, rd.routine_type, rd.title, rd.start_time, rd.repeat, rd.meta_id});
}

%>
