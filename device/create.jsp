<%@ page contentType="text/html; charset=utf-8" language="java"
	session="false"%>
<%@ page import="org.json.JSONObject"%>


<%@include file="../api_common.jsp"%>

<%	
	final String strDeviceId = request.getParameter("device_id");
	final String strDeviceOs = request.getParameter("device_os");
	final String strMacAddress = request.getParameter("mac_address");
	boolean bSuccess = false; 
	DeviceData deviData = new DeviceData();
	
	int nCount = queryDevice(strDeviceId, deviData);
	
	if (0 < nCount) {
		bSuccess = true;
		
		JSONObject jobj = new JSONObject();
		jobj.put("success", bSuccess);
		jobj.put("device_os", deviData.device_os);
		jobj.put("mac_address", deviData.mac_address);
		
		Logs.showTrace("**********************nCount: " + nCount);
		out.println(jobj.toString());
		}
		
		else {
			
			String strError = null;
			String strMessage = null;
		
			if (0 == nCount) {
				strError = "ER0100";
				strMessage = "Invalid device_id.";
			}
			
			if (0 > nCount) {
				strError = "ER0500";
				strMessage = "Internal server error.";
			}
			
			JSONObject jobj = new JSONObject();
			jobj.put("success", bSuccess);
			jobj.put("error", strError);
			jobj.put("message", strMessage);
			
			Logs.showTrace("********error*********nCount: " + nCount);
			out.println(jobj.toString());
		}
%>

