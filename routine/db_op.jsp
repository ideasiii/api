<%!
public int queryRoutineList(final String strDeviceId, final String strType, final ArrayList<RoutineData> listRoutine) {
    if (!StringUtility.isValid(strDeviceId)) {
        return ERR_INVALID_PARAMETER;
    }
    
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

public int queryRoutine(final String strDeviceId, final String strType, 
        final String strTime, final ArrayList<RoutineData> listRoutine) {
    if (!StringUtility.isValid(strDeviceId)) {
        return ERR_INVALID_PARAMETER;
    }
    
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
    if (!StringUtility.isValid(strDeviceId)) {
        return ERR_INVALID_PARAMETER;
    }
    
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