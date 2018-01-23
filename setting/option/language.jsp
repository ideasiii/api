<%@ page import="org.json.JSONObject"%>


<%@include file="../../api_common.jsp"%> 

<%
	final String strDeviceId = request.getParameter("device_id");
	final String strType = "language";
	boolean bSuccess = false;
	String strError = null;
	String strMessage = null;
	DeviceSetData deviSetData = new DeviceSetData();
	
	int nCount = querySetting(strDeviceId, strType, deviSetData);
	
	if (0 < nCount) {
		//setting exist
		bSuccess = true;
		
		JSONObject jobj = new JSONObject();
		jobj.put("success", bSuccess);
		jobj.put("result", deviSetData.action);

		Logs.showTrace("**********************nCount: " + nCount + " action: " + deviSetData.action);
		out.println(jobj.toString());
	
	} else {
		//setting not found
		switch (nCount)
		{
		case 0:
			strError = "ER0100";
			strMessage = "device_id not found.";
			break;
		case -1:
			strError = "ER0500";
			strMessage = "Internal server error.";
			break;
		case -2:
			strError = "ER0220";
			strMessage = "Invalid input.";
			break;
		}
			
			JSONObject jobj = new JSONObject();
			jobj.put("success", bSuccess);
			jobj.put("error", strError);
			jobj.put("message", strMessage);
			
			Logs.showTrace("********error*********nCount: " + nCount);
			out.println(jobj.toString());
	}
	
%>