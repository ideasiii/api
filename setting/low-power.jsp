<%@ page contentType="text/html; charset=utf-8" language="java"
	session="false"%>
<%@ page import="org.json.JSONObject"%>


<%@include file="../api_common.jsp"%>

<%
	final String strDeviceId = request.getParameter("device_id");
	final String strType = "battery";
	String strAction = request.getParameter("action");
	boolean bSuccess = false;
	String strError = null;
	String strMessage = null;
	DeviceData deviData = new DeviceData();
	DeviceSetData deviSetData = new DeviceSetData();

	int nAction = -1;
	if (strAction != null && !strAction.trim().isEmpty()) {

		try {
			nAction = Integer.parseInt(strAction.trim());
		} catch (Exception e) {
			strError = "ER0220";
			strMessage = "Invalid input.";

			JSONObject jobj = new JSONObject();
			jobj.put("success", bSuccess);
			jobj.put("error", strError);
			jobj.put("message", strMessage);

			Logs.showTrace("********error*********nAction: " + nAction + " strAction: " + strAction);
			out.println(jobj.toString());
			return;
		}

		int nCountDevice = queryDevice(strDeviceId, deviData);

		if (0 < nCountDevice) {
			//Device exist

			int nCount = querySetting(strDeviceId, strType, deviSetData);

			if (0 < nCount && -1 < nAction) {
				//setting exist
				int nUpdate = 0;

				// update battery setting 
				nUpdate = updateBattery(strDeviceId, strType, nAction);

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
				nInsert = insertBattery(strDeviceId, strType, nAction);

				if (0 < nInsert && -1 < nAction) {
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

					Logs.showTrace("********error*********nInsert: " + nInsert + "***nAction: " + nAction
							+ " id: " + strDeviceId);
					out.println(jobj.toString());
				}
			}
		} else {
			//Device not found
			switch (nCountDevice) {
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

			Logs.showTrace("********error*********nCountDevice: " + nCountDevice);
			out.println(jobj.toString());
		}

	} else {
		if (strAction == null) {
			strError = "ER0120";
			strMessage = "Required parameter missing.";
		} else {
			if (strAction.trim().isEmpty()) {
				strError = "ER0220";
				strMessage = "Invalid action.";
			} else {
				strError = "ER0220";
				strMessage = "Invalid input.";
			}
		}

		JSONObject jobj = new JSONObject();
		jobj.put("success", bSuccess);
		jobj.put("error", strError);
		jobj.put("message", strMessage);

		out.println(jobj.toString());
	} // invalid Action
%>