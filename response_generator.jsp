<%! // This file contains methods generating response on request failure

// response type to client on request failure

public static class ApiResponse {
	/** 找不到指定的資料 */
	public static final String STATUS_DATA_NOT_FOUND = "ER0100";
	   
	/** 缺少必要參數 */
	public static final String STATUS_MISSING_PARAM = "ER0120";

	/** 輸入的參數內容不在規範中 */
	public static final String STATUS_INVALID_PARAMETER = "ER0220";

	/** 輸入的參數內容抵觸 (抵觸甚麼東西?) */
	public static final String STATUS_CONFLICTS_WITH_EXISTING_DATA = "ER0240";

	/** 系統錯誤 */
	public static final String STATUS_INTERNAL_ERROR = "ER0500";


	/* 應該用不到的錯誤 */

	// 輸入的參數名稱不在規範中 (不在規範中就別管它
	//public static final String RESP_TYPE_UNKNOWN_FIELD = "ER0200";

	// 輸入的參數內容格式錯誤 (alias of ER0220 ????
	//public static final String RESP_TYPE_INVALID_VALUE = "ER0210";

	// 輸入的參數內容中，欄位名稱不存在 (???)
	//public static final String RESP_TYPE_ = "ER0230";

	public static JSONObject getErrorResponse(String status) {
	    return getErrorResponse(status, null);
	}

	public static JSONObject getErrorResponse(String status, String message) {
		JSONObject ret = new JSONObject();
		ret.put("success", false);
        ret.put("error", status);

        if (message == null) {
        	// fill with canned message
        	if (status == null) {
        		message = "Internal server error.";
        	} else if (status.equals(STATUS_DATA_NOT_FOUND)) {
        		message = "The record you requested does not exist.";
        	} else if (status.equals(STATUS_MISSING_PARAM)) {
        		message = "Missing required parameter.";
            } else if (status.equals(STATUS_INVALID_PARAMETER)) {
            	message = "Invalid input.";
            } else if (status.equals(STATUS_CONFLICTS_WITH_EXISTING_DATA)) {
            	message =  "There is conflict between the request and existing record";
            } else if (status.equals(STATUS_INTERNAL_ERROR)) {
                message = "Internal server error.";
            } else {
                message = "Unknown error.";
            }
        }

        ret.put("message", message);
        return ret;
	}

	public static JSONObject getSuccessResponseTemplate() {
		JSONObject ret = new JSONObject();
        ret.put("success", true);
        return ret;
	}

	public static JSONObject getUnknownErrorResponse() {
		JSONObject ret = new JSONObject();
        ret.put("success", false);
        ret.put("error", STATUS_INTERNAL_ERROR);
        ret.put("message", "Unknown error.");
        return ret;
	}
	
	public static JSONObject getDeviceIdNotFoundResponse() {
        JSONObject ret = new JSONObject();
        ret.put("success", false);
        ret.put("error", STATUS_DATA_NOT_FOUND);
        ret.put("message", "device_id not found.");
        return ret;
    }
}

%>