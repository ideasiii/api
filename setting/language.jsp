<%@ page contentType="text/html; charset=utf-8" language="java"
	session="false"%>
<%@ page import="org.json.JSONObject"%>


<%@include file="../api_common.jsp"%>

<%
	final String strDeviceId = request.getParameter("device_id");
	final String strType = "language";
	String strAction = request.getParameter("action");
	int nAction = 0;
	if (strAction != null && !strAction.isEmpty())
		nAction = Integer.parseInt(strAction.trim());

	boolean bSuccess = false;
	String strError = null;
	String strMessage = null;
	DeviceSetData deviSetData = new DeviceSetData();

	int nCount = querySetting(strDeviceId, strType, deviSetData);

	if (0 < nCount) {
		//setting exist
		int nUpdate = 0;

		// update language setting 
		nUpdate = updateLanguage(strDeviceId, strType, nAction);

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
				break;git
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

		//insert language setting
		nInsert = insertLanguage(strDeviceId, strType, nAction);

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

			Logs.showTrace("********error*********nInsert: " + nInsert + "***nAction: " + nAction + "id: " + strDeviceId);
			out.println(jobj.toString());
		}
	}
%>