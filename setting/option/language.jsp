<%@ include file="setting-option_common.jsp"%>

<%
    JSONObject jobj = processRequest(request, "language");
    out.print(jobj.toString());
%>
