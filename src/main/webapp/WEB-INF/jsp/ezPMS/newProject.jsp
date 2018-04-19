<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/dist/jstree.js"></script>
<!-- date picker -->
<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>

<style type="text/css">
.textInput {
	width : 100%;
}
</style>
<script>
var projectName = null;
var writerName = "${userName}";
var weightInput = null;
var planStartDate = "${planStartDate}";
var planEndDate = "${planEndDate}";
var managerList = [];
var participantList = [];
var viewerList = [];
var overview = null;
var endAlamStatus = null;

 $(function() {
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
		
		var SDate = new Date(planStartDate);
		var EDate = new Date(planEndDate);

		$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		$("#Sdatepicker").datepicker('setDate', SDate);
		
		$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		$("#Edatepicker").datepicker('setDate', EDate);
		
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
 
	$("#daysBeforeAlam").change(function() {
		var state = $("#daysBeforeAlam option:selected").val();
		if(state == "write") {
			$("#daysBeforeAlam").css("display", "none");
			$("#write").css("display", "");
		}
	});
 });
 
 function openOrganTree() {
	 var url = "/ezPMS/pmsSelectAuth.do";
	 //	url += "?companyId=" + companyId;
	 GetOpenWindow(url, "pmsSelectAuth", 980, 610);
 }
 
 function addNewProject() {
	 projectName = $("#projectName").val();
	 weightInput = $(":input:radio[name=weightInput]:checked").val();
	 planStartDate = $("#Sdatepicker").val();
	 planEndDate = $("#Edatepicker").val();
	 managerList = $("#managers").text();
	 participantList = $("#participants").text();
	 viewerList = $("#viewers").text();
	 overview = $("#overview").val();
	 
	 if ($("#endAlam").prop("checked") == false) {
		 endAlamStatus = -1;
	 } else {
		 if ($("#daysBeforeAlam option:selected").text() == "직접입력") {
			 endAlamStatus = $("#write").val();
		 } else {
			 endAlamStatus = $("#daysBeforeAlam option:selected").text(); 
		 }
	 }
	 
	 console.log(projectName);
	 console.log(writerName);
	 console.log(weightInput);
	 console.log(planStartDate);
	 console.log(planEndDate);
	 console.log(managerList);
	 console.log(participantList);
	 console.log(viewerList);
	 console.log(overview);
	 console.log(endAlamStatus);
 }

 function popupClose() {
	parent.DivPopUpHidden();
 }
</script>
</head>
<body class="popup">
	<h1>New Project</h1>
	<div id="main_body">
		<table class="content" style="width:100%;">
			<tr>
				<th>프로젝트명</th>
				<td colspan="3">
					<input type="text" id="projectName" class="textInput">
				</td>
			</tr>
			<tr>
				<th>등록자</th>
				<td style="width:45%">${userName }</td>
				<th>가중치 설정</th>
				<td><form><input type="radio" name="weightInput" value="autoCalc" style="vertical-align:left" checked>자동 계산  <input type="radio" name="weightInput" value="writeCalc">직접입력</form></td>
			</tr>
			<tr>
				<th>시작일</th>
				<td style="width:45%"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"></td>
				<th>종료일</th>
				<td><input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"></td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openOrganTree()"><span>담당자</span></a></th>
				<td colspan="3" style="height:70px" id="managers">은정</td>
			<tr>
				<th><a class="imgbtn" onclick="openOrganTree()"><span>참여자</span></a></th>
				<td colspan="3" style="height:70px" id="participants">은정</td>
			<tr>
				<th><a class="imgbtn" onclick="openOrganTree()"><span>조회자</span></a></th>
				<td colspan="3" style="height:70px" id="viewers">은정</td>
			<tr>
				<th>개요</th>
				<td colspan="3"><textarea id="overview" style="height:100px; width:98.5%; margin-top:2px; resize:none;"></textarea></td>
			</tr>
			
			<tr>
				<th>종료알림</th>
				<td style="width:45%"><input type="checkbox" name="endAlam" value="endAlam" id="endAlam" checked>프로젝트 작업 종료 알림메일 발송</td>
				<th>알림일</th>
				<td><select name="daysBeforeAlam" id="daysBeforeAlam">
						<option value="1" selected>1</option>
						<option value="3">3</option>
						<option value="5">5</option>
						<option value="10">10</option>
						<option value="write">직접입력</option>
					</select><input type="text" id="write" style="display:none;"> 일 전
				</td>
			</tr>
		</table>
		<table style="margin-top : 10px; margin-left:auto; margin-right:auto; border-spacing:10px 0; border-collapse: separate;">
			<tr>
				<td><a class="imgbtn" id="submit" onclick="addNewProject()"><span>등록</span></a></td>
				<td></td>
				<td><a class="imgbtn" id="cancel" onclick="popupClose()"><span>취소</span></a></td>
			</tr>
		</table>
	</div>
</body>
</html>