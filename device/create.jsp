<%@ page import="org.json.JSONObject"%>


<%@include file="../api_common.jsp"%>

<%! // methods used ONLY within this file
	public int insertDevice(final String strDeviceId, final String strDeviceOs) {
	    int nCount = 0;
	    Connection conn = null;
	    PreparedStatement pst = null;
	    String strSQL = "insert into device_list(device_id, device_os) values (?,?)";
	
	    if (!StringUtility.isValid(strDeviceId)) {
	        return ERR_INVALID_PARAMETER;
	    }
	
	    try {
	        DeviceData deviData = new DeviceData();
	        nCount = queryDevice(strDeviceId, deviData);
	        if (0 < nCount)
	            return ERR_CONFLICT;
	
	        conn = connect(Common.DB_URL, Common.DB_USER, Common.DB_PASS);
	
	        if (null != conn) {
	            pst = conn.prepareStatement(strSQL);
	            int idx = 1;
	            pst.setString(idx++, strDeviceId);
	            pst.setString(idx++, strDeviceOs);
	            pst.executeUpdate();
	        }
	        pst.close();
	        closeConn(conn);
	
	    } catch (Exception e) {
	        e.printStackTrace();
	        Logs.showTrace(e.toString());
	        return ERR_EXCEPTION;
	    }
	    return ERR_SUCCESS;
	}

%>

<%	
	final String strDeviceId = request.getParameter("device_id");
	final String strDeviceOs = request.getParameter("device_os");
	Logs.showTrace("********"+strDeviceId+" os: "+strDeviceOs);
	boolean bSuccess = false; 
	String strError = null;
	String strMessage = null;
	DeviceData deviData = new DeviceData();
	
	
	//int nCount = queryDevice(strDeviceId, deviData);
	
/*
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
		*/
		//deviceID not found
	
	int nInsert = insertDevice(strDeviceId, strDeviceOs);
	
	if (0 < nInsert) {
		bSuccess = true;
		
		JSONObject jobj = new JSONObject();
		jobj.put("success", bSuccess);
		
		Logs.showTrace("**********************nInsert: " + nInsert);
		out.println(jobj.toString());
		
		} else {
			
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
			case -3:
				strError = "ER0240";
				strMessage = "device_id conflict.";
				break;
			}
				
				JSONObject jobj = new JSONObject();
				jobj.put("success", bSuccess);
				jobj.put("error", strError);
				jobj.put("message", strMessage);
				
				Logs.showTrace("********error*********nInsert: " + nInsert);
				out.println(jobj.toString());
		}
	
//	}
%>

