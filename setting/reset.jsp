<%@ page contentType="text/html; charset=utf-8" language="java"
	session="false"%>
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
		//Device exist
		int nDelete = 0;

		nDelete = deleteSetting(strDeviceId);
		if (0 < nDelete) {
			bSuccess = true;

			JSONObject jobj = new JSONObject();
			jobj.put("success", bSuccess);

			Logs.showTrace("**********************nDelete: " + nDelete);
			out.println(jobj.toString());
		} else {

			switch (nDelete) {
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

			Logs.showTrace("********error*********nDelete: " + nDelete);
			out.println(jobj.toString());
		}

	} else {
		//Device not found
		
		switch (nCount) {
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

