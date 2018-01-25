<%@ include file="setting-option_common.jsp"%>

<%
    JSONObject jobj = processRequest(request, "language");
    out.println(jobj.toString());
%>
