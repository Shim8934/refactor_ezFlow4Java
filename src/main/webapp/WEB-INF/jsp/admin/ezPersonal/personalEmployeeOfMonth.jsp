<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>EmployeeofMonth</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezPersonal/slick.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezPersonal/slick-theme.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('main.e4', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/slick.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezPersonal.h1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/admin/adminManageEmployeeOfMonth.js')}"></script>
		<style>
		/* 2022-12-02 민지수 - slick-list 클래스에 margin을 주어 prev, next 버튼과 공간을 만들어 버튼 클릭이 되도록 수정 */
		.slick-list {
			margin-left: 25px;
		    margin-right: 25px;
		}
		</style>
		
		<script type="text/javascript">
			var nowYear = new Date().getFullYear();
			var popup;
			var selectedYear;
			var selectedTerm;
			
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
			$(document).on('ready', function() {
				getYearList();
				getEmployeeList(nowYear);
				
				$(".regular").on('afterChange', function(event, slick, currentSlide, nextSlide){
					var centerElmt = document.getElementsByClassName("slick-center")[0];
					var centerYear = centerElmt.getElementsByClassName("yearSpan")[0].innerHTML;
					var mainList   = document.getElementById("mainlist");
					
					$("#mainlist").fadeOut(100, function() {
						while (mainList.firstChild) {
							mainList.removeChild(mainList.firstChild);
						}
					})
					
					$("#mainlist").fadeIn(100, function() {
						getEmployeeList(centerYear);
					});
				});
			});
		</script>
	</head>
	<body class = "mainbody">
		<form id="form1">
			<h1><spring:message code = 'ezPersonal.t299' />
				<jsp:include page="/WEB-INF/jsp/admin/companySelect.jsp"/>
			</h1>
			<div style="width:100%;">
				<!-- 달력슬라이더 영역 -->
				<div class="regular calSlider" id="regular"></div>
				
				<!-- 이달의우수사원 리스트 영역 -->
				<ul id="mainlist" class="admin_employeeList"></ul>
			</div>
	    </form>
	</body>
</html>