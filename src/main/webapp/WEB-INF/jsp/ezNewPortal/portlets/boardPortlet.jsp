<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Board Portlet</title>
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/boardPortlet.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
<script type="text/javascript">
$(function() {
	var boardPortlet = "<c:out value='${portletId}'/>";
	$("#portletPlus" + boardPortlet).on("click", customBoardBtnClick);
	var type = "<c:out value='${type}'/>";
	var fileName = "<c:out value='${fileName}'/>";
	initBoardPortletInfo(boardPortlet, type, fileName);
	var portletName = "<c:out value='${portletName }'/>";
	ellipsisTitle(portletName, boardPortlet);
});
</script>
</head>
<body>
<article class="customBoard box_shadow">
		<div class="layDIV">
			<dl class="portlet_title sortablePortlet">
				<dt class="portletText"></dt>
				<dd id="<c:out value='portletPlus${portletId}'/>" class="portletPlus plus" data1="<c:out value='${boardId }'/>"></dd>
				<!-- 
				<dd class="portletPlus nextBtn" onclick="<c:out value='nextPageBoardPortlet(${portletId})'/>">
					<img src="/images/ezNewPortal/photo_next.png">
				</dd>
				<dd class="portletPlus preBtn" onclick="<c:out value='prePageBoardPortlet(${portletId})'/>">
					<img src="/images/ezNewPortal/photo_pre.png">
				</dd>
				 -->
			</dl>
			<c:choose>
			<c:when test="${access eq true}">
			<ul id="customBoardList<c:out value='${portletId }'/>" class="portlet_list two_line portletPagingArea">
			</ul>
			</c:when>
			<c:when test="${access eq false }">
					<ul class="portlet_list portletPagingArea">
						<dl class="nodata">
							<dt>
								<img src="/images/kr/main/noData_sIcon.png">
							</dt>
							<dd><spring:message code='ezNewPortal.t039' /></dd>
						</dl>
					</ul>
			</c:when>
			</c:choose>
		</div>
		<div class="portletPageNav">
			<span class="portlet_list_nav prev"></span>
			<span class="portlet_list_nav next"></span>
		</div>
	</article>
</body>
</html>