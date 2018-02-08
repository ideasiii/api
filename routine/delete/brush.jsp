<%@ include file="routine-delete_common.jsp" %>

<%
	JSONObject jobj = processDeleteRoutineRequest(request, ROUTINE_TYPE_BRUSH_TEETH);
	out.print(jobj.toString());
%>
