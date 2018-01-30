<%@include file="routine-add_common.jsp"%>
<%@page import="java.util.Map"%>

<%
    JSONObject jobj = processAddRoutineRequest(request);
    out.print(jobj.toString());
%>

<%!
private static final String ROUTINE_TYPE = "brush teeth";

public boolean hasRequiredParameters(final HttpServletRequest request) {
    Map paramMap = request.getParameterMap();
    return paramMap.containsKey("device_id") && paramMap.containsKey("title")
    	    && paramMap.containsKey("start_time") && paramMap.containsKey("repeat");
}

public boolean copyRequestParameterToRoutineData(HttpServletRequest request, RoutineData rd) {
	rd.routine_type = ROUTINE_TYPE;
	rd.device_id = request.getParameter("device_id");
	rd.title = request.getParameter("title");
	rd.start_time = request.getParameter("start_time");
	final String strRepeat = request.getParameter("repeat");
    
    if (!isValidRoutineRepeatValue(strRepeat)) {
        return false;
    }
    
    rd.repeat = Integer.parseInt(strRepeat.trim());
    rd.meta_id = 0; // no meta_id in brush teeth    

    return isValidDeviceId(rd.device_id) && hasValidTimeFormat(rd.start_time)
            && isNotEmptyString(rd.title);
}
%>
