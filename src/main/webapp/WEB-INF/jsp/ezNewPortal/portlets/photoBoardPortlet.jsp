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
		<div class="layDIV">
			<c:choose>
				<c:when test="${access eq 'true' }">
					<dl class="portlet_title photo_board sortablePortlet">
						<dt class="portletText" data1="${boardId }">
							<c:out value="${portletName }" />
						</dt>
					<dd class="portletPlus" id="photoBoardPlus">
						<img src="/images/ezNewPortal/portlet_Plus${usedTheme }.png">
					</dd>
						<c:if test="${not empty photoBoardList}">
							<dd class="nextBtn">
								<c:choose>
									<c:when test="${usedTheme eq 3 }">
										<img src="/images/ezNewPortal/photo_next3.png">
									</c:when>
									<c:otherwise>
										<img src="/images/ezNewPortal/photo_next.png">
									</c:otherwise>
								</c:choose>
							</dd>
							<dd class="preBtn">
								<c:choose>
									<c:when test="${usedTheme eq 3 }">
										<img src="/images/ezNewPortal/photo_pre3.png">
									</c:when>
									<c:otherwise>
										<img src="/images/ezNewPortal/photo_pre.png">
									</c:otherwise>
								</c:choose>
							</dd>
						</c:if>
						</dl>
						<c:choose>
							<c:when test="${not empty photoBoardList}">
								<ul class="photoList" id="photoul">
									<c:forEach items="${photoBoardList }" var="photo">
										<li><img src="${photo.filePath }" data1="${photo.boardID }"
											data2="${photo.itemID }" onclick="photoItemRead(this)"></li>
									</c:forEach>
								</ul>
							</c:when>
							<c:otherwise>
								<ul class="portlet_list">
									<dl class="nodata">
										<dt>
											<img src="/images/ezNewPortal/nodata.png">
										</dt>
										<dd>"<spring:message code='ezNewPortal.t018' />"</dd>
									</dl>
								</ul>
							</c:otherwise>
						</c:choose>
				</c:when>
					<c:otherwise>
						<dl class="portlet_title photo_board sortablePortlet">
							<dt class="portletText" data1="${boardId }">
								<c:out value="${portletName }" />
							</dt>
							<dd>"<spring:message code='ezNewPortal.t018' />"</dd>
						</dl>
						<ul class="portlet_list">
							<dl class="nodata">
								<dt>
									<img src="/images/ezNewPortal/nodata.png">
								</dt>
								<dd>"<spring:message code='ezNewPortal.t039' />"</dd>
							</dl>
						</ul>
					</c:otherwise>
			</c:choose>
			<c:if test="${access eq 'false' }">
				</dl>
				<ul class="portlet_list">
					<dl class="nodata">
						<dt>
							<img src="/images/ezNewPortal/nodata.png">
						</dt>
						<dd>"<spring:message code='ezNewPortal.t039' />"</dd>
					</dl>
				</ul>
			</c:if>
		</div>
	</article>
</body>
</html>