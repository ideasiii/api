<%@include file="routine-edit_common.jsp"%>
<%@page import="java.util.Map"%>

<%
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
	rd.device_id = request.getParameter("device_id").trim();
	rd.title = request.getParameter("title").trim();
	rd.start_time = request.getParameter("start_time").trim();
    final String strRoutineId = request.getParameter("routine_id").trim();
	final String strRepeat = request.getParameter("repeat").trim();
    
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
