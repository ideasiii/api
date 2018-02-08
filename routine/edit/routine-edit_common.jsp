<%@include file="../../api_common.jsp"%>
<%@include file="../../response_generator.jsp"%>
<%@include file="../routine__common.jsp"%>

<%@ page import="org.json.JSONObject"%>

<%!
// methods shared among /routine/edit/{brush, sleep}.jsp pages

private JSONObject processEditRoutineRequest(HttpServletRequest request) {
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

    int nCount = checkHasRoutineIdOwnership(conn, rd.device_id, rd.routine_id);
    if (nCount < 1) {
        switch (nCount) {
        case 0:
        	// routine does not exist, or routine ID is owned by other device
            jobj = ApiResponse.error(ApiResponse.STATUS_INVALID_PARAMETER,
                    "invalid routine_id.");
        default:
            jobj = ApiResponse.byReturnStatus(nCount);
        }

        closeConn(conn);
        return jobj;
    }

    nCount = checkRoutineTypeMatches(conn, rd.routine_id, rd.routine_type);
    if (nCount < 1) {
        switch (nCount) {
        case 0:
            // routine does not exist, or routine ID is owned by others
            jobj = ApiResponse.error(ApiResponse.STATUS_INVALID_PARAMETER,
                    "routine type mismatch.");
        default:
            jobj = ApiResponse.byReturnStatus(nCount);
        }

        closeConn(conn);
        return jobj;
    }

    // Device exists, search for possibly conflicting start_time
    nCount = checkRoutineExistance(conn, rd.device_id, rd.routine_type, rd.start_time);
    if (nCount != 0) {
        if (nCount > 0) {
            jobj = ApiResponse.error(ApiResponse.STATUS_CONFLICTS_WITH_EXISTING_DATA,
                    "start_time conflict.");
        } else {
        	jobj = ApiResponse.byReturnStatus(nCount);
        }

        closeConn(conn);
        return jobj;
    }

    int nUpdate = updateRoutineSetting(conn, rd);
    if (nUpdate < 1) {
    	jobj = ApiResponse.byReturnStatus(nUpdate);
    } else {
        jobj = ApiResponse.successTemplate();
    }

    closeConn(conn);
    return jobj;
}

public int updateRoutineSetting(final Connection conn, final RoutineData rd) {
    return insertUpdateDelete(conn,
            "UPDATE `routine_setting` SET `title`=?, `start_time`=?, `repeat`=?, `meta_id`=? WHERE `routine_id`=?",
            new Object[]{rd.title, rd.start_time, rd.repeat, rd.meta_id, rd.routine_id});
}

%>
