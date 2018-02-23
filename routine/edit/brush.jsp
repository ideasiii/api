<%@include file="routine-edit_common.jsp"%>
<%@page import="java.util.Map"%>

<%
    request.setCharacterEncoding("UTF-8");
    JSONObject jobj = processEditRoutineRequest(request);
    out.print(jobj.toString());
%>

<%!
public boolean hasRequiredParameters(final HttpServletRequest request) {
    Map paramMap = request.getParameterMap();
    return paramMap.containsKey("device_id") && paramMap.containsKey("routine_id")
    		&& paramMap.containsKey("title") && paramMap.containsKey("start_time")
    		&& paramMap.containsKey("repeat");
}

public boolean copyRequestParameterToRoutineData(HttpServletRequest request, RoutineData rd) {
	rd.routine_type = ROUTINE_TYPE_BRUSH_TEETH;
	rd.device_id = request.getParameter("device_id");
	rd.title = request.getParameter("title");
	rd.start_time = request.getParameter("start_time");
    String strRoutineId = request.getParameter("routine_id");
	String strRepeat = request.getParameter("repeat");

    if (rd.device_id == null || rd.title == null || rd.start_time == null ||
        strRoutineId == null || strRepeat == null) {
        return false;
    }

	rd.device_id = rd.device_id.trim();
	rd.title = rd.title.trim();
	rd.start_time = rd.start_time.trim();
    strRoutineId = strRoutineId.trim();
	strRepeat = strRepeat.trim();

    if (!isPositiveInteger(strRoutineId) || !isValidRoutineRepeatValue(strRepeat)) {
        return false;
    }

    rd.routine_id = Integer.parseInt(strRoutineId);
    rd.repeat = Integer.parseInt(strRepeat);
    rd.meta_id = 0; // no meta_id in brush teeth

    return isValidDeviceId(rd.device_id) && hasValidTimeFormat(rd.start_time)
            && isNotEmptyString(rd.title);
}
%>
