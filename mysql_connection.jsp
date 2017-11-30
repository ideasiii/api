<%@ page contentType="text/html; charset=utf-8" language="java"
	session="false"%>
<%@ page import="java.sql.*"%>
<%@ page import="more.Logs"%>

<%
	final String db_user = "more";
	final String db_pwd = "ideas123!";
	String database = "edubot";
	Connection conn = null;
	Statement stat = null;

	try {
		//load mysql Driver
		Class.forName("com.mysql.jdbc.Driver").newInstance();

		try {
			//connect
			conn = DriverManager.getConnection("jdbc:mysql://52.68.108.37:3306/" + database + "?user=" + db_user
					+ "&password=" + db_pwd + "&useUnicode=true&characterEncoding=UTF-8");

			try {
				//create statement
				stat = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

				//-----------------------------------------------------------
				
				
				String strSQL = "SELECT * FROM meta_type_definition";
				ResultSet rs = stat.executeQuery(strSQL);
				int nCount = 0;
				
				try {
					//SQL query
					while (rs.next()) {
						++nCount;
						int id = rs.getInt("id");
						int type = rs.getInt("type");
						String strDefine = rs.getString("definition");
					}

					
					//--------------------------------------------------------------
					
					// close connection
					rs.close();
					rs = null;
					stat.close();
					stat = null;
					conn.close();

				} catch (SQLException se) {
					se.printStackTrace();
					Logs.showTrace("MySQL Exception: " + se.toString());
				} catch (Exception ex) {
					Logs.showTrace("***failed to read data: " + ex.toString());
				}

			

			} catch (SQLException se) {
				se.printStackTrace();
				Logs.showTrace("MySQL Exception: " + se.toString());
			} catch (Exception e) {
				e.printStackTrace();
				Logs.showTrace("***create statement failed: " + e.toString());
			}

		} catch (SQLException se) {
			se.printStackTrace();
			Logs.showTrace("MySQL Exception: " + se.toString());
		} catch (Exception e) {
			Logs.showTrace("***connect mysql database failed: " + e.toString());
		}

	} catch (Exception e) {
		Logs.showTrace("***load mysql driver failed: " + e.toString());
	} finally {

		try {
			if (stat != null)
				stat.close();
		} catch (SQLException se) {
			se.printStackTrace();
		}
		try {
			if (conn != null)
				conn.close();
		} catch (SQLException se) {
			se.printStackTrace();
		}
	}
%>