<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
	<article id="movieArticle" class="photo_board box_shadow">
		<div id="layDIV"  class="layDIV">
			<dl class="portlet_title photo_board sortablePortlet">
				<dt id="movieDt" class="portletText" data1="${boardId}">
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
					<ul class="photoList" id="movieUl" style="margin:20px 0px; height:154px;">
						<c:forEach items="${movieBoardList}" var="movie" varStatus="status">
							<li id="li_${status.index}" style="width:50%; height:92%; padding:15px 5px 0px 3px; display:inline-flex; align-items:center;">
								<video style="width:100%; height:100%; cursor:pointer;" id="video_${status.index}" src="${movie.filePath}" data1="${movie.boardID}" data2="${movie.itemID}" 
									onclick="movieItemRead(this)" onmouseover="moviePrePlay(this)" onmouseout="moviePreStop(this)" preload="metadata" muted loop />
								<c:if test="${status.index % 2 == 0}">
									<img src="/images/ezLadder/btn_play.png" onclick="movieItemRead2(this)" style="position:absolute; display:list-item; width:20%; height:30%; left:16%; top:42%;"/>
								</c:if>
								<c:if test="${status.index % 2 == 1}">
									<img src="/images/ezLadder/btn_play.png" onclick="movieItemRead2(this)" style="position:absolute; display:list-item; width:20%; height:30%; left:64%; top:42%;"/>
								</c:if>
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