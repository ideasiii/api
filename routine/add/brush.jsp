<%@include file="routine-add_common.jsp"%>

<%
    JSONObject jobj = processRequest(request, "brush teeth");
    out.print(jobj.toString());
%>
