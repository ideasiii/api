<%! // DB operations shared among /routine/**/*.jsp pages

private static final String ROUTINE_TYPE_BRUSH_TEETH = "brush teeth";
private static final String ROUTINE_TYPE_SLEEP = "sleep";

public static class RoutineData {
    public int routine_id;
    public String device_id;
    public String routine_type;
    public String title;
    public String start_time;
    public int repeat;
    public int meta_id;
}

public static class RepeatData {
    public String device_id;
    public int routine_id;
    public int routine_seq;
    public int weekday;
}

public static class StoryData {
    public int story_id; // this is meta_id in sleep routine data
    public String story_url;
    public String story_name;
    public String category;
    public String language;
    public int type;
}

//取得生活作息設定，需指定 device ID 、指定類型。不須指定時間點
public int queryRoutineList(final String strDeviceId, final String strType, final ArrayList<RoutineData> listRoutine) {
    SelectResult sr = new SelectResult();

    return select(null, "SELECT * FROM `routine_setting` WHERE `device_id`=? AND `routine_type`=? ORDER BY `start_time`",
            new Object[]{strDeviceId, strType}, new ResultSetReader() {
        @Override
        public void read(ResultSet rs, SelectResult sr) throws Exception {
            sr.status = 0;

            while (rs.next()) {
                ++sr.status;
                RoutineData routineData = new RoutineData();
                routineData.routine_id = rs.getInt("routine_id");
                routineData.device_id = rs.getString("device_id");
                routineData.title = rs.getString("title");
                routineData.start_time = rs.getString("start_time");
                routineData.repeat = rs.getInt("repeat");
                routineData.meta_id = rs.getInt("meta_id");
                listRoutine.add(routineData);
            }
        }
    }, sr);
}

// 查詢指定 device ID 、指定時間點、指定類型的 routine，確認是否已存在於 DB
public int checkRoutineExistance(final Connection conn, final String strDeviceId, final String strType,
        final String strTime) {
    SelectResult sr = new SelectResult();

    return select(conn, "SELECT NULL FROM `routine_setting` WHERE `device_id`=? AND `routine_type`=? AND `start_time`=?",
            new Object[]{strDeviceId, strType, strTime}, new ResultSetReader() {
        @Override
        public void read(ResultSet rs, SelectResult sr) throws Exception {
            sr.status = 0;

            while (rs.next()) {
                ++sr.status;
            }
        }
    }, sr);
}

//查詢指定 routine ID 是否為 device ID 所擁有
public int checkHasRoutineIdOwnership(final Connection conn, final String strDeviceId, final int strRoutineId) {
	SelectResult sr = new SelectResult();

	return select(conn, "SELECT NULL FROM `routine_setting` WHERE `device_id`=? AND `routine_id`=?",
	        new Object[]{strDeviceId, strRoutineId}, new ResultSetReader() {
	    @Override
	    public void read(ResultSet rs, SelectResult sr) throws Exception {
	        sr.status = 0;

	        while (rs.next()) {
	            ++sr.status;
	        }
	    }
	}, sr);
}

// 確認 routine_id 的 routine_type 是否符合預期
public int checkRoutineTypeMatches(final Connection conn, final int strRoutineId, final String strRoutineType) {
    SelectResult sr = new SelectResult();

    return select(conn, "SELECT NULL FROM `routine_setting` WHERE `routine_id`=? AND `routine_type`=?",
            new Object[]{strRoutineId, strRoutineType}, new ResultSetReader() {
        @Override
        public void read(ResultSet rs, SelectResult sr) throws Exception {
            sr.status = 0;

            while (rs.next()) {
                ++sr.status;
            }
        }
    }, sr);
}

//查詢指定 routine seq 是否為 device ID 所擁有
public int checkHasRoutineSeqOwnership(final Connection conn, final String strDeviceId, final int routineSeq) {
	SelectResult sr = new SelectResult();
	return select(conn, "SELECT NULL FROM `routine_setting` as rs, `routine_repeat` AS rr "
                    + "WHERE rs.`routine_id`=rr.`routine_id` AND rs.`device_id`=? AND rr.`routine_seq`=?",
	        new Object[]{strDeviceId, Integer.valueOf(routineSeq)}, new ResultSetReader() {
	    @Override
	    public void read(ResultSet rs, SelectResult sr) throws Exception {
	        sr.status = 0;

	        while (rs.next()) {
	            ++sr.status;
	        }
	    }
	}, sr);
}

// 查詢指定的 routine 是否已經有設置在 weekday 重複，若有，傳回那個設定的 routine_seq，否則回傳 0
public int queryRepeatRoutineSequence(final Connection conn, final int routineId, final int weekday) {
    SelectResult sr = new SelectResult();

    return select(conn, "SELECT `routine_seq` FROM `routine_repeat` WHERE `routine_id`=? AND `weekday`=?",
            new Object[]{Integer.valueOf(routineId), Integer.valueOf(weekday)}, new ResultSetReader() {
        @Override
        public void read(ResultSet rs, SelectResult sr) throws Exception {
            sr.status = 0;

            while (rs.next()) {
                sr.status = rs.getInt("routine_seq");
            }
        }
    }, sr);
}

public int queryRoutineID(final Connection conn, final String strDeviceId, final String strType, final String strTime) {
    SelectResult sr = new SelectResult();

    return select(conn, "SELECT `routine_id` FROM `routine_setting` WHERE `device_id`=? AND `routine_type`=? AND `start_time`=?",
            new Object[]{strDeviceId, strType, strTime}, new ResultSetReader() {
        @Override
        public void read(ResultSet rs, SelectResult sr) throws Exception {
            while (rs.next()) {
                sr.status = rs.getInt("routine_id");
            }
        }
    }, sr);
}

private boolean isValidRoutineRepeatValue(String r) {
    if (r == null || r.length() < 1) {
        return false;
    }

    return r.equals("0") || r.equals("1");
}

private boolean isValidWeekday(int w) {
    return w >= 1 && w <= 7;
}
%>
