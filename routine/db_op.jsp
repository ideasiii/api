<%! // DB operations shared among /routine/**/*.jsp pages

//取得生活作息設定，需指定 device ID 、指定類型。不須指定時間點
public int queryRoutineList(final String strDeviceId, final String strType, final ArrayList<RoutineData> listRoutine) {    
    SelectResult sr = new SelectResult();
    
    select(null, "SELECT * FROM routine_setting WHERE device_id=? AND routine_type=?",
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

    return sr.status;
}

// 取得生活作息設定，需指定 device ID 、指定時間點、指定類型
// 與 queryRoutineList() 相比，本方法因為額外指定時間點，理論上只會傳回一條資料
public int queryRoutineInGivenTime(final String strDeviceId, final String strType, 
        final String strTime, final ArrayList<RoutineData> listRoutine) {   
    SelectResult sr = new SelectResult();
    
    select(null, "SELECT * FROM routine_setting WHERE device_id=? AND routine_type=? AND start_time=?",
            new Object[]{strDeviceId, strType, strTime}, new ResultSetReader() {
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
    
    return sr.status;
}

public int queryRoutineID(final String strDeviceId, final String strType, final String strTime) {
    SelectResult sr = new SelectResult();
    
    select(null, "SELECT routine_id FROM routine_setting WHERE device_id=? AND routine_type=? AND start_time=?",
            new Object[]{strDeviceId, strType, strTime}, new ResultSetReader() {
        @Override
        public void read(ResultSet rs, SelectResult sr) throws Exception {
            while (rs.next()) {
                sr.status = rs.getInt("routine_id");
            }
        }
    }, sr);

    return sr.status;
}

%>