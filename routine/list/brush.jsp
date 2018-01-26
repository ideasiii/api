<%@include file="../../api_common.jsp"%>
<%@include file="../../response_generator.jsp"%>
<%@include file="../db_op.jsp"%>

<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="org.json.JSONException"%>

<%
	JSONObject jobj = processRequest(request);
	out.print(jobj.toString());
%>

<%!
private JSONObject processRequest(HttpServletRequest request) {
    if (!request.getParameterMap().containsKey("device_id")) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_MISSING_PARAM);
    }

    final String strDeviceId = request.getParameter("device_id");

    if (!isValidDeviceId(strDeviceId)) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE, "Invalid device_id.");
    }
    
	ArrayList<RoutineData> listRoutine = new ArrayList<RoutineData>();
    JSONObject jobj;
    
	int nCount = queryRoutineList(strDeviceId, "brush teeth", listRoutine);

	if (0 < nCount) {
		// routine settings exist
		Logs.showTrace("**********************listRoutine: " + listRoutine.get(0).device_id);

		JSONArray jsonArray = new JSONArray();
		for (int i = 0; i < listRoutine.size(); i++) {
			RoutineData rd = listRoutine.get(i);
			
			JSONObject rdJson = new JSONObject();
			rdJson.put("routine_id", rd.routine_id);
			rdJson.put("titled", rd.title);
			rdJson.put("start_time", rd.start_time);
			rdJson.put("repeat", rd.repeat);
			
			jsonArray.put(rdJson);
		}

        jobj = ApiResponse.getSuccessResponseTemplate();
        jobj.put("result", jsonArray);

		Logs.showTrace("**********************nCount: " + nCount + " result: " + jsonArray.toString());
	} else {
		// routine setting not found
		switch (nCount) {
		case ERR_FAIL:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_DATA_NOT_FOUND, 
            		"device_id not found.");
			break;
		case ERR_EXCEPTION:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR);
			break;
		case ERR_INVALID_PARAMETER:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE);
			break;
		default:
            jobj = ApiResponse.getUnknownErrorResponse();
        }

		Logs.showTrace("********error*********nCount: " + nCount);
	}
	
	return jobj;
}
%>
