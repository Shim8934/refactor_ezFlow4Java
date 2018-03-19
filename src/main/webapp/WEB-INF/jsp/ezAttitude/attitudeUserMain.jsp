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
		
			window.onload = function() {
				getAttiTypeList();	
			}
			
			/**
			* 근태유형 메소드
			*/
			function getAttiTypeList() {
				$.ajax({
					type : "POST",
					dataType : "json",
					async : true,
					url : "/ezAttitude/attitudeTypeList.do",
					data : {},
					success : function(result) {
						getAttiTypeList_After(result);
					}
				})
			}
			
			//font-size:15px; text-align:center; border:1px solid #dedede; height:50px;
			function getAttiTypeList_After(result) {
					var objTable = $("<table></table>").css({"cellpadding":"0", "cellspacing":"0", "border":"0", "width":"100%"});
					var objTbody = $("<tbody></tbody>");
					var objTr = "";
					var objTd = "";
					var calendarHeight = $("#attiCalendar").css("height");
					var tdHeight = parseInt(calendarHeight.substr(0, calendarHeight.length - 2)/(result.length + 1));
					
					objTbody.prepend($("<tr></tr>").append($("<th></th>").attr("colspan","2").css({"height":tdHeight}).text($("#calTitle").text())));
					for (var i = 0; i < result.length; i++) {
						objTr = $("<tr></tr>");
						objTd = $("<td></td>").css({"font-size":"15px", "text-align":"center", "border":"1px solid #dedede", "height": tdHeight + "px"}).attr("typeid",result[i].typeId);
						objTd.text(result[i].typeName + " : 0일");
						
						objTr.append(objTd);
						objTbody.append(objTr);
					}
					
					objTable.append(objTbody);
					$("#attiStatis").append(objTable);
					
					if (calendarHeight != $("#attiStatis").css("Height")) {
						var statisHeight = $("#attiStatis").css("Height");
						tdHeight = tdHeight + (calendarHeight.substr(0, calendarHeight.length - 2) - statisHeight.substr(0, statisHeight.length - 2));
						$("#attiStatis tr:eq(0) th").css("height", tdHeight + "px");
					}
					
			}
			
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
				<td style="vertical-align:top; width:92%;">
					<div style="vertical-align:top;" id="attiCalendar"></div>
				</td>
				<td style="vertical-align:top; width:10px;">&nbsp;</td>
				<td style="vertical-align:top; width:8%; margin-left:5px;">
					<div style="vertical-align:top;" id="attiStatis">
					</div>
				</td>
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
		CalendarView("attiCalendar");
	</script>
</html>