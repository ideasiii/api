<%@ page contentType="text/html; charset=utf-8" language="java"
	session="false"%>
<%@ page import="java.sql.*"%>
<%@ page import="more.Logs"%>

<%!
	
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

	public static class mMemberData {
		public int member_id;
		public String member_email;
		public int member_level;
		public int member_state;
		public String start_date;
		public String end_date;
		public String create_date;
		public String update_date;
	}
	
	
	
	
	
	
	%>