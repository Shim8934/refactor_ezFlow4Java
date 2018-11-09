<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
	<style type="text/css">
	
	</style>
</head>
<body>
	<article class="photo_board box_shadow">
		<div id="layDIV"  class="layDIV">
			<dl class="portlet_title photo_board sortablePortlet">
				<dt class="portletText" data1="${boardId }">
					<c:out value="${portletName }" />
				</dt>
				<dd class="portletPlus" id="movieBoardPlus">
					<img src="/images/ezNewPortal/portlet_Plus${usedTheme }.png">
				</dd>
				<c:if test="${access eq 'true' }">
					<dd class="nextBtn">
						<img src="/images/ezNewPortal/photo_next.png">
					</dd>
					<dd class="preBtn">
						<img src="/images/ezNewPortal/photo_pre.png">
					</dd>
			</dl>
			<c:choose>
				<c:when test="${not empty movieBoardList}">
					<ul class="photoList" id="photoul" style="margin:20px 0px; height:154px;">
						<c:forEach items="${movieBoardList}" var="movie" varStatus="status">
						<c:if test=${status.index % 2 == 1}>
							<li id="li_${status.index}" style="width:49%; height:92%; padding:22px 0px 0px 0px; margin-right:5px;">
						</c:if>
						<c:if test=${status.index % 2 == 0}>
							<li id="li_${status.index}" style="width:49%; height:92%; padding:22px 0px 0px 0px;">
						</c:if>
								<video style="width:100%; filter:brightness(80%);" id="video_${status.index}" src="${movie.filePath}" data1="${movie.boardID}" data2="${movie.itemID}" 
									onclick="movieItemRead(this)" onmouseover="moviePrePlay(this)" onmouseout="moviePreStop(this)" preload="metadata" muted loop />
								<img src="/images/ezLadder/btn_play.png"/>
							</li>
						</c:forEach>
					</ul>
				</c:when>
				<c:otherwise>
					<ul class="portlet_list">
						<dl class="nodata">
							<dt>
								<img src="/images/ezNewPortal/nodata.png">
							</dt>
							<dd>데이터가 없습니다.</dd>
						</dl>
					</ul>
				</c:otherwise>
			</c:choose>
			</c:if>
			<c:if test="${access eq 'false' }">
				</dl>
				<ul class="portlet_list">
					<dl class="nodata">
						<dt>
							<img src="/images/ezNewPortal/nodata.png">
						</dt>
						<dd>해당 게시판의 접근 권한이 없습니다.</dd>
					</dl>
				</ul>
			</c:if>
		</div>
	</article>
</body>
</html>