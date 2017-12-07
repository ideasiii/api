<%@ page contentType="text/html; charset=utf-8" language="java"
	session="false"%>
<%@ page import="org.json.JSONObject"%>


<%@include file="../api_common.jsp"%>

<%
	final String strDeviceId = request.getParameter("device_id");
	int nAction = Integer.parseInt(request.getParameter("action"));

	boolean bSuccess = false;
	String strError = null;
	String strMessage = null;
	DeviceSetData deviSetData = new DeviceSetData();

	int nCount = queryBattery(strDeviceId, deviSetData);

	if (0 < nCount) {
		//setting exist
		int nUpdate = 0;

		// update battery setting 
		nUpdate = updateBattery(strDeviceId, "battery", nAction);

		if (0 < nUpdate) {
			bSuccess = true;

			JSONObject jobj = new JSONObject();
			jobj.put("success", bSuccess);

			Logs.showTrace("**********************nUpdate: " + nUpdate);
			out.println(jobj.toString());
		} else {

			switch (nUpdate) {
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

			Logs.showTrace("********error*********nUpdate: " + nUpdate);
			out.println(jobj.toString());
		}

	} else {
		//setting not found
		int nInsert = 0;

		//insert battery setting
		nInsert = insertBattery(strDeviceId, "battery", nAction);

		if (0 < nInsert) {
			bSuccess = true;

			JSONObject jobj = new JSONObject();
			jobj.put("success", bSuccess);

			Logs.showTrace("**********************nInsert: " + nInsert);
			out.println(jobj.toString());
		} else {
		
			switch (nInsert) {
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