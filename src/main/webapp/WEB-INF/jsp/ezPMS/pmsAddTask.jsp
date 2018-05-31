<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>새 업무 추가 페이지</title>
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
		 alert("업무명을 입력해주세요.");
		 return;
	 } else if (taskName.length > 100) {
		 alert("업무명은 100자를 초과할 수 없습니다.");
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
		  alert("시작날짜가 종료날짜보다 늦을 수 없습니다.");
		  return;
	  }
	  
	//2. 종료일 < 현재일일 떄, 지연업무로 넘어갈 것이라는 confirm창 띄우기
	 if (endDateComp.getTime() < todayComp.getTime()) {
		 var confCheck = confirm("종료일이 현재일보다 빠르기 때문에 업무의 상태가 지연으로 변경됩니다. 계속하시겠습니까?");
		 
		 if (confCheck != true) {
			 return;
		 }
	 }
	
	//3. 업무의 계획 시작일과 계획 종료일은 프로젝트 시작일과 종료일범위를 벗어날수 없음
	if (startDateComp.getTime() < projectStartDateComp.getTime()) {
		alert(startDateComp.getTime() + " <<<<>>>> " + projectStartDateComp.getTime());
		alert("업무의 계획 시작일은 프로젝트의 시작일보다 이를 수 없습니다.");
		return;
	}
	if (endDateComp.getTime() > projectEndDateComp.getTime()) {
		alert("업무의 계획 종료일은 프로젝트의 종료일보다 늦을 수 없습니다.");
		return;
	}
	
	// 담당자 검사
	if(managerList == null) {
		// 현재 총괄담당자 null 허용 불가
		alert("최소 1명 이상의 담당자를 지정해주세요.");
		return;
	}
	
	//상위그룹 미지정
	if(groupId == "") {
		alert("상위그룹을 지정해주세요.");
		return;
	}
	
	// 가중치 검사
	if(weightInput == 1) {
		if(weight == ""){
			alert("가중치를 입력해 주십시오.");
			return;
		}
		if(isNaN(weight)) {
			alert("가중치는 숫자만 입력 가능합니다.");
			return;
		}
		if(Number(weight) > remainingWeight) {
			alert("가중치는 프로젝트의 잔여가중치를 초과할 수 없습니다.");
			return;
		}
	} else {
		weight = -1;
	}

	
	data = {
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
	
	console.log(taskName);
	console.log(projectId);
	console.log(groupId);
	console.log(planStartDate);
	console.log(planEndDate);
	console.log(overview);
	console.log(headManagerId);
	console.log(managerList);
	console.log(weight);
	console.log(writerId);
	
	$.ajax({
		type : "POST",
		url : "/ezPMS/addTask.do",
		dataType : "json",
		contentType: "application/json; charset=UTF-8",
		data : JSON.stringify(data),
		success : function(data) {
			alert("<spring:message code='ezTask.t150' />");
			
			parent.location.reload();
			popupClose();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert("error2");
		}
	});
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
				<td style="width:50%">
					<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly">
					<span style="margin-left:20px ">현재 시작일 : ${projectStartDate}</span>
				</td>
				<th>계획종료일</th>
				<td>
					<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
					<span style="margin-left:20px ">현재 종료일 : ${projectEndDate}</span>
				</td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openMemberList()"><span>담당자</span></a></th>
				<td colspan="3" style="height:70px" id="managers"></td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openGroupTree()"><span>상위그룹</span></a></th>
				<td colspan="3" style="height:70px;" id="upperGroup"></td>
			</tr>
			<tr>
				<th>가중치</th>
				<c:choose>
      				<c:when test="${weightInput == 0}">
						<td colspan="3">
						가중치 자동 계산
						</td>
					</c:when>
      				<c:when test="${weightInput == 1}">
						<td colspan="3">
						<input type="text" id="weight" value="0" style="width:40px;text-align:center"> %  &nbsp; 프로젝트 잔여 가중치 ${remainingWeight} % 
						</td>
					</c:when>
   				</c:choose>
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