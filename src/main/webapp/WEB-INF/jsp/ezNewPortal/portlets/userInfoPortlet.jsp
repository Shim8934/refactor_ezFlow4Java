<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<body>
<div class="attitudePtl">
	<input type="hidden" id="useAttitude" value="${useAttitude}">
	<dl class="portlet_title sortablePortlet" style="position: relative; width: 100%; bottom: 0px; z-index: 100; border-bottom:none; background:none;"></dl>
	<div style="position:relative; bottom:46px; overflow:hidden;">
		<div class="box_shadow info_left" style="margin:0px; margin-right:7px">
	    	<div></div>
		</div>
	    <div class="box_shadow info_right" style="margin:0px; margin-left:7px">
	        <dl class="info">
	        	<dt class="infoImg">
	        		<c:if test="${userPhoto eq null || userPhoto eq ''}">
		        		<img src="/images/ezNewPortal/theme3Img/my_pic.png">
	        		</c:if>
	        		<c:if test="${userPhoto ne null && userPhoto ne ''}">
		        		<img src="${userPhoto }">
	        		</c:if>
	        	
	            <dd class="infoName">${userName }</dd>
	            <dd class="infoTeam">${deptName }</dd>
	            <dd class="infoMail">${userEmail }</dd>
	            <dd class="infoTime"><spring:message code="main.t00016" /><spring:message code="ezPersonal.t27" />&nbsp;&nbsp;${lastLogin }</dd>
	            <!-- 임시 -->
	            <dd id="portletEnv" class="infoSet" onclick="viewPortletEnv()" style="z-index: 101;background-color: rgb(51, 152, 254)"><img src="/images/admin/frameSetting.png"></dd>
	            <!-- <dd id="portletEnv" class="infoSet" onclick="infoSetClick()" style="z-index: 1001;"><img src="/images/ezNewPortal/theme3Img/infoSet_btn.png"></dd> -->
	            <dd class="infoLogout" onclick="infoLogoutClick()" style="z-index: 101;"><img src="/images/ezNewPortal/theme3Img/infoLogout_btn.png"></dd>
	        </dl>
	        <div class="time_check">
	        	<div class="presentTime">
	                <p class="timeTxt"><span id="ptlTimeFlow"></span>
	                <span class="timeAM">AM</span>
	                <span class="timePM">PM</span></p>
	            </div>
	            <div class="main_time">
	            	<dl class="timeCheckIn out" id="ptlInAttiBtn" type="A01" datetype="2" onclick="ptlCheckHoliday(this, '${usedTheme}')">
	                	<dt><img src="/images/ezNewPortal/theme3Img/main_time_icon.png"></dt>
	                	<dd><spring:message code='ezNewPortal.t046' /></dd>
	                </dl>
	                <dl class="timeCheckOut out" id="ptlOutAttiBtn" type="A03" datetype="2" onclick="ptlCheckHoliday(this, '${usedTheme}')">
	                	<dt><img src="/images/ezNewPortal/theme3Img/main_time_icon.png"></dt>
	                	<dd><spring:message code='ezNewPortal.t047' /></dd>
	                </dl>
	            </div>
	        </div>
	    </div>
	 </div>
</div>
</body>
</html>