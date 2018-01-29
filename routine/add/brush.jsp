<%@include file="routine-add_common.jsp"%>

<%
    JSONObject jobj = processAddRoutineRequest(request, "brush teeth");
    out.print(jobj.toString());
%>
