<%@ page contentType="text/html; charset=utf-8" language="java"
	session="false"%>
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
	RoutineData routineData = new RoutineData();
	ArrayList<RoutineData> listRoutine = new ArrayList<RoutineData>();
	
	int nCount = queryRoutine(strDeviceId, strType, listRoutine);
	  
	if (0 < nCount) {
		//routine setting exist
		
		JSONArray jarray = new JSONArray(listRoutine);
		bSuccess = true;
		
		JSONObject jobj = new JSONObject();
		jobj.put("success", bSuccess);
		jobj.put("result", jarray);

		Logs.showTrace("**********************nCount: " + nCount + " result: " + jarray);
		out.println(jobj.toString());
	
	} else {
		//routine setting not found
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