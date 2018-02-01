<%@ include file="../api_common.jsp"%>
<%@ include file="../response_generator.jsp"%>

<%@ page import="org.json.JSONObject"%>

<%
    JSONObject jobj = processRequest(request);
    out.print(jobj.toString());
%>

<%! // methods used ONLY within this file

private JSONObject processRequest(HttpServletRequest request) {
    if (!request.getParameterMap().containsKey("device_id")) {
        return ApiResponse.error(ApiResponse.STATUS_MISSING_PARAM);
    }

    final String strDeviceId = request.getParameter("device_id");

    if (!isValidDeviceId(strDeviceId)) {
        return ApiResponse.error(ApiResponse.STATUS_INVALID_PARAMETER, "Invalid device_id.");
    }

    DeviceData deviData = new DeviceData();
    JSONObject jobj;
    int nCount = queryDevice(strDeviceId, deviData);

    if (0 < nCount) {
        jobj = ApiResponse.successTemplate();
        jobj.put("device_os", deviData.device_os);
    } else {
        switch (nCount) {
        case 0:
            jobj = ApiResponse.deviceIdNotFound();
            break;
        default:
            jobj = ApiResponse.byReturnStatus(nCount);
        }
    }

    return jobj;
}

/** 取得指定 device ID 的裝置基本資料 */
public int queryDevice(final String strDeviceId, final DeviceData deviData) {
    SelectResult sr = new SelectResult();

    select(null, "SELECT * FROM device_list WHERE device_id=?",
            new Object[]{strDeviceId}, new ResultSetReader() {
        @Override
        public void read(ResultSet rs, SelectResult sr) throws Exception {
            sr.status = 0;

            while (rs.next()) {
                ++sr.status;
                deviData.device_id = rs.getString("device_id");
                deviData.device_os = rs.getString("device_os");
                deviData.create_time = rs.getString("create_time");
                deviData.update_time = rs.getString("update_time");
            }
        }
    }, sr);

    return sr.status;
}

%>
