<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Kanban Setting</title>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />"
	type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/dist/jstree.js"></script>
<script>
var selStatus = [];
var kanbanOrder = parent.kanbanOrder;
var projectId = parent.projectId;
var selOne = "";

$(function(){
	var kanbanOrderArr = kanbanOrder.split(",");
	var strHTML = "";
	strHTML += "<table class='.kanbanStatus'>";
	selStatus = kanbanOrderArr;
	
	for (var i = 0; i < kanbanOrderArr.length; i++) {
		if (kanbanOrderArr[i] == "MA") {
			strHTML += "<tr class='white hover' style='border: 1px solid #ddd; cursor:pointer;' id='selMA' ondblclick='selectStatus(" + "MA" + ")' onclick='selectOneStatus(" + "MA" + ")'>";
			strHTML += "<td style='border-right:none;max-width: 250px;width: 221px;height: 36px;background-color : white;'>";
			strHTML += $("#MA").val();
			strHTML += "</td></tr>";
			
			$("#MA").prop("checked", true);
		} else {
			$("#" + kanbanOrderArr[i].slice(-1)).prop("checked", true);	
			strHTML += "<tr class='white hover' style='border: 1px solid #ddd; cursor:pointer;' id='sel" + kanbanOrderArr[i].slice(-1) + "'";
			strHTML += "ondblclick='selectStatus(" + kanbanOrderArr[i].slice(-1) + ")' onclick='selectOneStatus(" + kanbanOrderArr[i].slice(-1) + ")'>";
			strHTML += "<td style='border-right:none;max-width: 250px;width: 221px;height: 36px;background-color : white;'>";
			strHTML += $("#" + kanbanOrderArr[i].slice(-1)).val();
			strHTML += "</td></tr>";
			
			$("#" + kanbanOrderArr[i].slice(-1)).prop("checked", true);
		}
	}

	strHTML += "</table>";
	$("#kanbanList").html(strHTML);
});

function selectStatus(status) {
	if ($("#" + status).prop("checked") == true) {
		for (var i = 0; i < selStatus; i++) {
			if (selStatus[i] != selOne) {
				return;
			}
		}
		
		selStatus.splice(selStatus.indexOf(status), 1);
		$("#" + status).prop("checked", false);
		$("#sel"+status).remove();
	} else {
		for (var i = 0; i < selStatus; i++) {
			if (selStatus[i] == selOne) {
				return;
			}
		}
		
		if (selStatus.length >= 4) {
			alert("4개 까지만 선택 가능합니다.");
			return;
		} else {
			$("#" + status).prop("checked", true);
			selStatus.push(status);
			
			var strHTML = "";
			strHTML += "<tr class='white hover' style='border: 1px solid #ddd; cursor:pointer;' id='sel" + kanbanOrderArr[i].slice(-1) + "' ondblclick='selectStatus(" + kanbanOrderArr[i].slice(-1) + ")' onclick='selectOneStatus(" + kanbanOrderArr[i].slice(-1) + ")'>";
			strHTML += "<td style='border-right:none;max-width: 250px;width: 221px;height: 36px;background-color : white; vertical-align:middle'>";
			strHTML += $("#" + status).val();
			strHTML += "</td></tr>";
			
			$("#kanbanList").append(strHTML);
		}
	}
}

function popupClose() {
	parent.DivPopUpHidden();
 }
 
function updateKanbanStatus() {
	kanbanOrder = "";
	
	for (var i = 0; i < selStatus.length; i++) {
		kanbanOrder += selStatus[i] + ",";
	}
	
	var data = {
		projectId : projectId,
		kanbanOrder : kanbanOrder
	}
	
	$.ajax({
		type : "POST",
		url : "/ezPMS/updateKanbanOrder.do",
		dataType : "json",
		contentType: "application/json; charset=UTF-8",
		data :JSON.stringify(data),
		success : function(result) {
			try { 
				if (mode == "edit") {
					alert ("프로젝트가 수정되었습니다.");
					parent.window.location.reload();
					parent.projectId = projectId;
				} else {
					sendNotiMail(result, projectName);
					alert("새프로젝트가 추가되었습니다.");
					parent.setProjectList(); 
				}
				popupClose();
			
			} catch (e) {
				alert("error 발생");
				return;
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert("error");
		}
	});
	
	parent.kanbanOrder = kanbanOrder;
	parent.setKanbanStatus();
	popupClose();
}

function selectOneStatus(status) {
	selOne = status;
}

function addStatus() {
	for (var i = 0; i < selStatus; i++) {
		if (selStatus[i] == selOne) {
			return;
		}
	}
	
	if (selStatus.length >= 4) {
		alert("4개 까지만 선택 가능합니다.");
		return;
	} else {
		$("#" + selOne).prop("checked", true);
		selStatus.push(selOne);
		
		var strHTML = "";
		strHTML += "<tr class='white hover' style='border: 1px solid #ddd; cursor:pointer;' id='sel" + kanbanOrderArr[i].slice(-1) + "' ondblclick='selectStatus(" + kanbanOrderArr[i].slice(-1) + ")' onclick='selectOneStatus(" + kanbanOrderArr[i].slice(-1) + ")'>";
		strHTML += "<td style='border-right:none;max-width: 250px;width: 221px;height: 36px;background-color : white; vertical-align:middle'>";
		strHTML += $("#" + selOne).val();
		strHTML += "</td></tr>";
		
		$("#kanbanList").append(strHTML);
	}
}

function deleteStatus() {
	for (var i = 0; i < selStatus; i++) {
		if (selStatus[i] != selOne) {
			return;
		}
	}
	
	selStatus.splice(selStatus.indexOf(selOne), 1);
	$("#" + selOne).prop("checked", false);
	$("#sel"+selOne).remove();
}
</script>
<style type="text/css">
tr.hover:not (.selectTR ):hover {
	background: #eee;
	color: #fff;
}

.selectTR {
	background-color: rgb(233, 241, 255);
}

#List_TBODY2 tr {
	cursor: pointer;
}

#List_TBODY tr {
	cursor: pointer;
}

.kanbanStatus tbody tr td {
	border-right:none;
	max-width: 250px;
 	width: 221px;
 	height: 36px;
 	background-color : white;
}

#instruction {
	font-size : 13px;
	margin-bottom : 15px;
}
</style>
</head>
<body class="popup" id="mainbody">
	<form method="POST">
		<div id="normalScreen" style="overflow: hidden;">
			    <div id="menu1" style="float: left; display: block; width:100%; text-align:left; padding-left:5px;">
					<h1 style="display: inline-block;">프로젝트 개요 화면 설정</h1>
			    </div>					
		</div>
		<div id = "instruction" >
			프로젝트 개요 화면에 표시할 업무 상태를 선택하세요.(최대 4개) 
		</div>
			<table id="kanbanSetting">
				<tr>
				     <td>
						<table border=1 style="width : 100%; border-color: grey;" id="kanbanStatus" class="kanbanStatus">
							<tr class="white hover" style="border: 1px solid #ddd; cursor:pointer;" ondblclick="selectStatus('MA')" onclick="selectOneStatus('MA')">
								<td><input type="checkbox" id="MA" name="kanbanStatus" value="나의 전체 업무" onchange="selectStatus('MA')">나의 전체 업무</td>
							</tr>
							<tr class="white hover" style="border: 1px solid #ddd; cursor:pointer;" ondblclick="selectStatus('P')" onclick="selectOneStatus('P')">
								<td><input type="checkbox" id="P" name="kanbanStatus" value="진행 중인 업무" onchange="selectStatus('P')">진행 중인 업무</td>
							</tr>
							<tr class="white hover" style="border: 1px solid #ddd; cursor:pointer;" ondblclick="selectStatus('C')" onclick="selectOneStatus('C')">
								<td><input type="checkbox" id="C" name="kanbanStatus" value="완료된 업무" onchange="selectStatus('C')">완료된 업무</td>
							</tr>
							<tr class="white hover" style="border: 1px solid #ddd; cursor:pointer;" ondblclick="selectStatus('L')" onclick="selectOneStatus('L')">
								<td><input type="checkbox"  id="L" name="kanbanStatus" value="기한이 지난 업무" onchange="selectStatus('L')">기한이 지난 업무</td>
							</tr>
							<tr class="white hover" style="border: 1px solid #ddd; cursor:pointer;" ondblclick="selectStatus('W')" onclick="selectOneStatus('W')">
								<td><input type="checkbox" id="W" name="kanbanStatus" value="대기 중인 업무" onchange="selectStatus('W')">대기 중인 업무</td>
							</tr>
							<tr class="white hover" style="border: 1px solid #ddd; cursor:pointer;" ondblclick="selectStatus('B')" onclick="selectOneStatus('B')">									
								<td><input type="checkbox" id="B" name="kanbanStatus" value="게시판" onchange="selectStatus('B')">게시판</td>
							</tr>
						</table>
					</td>
					<td style="width: 30px; text-align: center;">
						<div>
	                        <img src="/images/arr_r.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer; margin-top: 10px;" onclick="addStatus()"><br>
	                        <img src="/images/arr_l.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="deleteStatus()">
	                    </div>
	                </td>
	                
	                <td id="kanbanList" style="vertical-align: top; background-color: rgb(246, 246, 246); border:1px solid rgb(200, 200, 200);">
							
	                </td>
	           </tr>
	         </table>
			<table style="margin-top : 3px; margin-left:auto; margin-right:auto; border-spacing:10px 0; border-collapse: separate;">
			<tr>
				<td><a class="imgbtn" id="submit" onclick="updateKanbanStatus()"><span>확인</span></a></td>
				<td></td>
				<td><a class="imgbtn" id="cancel" onclick="popupClose()"><span>취소</span></a></td>
			</tr>
		</table>	
	</form>
</body>
</html>