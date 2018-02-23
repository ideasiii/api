<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ include file="routine-delete_common.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");
	JSONObject jobj = processDeleteRoutineRequest(request, ROUTINE_TYPE_BRUSH_TEETH);
	out.print(jobj.toString());
%>
