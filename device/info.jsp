<%@ include file="../api_common.jsp" %>
<%@ include file="../response_generator.jsp" %>

<%@ page import="org.json.JSONObject" %>

<%
	final String strDeviceId = request.getParameter("device_id");
	DeviceData deviData = new DeviceData();

	int nCount = queryDevice(strDeviceId, deviData);
	JSONObject jobj;

	if (0 < nCount) {
		jobj = new JSONObject();
		jobj.put("success", true);
		jobj.put("device_os", deviData.device_os);

		Logs.showTrace("**********************nCount: " + nCount);
	} else {
		switch (nCount) {
		case ERR_FAIL:
			jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_DATA_NOT_FOUND,
				"device_id not found.");
			break;
		case ERR_INVALID_PARAMETER:
			jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE,
				"Invalid device_id.");
			break;
		case ERR_EXCEPTION:
			jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR);
			break;
	    default:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR, "Unknown error.");
		}

		Logs.showTrace("********error*********nCount: " + nCount);
	}

	out.println(jobj.toString());
%>

