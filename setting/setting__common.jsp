<%! // shared methods among setting/**/*.jsp pages

/**
 * Get current setting of given device ID, filtered by specified type, saves to DeviceSetData
 */
public int querySetting(final String strDeviceId, final String strType, final DeviceSetData deviSetData) {
    SelectResult sr = new SelectResult();
    
    select(null, "SELECT * FROM device_setting WHERE device_id=? AND setting_type=?",
            new Object[]{strDeviceId, strType}, new ResultSetReader() {
        @Override 
        public void read(ResultSet rs, SelectResult sr) throws Exception {
            sr.status = 0;
            
            while (rs.next()) {
                ++sr.status;
                deviSetData.cmmd_id = rs.getInt("cmmd_id");
                deviSetData.device_id = rs.getString("device_id");
                deviSetData.setting_type = rs.getString("setting_type");
                deviSetData.action = rs.getInt("action");
                deviSetData.create_time = rs.getString("create_time");
                deviSetData.update_time = rs.getString("update_time");
            }
        }
    }, sr);

    return sr.status;
}
%>
