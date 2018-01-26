<%@ include file="setting_common.jsp"%>

<%!
private boolean actionIsInRange(int action) {
	return action == 0 || action == 1;
}
%>

<%
    JSONObject jobj = processPutSettingRequest(request, "language");
	out.print(jobj.toString());
%>
