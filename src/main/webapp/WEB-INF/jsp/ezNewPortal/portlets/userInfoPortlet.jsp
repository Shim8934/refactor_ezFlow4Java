<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<body>
<div class="attitudePtl">
	<input type="hidden" id="useAttitude" value="${useAttitude}">
	<dl class="portlet_title sortablePortlet"></dl>
	<div style="position:relative;">
	    <div class="box_shadow info_right" style="margin:0px; margin-left:7px">
	        <dl class="info">
	        	<dt class="infoImg">
					<c:set var="picNone" value="/images/ezNewPortal/info_pic_none.png" />
					<img src="${not empty userPhoto? userPhoto : picNone}" onerror="this.src='${picNone}'" />
	        	
	            <%-- 2023-06-23 황인경 - 디자인 개선 > 유저 포틀릿 > 구조 변경 --%>
				<dd class="infoName">${userName}<span class="infoTeam">${deptName} ${userTitle}</span></dd>
				<dd class="infoTime"><spring:message code="ezNewPortal.yej06" /><span><c:out value="${fn:replace(lastLogin, '-', '.')}" /></span></dd>
			</dl>
	            <%-- 임시 --%>
			<div class="info_btn">
				<div class="info_div">
					<span class="info_portal" id="portletEnv" onclick="viewPortletEnv()"><span class="info_portal_icon"></span><spring:message code='ezNewPortal.HSBPT01'/></span>
					<span class="info_set" id="personalEnv" onclick="infoSetClick()"><span class="info_set_icon"></span><spring:message code='ezNewPortal.t006'/></span>
				</div>
				<span class="info_logout" onclick="infoLogoutClick()"><span class="info_logout_icon"></span><spring:message code='ezNewPortal.t008'/></span>
			</div>
<%--			<dd class="infoName">${userName }</dd>
	            <dd class="infoTeam">${deptName }</dd>
	            <dd class="infoMail">${userEmail }</dd>
	            <dd class="infoTime"><spring:message code="ezNewPortal.yej06" />&nbsp;&nbsp;${lastLogin }</dd>
	            <dd class="infoIP"><spring:message code="ezNewPortal.jhy01" />&nbsp;&nbsp;${lastLoginIP }</dd>
	            <!-- 임시 -->
	            <dd id="portletEnv" class="infoSet" onclick="viewPortletEnv()"><img src="/images/admin/frameSetting.png"></dd>
	            <dd id="portletEnv" class="infoSet" onclick="infoSetClick()" style="z-index: 1001;"><img src="/images/ezNewPortal/theme3Img/infoSet_btn.png"></dd>
	            <dd class="infoLogout" onclick="infoLogoutClick()"><img src="/images/ezNewPortal/theme3Img/infoLogout_btn.png"></dd>
	        </dl>  --%>
	        <div class="time_check">
	        	<c:choose>
	        		<c:when test="${useAttitude eq 'YES' }">
	        			<div class="presentTime">
	               		 	<p class="timeTxt"><span id="ptlTimeFlow"></span>
	                		<span class="timeAM">AM</span>
	                		<span class="timePM">PM</span></p>
	            		</div>
	            		<div class="main_time">
	            			<dl class="timeCheckIn out" id="ptlInAttiBtn" type="A01" datetype="2" onclick="ptlCheckHoliday(this, '<c:out value="${usedTheme}"/>')">
<!-- 	                		<dt><img src="/images/ezNewPortal/theme3Img/main_time_icon.png"></dt> -->
	                			<dd><spring:message code='ezNewPortal.t013' /></dd>
	                		</dl>
	                		<dl class="timeCheckOut out" id="ptlOutAttiBtn" type="A03" datetype="2" onclick="ptlCheckHoliday(this, '<c:out value="${usedTheme}"/>')">
<!--							<dt><img src="/images/ezNewPortal/theme3Img/main_time_icon.png"></dt> -->
	                			<dd><spring:message code='ezNewPortal.t014' /></dd>
	                		</dl>
	            		</div>
	        		</c:when>
	        		<c:otherwise>
	        			<div class="presentTime" style="float: none; width: auto;">
	               		 	<p class="timeTxt"><span id="ptlTimeFlow"></span>
	                		<span class="timeAM">AM</span>
	                		<span class="timePM">PM</span></p>
	            		</div>
	            		<div class="main_time" style="display: none;">
	            			<dl class="timeCheckIn out" id="ptlInAttiBtn" type="A01" datetype="2" onclick="ptlCheckHoliday(this, '<c:out value="${usedTheme}"/>')">
<!-- 	                		<dt><img src="/images/ezNewPortal/theme3Img/main_time_icon.png"></dt> -->
	                			<dd><spring:message code='ezNewPortal.t013' /></dd>
	                		</dl>
	                		<dl class="timeCheckOut out" id="ptlOutAttiBtn" type="A03" datetype="2" onclick="ptlCheckHoliday(this, '<c:out value="${usedTheme}"/>')">
<!-- 	                		<dt><img src="/images/ezNewPortal/theme3Img/main_time_icon.png"></dt> -->
	                			<dd><spring:message code='ezNewPortal.t014' /></dd>
	                		</dl>
	            		</div>
	        		</c:otherwise>
	        	</c:choose>
	        </div>
	    </div>
	 </div>
</div>
</body>
</html>