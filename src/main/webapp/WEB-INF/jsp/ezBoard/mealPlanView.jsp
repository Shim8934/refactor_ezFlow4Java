<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<title><spring:message code='ezMealPlan.jsb001' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
		<style type="text/css">
			.date {
				width:18%;
			}
			td {
				border: 1px solid #d2d2d2;
				padding :0 10px;
				word-wrap: break-word;
    			white-space: normal;
			}
		</style>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}"/>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/monthpicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}"/>
		<script type="text/javascript">
			
		$(function() {
			var selectDate = "<c:out value='${selectDate}'/>";
			
			$.datepicker.regional["<spring:message code='main.t0619' />"] = {
	            closeText: "<spring:message code='main.t3' />",
	            prevText: "<spring:message code='main.t0604' />",
	            nextText: "<spring:message code='main.t0605' />",
	            currentText: "<spring:message code='main.t0606' />",
	            monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
	                         "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
	                         "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
	                         "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
	            monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
	                              "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
	                              "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
	                              "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
	            dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
	                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
	                       "<spring:message code='main.t0627' />"],
	            dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
			                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
			                       "<spring:message code='main.t0627' />"],
	            dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
		                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
		                       "<spring:message code='main.t0627' />"],
	            weekHeader: "Wk",
	            dateFormat: "yy-mm-dd",
	            firstDay: 0,
	            isRTL: false,
	            duration: 200,
	            showAnim: "show",
	            showMonthAfterYear: true
	        };
			
			$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
			
			var today = new Date();
			var sDateStr = formatDate(new Date(today.getFullYear(), today.getMonth(), (today.getDate() - today.getDay() + 1)));
			var eDateStr = formatDate(new Date(today.getFullYear(), today.getMonth(), (today.getDate() - today.getDay() + 5)));
			
			document.getElementById("viewSchedule").innerText = sDateStr + "~" + eDateStr;
			
			$('#weekPicker').datepicker({
				showOtherMonths: true,
				selectOtherMonths: true,
				selectWeek: true,
				buttonImage: "/images/ImgIcon/calendar-month.png",
				buttonImageOnly: true,
				showOn: "both",
				onSelect: function(dateText, inst) {
					setTimeout("applyWeeklyHighlight()", 100);
					$("#weekPicker").trigger('change');
				},
				beforeShow : function() {
					setTimeout("applyWeeklyHighlight()", 100);
				},
				onChangeMonthYear: function(year, month, inst) {
			        setTimeout("applyWeeklyHighlight()", 100);
				}
			});
			
			// 작성 화면에서 돌아온 경우 해당 일자로 보일 수 있도록 처리
			if (selectDate) {
				$('#weekPicker').datepicker('setDate', selectDate);
			} else {
				$('#weekPicker').datepicker('setDate', 'today');
			}
			
			$("#weekPicker").trigger('change');
			
		});
		
		function applyWeeklyHighlight() {
			$('.ui-datepicker-calendar tr').each(function() {
				
				if ($(this).parent().get(0).tagName == 'TBODY') {
					
					$(this).mouseover(function() {
						$(this).find('a').css({
							'background': '#1e90ff',
							'border' : '1px solid #dddddd'
						});
						$(this).css('background', '#1e90ff');
					});
					
					$(this).mouseout(function() {
						$(this).css('background', '#ffffff');
						$(this).find('a').css('background', '');
					});
				}
			});
		}
		
		function setMealTable() {
			var pickedDate = $('#weekPicker').datepicker('getDate');
			var startDate = new Date(pickedDate.getFullYear(), pickedDate.getMonth(), pickedDate.getDate() - pickedDate.getDay() + 1);
			var endDate = new Date(pickedDate.getFullYear(), pickedDate.getMonth(), pickedDate.getDate() - pickedDate.getDay() + 5);
			
			document.getElementById("viewSchedule").innerText = formatDate(startDate) + "~" + formatDate(endDate);
			
			var mealDataList;
			
			$.ajax({
				type : "POST",
				dataType : "json",
				async : false,
				url : "/ezBoard/getMealPlanList.do",	//	게시판 리스트설정셋팅 실행
				data : { startDate : formatDate(startDate)},
				success: function(res, status, xhr) {
					mealDataList = res.mealDataList;
					
				},
				error: function(xhr, status, error) {
					console.log(error);
				}
			});
			if (typeof(mealDataList) == 'undefined') {
				alert("<spring:message code='ezMealPlan.nbh001' />");
				return;
			}
			var mealTable = document.getElementById("mealCal");
			
			// 월요일부터 하루씩 해당하는 일자가 있는지 비교하고, 해당 일자가 없으면 반복문을 빠져나가고 데이터가 있으면 테이블을 채우는 반복문 실행
			// 월 ~ 금 5일 고정 
			for (var a = 0; a < 5; a++) {
				
				if (mealDataList[a] && (formatDate(startDate) == mealDataList[a].mealDate)) {
					mealTable.getElementsByTagName('tr')[0].getElementsByTagName('th')[a + 1].innerText = mealDataList[a].mealDate;
					mealTable.getElementsByTagName('tr')[1].getElementsByTagName('td')[a].innerText = mealDataList[a].aCourse;
					mealTable.getElementsByTagName('tr')[2].getElementsByTagName('td')[a].innerText = mealDataList[a].bCourse;
					mealTable.getElementsByTagName('tr')[3].getElementsByTagName('td')[a].innerText = mealDataList[a].saladBar;
					mealTable.getElementsByTagName('tr')[4].getElementsByTagName('td')[a].innerText = mealDataList[a].dessert;
					mealTable.getElementsByTagName('tr')[5].getElementsByTagName('td')[a].innerText = mealDataList[a].totalCal == 0 ? "" : mealDataList[a].totalCal;
				} else {
					mealTable.getElementsByTagName('tr')[0].getElementsByTagName('th')[a + 1].innerText = formatDate(startDate);
					mealTable.getElementsByTagName('tr')[1].getElementsByTagName('td')[a].innerText = "";
					mealTable.getElementsByTagName('tr')[2].getElementsByTagName('td')[a].innerText = "";
					mealTable.getElementsByTagName('tr')[3].getElementsByTagName('td')[a].innerText = "";
					mealTable.getElementsByTagName('tr')[4].getElementsByTagName('td')[a].innerText = "";
					mealTable.getElementsByTagName('tr')[5].getElementsByTagName('td')[a].innerText = "";
				}
				
				startDate.setDate(startDate.getDate() + 1);
			}
			
			
		}
		
		function formatDate(date) {
			return date.getFullYear() + "-" + (date.getMonth() + 1).toString().padStart(2, '0') + "-" + date.getDate().toString().padStart(2,'0');
		}
		
		function preWeek() {
			var currDate = $("#weekPicker").datepicker('getDate');
			
			if (currDate) {
				currDate.setDate(currDate.getDate() - 7);
				$("#weekPicker").datepicker('setDate', currDate);
				$("#weekPicker").trigger('change');
			}
		}
		
		function nextWeek() {
			var currDate = $("#weekPicker").datepicker('getDate');
			
			if (currDate) {
				currDate.setDate(currDate.getDate() + 7);
				$("#weekPicker").datepicker('setDate', currDate);
				$("#weekPicker").trigger('change');
			}
		}
		
		function editMealPlan() {
			var pickedDate = $('#weekPicker').datepicker('getDate');
			var startDate = new Date(pickedDate.getFullYear(), pickedDate.getMonth(), pickedDate.getDate() - pickedDate.getDay() + 1);
			document.getElementById("startDate").value = startDate;
			document.getElementById("selectDate").value = document.getElementById("weekPicker").value;
			document.getElementById("goWrite").submit();
		}
		
		</script>
	</head>
	<body class="mainbody meal" style="height:calc(100% - 15px);">
		<h1>
			<spring:message code='ezMealPlan.jsb001' />
		</h1>
		<div class="calendar_pagenav">
			<c:if test="${isAdmin eq 'true'}">
				<ul class="meal_btn">
					<li>
						<span onclick="editMealPlan()"><spring:message code='ezMealPlan.jsb011' /></span>
					</li>
				</ul>
			</c:if>
	        <ul class="contentlayout">
	            <li class="contentlayout_left" id="preM"><span class="icon16 calendarleft" onclick="preWeek()"></span></li>
	            <li class="contentlayout_right" id="preN"><span class="icon16 calendarright" onclick="nextWeek()"></span></li>
	            <li class="contentlayout_none">
	            	<span class="meal_plan_date">
	            		<span class="spanText" id="viewSchedule"></span>
	            		<input type="hidden" id="weekPicker" onchange="setMealTable()">
	            	</span>
	            </li>
	        </ul>
	    </div>
	    <table id="mealCal" style="width:100%; height:80%; margin-top:50px;">
			<tr style="height:6%">
				<th><spring:message code='ezMealPlan.jsb008' /></th>
				<th id="day1" class="date"></th>
				<th id="day2" class="date"></th>
				<th id="day3" class="date"></th>
				<th id="day4" class="date"></th>
				<th id="day5" class="date"></th>
			</tr>
			<tr style="height:34%">
				<th>
					<spring:message code='ezMealPlan.jsb002' />
				</th>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr style="height:34%">
				<th>
					<spring:message code='ezMealPlan.jsb003' />
				</th>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr style="height:12%">
				<th>
					<spring:message code='ezMealPlan.jsb004' />
				</th>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr style="height:8%">
				<th>
					<spring:message code='ezMealPlan.jsb005' />
				</th>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr style="height:6%">
				<th>
					<spring:message code='ezMealPlan.jsb006' />
				</th>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
	    </table>
		<c:if test="${isAdmin eq 'true'}">
        	<form  id="goWrite" action="/ezBoard/mealPlanWrite.do" method="post">
        		<input type="hidden" name="startDate" id="startDate">
        		<input type="hidden" name="selectDate" id="selectDate">
        	</form>
		</c:if>
</body>
</html>