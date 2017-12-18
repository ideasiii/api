<%@ page contentType="text/html; charset=utf-8" language="java"
	session="false"%>
<%@ page import="org.json.JSONObject"%>


<%@include file="../api_common.jsp"%>

<%	
	final String strDeviceId = request.getParameter("device_id");
	final String strDeviceOs = request.getParameter("device_os");
	Logs.showTrace("********"+strDeviceId+" os: "+strDeviceOs);
	boolean bSuccess = false; 
	String strError = null;
	String strMessage = null;
	DeviceData deviData = new DeviceData();
	
	
	int nCount = queryDevice(strDeviceId, deviData);
	
	if (0 < nCount) {
		//deviceID exist
	
		strError = "ER0240";
		strMessage = "device_id conflict.";
	
		JSONObject jobj = new JSONObject();
		jobj.put("success", bSuccess);
		jobj.put("error", strError);
		jobj.put("message", strMessage);
		
		Logs.showTrace("********error*********nCount: " + nCount);
		out.println(jobj.toString());
	
		
	} else {
		//deviceID not found
	
	int nInsert = insertDevice(strDeviceId, strDeviceOs);
	
	if (0 < nInsert) {
		bSuccess = true;
		
		JSONObject jobj = new JSONObject();
		jobj.put("success", bSuccess);
		
		Logs.showTrace("**********************nInsert: " + nInsert);
		out.println(jobj.toString());
		}
		
		else {
			
			switch (nInsert)
			{
			case 0:
				strError = "ER0500";
				strMessage = "Internal server error.";
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
				
				Logs.showTrace("********error*********nInsert: " + nInsert);
				out.println(jobj.toString());
		}
	
	}
%>

