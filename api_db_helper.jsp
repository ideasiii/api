<%! // 一些常用的資料庫操作行為包裝

/** select() 返回的結果 */
public static class SelectResult {
    int status;
    Object obj;

    public SelectResult() {
        status = 0;
        obj = null;
    }
}

/** select() 讀取 ResultSet 時的 callback */
public interface ResultSetReader {
    void read(ResultSet rs, SelectResult sr) throws Exception;
}

/** 取得一個資料庫的連接 */
public static Connection connect(final String strDB, final String strUser, final String strPwd) {
    Connection conn = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(strDB, strUser, strPwd);
    } catch (Exception e) {
        e.printStackTrace();
    }

    return conn;
}

public static int closeConn(Connection conn) {
    try {
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        return ERR_EXCEPTION;
    }

    return ERR_SUCCESS;
}

/** INSERT、UPDATE、DELETE 操作，為 prepared statement 而生 */
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

        return ERR_EXCEPTION;
    } finally {
        if (closeConnOnReturn) {
            closeConn(conn);
        }
    }
}

/**
 * SELECT 操作
 * @return ERR_EXCEPTION if error occured, otherwise return user-defined value.
 *         Caller should be able to distinguish ERR_EXCEPTION and their own return values.
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
                pst.setLong(paramIndex++, ((Long)param).longValue());
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
        ret.status = ERR_EXCEPTION;
    } finally {
        if (closeConnOnReturn) {
            closeConn(conn);
        }

        return ret;
    }
}
%>
