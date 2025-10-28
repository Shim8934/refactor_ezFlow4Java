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
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<title><spring:message code='ezPMS.t92' /></title>
<script type="text/javascript">
var projectList = parent.checkedVal;
var nowStatus = parent.listProjectStatus;
var strHTML = "";
var viewType = parent.viewType;

$(function(){	
	strHTML += "<tr><th>";
	
	switch(nowStatus) {
	case 'W' :
	case 'D' :
		strHTML += "<div class='custom_radio'><input type='radio' value='P' name='status' checked>";
		strHTML += "</th></div><td>";
		strHTML += "<spring:message code='ezPMS.t258' />";
		strHTML += "</input></td></tr>";
		strHTML += "<tr><th>";
		strHTML += "<div class='custom_radio'><input type='radio' value='S' name='status'>";
		strHTML += "</div></th><td>";
		strHTML += "<spring:message code='ezPMS.t259' />";
		strHTML += "</input></td></tr>";
		break;
	case 'P' :
		strHTML += "<div class='custom_radio'><input type='radio' value='C' name='status' checked>";
		strHTML += "</div></th><td>";
		strHTML += "<spring:message code='ezPMS.t261' />";
		strHTML += "</input></td></tr>";
		strHTML += "<tr><th>";
		strHTML += "<div class='custom_radio'><input type='radio' value='S' name='status'>";
		strHTML += "</div></th><td>";
		strHTML += "<spring:message code='ezPMS.t259' />";
		strHTML += "</input></td></tr>";
		break;
	case 'L' :
		strHTML += "<div class='custom_radio'><input type='radio' value='C' name='status' checked>";
		strHTML += "</div></th><td>";
		strHTML += "<spring:message code='ezPMS.t261' />";
		strHTML += "</input></td></tr>";
		strHTML += "<tr><th>";
		strHTML += "<div class='custom_radio'><input type='radio' value='S' name='status' checked>";
		strHTML += "</div></th><td>";
		strHTML += "<spring:message code='ezPMS.t259' />";
		strHTML += "</input></td></tr>";
		break;
	case 'S' :
		strHTML += "<div class='custom_radio'><input type='radio' value='P' name='status' checked>";
		strHTML += "</div></th><td>";
		strHTML += "<spring:message code='ezPMS.t258' />";
		strHTML += "</input></td></tr>";
		strHTML += "<tr><th>";
		strHTML += "<div class='custom_radio'><input type='radio' value='C' name='status'>";
		strHTML += "</div></th><td>";
		strHTML += "<spring:message code='ezPMS.t261' />";
		strHTML += "</input></td></tr>";
		break;
	}
	
	$("#statusList").html(strHTML);
});

function changeStatus() {
	var status = $("input[name='status']:checked").val();
	var response = true;
	var isHeadManager = true;
	
	var checkedPrjInfo = parent.getCheckedProjectInfo();
	
	checkedPrjInfo.forEach(function(elem, idx) {
	    if (elem.headManagerId !== parent.userId) {
	    	isHeadManager = false;
	    }
	});
	
	if(!isHeadManager){
		alert("<spring:message code='ezPMS.t9' />");
		popupClose();
		return;
	}
	
	if (status == "C") {
		response = confirm("<spring:message code='ezPMS.t159' />");
	}
	
	if (response == true) {
		var data = {
			nowStatus : nowStatus,
			status : status,
			projectList : projectList
		}
		
		$.ajax({
			type : "POST",
			dataType: "text",
			contentType: "application/json; charset=UTF-8",
			url : "/ezPMS/updateProjectStatus.do",
			data :JSON.stringify(data),
			success : function(result) {
				if (result == "permitted") {
					alert("<spring:message code='ezPMS.t10' />");
					parent.checkedVal = "";

					if (viewType == 0) {
						parent.startRow = 0;
						parent.listNumber = parent.$(".project_list").length;
					}
					
					var nowStatusStr = getStatusStr(nowStatus);
					var statusStr 	 = getStatusStr(status);
					var checkedPrjInfoCount = checkedPrjInfo.length;
					
					for(var i = 0; i < checkedPrjInfoCount; i++) {
						var projectName = checkedPrjInfo[i].projectName;
						var projectId 	= checkedPrjInfo[i].projectId;
						var groupId 	= checkedPrjInfo[i].groupId;
						
						var logContent = "<spring:message code='ezPMS.t314' arguments='" + projectName + "," + nowStatusStr + "," + statusStr + "'/>"; 
						addTaskLog(projectId, 2, groupId, null, logContent);
					}
					
					parent.setProjectList("new");
					popupClose();
				} else {
					alert("<spring:message code='ezPMS.t9' />");
					popupClose();
					return;
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
			}
		});
	}
}

function popupClose() {
	$("#blockLeft", parent.parent.frames["left"].document).remove();
	parent.DivPopUpHidden();
}

// status 알파벳을 문자열로 반환
function getStatusStr(status) {
	
	switch(status) {
	case 'P': // 진행
		return "<spring:message code='ezPMS.t15'/>"
		break;
	case 'W': // 대기
		return "<spring:message code='ezPMS.t16'/>"
		break;
	case 'C': // 완료
		return "<spring:message code='ezPMS.t17'/>"
		break;
	case 'L': // 지연
		return "<spring:message code='ezPMS.t18'/>"
		break;
	case 'S': // 보류
		return "<spring:message code='ezPMS.t19'/>"
		break;
	case 'D': // 삭제
		return "<spring:message code='ezPMS.t11'/>"
		break;
	}
}
</script>
</head>
<body class="popup">
<h1><spring:message code='ezPMS.t92' />
		<div id="close" style="float:right">
		<ul>
			<li>
				<span id="cancel" onclick="popupClose()"></span>
			</li>
		</ul>
		</div>
</h1>
<div class="main_body">
<span><spring:message code='ezPMS.t39' /></span>
	<div>
		<table id="statusList" class="content" style="margin-top:10px">
		</table>
	</div>
	<br/>
		<table style="width:100%;">
			<tr>
				<td><div class="btnposition btnpositionNew"><a class="imgbtn" id="submit" onclick="changeStatus()"><span><spring:message code='ezPMS.t40' /></span></a></div></td>
			</tr>
		</table>
</div>
</body>
</html>