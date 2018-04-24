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
var projectId = "${projectId}";
var projectName = null;
var writerId = "${writerId}";
var writerName = "${writerName}";
var writerDeptName = "${writerDeptName}";
var weightInput = null;
var planStartDate = "${planStartDate}";
var planEndDate = "${planEndDate}";
var managerList = null;
var overview = null;
var headManagerId = null;
var groupId = "";
var groupName = "";

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
 
function openMemberList() {
		 var win;
		 var feature = GetOpenPosition(760, 700);
		 DivPopUpShow($('body').prop('scrollWidth') * 0.9, $('body').prop('scrollHeight') * 0.8, "/ezPMS/goProjectMemberList.do?projectId=" + projectId, "",
				 "height = 700px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
}

function openGroupTree() {
		var win;
	 	var feature = GetOpenPosition(760, 700);
	 	DivPopUpShow($('body').prop('scrollWidth') * 0.4, $('body').prop('scrollHeight') * 0.7, "/ezPMS/goGroupTree.do?projectId=" + projectId, "",
			 	"height = 700px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
}
 
 function addTask() {
	 taskName = $("#taskName").val();
	 planStartDate = $("#Sdatepicker").val();
	 planEndDate = $("#Edatepicker").val();
	 managerList = $("#managers").text();
	 upperGroup = $("#upperGroup").text();
	 viewerList = $("#viewers").text();
	 overview = $("#overview").val();
	 
 }

 function popupClose() {
	parent.DivPopUpHidden();
 }
 
 function applyList() {
	 var managerNameList = "";
	 
	 for (var i = 0; i < managerList.length; i++) {
		if(headManagerId == managerList[i].userId) {
			managerNameList += "<b>"
			managerNameList += managerList[i].userName;
			managerNameList += "(" + managerList[i].userDept + ")</b>, ";
		} else {
			managerNameList += managerList[i].userName;
			managerNameList += "(" + managerList[i].userDept + "), ";
		}
		
	 }
	 
	 managerNameList = managerNameList.substr(0, managerNameList.length - 2);
	 
	 $("#managers").html(managerNameList);
 }
 
function setUpperGroup() {
	$("#upperGroup").html(groupName);
}

</script>
</head>
<body class="popup">
	<h1>새 업무 추가</h1>
	<div id="main_body">
		<table class="content" style="width:100%;">
			<tr>
				<th>업무명</th>
				<td colspan="3">
					<input type="text" id="taskName" class="textInput">
				</td>
			</tr>
			<tr>
				<th>등록자</th>
				<td colspan="3">${writerName}(${writerDeptName})</td>
			</tr>
			<tr>
				<th>계획시작일</th>
				<td style="width:50%"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"></td>
				<th>계획종료일</th>
				<td><input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"></td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openMemberList()"><span>담당자</span></a></th>
				<td colspan="3" style="height:70px" id="managers">은정</td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openGroupTree()"><span>상위그룹</span></a></th>
				<td colspan="3" style="height:70px;" id="upperGroup"></td>
			</tr>
			<tr>
				<th>가중치</th>
				<td colspan="3" >
				<input type="text" id="weight" style="width:40px;text-align:center"> % 잔여 가중치 100%
				</td>
			</tr>
			<tr>
				<th>업무개요</th>
				<td colspan="3"><textarea id="overview" style="height:100px; width:98.5%; margin-top:2px; resize:none;"></textarea></td>
			</tr>
		</table>
		<table style="margin-top : 10px; margin-left:auto; margin-right:auto; border-spacing:10px 0; border-collapse: separate;">
			<tr>
				<td><a class="imgbtn" id="submit" onclick="addTask()"><span>등록</span></a></td>
				<td></td>
				<td><a class="imgbtn" id="cancel" onclick="popupClose()"><span>취소</span></a></td>
			</tr>
		</table>
	</div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>