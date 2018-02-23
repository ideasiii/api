<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@include file="routine-add_common.jsp"%>
<%@page import="java.util.Map"%>

<%
    request.setCharacterEncoding("UTF-8");
    JSONObject jobj = processAddRoutineRequest(request);
    out.print(jobj.toString());
%>

<%!
public boolean hasRequiredParameters(final HttpServletRequest request) {
    Map paramMap = request.getParameterMap();
    return paramMap.containsKey("device_id") && paramMap.containsKey("title")
    	    && paramMap.containsKey("start_time") && paramMap.containsKey("repeat");
}

public boolean copyRequestParameterToRoutineData(HttpServletRequest request, RoutineData rd) {
	rd.routine_type = ROUTINE_TYPE_BRUSH_TEETH;
	rd.device_id = request.getParameter("device_id");
	rd.title = request.getParameter("title");
	rd.start_time = request.getParameter("start_time");
	String strRepeat = request.getParameter("repeat");

    if (rd.device_id == null || rd.title == null || rd.start_time == null || strRepeat == null) {
        return false;
    }

	rd.device_id = rd.device_id.trim();
	rd.title = rd.title.trim();
	rd.start_time = rd.start_time.trim();
	strRepeat = strRepeat.trim();

    if (!isValidRoutineRepeatValue(strRepeat)) {
        return false;
    }

    rd.repeat = Integer.parseInt(strRepeat);
    rd.meta_id = 0; // no meta_id in brush teeth

    return isValidDeviceId(rd.device_id) && hasValidTimeFormat(rd.start_time)
            && isNotEmptyString(rd.title);
}
%>
