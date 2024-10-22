<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
	<article class="photo_board box_shadow photo_portlet">
	<input type="hidden" id=photoPortletListCnt value="${totalCnt}">
		<div class="layDIV">
			<c:choose>
				<c:when test="${access eq 'true' }">
					<dl class="portlet_title photo_board sortablePortlet">
						<dt class="portletText" data1="${boardId }">
							<c:out value="${portletName }" />
						</dt>
					<dd class="portletPlus plus" id="photoBoardPlus"></dd>
						<!-- 
						<c:if test="${not empty photoBoardList}">
							<dd class="portletPlus  nextBtn">
								<c:choose>
									<c:when test="${usedTheme eq 3}">
										<img src="/images/ezNewPortal/photo_next.png">
									</c:when>
									<c:otherwise>
										<img src="/images/ezNewPortal/photo_next.png">
									</c:otherwise>
								</c:choose>
							</dd>
							<dd class="portletPlus preBtn">
								<c:choose>
									<c:when test="${usedTheme eq 3}">
										<img src="/images/ezNewPortal/photo_pre.png">
									</c:when>
									<c:otherwise>
										<img src="/images/ezNewPortal/photo_pre.png">
									</c:otherwise>
								</c:choose>
							</dd>
						</c:if>
						 -->
						</dl>
						<c:choose>
							<c:when test="${not empty photoBoardList && photoBoardList != ''}">
								<ul class="photoList portletPagingArea" id="photoul">
									<c:forEach items="${photoBoardList}" var="photo">
										<li><img src="${photo.filePath}" data1="${photo.boardID}" data2="${photo.itemID}" onclick="photoItemRead(this)">
											<span><c:out value='${photo.title}'/></span>
										</li>
									</c:forEach>
								</ul>
							</c:when>
							<c:otherwise>
								<ul class="portlet_list portletPagingArea" id="photoul" style="display:block">
									<dl class="nodata">
										<dt>
											<img src="/images/kr/main/noData_sIcon.png">
										</dt>
										<dd><spring:message code='ezNewPortal.t018' /></dd>
									</dl>
								</ul>
							</c:otherwise>
						</c:choose>
				</c:when>
				<c:otherwise>
					<c:choose>
						<c:when test="${not empty boardId }">
						<dl class="portlet_title photo_board sortablePortlet">
							<dt class="portletText" data1="${boardId }">
								<c:out value="${portletName }" />
							</dt>
						</dl>
						<ul class="portlet_list portletPagingArea" id="photoul" style="display:block">
							<dl class="nodata">
								<dt>
									<img src="/images/kr/main/noData_sIcon.png">
								</dt>
								<dd><spring:message code='ezNewPortal.t039' /></dd>
							</dl>
						</ul>
						</c:when>
						<c:otherwise>
							<dl class="portlet_title photo_board sortablePortlet" style="display:block">
								<dt class="portletText" data1="">
									<c:out value="${portletName }" />
								</dt>
							</dl>
							<ul class="portlet_list portletPagingArea" id="photoul">
								<dl class="nodata">
									<dt>
										<img src="/images/kr/main/noData_sIcon.png">
									</dt>
									<dd><spring:message code='ezNewPortal.t129'/></dd>
								</dl>
							</ul>
						</c:otherwise>
					</c:choose>
				</c:otherwise>
			</c:choose>
		</div>
		
		<div class="portletPageNav">
			<span class="portlet_list_nav prev"></span>
			<span class="portlet_list_nav next"></span>
		</div>
	</article>
</body>
</html>