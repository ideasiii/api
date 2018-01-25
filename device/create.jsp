<%@include file="../api_common.jsp"%>
<%@ include file="../response_generator.jsp" %>

<%@ page import="org.json.JSONObject"%>

<%! // methods used ONLY within this file

	public int insertDevice(final String strDeviceId, final String strDeviceOs) {
	    int nCount = 0;
	    Connection conn = null;
	    PreparedStatement pst = null;
	    String strSQL = "INSERT INTO device_list(device_id, device_os) VALUES (?,?)";
	
	    if (!StringUtility.isValid(strDeviceId)) {
	        return ERR_INVALID_PARAMETER;
	    }
	    
	    try {
	        DeviceData deviData = new DeviceData();
	        nCount = queryDevice(strDeviceId, deviData);
	        if (0 < nCount) {
	            return ERR_CONFLICT;
	        }
	
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
	
	// TODO check if device_id and device_os both exists
	
	Logs.showTrace("********" + strDeviceId + " os: " + strDeviceOs);
	JSONObject jobj;
	
	int nInsert = insertDevice(strDeviceId, strDeviceOs);
	
	if (0 < nInsert) {
		jobj = new JSONObject();
		jobj.put("success", true);
		
		Logs.showTrace("**********************nInsert: " + nInsert);		
	} else {
		switch (nInsert) {
		case ERR_FAIL:
		case ERR_EXCEPTION:
		    jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR);
			break;
		case ERR_INVALID_PARAMETER:
			jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE);
			break;
		case ERR_CONFLICT:
			jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_CONFLICTS_WITH_EXISTING_DATA,
	                "device_id conflict.");
			break;
		default:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR, "Unknown error.");
		}
		
		Logs.showTrace("********error*********nInsert: " + nInsert);
		
	}
	
	out.println(jobj.toString());
%>

