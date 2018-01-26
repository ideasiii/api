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
	public final static int ERR_FAIL = 0;
	public final static int ERR_EXCEPTION = -1;
	public final static int ERR_INVALID_PARAMETER = -2;
	public final static int ERR_CONFLICT = -3;

	public class Common {
		final public static String DB_URL = "jdbc:mysql://52.68.108.37:3306/edubot?useUnicode=true&characterEncoding=UTF-8";
		//wins IP version

	/*	final public static String DB_URL = "jdbc:mysql://10.0.20.130:3306/edubot?useUnicode=true&characterEncoding=UTF-8";
		*/
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


	final public static ArrayList<String> listDeviceField = new ArrayList<String>(Arrays.asList(Common.DEVICE_ID,
				Common.DEVICE_OS, Common.CREATE_TIME));
	/*
		final public static ArrayList<String> listRoutineField = new ArrayList<>(
				Arrays.asList(Common.ROUTINE_ID, Common.DEVICE_ID, Common.ROUTINE_TYPE, Common.TITLE, Common.START_TIME,
						Common.REPEAT, Common.META_ID, Common.CREATE_TIME));

		final public static ArrayList<String> listStoryField = new ArrayList<>(
				Arrays.asList(Common.STORY_ID, Common.STORY_URL, Common.STORY_NAME, Common.CATEGORY, Common.LANGUAGE,
						Common.TYPE, Common.CREATE_TIME));
	*/
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
			//load mysql Driver
			Class.forName("com.mysql.jdbc.Driver");//.newInstance();
			//connect database
			conn = DriverManager.getConnection(strDB,strUser,strPwd);

			/*("jdbc:mysql://52.68.108.37:3306/" + strDB + "?user=" + strUser
					+ "&password=" + strPwd + "&useUnicode=true&characterEncoding=UTF-8");
*/
		} catch (SQLException se) {
			se.printStackTrace();
			Logs.showTrace("MySQL Exception: " + se.toString());
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

	public int queryDevice(final String strDeviceId, DeviceData deviData) {
		if (!StringUtility.isValid(strDeviceId)) {
			return ERR_INVALID_PARAMETER;
		}
        
		int nCount = 0;
        Connection conn = null;
        PreparedStatement pst = null;
        
		try {
			conn = connect(Common.DB_URL, Common.DB_USER, Common.DB_PASS);

			if (conn != null) {
				pst = conn.prepareStatement("SELECT * FROM device_list WHERE device_id = ?");
				pst.setString(1, strDeviceId);
				ResultSet rs = pst.executeQuery();
	
				while (rs.next()) {
					++nCount;
					deviData.device_id = rs.getString("device_id");
					deviData.device_os = rs.getString("device_os");
					deviData.create_time = rs.getString("create_time");
					deviData.update_time = rs.getString("update_time");
				}
				
				rs.close();
				pst.close();
			}
			
			closeConn(conn);
		} catch (Exception e) {
			e.printStackTrace();
			Logs.showTrace(e.toString());
			return ERR_EXCEPTION;
		}
		return nCount;
	}



	/** DEVICE SETTING API **/

    public int querySetting(final String strDeviceId, final String strType, DeviceSetData deviSetData) {
        if (!StringUtility.isValid(strDeviceId)) {
            return ERR_INVALID_PARAMETER;
        }
        
        int nCount = 0;
		Connection conn = null;

		try {
			conn = connect(Common.DB_URL, Common.DB_USER, Common.DB_PASS);

			if (null != conn) {
                PreparedStatement pst = conn.prepareStatement("SELECT * FROM device_setting WHERE device_id = ? AND setting_type = ?");
                pst.setString(1, strDeviceId);
                pst.setString(2, strType);
                ResultSet rs = pst.executeQuery();
                
				while (rs.next()) {
					++nCount;
					deviSetData.cmmd_id = rs.getInt("cmmd_id");
					deviSetData.device_id = rs.getString("device_id");
					deviSetData.setting_type = rs.getString("setting_type");
					deviSetData.action = rs.getInt("action");
					deviSetData.create_time = rs.getString("create_time");
					deviSetData.update_time = rs.getString("update_time");
				}
				rs.close();
				pst.close();
			}
			
			closeConn(conn);
		} catch (Exception e) {
			e.printStackTrace();
			Logs.showTrace(e.toString());
			return ERR_EXCEPTION;
		}
		
		return nCount;
	}

	/** ROUTINE SETTING API **/

	public int queryRoutineList(final String strDeviceId, final String strType,  ArrayList<RoutineData> listRoutine) {
		int nCount = 0;
		Connection conn = null;
		String strSQL = "SELECT * FROM routine_setting WHERE device_id = '" + strDeviceId + "' AND routine_type ='"
				+ strType + "'";

		if (!StringUtility.isValid(strDeviceId)) {
			return ERR_INVALID_PARAMETER;
		}
		
		try {
			conn = connect(Common.DB_URL, Common.DB_USER, Common.DB_PASS);

			if (null != conn) {
				Statement stat = conn.createStatement();
				ResultSet rs = stat.executeQuery(strSQL);

				while (rs.next()) {
					++nCount;
					RoutineData routineData = new RoutineData();
					routineData.routine_id = rs.getInt("routine_id");
					routineData.device_id = rs.getString("device_id");
					routineData.title = rs.getString("title");
					routineData.start_time = rs.getString("start_time");
					routineData.repeat = rs.getInt("repeat");
					routineData.meta_id = rs.getInt("meta_id");
					listRoutine.add(routineData);
					//System.out.println(listRoutine.get(0).routine_id);
				}
				//nCount = listRoutine.size();
				rs.close();
				stat.close();
			}
		
			closeConn(conn);
		} catch (Exception e) {
			e.printStackTrace();
			Logs.showTrace(e.toString());
			return ERR_EXCEPTION;
		}
		
		return nCount;
	}

	public int queryRoutine(final String strDeviceId, final String strType, final String strTime, ArrayList<RoutineData> listRoutine) {
		int nCount = 0;
		Connection conn = null;
		String strSQL = "SELECT * FROM routine_setting WHERE device_id = '" + strDeviceId + "' AND routine_type ='"
				+ strType + "' AND start_time ='" + strTime + "'";

		if (!StringUtility.isValid(strDeviceId)) {
			return ERR_INVALID_PARAMETER;
		}
		
		try {
			conn = connect(Common.DB_URL, Common.DB_USER, Common.DB_PASS);

			if (null != conn) {
				Statement stat = conn.createStatement();
				ResultSet rs = stat.executeQuery(strSQL);

				while (rs.next()) {
					++nCount;
					RoutineData routineData = new RoutineData();
					routineData.routine_id = rs.getInt("routine_id");
					routineData.device_id = rs.getString("device_id");
					routineData.title = rs.getString("title");
					routineData.start_time = rs.getString("start_time");
					routineData.repeat = rs.getInt("repeat");
					routineData.meta_id = rs.getInt("meta_id");
					listRoutine.add(routineData);
				}
				rs.close();
				stat.close();
			}
			
			closeConn(conn);
		} catch (Exception e) {
			e.printStackTrace();
			Logs.showTrace(e.toString());
			return ERR_EXCEPTION;
		}
		
		return nCount;
	}

	public int queryRoutineID(final String strDeviceId, final String strType, final String strTime) {
		int nRoutineId = 0;
		Connection conn = null;
		String strSQL = "SELECT routine_id FROM routine_setting WHERE device_id = '" + strDeviceId + "' AND routine_type ='"
				+ strType + "' AND start_time ='" + strTime + "'";

		if (!StringUtility.isValid(strDeviceId)) {
			return ERR_INVALID_PARAMETER;
		}
		
		try {
			conn = connect(Common.DB_URL, Common.DB_USER, Common.DB_PASS);

			if (null != conn) {
				Statement stat = conn.createStatement();
				ResultSet rs = stat.executeQuery(strSQL);

				while (rs.next()) {
					nRoutineId = rs.getInt("routine_id");
				}
				rs.close();
				stat.close();
			}
			
			closeConn(conn);
		} catch (Exception e) {
			e.printStackTrace();
			Logs.showTrace(e.toString());
			return ERR_EXCEPTION;
		}
		
		return nRoutineId;
	}

	/****    Brush Teeth    ****/

	public int insertBrush(final String strDeviceId, final String strType, final String strTitle, final String strTime, final int nRepeat) {
		if (strType != "brush teeth" || 1 < nRepeat || 0 > nRepeat) {
	         return ERR_INVALID_PARAMETER;
	     }
	     
	     if (!StringUtility.isValid(strDeviceId)) {
	         return ERR_INVALID_PARAMETER;
	     }

	    return insertUpdateDelete("INSERT INTO routine_setting(device_id, routine_type, title, start_time, repeat)VALUES(?,?,?,?,?)",
	    		new Object[]{strDeviceId, strType, strTitle, strTime, Integer.valueOf(nRepeat)});	
	}

	
    /****    Helpers    ****/

    public static boolean checkTime(String str) {
        return str == null ? false : str.matches("(?:[01]\\d|2[0123]):(?:[012345]\\d):(?:[012345]\\d)");
    }

    public static boolean isInteger(String s) {
        return s == null ? false : s.matches("[-+]?[0-9]+");
    }
    
    public static boolean isValidDeviceId(String s) {
        return StringUtility.isValid(s);
    }
    
    public static boolean isNotEmptyString(String s) {
    	return s != null && s.length() > 0;
    }
	
    public int insertUpdateDelete(final String template, Object[] params) {
        return insertUpdateDelete(null, template, params);
    }

	public int insertUpdateDelete(Connection conn, final String template, Object[] params) {
	    PreparedStatement pst = null;

	    try {
	    	if (conn == null) {
    		   conn = connect(Common.DB_URL, Common.DB_USER, Common.DB_PASS);
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
	    } catch (Exception e) {
	        e.printStackTrace();
	        Logs.showTrace(e.toString());
	        return ERR_EXCEPTION;
	    }

	    return ERR_SUCCESS;
	}
%>
