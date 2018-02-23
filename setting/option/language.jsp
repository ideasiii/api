<%@ include file="setting-option_common.jsp"%>

<%
    request.setCharacterEncoding("UTF-8");
    JSONObject jobj = processRequest(request, "language");
    out.print(jobj.toString());
%>
