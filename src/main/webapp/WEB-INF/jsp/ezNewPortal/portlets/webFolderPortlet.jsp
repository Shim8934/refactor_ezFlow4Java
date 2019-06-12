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
<body>
<article class="webFolder_portlet box_shadow">
<!-- 
	<input type="hidden" id="webFolderId" />
	<input type="hidden" id="folderType" value="U" />
	<input type="hidden" id="parentId" value="root" />
	 -->
    <div class="layDIV">
        <dl class="portlet_title">
            <dt class="portletText"><c:out value="${portletName}"></c:out></dt>
            <dd class="portletPlus" onclick="openWebFolderPage()">
            	<img src="/images/ezNewPortal/portlet_Plus.png">
            </dd>
            <dd class="mailGraph" id="webFolderGraph">
            	<p class="mGraph">
            		<span id="usedRate"></span>
            	</p>
           		<span class="mGraph_text" id="usingCpacity">
           			<span id="totalCapacity"></span>
           		</span>
            </dd>
        </dl>
        
        <div class="fileListWrapper">
	        <ul class="webFolder" id = webfolderUl></ul>
        </div>
        <iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>
    </div>    
</article>
</body>
</html>