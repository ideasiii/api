<%@ page contentType="text/html; charset=utf-8" language="java"
	session="false"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="org.json.JSONException"%>

<%@include file="../../api_common.jsp"%>  

<%
	final String strDeviceId = request.getParameter("device_id");
	final String strType = "brush teeth";
	final String strTitle = request.getParameter("title");
	final String strTime = request.getParameter("start_time");
	String strRepeat = request.getParameter("repeat");
	boolean bSuccess = false;
	String strError = null;
	String strMessage = null;
	DeviceData deviData = new DeviceData();
	ArrayList<RoutineData> listRoutine = new ArrayList<RoutineData>();
	

	if (strTime != null && !strTime.isEmpty()) {
	
		boolean time = false; 
		time = checkTime(strTime);
		
			if (time != true) {
		
			strError = "ER0210";
			strMessage = "Invalid time format.";
			
			JSONObject jobj = new JSONObject();
			jobj.put("success", bSuccess);
			jobj.put("error", strError);
			jobj.put("message", strMessage);

			Logs.showTrace("********error*********Time: " + time);
			out.println(jobj.toString());
			return;
			}
			
	} else {
		if (strTime == null) {
			strError = "ER0120";
			strMessage = "Required parameter missing.";
		} else {
			if (strTime.trim().isEmpty()) {
				strError = "ER0220";
				strMessage = "Invalid time.";
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
		return;
	}// invalid Start_time input
			
	
	int nRepeat = -1;
	if (strRepeat != null && !strRepeat.isEmpty()) {
	
		try {
			nRepeat = Integer.parseInt(strRepeat.trim());
			} catch (Exception e) {
				strError = "ER0220";
				strMessage = "Invalid input.";
				
				JSONObject jobj = new JSONObject();
				jobj.put("success", bSuccess);
				jobj.put("error", strError);
				jobj.put("message", strMessage);

				Logs.showTrace("********error*********nRepeat: " + nRepeat + " strRepeat: " + strRepeat);
				out.println(jobj.toString());
				return;
			}
	
		int nCountDevice = queryDevice(strDeviceId, deviData);
		
			if (0 < nCountDevice) {
				//Device exist
		
				int nCount = queryRoutine(strDeviceId, strType, listRoutine);
		
				if (0 == nCount) {
					//routine not found
				int nInsert = 0;
					
				 nInsert = insertBrush(strDeviceId, strType, strTitle, strTime, nRepeat);
				
				 if (0 < nInsert && -1 < nRepeat) {
						bSuccess = true;
						int nRoutineId = routineData.routine_id;
						
						JSONObject jobj = new JSONObject();
						jobj.put("success", bSuccess);
						jobj.put("routine_id", bSuccess);

						Logs.showTrace("**********************nInsert: " + nInsert);
						out.println(jobj.toString());
					}	
				 
				 
				 
				 
				 
				 
					
					
					
					
				} else {
				//routine conflict or exception
				switch (nCount) 
				{
				case 1:
					strError = "ER0240";
					strMessage = "brush teeth setting conflict.";
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
				return;
				}
				
			} else {
				//Device not found
				switch (nCountDevice)
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
					strMessage = "Invalid device_id.";
					break;
				}
					
					JSONObject jobj = new JSONObject();
					jobj.put("success", bSuccess);
					jobj.put("error", strError);
					jobj.put("message", strMessage);
					
					Logs.showTrace("********error*********nCountDevice: " + nCountDevice);
					out.println(jobj.toString());
					return;
			}
		

	} else {
		if (strRepeat == null) {
			strError = "ER0120";
			strMessage = "Required parameter missing.";
		} else {
			if (strRepeat.trim().isEmpty()) {
				strError = "ER0220";
				strMessage = "Invalid repeat.";
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
		return;
	} // invalid Repeat input
	

	
%>