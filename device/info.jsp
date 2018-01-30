<%@ include file="../api_common.jsp" %>
<%@ include file="../response_generator.jsp" %>

<%@ page import="org.json.JSONObject" %>


<%! // methods used ONLY within this file

private JSONObject processRequest(HttpServletRequest request) {
    if (!request.getParameterMap().containsKey("device_id")) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_MISSING_PARAM);
    }

    final String strDeviceId = request.getParameter("device_id");

    if (!isValidDeviceId(strDeviceId)) {
        return ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_PARAMETER, "Invalid device_id.");
    }

    DeviceData deviData = new DeviceData();
    JSONObject jobj;
    int nCount = queryDevice(strDeviceId, deviData);

    if (0 < nCount) {
        jobj = ApiResponse.getSuccessResponseTemplate();
        jobj.put("device_os", deviData.device_os);
    } else {
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

<%
	JSONObject jobj = processRequest(request);
	out.print(jobj.toString());
%>
