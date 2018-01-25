<%@ include file="../api_common.jsp"%>
<%@ include file="../response_generator.jsp"%>

<%@ page import="org.json.JSONObject"%>

<%! // methods used ONLY within this file

    public int deleteSetting(final String strDeviceId) {
        if (!StringUtility.isValid(strDeviceId)) {
            return ERR_INVALID_PARAMETER;
        }

        int nCount = 0;
        int ret;
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = connect(Common.DB_URL, Common.DB_USER, Common.DB_PASS);

            if (null != conn) {
                pst = conn.prepareStatement("DELETE FROM device_setting WHERE device_id = ?");
                pst.setString(1, strDeviceId);
                pst.executeUpdate();
                pst.close();

                pst = conn.prepareStatement("DELETE FROM routine_setting WHERE device_id = ?");
                pst.setString(1, strDeviceId);
                pst.executeUpdate();
                pst.close();
            }

            ret = ERR_SUCCESS;
        } catch (Exception e) {
            e.printStackTrace();
            Logs.showTrace(e.toString());
            ret = ERR_EXCEPTION;
        } finally {
        	if (conn != null) {
        		closeConn(conn);
        	}

        	return ret;
        }
    }
%>

<%
	final String strDeviceId = request.getParameter("device_id");

	// TODO check if device_id exists in "request"

	DeviceData deviData = new DeviceData();
	JSONObject jobj;

	int nCount = queryDevice(strDeviceId, deviData);
    Logs.showTrace("**********************nCount: " + nCount);

	if (0 < nCount) {
		// Device record exists
		int nDelete = deleteSetting(strDeviceId);
		if (0 < nDelete) {
			jobj = new JSONObject();
			jobj.put("success", true);

			Logs.showTrace("**********************nDelete: " + nDelete);
		} else {
			switch (nDelete) {
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

			Logs.showTrace("********error*********nDelete: " + nDelete);
		}
	} else {
		// Device not found
		switch (nCount) {
			case ERR_FAIL:
				jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_DATA_NOT_FOUND, "device_id not found.");
                break;
			case ERR_EXCEPTION:
				jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR);
	            break;
			case ERR_INVALID_PARAMETER:
				jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INVALID_VALUE);
				break;
	        default:
	            jobj = ApiResponse.getErrorResponse(ApiResponse.STATUS_INTERNAL_ERROR, "Unknown error.");
		}

		Logs.showTrace("********error*********nCount: " + nCount);
	}

	out.println(jobj.toString());
%>
