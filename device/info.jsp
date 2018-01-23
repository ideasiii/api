<%@ page import="org.json.JSONObject"%>


<%@include file="../api_common.jsp"%> 

<%	
	final String strDeviceId = request.getParameter("device_id");
	boolean bSuccess = false; 
	String strError = null;
	String strMessage = null;
	DeviceData deviData = new DeviceData();
	
	int nCount = queryDevice(strDeviceId, deviData);
	
	if (0 < nCount) {
		bSuccess = true;
		
		JSONObject jobj = new JSONObject();
		jobj.put("success", bSuccess);
		jobj.put("device_os", deviData.device_os);
		
		Logs.showTrace("**********************nCount: " + nCount);
		out.println(jobj.toString());
		
		} else {
			
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
			strMessage = "Invalid device_id.";
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

