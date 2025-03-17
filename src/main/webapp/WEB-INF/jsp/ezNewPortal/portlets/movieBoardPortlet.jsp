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
		<div id="layDIV"  class="layDIV sortablePortlet">
		
		<%-- 기존 포토게시판 썸네일처럼 동영상 2개 띄워주는 디자인 주석처리 --%>
<%--		
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
			</c:if> --%>
			
			<%-- 비디오 하나만 크게 띄워주는 디자인 --%>
			<c:choose>
				<c:when test="${not empty movieBoardList}">
					<c:forEach items="${movieBoardList}" var="movie" varStatus="status">
						<li id="li_${status.index}" style="width:100%; height:100%; padding:0px; display:inline-flex; background-color:black;">
							<div style="position:relative; width:100%;">
								<c:choose>
									<c:when test="${movie.addThumbnail eq 'Y'}">
										<img id="thumbnail" style="width:100%; height:100%;" class="handle-movie" src="${movie.thumbnailPath}">
										<video style="width:100%; height:100%; display:none;" id="mainVideo" class="handle-movie" src="${movie.filePath}" data1="${movie.boardID}" data2="${movie.itemID}" preload="metadata"/>
									</c:when>
									
									<c:otherwise>
										<video style="width:100%; height:100%;" id="mainVideo" class="handle-movie" src="${movie.filePath}" data1="${movie.boardID}" data2="${movie.itemID}" preload="metadata"/>
									</c:otherwise>
								</c:choose>
								<img id="playButton" src="/images/playButton.png" style="position:absolute; width:64px; left:calc(50% - 32px); top:34%; cursor:pointer; opacity:0.9;" onclick="moviePlay()"/>
								<div id="titleDiv" class="noti_portlet_list" style="position:absolute; width:100%; height:55px; margin:-57px 0px 0px 0px; padding:0px;
								 text-align:center; line-height:58px; color:white; background-color:rgba(0, 0, 0, 0.5); overflow:hidden;">
								 	<span style="width:90%; text-overflow:ellipsis; white-space:nowrap; overflow:hidden; display:inline-block;"><c:out value='${movie.title}'/></span>
								 </div>
							 </div>
							 <div style="display:none;" id="addThumbnail" value="${movie.addThumbnail}"></div>
							 <div style="display:none;" id="thumbnailExt" value="${movie.thumbnailExt}"></div>
						</li>
					</c:forEach>
				</c:when>
				<c:when test="${access eq 'false' }">
					<dl class="portlet_title photo_board sortablePortlet">
							<dt class="portletText">
								<c:out value="${portletName }" />
							</dt>
					</dl>
					<c:choose>
						<c:when test="${empty boardId }">
							<ul class="portlet_list">
								<dl class="nodata">
									<dt>
										<img src="/images/kr/main/noData_sIcon.png">
									</dt>
									<dd><spring:message code='ezNewPortal.t129' /></dd>
								</dl>
							</ul>
						</c:when>
						<c:otherwise>
							<ul class="portlet_list">
								<dl class="nodata">
									<dt>
										<img src="/images/kr/main/noData_sIcon.png">
									</dt>
									<dd><spring:message code='ezNewPortal.t039' /></dd>
								</dl>
							</ul>
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<dl class="portlet_title photo_board sortablePortlet">
							<dt class="portletText">
								<c:out value="${portletName }" />
							</dt>
					</dl>
					<ul class="portlet_list">
						<dl class="nodata">
							<dt>
								<img src="/images/kr/main/noData_sIcon.png">
							</dt>
							<dd><spring:message code='ezNewPortal.t018' /></dd>
						</dl>
					</ul>
				</c:otherwise>
			</c:choose>
		</div>
	</article>
</body>
</html>