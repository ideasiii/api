<%@ include file="routine-list_common.jsp" %>

<%@ page import="org.json.JSONObject"%>

<%
    JSONObject jobj = processListRoutineRequest(request, "sleep");
    out.print(jobj.toString());
%>

<%!
// this method is called by processListRoutineRequest() in routine-list_common.jsp
private static void mapRoutineDataToObjectInResultArray(final RoutineData rd, final JSONObject rdJson) {
    rdJson.put("routine_id", rd.routine_id);
    rdJson.put("title", rd.title);
    rdJson.put("start_time", rd.start_time);
    rdJson.put("repeat", rd.repeat);
    rdJson.put("meta_id", rd.meta_id);
}
%>
