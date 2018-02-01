<%@ page trimDirectiveWhitespaces="true"%>
<%@ page contentType="application/json; charset=utf-8" language="java"
	session="false"%>

<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="more.Logs"%>
<%@ page import="more.StringUtility"%>
<%@ page import="java.util.regex.Matcher"%>
<%@ page import="java.util.regex.Pattern"%>
<%@ page import="org.json.JSONObject"%>

<%@ include file="api_db_helper.jsp"%>

<%! // shared methods and constants
    public final static int ERR_SUCCESS = 1;

	/* no ERR constant with value 0 as its appearance is sometimes confusing */

	public final static int ERR_EXCEPTION = -1;
	public final static int ERR_INVALID_PARAMETER = -2;
	public final static int ERR_CONFLICT = -3;

	public class Common {
		private static final String DB_IP = "52.68.108.37";

		// dev environment
		//private static final String DB_IP = "10.0.20.130";

		public static final String DB_URL = "jdbc:mysql://" + DB_IP + ":3306/edubot?useUnicode=true&characterEncoding=UTF-8&useSSL=false&verifyServerCertificate=false";
		public static final String DB_USER = "more";
		public static final String DB_PASS = "ideas123!";
	}

	public static class DeviceData {
		public String device_id;
		public String device_os;
		public String create_time;
		public String update_time;
	}

	/** Device Manager API **/

	/**
	 * 測試 device ID 存不存在 device_list 內
	 * @return 若 device ID 存在且執行過程中未發生錯誤，返回 null；
	 *	   若 device ID 不存在或執行過程中發生錯誤，傳回一個可作為 request response 的 JSONObject
	 *	   這個方法適合在 handle HttpServletRequest 並進行進一步的處理前，想要提前返回 response 時使用
	 */
	public JSONObject tryIfDeviceNotExistInList(Connection conn, final String strDeviceId) {
		JSONObject ret = null;

		int nCount = checkDeviceIdExistance(null, strDeviceId);
	    if (nCount < 1) {
	        switch (nCount) {
	        case 0:
	        	ret = ApiResponse.deviceIdNotFound();
	            break;
	        default:
				ret = ApiResponse.byReturnStatus(nCount);
	        }
	    }

	    return ret;
	}

	/**
	 * 有時候我們只想知道 device ID 有沒有在 DB 內，但不想要詳細資訊
	 * @return 若發生錯誤，傳回 ERR_EXCEPTION，否則傳回一個大於等於零的值，代表取得的資料筆數
	 */
	public int checkDeviceIdExistance(Connection conn, final String strDeviceId) {
		SelectResult sr = new SelectResult();

        select(conn, "SELECT NULL FROM device_list WHERE device_id=?",
                new Object[]{strDeviceId}, new ResultSetReader() {
            @Override
            public void read(ResultSet rs, SelectResult sr) throws Exception {
                sr.status = 0;

                while (rs.next()) {
                    ++sr.status;
                }
            }
        }, sr);

        return sr.status;
	}

    /****    Helpers    ****/

    public static boolean hasValidTimeFormat(String str) {
        return str == null ? false : str.matches("(?:[01]\\d|2[0123]):(?:[012345]\\d):(?:[012345]\\d)");
    }

    public static boolean isInteger(String s) {
        return s == null ? false : s.matches("[-+]?[0-9]+");
    }

    public static boolean isPositiveInteger(String s) {
        return s == null ? false : s.matches("[0-9]+");
    }

    public static boolean isValidDeviceId(final String s) {
        return StringUtility.isValid(s);
    }

    public static boolean isNotEmptyString(final String s) {
    	return s != null && s.length() > 0;
    }

%>
