<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<body>
	<article class="box_shadow">
	<div class="layDIV">
		<input type="hidden" id="nowMonth" value="${nowMonth}">
		<dl class="portlet_title photo_board sortablePortlet">
			<dt class="portletText">
				<span id="curMonth"><c:out value="${nowMonth }" /></span>
				<spring:message code='main.t00049'/> <c:out value='${portletName }'/>
			</dt>
			<!-- 		<dd class="portletPlus"><img src="/images/ezNewPortal/portlet_Plus.png"></dd> -->
			<dd id="birthNext" class="nextBtn">
				<c:choose>
					<c:when test="${usedTheme eq 3 }">
						<img src="/images/ezNewPortal/photo_next3.png">
					</c:when>
					<c:otherwise>
						<img src="/images/ezNewPortal/photo_next.png">
					</c:otherwise>
				</c:choose>
			</dd>
			<dd id="birthPrev" class="preBtn">
				<c:choose>
					<c:when test="${usedTheme eq 3 }">
						<img src="/images/ezNewPortal/photo_pre3.png">
					</c:when>
					<c:otherwise>
						<img src="/images/ezNewPortal/photo_pre.png">
					</c:otherwise>
				</c:choose>
			</dd>
		</dl>
		<div class="birthdayList" id="birthcount" style="display: none;">
			<ul class="birthList" id="birthdayList"></ul>
		</div>
		<div id="nodata_NewBirthday" class="nodata_newBirthday" style="padding-top: 15px;">
			<dl class='nodata'>
				<dt><img src='/images/kr/main/nodata.png'></dt>
				<dd>"<spring:message code='main.t00026' />"</dd>
			</dl>
		</div>
	</div>
	</article>
</body>
</html>