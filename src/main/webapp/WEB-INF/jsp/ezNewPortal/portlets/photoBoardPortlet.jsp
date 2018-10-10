<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<div class="layDIV">
	<dl class="portlet_title photo_board">
		<dt class="portletText" data1="${boardId }"><c:out value="${portletName }"/></dt>
		<dd class="portletPlus" id="photoBoardPlus"><img src="/images/ezNewPortal/portlet_Plus.png"></dd>
	<c:if test="${access eq 'true' }">
		<dd class="nextBtn"><img src="/images/ezNewPortal/photo_next.png"></dd>
		<dd class="preBtn"><img src="/images/ezNewPortal/photo_pre.png"></dd>
	</dl>
	<ul class="photoList" id="photoul">
		<c:forEach items="${photoBoardList }" var="photo">
		 	<li><img src="${photo.filePath }" data1="${photo.boardID }" data2="${photo.itemID }" onclick="photoItemRead(this)"></li>
		</c:forEach>
	</ul>
	</c:if>
	<c:if test="${access eq 'false' }">
	</dl>
	<ul class="portlet_list">
		<dl class="nodata">
			<dt><img src="/images/ezNewPortal/nodata.png"></dt>
			<dd>해당 게시판의 접근 권한이 없습니다.</dd>
		</dl>
	</ul>
	</c:if>
</div>