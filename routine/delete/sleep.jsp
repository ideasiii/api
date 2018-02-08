<%@ include file="routine-delete_common.jsp" %>

<%
    JSONObject jobj = processDeleteRoutineRequest(request, ROUTINE_TYPE_SLEEP);
    out.print(jobj.toString());
%>
