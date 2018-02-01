<%@include file="routine-add_common.jsp"%>
<%@page import="java.util.Map"%>

<%
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
    final String strRepeat = request.getParameter("repeat");
    final String strMetaId = request.getParameter("meta_id");

    if (!isValidRoutineRepeatValue(strRepeat) || !isPositiveInteger(strMetaId)) {
    	return false;
    }
    
    rd.repeat = Integer.parseInt(strRepeat.trim());
    rd.meta_id = Integer.parseInt(strMetaId.trim());
    
    return isValidDeviceId(rd.device_id) && hasValidTimeFormat(rd.start_time)
    	    && isNotEmptyString(rd.title);
}
%>
