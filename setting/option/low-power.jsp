<%@ include file="setting-option_common.jsp"%>

<%
	JSONObject jobj = processRequest(request, "battery");
	out.println(jobj.toString());
%>
