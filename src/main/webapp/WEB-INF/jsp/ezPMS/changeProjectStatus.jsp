<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<title>프로젝트 상태 변경</title>
<script type="text/javascript">
var projectList = parent.checkedVal;
var nowStatus = parent.listProjectStatus;
var strHTML = "";

$(function(){
	strHTML += "<tr><td>";
	
	switch(nowStatus) {
	case 'W' :
	case 'D' :
		strHTML += "<input type='radio' value='P' name='status' checked>";
		strHTML += "진행 프로젝트";
		strHTML += "</input></td></tr>";
		strHTML += "<tr><td>";
		strHTML += "<input type='radio' value='S' name='status'>";
		strHTML += "보류 프로젝트";
		strHTML += "</input></td></tr>";
		break;
	case 'P' :
		strHTML += "<input type='radio' value='C' name='status' checked>";
		strHTML += "완료 프로젝트";
		strHTML += "</input></td></tr>";
		strHTML += "<tr><td>";
		strHTML += "<input type='radio' value='S' name='status'>";
		strHTML += "보류 프로젝트";
		strHTML += "</input></td></tr>";
		break;
	case 'L' :
		strHTML += "<input type='radio' value='S' name='status' checked>";
		strHTML += "보류 프로젝트";
		strHTML += "</input></td></tr>";
		break;
	case 'S' :
		strHTML += "<input type='radio' value='P' name='status' checked>";
		strHTML += "진행 프로젝트";
		strHTML += "</input></td></tr>";
		strHTML += "<tr><td>";
		strHTML += "<input type='radio' value='C' name='status'>";
		strHTML += "완료 프로젝트";
		strHTML += "</input></td></tr>";
		break;
	}
	
	$("#statusList").html(strHTML);
});

function changeStatus() {
	var status = $("input[name='status']:checked").val();
	
	data = {
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
				alert("상태가 변경되었습니다. \n현재일보다 마감일이 빠른 프로젝트는 지연 프로젝트 상태로 변경됩니다.");
				parent.checkedVal = "";
				parent.setProjectList();
				popupClose();
			} else {
				alert("프로젝트 담당자만 상태를 변경할 수 있습니다.");
				popupClose();
				return;
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
		}
	});
}

function popupClose() {
	parent.DivPopUpHidden();
}
 
</script>
<style type="text/css">
input {
	font-size : 15px;
}
</style>
</head>
<body class="popup">
<h1>프로젝트 상태 변경</h1>
<div class="main_body">
선택된 프로젝트의 변경할 상태를 선택하세요.
	<div style="border:1px gray solid">
		<table id="statusList">
		
		</table>
	</div>
	
		<table style="margin-top : 10px; margin-left:auto; margin-right:auto; border-spacing:10px 0; border-collapse: separate;">
			<tr>
				<td><a class="imgbtn" id="submit" onclick="changeStatus()"><span>등록</span></a></td>
				<td></td>
				<td><a class="imgbtn" id="cancel" onclick="popupClose()"><span>취소</span></a></td>
			</tr>
		</table>
</div>
</body>
</html>