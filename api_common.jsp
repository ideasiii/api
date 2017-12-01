<%@ page contentType="text/html; charset=utf-8" language="java"
	session="false"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="more.Logs"%>

<%!public final static int ERR_SUCCESS = 1;
	public final static int ERR_FAIL = 0;
	public final static int ERR_EXCEPTION = -1;
	public final static int ERR_INVALID_PARAMETER = -2;

	public class Common {

		final public static String DB = "edubot";
		final public static String DB_USER = "more";
		final public static String DB_PASS = "ideas123!";

		/**
		 * MySQL DB : device_list
		 **/
		final public static String DEVICE_ID = "device_id";
		final public static String DEVICE_OS = "device_os";
		final public static String MAC_ADDRESS = "mac_address";

		/**
		 * MySQL DB : device_setting
		 **/
		final public static String CMMD_ID = "cmmd_id";
		final public static String SETTING_TYPE = "setting_type";
		final public static String ACTION = "action";

		/**
		 * MySQL DB : routine_setting
		 **/
		final public static String ROUTINE_ID = "routine_id";
		final public static String ROUTINE_TYPE = "routine_type";
		final public static String TITLE = "title";
		final public static String START_TIME = "start_time";
		final public static String REPEAT = "repeat";
		final public static String META_ID = "meta_id";

		/**
		 * MySQL DB : routine_repeat
		 **/
		final public static String ROUTINE_SEQ = "routine_seq";
		final public static String WEEKDAY = "weekday";

		/**
		 * MySQL DB : story
		 **/
		final public static String STORY_ID = "story_id";
		final public static String STORY_URL = "story_url";
		final public static String STORY_NAME = "story_name";
		final public static String CATEGORY = "category";
		final public static String LANGUAGE = "language";
		final public static String TYPE = "type";

		final public static String CREATE_TIME = "create_time";
		final public static String UPDATE_TIME = "update_time";
	}

	final public static ArrayList<String> listDeviceField = new ArrayList<>(Arrays.asList(Common.DEVICE_ID,
			Common.DEVICE_OS, Common.MAC_ADDRESS, Common.CREATE_TIME, Common.UPDATE_TIME));

	final public static ArrayList<String> listRoutineField = new ArrayList<>(
			Arrays.asList(Common.ROUTINE_ID, Common.DEVICE_ID, Common.ROUTINE_TYPE, Common.TITLE, Common.START_TIME,
					Common.REPEAT, Common.META_ID, Common.CREATE_TIME, Common.UPDATE_TIME));

	final public static ArrayList<String> listStoryField = new ArrayList<>(
			Arrays.asList(Common.STORY_ID, Common.STORY_URL, Common.STORY_NAME, Common.CATEGORY, Common.LANGUAGE,
					Common.TYPE, Common.CREATE_TIME, Common.UPDATE_TIME));

	public static class DeviceData {
		public String device_id;
		public String device_os;
		public String mac_address;
		public String create_date;
		public String update_date;
	}

	public static class RoutineData {
		public int routine_id;
		public String device_id;
		public String routine_type;
		public String title;
		public String start_date;
		public int repeat;
		public int meta_id;
		public String create_date;
		public String update_date;
	}

	public static class RepeatData {
		public int routine_seq;
		public int routine_id;
		public int weekday;
		public String create_date;
	}

	public static class StoryData {
		public int story_id; //one of meta_id
		public String story_url;
		public String story_name;
		public String category;
		public String language;
		public int type;
		public String create_date;
		public String update_date;
	}

	/** MySQL Connection **/

	static public int connect(String strSQL, final String strDB, final String strUser, final String strPwd) {
		try {
			//load mysql Driver
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			//connect database
			Connection conn = DriverManager.getConnection("jdbc:mysql://52.68.108.37:3306/" + strDB + "?user=" + strUser
					+ "&password=" + strPwd + "&useUnicode=true&characterEncoding=UTF-8");
			//create statement
			Statement stat = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

			ResultSet rs = stat.executeQuery(strSQL);
			
		} catch (SQLException se) {
			se.printStackTrace();
			Logs.showTrace("MySQL Exception: " + se.toString());
			return ERR_EXCEPTION;

		} catch (Exception e) {
			Logs.showTrace(e.toString());
			return ERR_EXCEPTION;
		}
		return ERR_SUCCESS;
	}

	/** Device Manager API **/

	public int queryDevice(final String strDeviceId, DeviceData deviData) {
		int nCount = 0;
		String strSQL = "select * from device where device_id = '" + strDeviceId + "';";

	

			connect(strSQL, Common.DB, Common.DB_USER, Common.DB_PASS);
			
			
			
			
	
		return nCount;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	%>