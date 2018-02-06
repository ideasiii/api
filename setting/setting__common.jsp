<%! // shared methods among setting/**/*.jsp pages

public static class DeviceSettingData {
    public int cmmd_id;
    public String device_id;
    public String setting_type;
    public int action;
    public String create_time;
    public String update_time;
}

/**
 * Get current setting of given device ID, filtered by specified type, saves to DeviceSettingData
 */
public int querySetting(final Connection conn, final String strDeviceId, final String strType, final DeviceSettingData deviSetData) {
    SelectResult sr = new SelectResult();

    return select(conn, "SELECT * FROM device_setting WHERE device_id=? AND setting_type=?",
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
}
%>
