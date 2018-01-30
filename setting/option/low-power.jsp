<%@ include file="setting-option_common.jsp"%>

<%
	JSONObject jobj = processRequest(request, "battery");
	out.print(jobj.toString());
%>
