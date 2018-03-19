<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="/css/default_kr.css" type="text/css"/>
		<link rel="stylesheet" href="/css/ezSchedule/Calendar_cross.css" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezAttitude/Calendar.js"></script>
		<script>
			
			/**
			* 통계 메소드
			*/
			function getAttiStatisList() {
				$.ajax({
					type : "POST",
					dataType : "json",
					async : true,
					url : "",
					data : {},
					success : function(result) {
						
					}
				})
			}
			
			/**
			* 근태 메소드
			*/
			function getAttitudeMainList() {
				$.ajax({
					type : "POST",
					dataType : "json",
					async : true,
					url : "",
					data : {},
					success : function(result) {
						
					}
				})
			}
		</script>
	</head>
	<body class="mainbody" style="overflow:auto" marginwidth="0" marginheight="0">
		<h1 id="titleimg">개인근태현황</h1>
		<div id="mainmenu">
			<ul>
			</ul>
		</div>
		
		<table>
			<tr>
				<td style="vertical-align:top; width:100%;">
					<div style="vertical-align:top;" id="Calendar"></div>
				</td>
				<td style="vertical-align:top; width:10px;">&nbsp;</td>
<!-- 				<td style="vertical-align:top; width:8%; margin-left:5px;"> -->
<!-- 					<div style="vertical-align:top;" id="attiStatis"> -->
<!-- 						<table cellpadding="0" cellspacing="0" border="0" width="100%"> -->
<!-- 							<tbody> -->
<!-- 								<tr> -->
<!-- 									<th colspan="2" style="height:44px">2018년 3월</th> -->
<!-- 								</tr> -->
<!-- 								<tr> -->
<!-- 									<td style="font-size:15px; text-align:center; border:1px solid #dedede; height:50px;">지각 : 0일</td> -->
<!-- 								</tr> -->
<!-- 								<tr> -->
<!-- 									<td style="font-size:15px; text-align:center; border:1px solid #dedede; height:50px;">지각 : 0일</td> -->
<!-- 								</tr> -->
<!-- 								<tr> -->
<!-- 									<td style="font-size:15px; text-align:center; border:1px solid #dedede; height:50px;">지각 : 0일</td> -->
<!-- 								</tr> -->
<!-- 								<tr> -->
<!-- 									<td style="font-size:15px; text-align:center; border:1px solid #dedede; height:50px;">지각 : 0일</td> -->
<!-- 								</tr> -->
<!-- 								<tr> -->
<!-- 									<td style="font-size:15px; text-align:center; border:1px solid #dedede; height:50px;">지각 : 0일</td> -->
<!-- 								</tr> -->
<!-- 								<tr> -->
<!-- 									<td style="font-size:15px; text-align:center; border:1px solid #dedede; height:50px;">지각 : 0일</td> -->
<!-- 								</tr> -->
<!-- 								<tr> -->
<!-- 									<td style="font-size:15px; text-align:center; border:1px solid #dedede; height:50px;">지각 : 0일</td> -->
<!-- 								</tr> -->
<!-- 								<tr> -->
<!-- 									<td style="font-size:15px; text-align:center; border:1px solid #dedede; height:50px;">지각 : 0일</td> -->
<!-- 								</tr> -->
<!-- 								<tr> -->
<!-- 									<td style="font-size:15px; text-align:center; border:1px solid #dedede; height:50px;">지각 : 0일</td> -->
<!-- 								</tr> -->
<!-- 								<tr> -->
<!-- 									<td style="font-size:15px; text-align:center; border:1px solid #dedede; height:50px;">지각 : 0일</td> -->
<!-- 								</tr> -->
<!-- 								<tr> -->
<!-- 									<td style="font-size:15px; text-align:center; border:1px solid #dedede; height:50px;">지각 : 0일</td> -->
<!-- 								</tr> -->
<!-- 								<tr> -->
<!-- 									<td style="font-size:15px; text-align:center; border:1px solid #dedede; height:50px;">지각 : 0일</td> -->
<!-- 								</tr> -->
<!-- 								<tr> -->
<!-- 									<td style="font-size:15px; text-align:center; border:1px solid #dedede; height:50px;">지각 : 0일</td> -->
<!-- 								</tr> -->
<!-- 								<tr> -->
<!-- 									<td style="font-size:15px; text-align:center; border:1px solid #dedede; height:50px;">지각 : 0일</td> -->
<!-- 								</tr> -->
<!-- 							</tbody> -->
<!-- 						</table> -->
<!-- 					</div> -->
<!-- 				</td> -->
			</tr>
		</table>
		
		<!-- 
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		 -->
	</body>
	<script>
		CalendarView("Calendar");
	</script>
</html>