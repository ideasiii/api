<%@ include file="setting-option_common.jsp"%>

<%
    request.setCharacterEncoding("UTF-8");
	JSONObject jobj = processRequest(request, "battery");
	out.print(jobj.toString());
%>
