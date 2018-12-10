<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>EmployeeofMonth</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezPersonal.e3', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezPersonal/slick.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezPersonal/slick-theme.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/slick.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezPersonal.h1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/admin/adminManageEmployeeOfMonth.js')}"></script>
		<style>
			.calSlider {width: 85% !important; margin: 0px auto; border-top: 2px solid; border-bottom: 1px solid #c8ccd0;}
			.slick-slide {margin: 0px 3px;}
			.slick-slide img {width: 100% !important;}
			.slick-center {color: red;}
			.slick-prev:before, .slick-next:before {color: black;}
			.yearDiv {height: 38px; /* border: 1px solid #c8ccd0; */ }
			.yearSpan {text-align: center; font-size: 20px; white-space: nowrap; text-overflow: ellipsis; overflow: hidden; letter-spacing: -1px; line-height: 31px;}
			.employee {vertical-align: top; display: inline-block; width: 180px; border: 1px solid #d9d9d9; margin: 20px 60px 0px 0px; height: 240px;}
			.empBttn {text-align: right; padding: 10px 10px 0px 0px; height: 27px;}
			.empBttn > img:first-child {margin-right: 7px;}
			.empAdd dl dt {margin: 0px;}
			.empAdd dl dt img {margin: 10px 0px 20px 60px; cursor: pointer;}
			.empAdd dl dd {color: #999; font-size: 15px; line-height: 21px; text-align: center; margin: 0px;}
			.empImg dl dd {font-size: 15px; line-height: 19px; text-align: center; margin: 0px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;}
			.empImg dl dt img {margin-left: 40px; height: 95px; width: 95px; cursor:pointer;}
			.empInfo {border-bottom: 3px solid; margin: 0px 25px 0px 25px;}
			.empInfo p {margin: 0px; text-align: center; font-size: 20px; font-weight: bold;}
			.empCompany {font-weight: bold; font-size: 20px;}
			.calendarleft {margin: 0px;}
			.calendarright {margin: 0px;}
			.tree_delete {margin: 0px; cursor: pointer;}
			.slick-slide {outline: none !important;}
			.mainlist {margin-left: 110px;}
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
			<h1><spring:message code = 'ezPersonal.t299' /></h1>
			<div style="width:100%;">
				<!-- 달력슬라이더 영역 -->
				<div class="regular calSlider" id="regular"></div>
				
				<!-- 이달의우수사원 리스트 영역 -->
				<ul id="mainlist" class="mainlist"></ul>
			</div>
	    </form>
	</body>
</html>