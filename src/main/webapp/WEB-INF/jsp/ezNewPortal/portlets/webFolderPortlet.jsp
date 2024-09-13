<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix ="fn" uri = "http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WebFolder Portlet</title>
</head>
<script type="text/javascript">
    $(function() {
        var portletId = "<c:out value='${portletId }'/>";
        var portletName = "<c:out value='${portletName }'/>";
        ellipsisTitle(portletName, portletId);
    });
</script>
<body>
<article class="webFolder_portlet box_shadow">
    <div class="layDIV">
        <dl class="portlet_title sortablePortlet">
            <dt class="portletText"><c:out value="${portletName}"></c:out></dt>
            <dd class="portletPlus plus" onclick="openWebFolderPage()"></dd>
            <dd class="mailGraph" id="webFolderGraph">
            	<p class="mGraph sortablePortlet">
            		<span id="usedRate" class="sortablePortlet"></span>
            	</p>
           		<span class="mGraph_text sortablePortlet" id="usingCpacity">
           		</span>
            </dd>
        </dl>
        
        <div class="fileListWrapper">
	        <ul class="webFolder portletPagingArea" id ="webfolderUl"></ul>
        </div>
        <iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>
    </div>
    <div class="portletPageNav">
    	<span class="portlet_list_nav prev"></span>
    	<span class="portlet_list_nav next"></span>
    </div>
</article>
</body>
</html>