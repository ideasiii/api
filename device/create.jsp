<%@ page contentType="text/html; charset=utf-8" language="java"
	session="false"%>
<%@ page import="org.json.JSONObject"%>


<%@include file="../api_common.jsp"%>

<%	
	final String strDeviceId = request.getParameter("device_id");
	final String strDeviceOs = request.getParameter("device_os");
	final String strMacAddress = request.getParameter("mac_address");
	boolean bSuccess = false; 
	String strError = null;
	String strMessage = null;
	
	int nCount = insertDevice(strDeviceId, strDeviceOs, strMacAddress);
	
	if (0 < nCount) {
		bSuccess = true;
		
		JSONObject jobj = new JSONObject();
		jobj.put("success", bSuccess);
		
		Logs.showTrace("**********************nCount: " + nCount);
		out.println(jobj.toString());
		}
		
		else {
			
			switch (nCount)
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
				
				Logs.showTrace("********error*********nCount: " + nCount);
				out.println(jobj.toString());
		}
%>

