<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="application/json; charset=utf-8" language="java"
	session="false"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="more.Logs"%>
<%@ page import="more.StringUtility"%>
<%@ page import="java.util.regex.Matcher"%>
<%@ page import="java.util.regex.Pattern"%>

<%! // shared methods and constants
    public final static int ERR_SUCCESS = 1;

	/* no ERR constant with value 0 as its appearance in code sometimes confusing */
	
	public final static int ERR_EXCEPTION = -1;
	public final static int ERR_INVALID_PARAMETER = -2;
	public final static int ERR_CONFLICT = -3;

	public class Common {
		private static final String DB_IP = "52.68.108.37";

		// dev environment
		//private static final DB_IP = "10.0.20.130";

		final public static String DB_URL = "jdbc:mysql://" + DB_IP + ":3306/edubot?useUnicode=true&characterEncoding=UTF-8&verifyServerCertificate=false";
		final public static String DB_USER = "more";
		final public static String DB_PASS = "ideas123!";

		/**
		 * MySQL DB : device_list
		 */
		final public static String DEVICE_ID = "device_id";
		final public static String DEVICE_OS = "device_os";

		/**
		 * MySQL DB : device_setting
		 */
		final public static String CMMD_ID = "cmmd_id";
		final public static String SETTING_TYPE = "setting_type";
		final public static String ACTION = "action";

		/**
		 * MySQL DB : routine_setting
		 */
		final public static String ROUTINE_ID = "routine_id";
		final public static String ROUTINE_TYPE = "routine_type";
		final public static String TITLE = "title";
		final public static String START_TIME = "start_time";
		final public static String REPEAT = "repeat";
		final public static String META_ID = "meta_id";

		/**
		 * MySQL DB : routine_repeat
		 */
		final public static String ROUTINE_SEQ = "routine_seq";
		final public static String WEEKDAY = "weekday";

		/**
		 * MySQL DB : story
		 */
		final public static String STORY_ID = "story_id";
		final public static String STORY_URL = "story_url";
		final public static String STORY_NAME = "story_name";
		final public static String CATEGORY = "category";
		final public static String LANGUAGE = "language";
		final public static String TYPE = "type";

		final public static String CREATE_TIME = "create_time";
		final public static String UPDATE_TIME = "update_time";
	}

	public static class DeviceData {
		public String device_id;
		public String device_os;
		public String create_time;
		public String update_time;
	}

	public static class DeviceSetData {
		public int cmmd_id;
		public String device_id;
		public String setting_type;
		public int action;
		public String create_time;
		public String update_time;
	}

	public static class RoutineData {
		public int routine_id;
		public String device_id;
		public String routine_type;
		public String title;
		public String start_time;
		public int repeat;
		public int meta_id;
		public String create_time;
		public String update_time;
	}

	public static class RepeatData {
		public int routine_seq;
		public int routine_id;
		public int weekday;
		public String create_time;
	}

	public static class StoryData {
		public int story_id; //one of meta_id
		public String story_url;
		public String story_name;
		public String category;
		public String language;
		public int type;
		public String create_time;
		public String update_time;
	}

	/** MySQL Connection **/

	static public Connection connect(final String strDB, final String strUser, final String strPwd) {
		Connection conn = null;

		try {
			Class.forName("com.mysql.jdbc.Driver");//.newInstance();
			conn = DriverManager.getConnection(strDB, strUser, strPwd);
		} catch (Exception e) {
			e.printStackTrace();
			Logs.showTrace(e.toString());
		}

		return conn;
	}

	static public int closeConn(Connection conn) {
		try {
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
			Logs.showTrace(e.toString());
			return ERR_EXCEPTION;
		}

		return ERR_SUCCESS;
	}

	/** Device Manager API **/

	/**
	 * 有時候我們只想知道 device ID 有沒有在 DB 內，但不想要詳細資訊
	 * @return 若發生錯誤，傳回 ERR_EXCEPTION，否則傳回一個大於等於零的值，代表取得的資料筆數
	 */
	public int checkDeviceIdExistance(final String strDeviceId) {
		SelectResult sr = new SelectResult();

        select(null, "SELECT NULL FROM device_list WHERE device_id=?",
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
	
	public int queryDevice(final String strDeviceId, DeviceData deviData) {
        SelectResult sr = new SelectResult();
        sr.obj = deviData;

        select(null, "SELECT * FROM device_list WHERE device_id=?",
        		new Object[]{strDeviceId}, new ResultSetReader() {
            @Override
            public void read(ResultSet rs, SelectResult sr) throws Exception {
            	sr.status = 0;
            	DeviceData d = (DeviceData) sr.obj;

            	while (rs.next()) {
                    ++sr.status;
                    d.device_id = rs.getString("device_id");
                    d.device_os = rs.getString("device_os");
                    d.create_time = rs.getString("create_time");
                    d.update_time = rs.getString("update_time");
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

    public static boolean isValidDeviceId(final String s) {
        return StringUtility.isValid(s);
    }

    public static boolean isNotEmptyString(final String s) {
    	return s != null && s.length() > 0;
    }

    public int insertUpdateDelete(final String template, final Object[] params) {
        return insertUpdateDelete(null, template, params);
    }

	public int insertUpdateDelete(Connection conn, final String template, final Object[] params) {
	    PreparedStatement pst = null;
	    boolean closeConnOnReturn = false;

	    try {
	    	if (conn == null) {
    		   conn = connect(Common.DB_URL, Common.DB_USER, Common.DB_PASS);
    		   closeConnOnReturn = true;
   		    }

            pst = conn.prepareStatement(template);
            int paramIndex = 1;

            for (int i = 0; i < params.length; i++) {
            	Object param = params[i];

            	if (params[i] instanceof Integer) {
                    pst.setInt(paramIndex++, ((Integer)param).intValue());
            	} else if (params[i] instanceof Long) {
                    pst.setLong(paramIndex++, ((Integer)param).longValue());
                   } else if (params[i] instanceof String) {
                       pst.setString(paramIndex++, (String)param);
                   } else {
                   	throw new IllegalArgumentException(
                   			"unsupported type of parameter " + param.getClass().getName());
                   }
            }
            pst.executeUpdate();
            pst.close();

            return ERR_SUCCESS;
	    } catch (Exception e) {
	        e.printStackTrace();
	        Logs.showTrace(e.toString());

	        return ERR_EXCEPTION;
	    } finally {
            if (closeConnOnReturn) {
                closeConn(conn);
            }
	    }
	}

	public static class SelectResult {
		int status;
		Object obj;

		public SelectResult() {
			status = 0;
			obj = null;
		}
	}

	public interface ResultSetReader {
		void read(ResultSet rs, SelectResult sr) throws Exception;
	}

    public SelectResult select(final String template, final Object[] params
    		,final ResultSetReader reader) {
         return select(null, template, params, reader, new SelectResult());
     }

    public SelectResult select(final Connection conn, final String template,
   		   final Object[] params, final ResultSetReader reader) {
        return select(conn, template, params, reader, new SelectResult());
    }

    /**
     * Does SELECT operation to designated connection
     * @return ERR_EXCEPTION if error occured, otherwise return user-defined value.
     *         Caller should be able to distinguish ERR_EXCEPTION and their special return value.	   
     */
    
	public SelectResult select(Connection conn, final String template,
			final Object[] params, final ResultSetReader reader, SelectResult ret) {
		PreparedStatement pst = null;
		boolean closeConnOnReturn = false;

        try {
            if (conn == null) {
               conn = connect(Common.DB_URL, Common.DB_USER, Common.DB_PASS);
               closeConnOnReturn = true;
            }

            pst = conn.prepareStatement(template);
            int paramIndex = 1;

            for (int i = 0; i < params.length; i++) {
                Object param = params[i];

                if (params[i] instanceof Integer) {
                    pst.setInt(paramIndex++, ((Integer)param).intValue());
                } else if (params[i] instanceof Long) {
                    pst.setLong(paramIndex++, ((Integer)param).longValue());
                } else if (params[i] instanceof String) {
             	    pst.setString(paramIndex++, (String)param);
                } else {
             	    throw new IllegalArgumentException(
             	    	    "unsupported type of parameter " + param.getClass().getName());
                }
            }

            ResultSet rs = pst.executeQuery();
            reader.read(rs, ret);

            rs.close();
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
            Logs.showTrace(e.toString());
            ret.status = ERR_EXCEPTION;
        } finally {
        	if (closeConnOnReturn) {
        		closeConn(conn);
        	}

        	return ret;
        }
	}
%>
