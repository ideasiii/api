<%@ include file="../api_common.jsp"%>
<%@ include file="../response_generator.jsp"%>

<%@ page import="org.json.JSONObject"%>

<%! // methods used ONLY within this file
    public int insertBattery(final String strDeviceId, final String strType, final int nAction) {
        int nCount = 0;
        Connection conn = null;
        PreparedStatement pst = null;
        String strSQL = "INSERT INTO device_setting(device_id, setting_type, action) VALUES (?,?,?)";
    
        if (strType != "battery" || 1 < nAction || 0 > nAction 
        		|| !StringUtility.isValid(strDeviceId)) {
            return ERR_INVALID_PARAMETER;
        }
        
        try {
            conn = connect(Common.DB_URL, Common.DB_USER, Common.DB_PASS);
    
            if (null != conn) {
                pst = conn.prepareStatement(strSQL);
                int idx = 1;
                pst.setString(idx++, strDeviceId);
                pst.setString(idx++, strType);
                pst.setInt(idx++, nAction);
                pst.executeUpdate();
                pst.close();
            }

            closeConn(conn);            
        } catch (Exception e) {
            e.printStackTrace();
            Logs.showTrace(e.toString());
            return ERR_EXCEPTION;
        }
        
        return ERR_SUCCESS;
    }

	public int updateBattery(final String strDeviceId, final String strType, final int nAction) {
	    int nCount = 0;
	    Connection conn = null;
	    PreparedStatement pst = null;
	    String strSQL = "UPDATE device_setting SET action = ? WHERE device_id =? AND setting_type = ?";
	
	    if (strType != "battery" || 1 < nAction || 0 > nAction
	    		|| !StringUtility.isValid(strDeviceId)) {
	        return ERR_INVALID_PARAMETER;
	    }
	    
	    try {
	        conn = connect(Common.DB_URL, Common.DB_USER, Common.DB_PASS);
	
	        if (null != conn) {
	            pst = conn.prepareStatement(strSQL);
	            int idx = 1;
	            pst.setInt(idx++, nAction);
	            pst.setString(idx++, strDeviceId);
	            pst.setString(idx++, strType);
	            pst.executeUpdate();
	            pst.close();
	        }
	        
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
	final String strType = "battery";
	String strAction = request.getParameter("action");
	DeviceData deviData = new DeviceData();
	DeviceSetData deviSetData = new DeviceSetData();
    JSONObject jobj;
    
    // TODO check "device_id" parameter exists
    
    // TODO check if "action" parameter exists and within range
    // if does not exist
    // jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_MISSING_PARAM,
    //                "Required parameter missing.");
    
    if (!isInteger(strAction)) {
        Logs.showTrace("********error*********strAction: " + strAction);
        jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE,
                 "Invalid action.");
        out.println(jobj.toString());
        return;
    }
    
	int nAction = Integer.parseInt(strAction.trim());
	int nCountDevice = queryDevice(strDeviceId, deviData);

	if (0 < nCountDevice) {
		// Device exists

		int nCount = querySetting(strDeviceId, strType, deviSetData);

		if (0 < nCount) {
			//setting exists, do update
			int nUpdate = updateBattery(strDeviceId, strType, nAction);

			if (0 < nUpdate) {
				jobj = new JSONObject();
				jobj.put("success", true);

				Logs.showTrace("**********************nUpdate: " + nUpdate);
			} else {
				switch (nUpdate) {
	            case ERR_FAIL:
	            case ERR_EXCEPTION:
	                jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR);
	                break;
	            case ERR_INVALID_PARAMETER:
	                jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE);
	                break;
	            default:
	                jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR, "Unknown error.");
	            }

				Logs.showTrace("********error*********nUpdate: " + nUpdate);
			}
		} else {
			//setting not found, insert setting
			int nInsert = insertBattery(strDeviceId, strType, nAction);

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
		        default:
		            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR, "Unknown error.");
				}

				Logs.showTrace("********error*********nInsert: " + nInsert + "***nAction: " + nAction
						+ " id: " + strDeviceId);
			}
		}
	} else {
		// Device not found
		switch (nCountDevice) {
        case ERR_FAIL:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_DATA_NOT_FOUND, "device_id not found.");
            break;
        case ERR_EXCEPTION:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR);
            break;
        case ERR_INVALID_PARAMETER:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE, "Invalid device_id.");
            break;
        default:
            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR, "Unknown error.");
        }
		
		Logs.showTrace("********error*********nCountDevice: " + nCountDevice);
	}
	
	out.println(jobj.toString());
%>
