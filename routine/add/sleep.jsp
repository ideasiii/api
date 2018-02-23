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
		    && paramMap.containsKey("start_time") && paramMap.containsKey("repeat")
		    && paramMap.containsKey("meta_id");
}

public boolean copyRequestParameterToRoutineData(HttpServletRequest request, RoutineData rd) {
	rd.routine_type = ROUTINE_TYPE_SLEEP;
	rd.device_id = request.getParameter("device_id");
	rd.title = request.getParameter("title");
	rd.start_time = request.getParameter("start_time");
    String strRepeat = request.getParameter("repeat");
    String strMetaId = request.getParameter("meta_id");

    if (rd.device_id == null || rd.title == null || rd.start_time == null ||
        strRepeat == null || strMetaId == null) {
        return false;
    }

	rd.device_id = rd.device_id.trim();
	rd.title = rd.title.trim();
	rd.start_time = rd.start_time.trim();
    strRepeat = strRepeat.trim();
    strMetaId = strMetaId.trim();

    if (!isValidRoutineRepeatValue(strRepeat) || !isPositiveInteger(strMetaId)) {
    	return false;
    }

    rd.repeat = Integer.parseInt(strRepeat);
    rd.meta_id = Integer.parseInt(strMetaId);

    return isValidDeviceId(rd.device_id) && hasValidTimeFormat(rd.start_time)
    	    && isNotEmptyString(rd.title);
}
%>
