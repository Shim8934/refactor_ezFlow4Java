<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/ezPMS/pms.css')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/jstree.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>

<!-- time picker-->
<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
<title><spring:message code='ezPMS.t290' /></title>
<script type="text/javascript">
var memberList = '${memberList}';
var memberScheduleList = JSON.parse('${memberScheduleList}');
var planStartDate = '${planStartDate}';
var planEndDate = '${planEndDate}';
var dateList = JSON.parse('${dateList}');

$(function() {
	getDatePicker();
	setMemberScheduleList();
});

function setMemberScheduleList() {
	var dayOfWeeks = "<spring:message code='ezPMS.t244'/>".split(";");
	var filteredDateList = [];
	var sDate = $("#Sdatepicker").val() != "" ? $("#Sdatepicker").val() : planStartDate;
	var eDate = $("#Edatepicker").val() != "" ? $("#Edatepicker").val() : planEndDate;
	
	var sDateParsed = Date.parse(sDate);
	var eDateParsed = Date.parse(eDate);
	
	if (sDateParsed > eDateParsed) {
		alert("<spring:message code='ezPMS.t49'/>");
		return;
	}
	
	$("#dateListHeader1").empty();
	$("#dateListHeader2").empty();
	$(".dateList").empty();
	$("#memberCNT").empty();
	
	
	// 사용자가 설정한 기간으로 dateList를 필터링
	var dateListCount = dateList.length;
	
	for (var i = 0; i < dateListCount; i++) {
		
		if(Date.parse(dateList[i].date) >= sDateParsed && Date.parse(dateList[i].date) <= eDateParsed) {
			filteredDateList.push(dateList[i]);
		}
	}
	
	if (filteredDateList.length == 0) {
		return;
	}
	
	$("#calendar").css("width", filteredDateList.length * 26 + 1);
	
	var tmp = filteredDateList[0].date.substring(0, 7);
	var monthCount = 0;
	var filteredDateListCount = filteredDateList.length;
	
	for (var i = 0; i < filteredDateListCount; i++) {
		var yearMonth  = filteredDateList[i].date.substring(0, 7);
		var dayOfMonth = filteredDateList[i].date.charAt(8) == '0' ? filteredDateList[i].date.substring(9) : filteredDateList[i].date.substring(8);
		
		if(yearMonth == tmp) {
			monthCount++;
		} else {
			var month = tmp.charAt(5) == '0' ? tmp.substring(6) : tmp.substring(5);
			var year  = tmp.substring(0, 4);
			
			if(monthCount == 1) {
				$("#dateListHeader1").append('<th colspan=' + monthCount + '>' + '<spring:message code="ezPMS.t341" arguments="' + month + '"/></th>');
			} else {
				$("#dateListHeader1").append('<th colspan=' + monthCount + '>' + '<spring:message code="ezPMS.t341" arguments="' + month + '"/> ' + year + '</th>');
			}
			
			monthCount = 1;
		}
		
		if (filteredDateList[i].holidayOrNot == true) {
			$("#dateListHeader2").append('<th class="holyday" date="' + filteredDateList[i].date + '">' + dayOfMonth + '</th>');
			$(".dateList").append('<td class="holyday" date="' + filteredDateList[i].date + '">&nbsp;</td>');
		} else {
			$("#dateListHeader2").append('<th date="' + filteredDateList[i].date + '" >' + dayOfMonth + '</th>');
			$(".dateList").append('<td date="' + filteredDateList[i].date + '">&nbsp;</td>');
		}
		
		tmp = yearMonth;
	}
	
	var month = tmp.charAt(5) == '0' ? tmp.substring(6) : tmp.substring(5);
	var year  = tmp.substring(0, 4);
	
	if (monthCount == 1) {
		$("#dateListHeader1").append('<th colspan=' + monthCount + '>' + '<spring:message code="ezPMS.t341" arguments="' + month + '"/></th>');
	} else {
		$("#dateListHeader1").append('<th colspan=' + monthCount + '>' + '<spring:message code="ezPMS.t341" arguments="' + month + '"/> ' + year + '</th>');
	}
	
	// 멤버 스케쥴을 테이블에 반영
	setMemberSchedule();
		
	// 일자별 업무 할당 인원 수 반영
	for(var i = 0; i < filteredDateListCount; i++) {
		var memberCNT = $(".dateList").find("td[date='" + filteredDateList[i].date + "']").find(".circle").length;
		memberCNT = memberCNT == 0 ? "" : memberCNT;
		
		if(filteredDateList[i].holidayOrNot == true) {
			$("#memberCNT").append('<td style="text-align:center; background-color: #FFFAF2;">' + memberCNT + '</td>');
		} else {
			$("#memberCNT").append('<td style="text-align:center;">' + memberCNT + '</td>');
		}
	}
}

function setMemberSchedule() {
	var memberScheduleListCount = memberScheduleList.length;
	
	for (var i = 0; i < memberScheduleListCount; i++) {
		var memberId = memberScheduleList[i].userId;
		var assignedDate = memberScheduleList[i].assignedDate;
		$("tr[userId='" + memberId + "']").find("td[date='" + assignedDate + "']").html("<div class='circle' onclick='getTaskNameList(this)'></div>");	
	}
}

function getTaskNameList(elem) {
	var clickedDate = $(elem).parent().attr("date");
	var clickedUser = $(elem).parent().parent().attr("userId");
	var projectId = "<c:out value='${projectId}'/>";
	
	$.ajax({
		type : "post",
		url : "/ezPMS/getDateTaskList.do",
		data : {
			"projectId" : projectId, 
			"selectedDate" : clickedDate, 
			"selectedUserId" : clickedUser
		},
		success : function(result) {
			if (result.length != 0) {
				var infoHTML = "<div class='tooltipTitle'>" + clickedDate + " <spring:message code='ezPMS.t137' /></div>";
				infoHTML += "<div class='tooltipText'>";
				var resultCount = result.length;
				
				for (var i = 0; i < resultCount; i++) {
					infoHTML += "&gt; " + revertString(result[i]) + "<br>";
				}
				
				infoHTML += "</div>";
				
				$(".tooltipBox").html(infoHTML);
			    $('.tooltipBox').show();
			} 
		},
		error : function(request, status, error) {
		}
	});
	
}

function getDatePicker() {
	$("#Sdatepicker").datepicker({
		changeMonth: true,
		changeYear: true,
		autoSize: true,
		showOn: "both",
		buttonImage: "/images/ImgIcon/calendar-month.gif",
		buttonImageOnly: true,
		beforeShow: function (input) {
			var i_offset = $(input).offset();
			setTimeout(function () {
				//$('#ui-datepicker-div').css({ 'top': i_offset.top, 'bottom': '', 'top': '0px' });
			})
		}
	});

	$("#Edatepicker").datepicker({
		changeMonth: true,
		changeYear: true,
		autoSize: true,
		showOn: "both",
		buttonImage: "/images/ImgIcon/calendar-month.gif",
		buttonImageOnly: true,
		beforeShow: function (input) {
			var i_offset = $(input).offset();
			setTimeout(function () {
				//$('#ui-datepicker-div').css({ 'top': i_offset.top, 'bottom': '', 'top': '0px' });
			})
		}
	});
	
	var SDate = new Date();
	var EDate = new Date();

	$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	$("#Sdatepicker").datepicker('setDate', "");
	
	$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	$("#Edatepicker").datepicker('setDate', "");
	
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
}

window.onload = function() {
	//툴팁 위치 지정
	var positionTooltip = function(event) {
		var tPosX = event.pageX - 5;
		var tPosY = event.pageY + 15;
		$(".tooltipBox").css({top:tPosY, left : tPosX});
	};
	
	$(document).on("click", ".circle", function(event) {
		//마우스 오버했을 때 툴팁위치 위치 지정해줌
		positionTooltip(event);
	});
	
	$("html").click(function(event) {
		if (!$(event.target).hasClass("circle")) {
			$(".tooltipBox").hide();
		}
	});
}
</script>
<style type="text/css">
.circle {
	width : 17px;
	height : 17px;
	border : 1px solid #d1d1d1;
	display : inline-block;
	margin-top : 1px;
	border-radius : 50%;
	background-color : #d1d1d1;
	cursor : pointer;
}
#memberTable {
	margin-left : 15px;
	margin-top : 15px;
	display : inline-block;
	width : 98%;
	overflow : auto;
	float : left;
}

#calendar {
	max-width : 84%;
	display : inline-block;
	height : 100%;
	overflow-x : scroll;
	overflow: auto;
}

#mainmenu {
	margin : 13px;;
}

#memberList {
	width : 16%;
	float : left;
	overflow-x : hidden;
}

.tooltipBox {
	position:absolute;
	width:200px;
	border:1px solid #4e4e46;
}
		  
.tooltipBox .tooltipTitle { 
	height: 33px; 
	line-height: 33px; 
	padding: 0px 10px; 
	background: #f0f6ff; 
	border: 1px solid #d1ddec; 
	font-size:14px; 
	white-space: nowrap; 
	text-overflow: ellipsis; 
	overflow: hidden; 
}

.tooltipBox .tooltipText {
	padding:10px; 
	background:#fff; 
	font-size:12px; 
	line-height:22px;
}

#dateListHeader2 .holyday{background-color: rgba(236, 195, 176, 0.40);}
#dateListHeader2{text-align:center; height: 20px; padding: 2px 2px; }
#dateListHeader2 th{height: 20px; min-width:25px; padding: 2px 0px;}
#dateListHeader1{padding: 2px 4px; height: 20px;}
#dateListHeader1 th{padding: 2px 0px; height: 20px;}
.dateList td.holyday{text-align:center; background-color: #FFFAF2;}
.dateList td, #dateListHeader1 th, #dateListHeader2 th{text-align:center;}
</style>
</head>
<body class="popup">
	<h1><spring:message code='ezPMS.t290' />
		<div id="close" style="float:right">
		<ul>
			<li>
				<span id="cancel" onclick="parent.DivMemberSchedulePopUpHidden()"></span>
			</li>
		</ul>
		</div>
	</h1>
<div style="text-align: center;">
	<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"> ~ <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
	<a class="imgbtn" onclick="emptyDate(this)" style="margin-left:3px;"><span><spring:message code='ezPMS.t124' /></span></a>
	<a class="imgbtn" onclick="setMemberScheduleList()" style="margin-left:3px;"><span><spring:message code='ezPMS.t1' /></span></a>
</div>
<div id="memberTable">
<div>
	<div>
	<table id="memberList" class="content">
	<tr style="height: 50px;">
		<th><spring:message code='ezPMS.t137' /> <spring:message code='ezPMS.t63' /></th>
		<th><spring:message code='ezPMS.t115' /></th>
	</tr>
	<c:forEach items="${memberList }" var="member">
	<tr id="${member.userId }">
		<td style="width:50%"><c:out value="${member.userName }"/></td>
		<td><c:out value="${member.userDeptname }"/></td>
	</tr>
	</c:forEach>
	<tr>
		<td colspan="2"><spring:message code='ezPMS.t336'/></td>
	</tr>
	</table>
	</div>
	<div id="calendar">
	<table id="workSchedule" class="content">
	<tr id="dateListHeader1"></tr>
	<tr id="dateListHeader2">
	<%-- <c:forEach items="${dateList }" var="dateVO">
		<c:choose>
			<c:when test="${dateVO.holidayOrNot eq true}">
				<th style="background-color: rgba(236, 195, 176, 0.40);">${dateVO.date}</th>
			</c:when>
			<c:otherwise>
				<th>${dateVO.date}</th>
			</c:otherwise>
		</c:choose>
	</c:forEach> --%>
	</tr>
	<c:forEach items="${memberList}" var="member">
	<tr userId="${member.userId }" class="dateList">
	<%-- <c:forEach items="${dateList}" var="dateVO">
		<c:choose>
			<c:when test="${dateVO.holidayOrNot eq true}">
				<td date="${dateVO.date}" style="text-align:center; background-color: #FFFAF2;">&nbsp;</td>
			</c:when>
			<c:otherwise>
				<td date="${dateVO.date}" style="text-align:center">&nbsp;</td>
			</c:otherwise>
		</c:choose>
		
	</c:forEach> --%>
	</tr>
	</c:forEach>
	<tr id='memberCNT'></tr>
	</table>
	</div>
</div>
</div>
<div class="tooltipBox" style="display : none;"></div>
</body>
</html>