<%@ include file="../../api_common.jsp"%>
<%@ include file="../../response_generator.jsp"%>
<%@ include file="../setting__common.jsp"%>

<%@ page import="org.json.JSONObject"%>

<%! // methods shared among /setting/option/___.jsp pages

public JSONObject processRequest(HttpServletRequest request, String strType) {
    if (!request.getParameterMap().containsKey("device_id")) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_MISSING_PARAM);
    }

    final String strDeviceId = request.getParameter("device_id");

    if (!isValidDeviceId(strDeviceId)) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_PARAMETER, "Invalid device_id.");
    }

    DeviceSetData deviSetData = new DeviceSetData();
    JSONObject jobj;

    int nCount = querySetting(strDeviceId, strType, deviSetData);

    if (0 < nCount) {
        // setting exists
        jobj = ApiResponse.getSuccessResponseTemplate();
        jobj.put("result", deviSetData.action);
    } else {
        // setting not found
        switch (nCount) {
        case 0:
            jobj = ApiResponse.deviceIdNotFoundResponse();
            break;
        case ERR_EXCEPTION:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR);
            break;
        default:
            jobj = ApiResponse.getUnknownErrorResponse();
        }
    }

    return jobj;
}

%>
