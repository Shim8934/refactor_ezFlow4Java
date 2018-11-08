<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<body>
<div class="layDIV">
	<input type="hidden" id="useAttitude" value="${useAttitude}">
	<dl class="portlet_title sortablePortlet" style="position: relative; width: calc(100% - 75px); bottom: 0px; z-index: 1000; border-bottom:none; background:none;"></dl>
	<div style="position:relative; bottom:46px; overflow:hidden;">
		<div class="box_shadow info_left" style="margin:0px; margin-right:7px">
	    	<div></div>
		</div>
	    <div class="box_shadow info_right" style="margin:0px; margin-left:7px">
	        <dl class="info">
	        	<dt class="infoImg"><img src="/images/ezNewPortal/theme3Img/my_pic.png"></dt>
	            <dd class="infoName">${userName }</dd>
	            <dd class="infoTeam">${deptName }</dd>
	            <dd class="infoMail">${userEmail }</dd>
	            <dd class="infoTime"><spring:message code="main.t00016" /><spring:message code="ezPersonal.t27" />&nbsp;&nbsp;${lastLogin }</dd>
	            <dd class="infoSet" onclick="infoSetClick()"><img src="/images/ezNewPortal/theme3Img/infoSet_btn.png"></dd>
	            <dd class="infoLogout" onclick="infoLogoutClick()"><img src="/images/ezNewPortal/theme3Img/infoLogout_btn.png"></dd>
	        </dl>
	        <div class="time_check">
	        	<div class="presentTime">
	                <p class="timeTxt"><span id="ptlTimeFlow"></span>
	                <span class="timeAM">AM</span>
	                <span class="timePM">PM</span></p>
	            </div>
	            <div class="main_time">
	            	<dl class="timeCheckIn out" id="ptlInAttiBtn" type="A01" datetype="2" onclick="ptlCheckHoliday(this)">
	                	<dt><img src="/images/ezNewPortal/theme3Img/main_time_icon.png"></dt>
	                	<dd>출근입력</dd>
	                </dl>
	                <dl class="timeCheckOut out" id="ptlOutAttiBtn" type="A03" datetype="2" onclick="ptlCheckHoliday(this)">
	                	<dt><img src="/images/ezNewPortal/theme3Img/main_time_icon.png"></dt>
	                	<dd>퇴근입력</dd>
	                </dl>
	            </div>
	        </div>
	    </div>
	 </div>
</div>
</body>
</html>