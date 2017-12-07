<%@ page contentType="text/html; charset=utf-8" language="java"
	session="false"%>
<%@ page import="org.json.JSONObject"%>


<%@include file="../api_common.jsp"%>

<%
	final String strDeviceId = request.getParameter("device_id");
	boolean bSuccess = false;
	String strError = null;
	String strMessage = null;
	DeviceSetData deviSetData = new DeviceSetData();

	int nCount = queryResetSetting(strDeviceId, deviSetData);

	if (0 < nCount) {
		//setting exist
		int nUpdate = 0;
		int nAction = deviSetData.action;

		if (0 == nAction) {
			// update reset setting to cmmd
			nUpdate = updateResetSetting(strDeviceId, "reset", 1);

			if (0 < nUpdate) {
				bSuccess = true;

				JSONObject jobj = new JSONObject();
				jobj.put("success", bSuccess);

				Logs.showTrace("**********************nCount: " + nCount);
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

				Logs.showTrace("********error*********nCount: " + nCount);
				out.println(jobj.toString());
			}
		}

		if (1 == nAction) {
			// update reset setting to acted
			nUpdate = updateResetSetting(strDeviceId, "reset", 0);

			if (0 < nUpdate) {
				bSuccess = true;

				JSONObject jobj = new JSONObject();
				jobj.put("success", bSuccess);

				Logs.showTrace("**********************nCount: " + nCount);
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

				Logs.showTrace("********error*********nCount: " + nCount);
				out.println(jobj.toString());
			}
		}
	}

	else {
		//setting not found

		
		
		
		
	}
%>

