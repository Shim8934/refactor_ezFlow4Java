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
				<spring:message code='main.t1002' />
			</dt>
			<!-- 		<dd class="portletPlus"><img src="/images/ezNewPortal/portlet_Plus.png"></dd> -->
			<dd id="birthNext" class="nextBtn">
				<img src="/images/ezNewPortal/photo_next.png">
			</dd>
			<dd id="birthPrev" class="preBtn">
				<img src="/images/ezNewPortal/photo_pre.png">
			</dd>
		</dl>
		<div id="birthcount" style="display: none;">
			<ul class="birthList" id="birthdayList"></ul>
		</div>
		<div id="nodata_NewBirthday">
			<dl class='nodata'>
				<dt><img src='/images/kr/main/nodata.png'></dt>
				<dd><spring:message code='main.t00026' /></dd>
			</dl>
		</div>
	</div>
	</article>
</body>
</html>