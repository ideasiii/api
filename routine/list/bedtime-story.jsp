<%@include file="../../api_common.jsp"%>
<%@include file="../../response_generator.jsp"%>
<%@include file="../routine__common.jsp"%>

<%@ page import="java.util.Map"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="org.json.JSONObject"%>

<%
    request.setCharacterEncoding("UTF-8");
    JSONObject jobj = processListBedtimeStoryRequest(request);
    out.print(jobj.toString());
%>

<%!
private JSONObject processListBedtimeStoryRequest(HttpServletRequest request) {
    if (!hasRequiredParameters(request)) {
        return ApiResponse.error(ApiResponse.STATUS_MISSING_PARAM);
    }

    final RequestParam rp = new RequestParam();
    if (!extractRequestParameter(request, rp)) {
        return ApiResponse.error(ApiResponse.STATUS_INVALID_PARAMETER);
    }

    final Connection conn = connect(Common.DB_URL, Common.DB_USER, Common.DB_PASS);
    if (conn == null) {
        return ApiResponse.error(ApiResponse.STATUS_INTERNAL_ERROR);
    }

    JSONArray resArr = new JSONArray();
    int nSelect = selectStories(conn, rd, resArr);
    if (nSelect < 0) {
        // SELECT failed
        jobj = ApiResponse.byReturnStatus(nSelect);
    } else {
        jobj = ApiResponse.successTemplate();
        jobj.put("result", resArr);
    }

    closeConn(conn);
    return jobj;
}

public boolean hasRequiredParameters(final HttpServletRequest request) {
    Map paramMap = request.getParameterMap();
    return paramMap.containsKey("language") && paramMap.containsKey("type");
}

public boolean extractRequestParameter(HttpServletRequest request, RequestParam rp) {
    rp.language = request.getParameter("language").trim();
    String strType = request.getParameter("typeroutine_id").trim();

    if (!isPositiveInteger(strType)) {
        return false;
    }

    rp.type = Integer.parseInt(strType);

    return isNotEmptyString(rp.language);
}

public int selectStories(final Connection conn, final RequestParam rp, final JSONArray out) {
    SelectResult sr = new SelectResult();

    return select(conn, "SELECT `story_id`,`story_url`,`story_name`, FROM `story` WHERE `language`=? AND `type`=?",
            new Object[]{rp.language, Integer.valueOf(rp.type)}, new ResultSetReader() {
        @Override
        public void read(ResultSet rs, SelectResult sr) throws Exception {
            sr.status = 0;

            while (rs.next()) {
                ++sr.status;
                JSONObject story = new JSONObject();
                story.put("story_id", rs.getInt("story_id"));
                story.put("story_url", rs.getString("story_url"));
                story.put("story_name", rs.getString("story_name"));
                out.put(story);
            }
        }
    }, sr);
}

private static class RequestParam {
    String language;
    int type;
}

public static class StoryData {
    public int story_id; // this is meta_id in sleep routine data
    public String story_url;
    public String story_name;
    public String category;
    public String language;
    public int type;
}

%>
