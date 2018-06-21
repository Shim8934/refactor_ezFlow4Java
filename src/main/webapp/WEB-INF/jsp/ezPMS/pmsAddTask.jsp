<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t89' /></title>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/dist/jstree.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>
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
var weight = null;
var projectStartDate = "${projectStartDate}";
var projectEndDate = "${projectEndDate}";
var planStartDate = "${planStartDate}";
var planEndDate = "${planEndDate}";
var managerList = null;
var overview = null;
var headManagerId = null;
var groupId = "";
var groupName = "";
var remainingWeight = "${remainingWeight}";
var weightInput = "${weightInput}";
var treeDepth = 0;

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
			},
			beforeShowDay : function (date) {
				var day = date.getDay();
				return [(day != 0 && day != 6)];
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
			},
			beforeShowDay : function (date) {
				var day = date.getDay();
				return [(day != 0 && day != 6)];
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

 function popupClose() {
	parent.DivPopUpHidden();
 }
 
 function applyList() {
	 var managerNameList = "";
	 
	 for (var i = 0; i < managerList.length; i++) {
		if(headManagerId == managerList[i].userId) {
			managerNameList += "<b>"
			managerNameList += managerList[i].userName;
			managerNameList += "(" + managerList[i].userDeptname + ")</b>, ";
		} else {
			managerNameList += managerList[i].userName;
			managerNameList += "(" + managerList[i].userDeptname + "), ";
		}
		
	 }
	 
	 managerNameList = managerNameList.substr(0, managerNameList.length - 2);
	 
	 $("#managers").html(managerNameList);
 }
 
function setUpperGroup() {
	$("#upperGroup").html(groupName);
}

function addTask() {
	 taskName = $("#taskName").val().trim();
	 planStartDate = $("#Sdatepicker").val();
	 planEndDate = $("#Edatepicker").val();
	 weight = $("#weight").val();
	 overview = convertString($("#overview").val().trim());
	 
	 //업무 이름 길이 제한
	 if (taskName.length == 0) {
		 alert("<spring:message code='ezPMS.t90' />");
		 return;
	 } else if (taskName.length > 100) {
		 alert("<spring:message code='ezPMS.t91' />");
		 return;
	 }
	 
	 //날짜 제한
	 var startDateArr = planStartDate.split('-');
	 var endDateArr = planEndDate.split('-');
	 
	 var startDateComp = new Date(planStartDate);
	 var endDateComp = new Date(planEndDate);
	 
	 var today = new Date();
	 var todayComp = new Date(today.getFullYear(), today.getMonth()-1, today.getDay());
	 
	 var projectStartDateComp = new Date(projectStartDate);
	 var projectEndDateComp = new Date(projectEndDate);
	 
	//1. 시작일 > 종료일은 불가능
	 if (startDateComp.getTime() > endDateComp.getTime()) {
		  alert("<spring:message code='ezPMS.t49' />");
		  return;
	  }
	  
	//2. 종료일 < 현재일일 떄, 지연업무로 넘어갈 것이라는 confirm창 띄우기
	 if (endDateComp.getTime() < todayComp.getTime()) {
		 var confCheck = confirm("<spring:message code='ezPMS.t93' />");
		 
		 if (confCheck != true) {
			 return;
		 }
	 }
	
	//3. 업무의 계획 시작일과 계획 종료일은 프로젝트 시작일과 종료일범위를 벗어날수 없음
	if (startDateComp.getTime() < projectStartDateComp.getTime()) {
		alert(startDateComp.getTime() + " <<<<>>>> " + projectStartDateComp.getTime());
		alert("<spring:message code='ezPMS.t94' />");
		return;
	}
	if (endDateComp.getTime() > projectEndDateComp.getTime()) {
		alert("<spring:message code='ezPMS.t95' />");
		return;
	}
	
	// 담당자 검사
	if(managerList == null) {
		// 현재 총괄담당자 null 허용 불가
		alert("<spring:message code='ezPMS.t47' />");
		return;
	}
	
	//상위그룹 미지정
	if(groupId == "") {
		alert("<spring:message code='ezPMS.t85' />");
		return;
	}
	
	// 가중치 검사
	if(weightInput == 1) {
		if(weight == ""){
			alert("<spring:message code='ezPMS.t96' />");
			return;
		}
		if(isNaN(weight)) {
			alert("<spring:message code='ezPMS.t248' />");
			return;
		}
		if(Number(weight) > remainingWeight) {
			alert("<spring:message code='ezPMS.t97' />");
			return;
		}
	} else {
		weight = -1;
	}

	
	var data = {
			taskName : taskName,
			projectId : projectId,
			groupId : groupId,
			planStartDate : planStartDate,
			planEndDate : planEndDate,
			overview	 : overview,
			headManagerId : headManagerId,
			managerList : managerList,
			weight : weight,
			writerId : writerId,
			treeDepth : treeDepth
	}
	
	$.ajax({
		type : "POST",
		url : "/ezPMS/addTask.do",
		dataType : "json",
		contentType: "application/json; charset=UTF-8",
		data : JSON.stringify(data),
		success : function(data) {
			alert("<spring:message code='ezPMS.t266' />");
			
			parent.location.reload();
			popupClose();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert("<spring:message code='ezPMS.t224' />");
		}
	});
}

</script>
</head>
<body class="popup">
	<h1><spring:message code='ezPMS.t89' /></h1>
	<div id="main_body">
		<table class="content" style="width:100%;">
			<tr>
				<th><spring:message code='ezPMS.t98' /></th>
				<td colspan="3">
					<input type="text" id="taskName" class="textInput">
				</td>
			</tr>
			<tr>
				<th><spring:message code='ezPMS.t57' /></th>
				<td colspan="3">${writerName}(${writerDeptName})</td>
			</tr>
			<tr>
				<th><spring:message code='ezPMS.t61' /></th>
				<td style="width:50%">
					<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly">
					<span style="margin-left:20px "><spring:message code='ezPMS.t13' /> <spring:message code='ezPMS.t61' /> : ${projectStartDate}</span>
				</td>
				<th><spring:message code='ezPMS.t62' /></th>
				<td>
					<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
					<span style="margin-left:20px "><spring:message code='ezPMS.t13' /> <spring:message code='ezPMS.t62' /> : ${projectEndDate}</span>
				</td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openMemberList()"><span><spring:message code='ezPMS.t63' /></span></a></th>
				<td colspan="3" style="height:70px" id="managers"></td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openGroupTree()"><span><spring:message code='ezPMS.t42' /></span></a></th>
				<td colspan="3" style="height:70px;" id="upperGroup"></td>
			</tr>
			<tr>
				<th><spring:message code='ezPMS.t267' /></th>
				<c:choose>
      				<c:when test="${weightInput == 0}">
						<td colspan="3">
						<spring:message code='ezPMS.t267' /> <spring:message code='ezPMS.t59' />
						</td>
					</c:when>
      				<c:when test="${weightInput == 1}">
						<td colspan="3">
						<input type="text" id="weight" value="0" style="width:40px;text-align:center"> %  &nbsp; <spring:message code='ezPMS.t103' /> ${remainingWeight} % 
						</td>
					</c:when>
   				</c:choose>
			</tr>
			<tr>
				<th><spring:message code='ezPMS.t104' /></th>
				<td colspan="3"><textarea id="overview" style="height:100px; width:98.5%; margin-top:2px; resize:none;"></textarea></td>
			</tr>
		</table>
		<table style="margin-top : 10px; margin-left:auto; margin-right:auto; border-spacing:10px 0; border-collapse: separate;">
			<tr>
				<td><a class="imgbtn" id="submit" onclick="addTask()"><span><spring:message code='ezPMS.t40' /></span></a></td>
				<td></td>
				<td><a class="imgbtn" id="cancel" onclick="popupClose()"><span><spring:message code='ezPMS.t41' /></span></a></td>
			</tr>
		</table>
	</div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>