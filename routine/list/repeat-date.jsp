<%@include file="../../api_common.jsp"%>
<%@include file="../../response_generator.jsp"%>
<%@include file="../routine__common.jsp"%>

<%@ page import="java.util.Map"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="org.json.JSONObject"%>

<%
    JSONObject jobj = processListRepeatDayRequest(request);
    out.print(jobj.toString());
%>

<%!
private JSONObject processListRepeatDayRequest(HttpServletRequest request) {
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

    JSONArray resArr = new JSONArray();
    int nSelect = selectRepeatDays(conn, rd, resArr);
    if (nSelect < 0) {
        // SELECT failed
        jobj = ApiResponse.byReturnStatus(nSelect);
    } else {
        jobj = ApiResponse.successTemplate();
        jobj.put("result", resArr);
    }

    closeConn(conn);
    return jobj;
}

public boolean hasRequiredParameters(final HttpServletRequest request) {
    Map paramMap = request.getParameterMap();
    return paramMap.containsKey("device_id") && paramMap.containsKey("routine_id");
}

public boolean copyRequestParameterToRoutineData(HttpServletRequest request, RoutineData rd) {
    rd.routine_type = ROUTINE_TYPE_BRUSH_TEETH;
    rd.device_id = request.getParameter("device_id").trim();
    final String strRoutineId = request.getParameter("routine_id").trim();

    if (!isPositiveInteger(strRoutineId)) {
        return false;
    }

    rd.routine_id = Integer.parseInt(strRoutineId);

    return isValidDeviceId(rd.device_id);
}

public int selectRepeatDays(final Connection conn, final RoutineData rd, final JSONArray out) {
    SelectResult sr = new SelectResult();

    return select(conn, "SELECT `routine_seq`, `weekday` FROM `routine_repeat` WHERE `routine_id`=? ORDER BY `weekday`",
            new Object[]{rd.routine_id}, new ResultSetReader() {
        @Override
        public void read(ResultSet rs, SelectResult sr) throws Exception {
            sr.status = 0;

            while (rs.next()) {
                ++sr.status;
                JSONObject repeat = new JSONObject();
                repeat.put("routine_seq", rs.getInt("routine_seq"));
                repeat.put("weekday", rs.getString("weekday"));
                out.put(repeat);
            }
        }
    }, sr);
}

%>
