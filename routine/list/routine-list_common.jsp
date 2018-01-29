<%@include file="../../api_common.jsp"%>
<%@include file="../../response_generator.jsp"%>
<%@include file="../db_op.jsp"%>

<%@ page import="org.json.JSONArray" %>

<%! // methods shared among /routine/list/___.jsp pages

private JSONObject processListRoutineRequest(HttpServletRequest request, final String strType) {
    if (!request.getParameterMap().containsKey("device_id")) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_MISSING_PARAM);
    }

    final String strDeviceId = request.getParameter("device_id");

    if (!isValidDeviceId(strDeviceId)) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE, "Invalid device_id.");
    }

    ArrayList<RoutineData> listRoutine = new ArrayList<RoutineData>();
    JSONObject jobj;

    int nCount = queryRoutineList(strDeviceId, strType, listRoutine);

    // TODO there maybe one possibility: device ID exists, but no routine is inserted to DB
    // TODO there maybe one possibility: device ID exists, but no routine is inserted to DB
    // TODO there maybe one possibility: device ID exists, but no routine is inserted to DB
    // TODO there maybe one possibility: device ID exists, but no routine is inserted to DB
    // TODO there maybe one possibility: device ID exists, but no routine is inserted to DB
    
    if (0 < nCount) {
        // routine settings exist
        Logs.showTrace("**********************listRoutine: " + listRoutine.get(0).device_id);

        JSONArray jsonArray = new JSONArray();
        for (int i = 0; i < listRoutine.size(); i++) {
            RoutineData rd = listRoutine.get(i);
            JSONObject rdJson = new JSONObject();
            
            // 同樣是 RoutineData，不同的 API 要給予的回應可能會有出入。
            // 實作 mapRoutineDataToObjectInResultArray(RoutineData, JSONObject)
            // 以控制要把 RoutineData 內的那些資料傳回給 client
            mapRoutineDataToObjectInResultArray(rd, rdJson);

            jsonArray.put(rdJson);
        }

        jobj = ApiResponse.getSuccessResponseTemplate();
        jobj.put("result", jsonArray);

        Logs.showTrace("**********************nCount: " + nCount + " result: " + jsonArray.toString());
    } else {
        // routine setting not found
        switch (nCount) {
        case 0:
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
