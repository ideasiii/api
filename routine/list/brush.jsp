<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ include file="routine-list_common.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");
	JSONObject jobj = processListRoutineRequest(request, ROUTINE_TYPE_BRUSH_TEETH);
	out.print(jobj.toString());
%>

<%!
// this method is called by processListRoutineRequest() in routine-list_common.jsp
private static void mapRoutineDataToObjectInResultArray(final RoutineData rd, final JSONObject rdJson) {
	rdJson.put("routine_id", rd.routine_id);
    rdJson.put("title", rd.title);
    rdJson.put("start_time", rd.start_time);
    rdJson.put("repeat", rd.repeat);
}
%>
