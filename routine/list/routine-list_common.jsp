<%@include file="../../api_common.jsp"%>
<%@include file="../../response_generator.jsp"%>
<%@include file="../routine__common.jsp"%>

<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>

<%! // methods shared among /routine/list/___.jsp pages

private JSONObject processListRoutineRequest(HttpServletRequest request, final String strType) {
    if (!request.getParameterMap().containsKey("device_id")) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_MISSING_PARAM);
    }

    final String strDeviceId = request.getParameter("device_id");

    if (!isValidDeviceId(strDeviceId)) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_PARAMETER, "Invalid device_id.");
    }


    final Connection conn = connect(Common.DB_URL, Common.DB_USER, Common.DB_PASS);
    if (conn == null) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR);
    }

    JSONObject jobj = tryIfDeviceNotExistInList(conn, strDeviceId);
    if (jobj != null) {
    	closeConn(conn);
    	return jobj;
    }
    
    ArrayList<RoutineData> listRoutine = new ArrayList<RoutineData>();
    int nCount = queryRoutineList(strDeviceId, strType, listRoutine);

    if (nCount >= 0) {
        JSONArray jsonArray = new JSONArray();
        for (int i = 0; i < listRoutine.size(); i++) {
            RoutineData rd = listRoutine.get(i);
            JSONObject rdJson = new JSONObject();

            // 同樣是 RoutineData，不同的 API 會從從裡面抽取不同的內容。
            // 實作 mapRoutineDataToObjectInResultArray(RoutineData, JSONObject)
            // 以控制要把 RoutineData 內的那些資料傳回給 client
            mapRoutineDataToObjectInResultArray(rd, rdJson);

            jsonArray.put(rdJson);
        }

        jobj = ApiResponse.getSuccessResponseTemplate();
        jobj.put("result", jsonArray);
    } else {
        switch (nCount) {
        case ERR_EXCEPTION:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR);
            break;
        default:
            jobj = ApiResponse.getUnknownErrorResponse();
        }
    }

    closeConn(conn);
    return jobj;
}
%>
