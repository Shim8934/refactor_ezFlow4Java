<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>근태 상세조회</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezAttitude.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
		
		<script type="text/javascript" src="/js/ezSchedule/schedule_write_Cross.js"></script>
		<script type="text/javascript" src="/js/ezSchedule/Calendar/TabMenu.js"></script>
	    <script type="text/javascript" src="/js/ezSchedule/lang/ezSchedule.js"></script>
		
		<script type="text/javascript">
			var formInfo = ${formInfo};
			var attitudeInfo = ${attitudeInfo};
			
			window.onload = function () {
				setHtml();
			}
			
			function setHtml() {
				$("#attiInfoView").append(formInfo.formHtml);
				
				$("#attiInfoView tr td *").remove();
				
				$("#typeName").text(" " + attitudeInfo.typeName);
				$("#writerName").text(" " + attitudeInfo.writerName);
				$("#region").text(" " + attitudeInfo.region);
				$("#mobile").text(" " + attitudeInfo.mobile);
				$("#bizsub").text(" " + attitudeInfo.bizSub);
				//$("#content").text(" ");
				
				var dateType = attitudeInfo.dateType;
				var showTime = "";
				switch (dateType) {
					case "1":
						showTime = attitudeInfo.startDate.substring(0, 10);
						break;
					case "2":
						showTime = attitudeInfo.startDate.substring(0, 16);
						break;
					case "3":
						showTime = attitudeInfo.startDate.substring(0, 16) + " ~ " + attitudeInfo.endDate.substring(11, 16);
						break;
					case "4":
						showTime = attitudeInfo.startDate.substring(0, 10) + " ~ " + attitudeInfo.endDate.substring(0, 10);
						break;
					case "5":
						showTime = attitudeInfo.startDate.substring(0, 16) + " ~ " + attitudeInfo.endDate.substring(0, 16);
						break;
				}
				
				$("#attiTime").text(" " + showTime);
			}
		</script>
	</head>
	<body class = "popup">
<!-- 		<h1>근태 작성</h1> -->
		<div id="menu">
			<ul>
				<li><span onClick="">메일로 발송</span></li>
			</ul>
			<ul>
				<li><span onClick="">수정</span></li>
			</ul>
			<ul>
				<li><span onClick="">삭제</span></li>
			</ul>
		</div>
		<div id="close">
			<ul>
				<li><span onClick="window.close()">닫기</span></li>
			</ul>
		</div>
		<div id="contentDiv">
			<table id="attiInfoView" class="content">
				<tbody>
					<tr>
		    			<th>구분</th> 
		    			<td id="typeName"></td> 
		  			</tr>
	  			</tbody>
			</table>
			<table id="content" class="content" style="width:100%; margin-top: 10px;">
			  	<tr>
	  				<td style="height: 300px;">
	  				</td>  
	  			</tr>
			</table>
		</div>
	</body>
</html>