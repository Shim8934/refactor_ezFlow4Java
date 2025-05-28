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
<%--				<span id="curMonth"><c:out value="${nowMonth }" /></span><spring:message code='ezNewPortal.yej04'/><c:out value='${portletName }'/>--%>
				<span id="curMonth"></span><spring:message code='ezNewPortal.birthPortlet01'/><c:out value='${portletName }'/>
			</dt>
			<!-- 		<dd class="portletPlus"><img src="/images/ezNewPortal/portlet_Plus.png"></dd> -->
<!-- 			<dd id="birthNext" class="portletPlus nextBtn"> -->
<!-- 				<img src="/images/ezNewPortal/photo_next.png"> -->
<!-- 			</dd> -->
<!-- 			<dd id="birthPrev" class="portletPlus preBtn"> -->
<!-- 				<img src="/images/ezNewPortal/photo_pre.png"> -->
<!-- 			</dd> -->
		</dl>
		<div style="height:calc(100% - 73px);">
			<div class="birthdayList" id="birthcount" style="display: none;">
				<ul class="birthList portletPagingArea" id="birthdayList"></ul>
			</div>
			<div id="nodata_NewBirthday" class="nodata_newBirthday" style="display:none;">
				<dl class='nodata'>
					<dt><img src='/images/kr/main/noData_sIcon.png'></dt>
					<dd><spring:message code='ezNewPortal.t018' /></dd>
				</dl>
			</div>
		</div>
	</div>
	<div class="portletPageNav">
		<span class="portlet_list_nav prev"></span>
		<span class="portlet_list_nav next"></span>
	</div>
	</article>
	</article>
</body>
</html>