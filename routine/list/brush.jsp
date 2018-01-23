<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="org.json.JSONException"%>

<%@include file="../../api_common.jsp"%>

<%
	final String strDeviceId = request.getParameter("device_id");
	final String strType = "brush teeth";
	boolean bSuccess = false;
	String strError = null;
	String strMessage = null;
	ArrayList<RoutineData> listRoutine = new ArrayList<RoutineData>();

	int nCount = queryRoutineList(strDeviceId, strType, listRoutine);

	if (0 < nCount) {
		//routine setting exist
		Logs.showTrace("**********************listRoutine: " + listRoutine.get(0).device_id);

		JSONArray jsonArray = new JSONArray();
		for (int i = 0; i < listRoutine.size(); i++) {
			JSONObject jobj = new JSONObject();
			jobj.put("routine_id", listRoutine.get(i).routine_id);
			jobj.put("titled", listRoutine.get(i).title);
			jobj.put("start_time", listRoutine.get(i).start_time);
			jobj.put("repeat", listRoutine.get(i).repeat);
			jsonArray.put(jobj);
		}

		bSuccess = true;

		JSONObject jobjResult = new JSONObject();
		jobjResult.put("success", bSuccess);
		jobjResult.put("result", jsonArray);

		Logs.showTrace("**********************nCount: " + nCount + " result: " + jsonArray.toString());
		out.println(jobjResult.toString());

	} else {
		//routine setting not found
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