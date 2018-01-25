<%@ include file="../../api_common.jsp" %>
<%@ include file="../../response_generator.jsp" %>

<%@ page import="org.json.JSONObject"%>

<%
	final String strDeviceId = request.getParameter("device_id");
	final String strType = "language";
	DeviceSetData deviSetData = new DeviceSetData();
	JSONObject jobj;
	
	// TODO check required param in "request"
	
	int nCount = querySetting(strDeviceId, strType, deviSetData);
	
	if (0 < nCount) {
		// setting exists
        jobj = new JSONObject();
        jobj.put("success", true);
        jobj.put("result", deviSetData.action);

		Logs.showTrace("**********************nCount: " + nCount + " action: " + deviSetData.action);
	} else {
        // setting not found
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
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR, "Unknown error.");
        }
        
        Logs.showTrace("********error*********nCount: " + nCount);
    }
    
    out.println(jobj.toString());	
%>
