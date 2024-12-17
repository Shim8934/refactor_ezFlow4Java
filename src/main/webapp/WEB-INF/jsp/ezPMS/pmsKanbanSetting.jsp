<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t134' /></title>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery-ui/jquery-ui.min.css')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/jstree.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script>
var selStatus = [];
var kanbanOrder = parent.kanbanOrder;
var projectId = parent.projectId;
var selOne = "";

$(function(){
	var kanbanOrderArr = kanbanOrder.split(",");
	var strHTML = "";
	strHTML += "<table class='.kanbanStatus'><tbody id='kanbanOrder'>";
	selStatus = kanbanOrderArr;
	var kanbanOrderArrCount = kanbanOrderArr.length;
	
	for (var i = 0; i < kanbanOrderArrCount; i++) {
		$("#" + kanbanOrderArr[i].slice(-1)).prop("checked", true);	
			
		strHTML += "<tr class='white hover statusOrder' style='border: 1px solid #ddd; cursor:pointer;' id='sel" + kanbanOrderArr[i].slice(-1) + "'>";
		strHTML += "<td style='border-right:none;max-width: 250px;width: 221px;height: 36px;background-color : white;'>";
		strHTML += $("#" + kanbanOrderArr[i].slice(-1)).val();
		strHTML += "</td></tr>";
	}

	strHTML += "</tbody></table>";
	$("#kanbanList").html(strHTML);
	
	for (var i = 0; i < kanbanOrderArrCount; i++) {
		$("#sel" + kanbanOrderArr[i].slice(-1)).attr("onclick", "selectOneStatus('" + kanbanOrderArr[i].slice(-1) + "')");
		$("#sel" + kanbanOrderArr[i].slice(-1)).attr("ondblclick", "selectStatus('" + kanbanOrderArr[i].slice(-1) + "', 'tr')");
	}
	
	 getDragAndSwap();
});

function getDragAndSwap() {
	$("#kanbanOrder").sortable();
	$("#kanbanOrder").disableSelection();
}

function selectStatus(status, location) {
	if (($("#" + status).prop("checked") == false && location == "checkbox") || ($("#" + status).prop("checked") == true && location == "tr")) {
		selStatus.splice(selStatus.indexOf(status), 1);
		$("#" + status).prop("checked", false);
		$("#sel"+status).remove();
	} else {
		if (selStatus.length >= 4) {
			alert("<spring:message code='ezPMS.t135' />");
			$("#" + status).prop("checked", false);
			return;
		} else {
			$("#" + status).prop("checked", true);
			selStatus.push(status);
			var selectStatus = status + "";
			
			var strHTML = "";
			strHTML += "<tr class='white hover statusOrder' style='border: 1px solid #ddd; cursor:pointer;' id='sel" + selectStatus + "'>";
			strHTML += "<td style='border-right:none;max-width: 250px;width: 221px;height: 36px;background-color : white; vertical-align:middle'>";
			strHTML += $("#" + selectStatus).val();
			strHTML += "</td></tr>";
			
			$("#kanbanOrder").append(strHTML);
			
			$("#sel" + selectStatus).attr("onclick", "selectOneStatus('" + selectStatus + "')");
			$("#sel" + selectStatus).attr("ondblclick", "selectStatus('" + selectStatus + "', 'tr')");
		}
	}
	
	getDragAndSwap();
}

function popupClose() {
	$("#blockLeft", parent.parent.parent.frames["left"].document).remove();
	$("#blockTop", parent.parent.parent.frames["right"].document).remove();
	parent.DivPopUpHidden();
}
 
function updateKanbanStatus() {
	kanbanOrder = "";
	var statusOrder = $(".statusOrder");
	var statusOrderCount = statusOrder.length;
	
	for (var i = 0; i < statusOrderCount; i++) {
		kanbanOrder += statusOrder.eq(i).attr("id").substring(3) + ",";
	}
	
	kanbanOrder = kanbanOrder.slice(0,-1);
	
	if (kanbanOrder == "" || kanbanOrder == null) {
		alert("<spring:message code='ezPMS.t324'/>");
		return;
	}
	
	 var data = {
		projectId : projectId,
		orderStatus : kanbanOrder
	}
	
	 $.ajax({
		type : "POST",
		url : "/ezPMS/changeKanbanOrder.do",
		contentType: "application/json; charset=UTF-8",
		data :JSON.stringify(data),
		success : function(result) {
			parent.kanbanOrder = kanbanOrder;
			parent.initKanbanList();
			popupClose(); 
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert("<spring:message code='ezPMS.t208' />");
		}
	});  
	
}

function selectOneStatus(status) {
	selOne = status;
	$("#kanbanStatus tr").removeClass("selectTR");
	$("#" + status).parent().parent().addClass("selectTR");
}

function addStatus() {
	var selStatusCount = selStatus.length;
	
	for (var i = 0; i < selStatusCount; i++) {
		if (selStatus[i] == selOne) {
			return;
		}
	}
	
	if (selStatusCount >= 4) {
		alert("<spring:message code='ezPMS.t135' />");
		return;
	} else {
		$("#" + selOne).prop("checked", true);
		selStatus.push(selOne);
		
		var strHTML = "";
		strHTML += "<tr class='white hover statusOrder' style='border: 1px solid #ddd; cursor:pointer;' id='sel" + selOne + "'>";
		strHTML += "<td style='border-right:none;max-width: 250px;width: 221px;height: 36px;background-color : white; vertical-align:middle'>";
		strHTML += $("#" + selOne).val();
		strHTML += "</td></tr>";
		
		$("#kanbanOrder").append(strHTML);
		
		$("#sel" + selOne).attr("onclick", "selectOneStatus('" + selOne + "')");
		$("#sel" + selOne).attr("ondblclick", "selectStatus('" + selOne + "')");
		
		getDragAndSwap();
	}
}

function deleteStatus() {
	selStatus.splice(selStatus.indexOf(selOne), 1);
	$("#" + selOne).prop("checked", false);
	$("#sel"+selOne).remove();
}

</script>
<style type="text/css">
.white:hover {
	background-color: rgb(233, 241, 255);
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
}

#instruction {
	font-size : 13px;
	margin-bottom : 15px;
}

body {
	overflow : hidden;
}
</style>
</head>
<body class="popup" id="mainbody">
	<form method="POST">
		<div id="normalScreen" style="overflow: hidden;">
			    <div id="menu1" style="float: left; display: block; width:100%; text-align:left; padding-left:5px;">
					<h1 style="display: inline-block;"><spring:message code='ezPMS.t134' />
						<div id="close" style="float:right">
							<ul><li>
									<span id="cancel" onclick="popupClose()"></span>
							</li></ul>
						</div>
					</h1>
			    </div>					
		</div>
		<div id = "instruction" >
			<spring:message code='ezPMS.t136' /> 
		</div>
			<table id="kanbanSetting">
				<tr>
				     <td>
						<table border=1 style="width : 100%; border-color: grey;" id="kanbanStatus" class="kanbanStatus">
							<tr class="white hover" style="border: 1px solid #ddd; cursor:pointer;" ondblclick="selectStatus('A', 'tr')" onclick="selectOneStatus('A')">
								<td><input type="checkbox" id="A" name="kanbanStatus" value="<spring:message code='ezPMS.t269' />" onchange="selectStatus('A', 'checkbox')"><spring:message code='ezPMS.t269' /></td>
							</tr>
							<tr class="white hover" style="border: 1px solid #ddd; cursor:pointer;" ondblclick="selectStatus('P', 'tr')" onclick="selectOneStatus('P')">
								<td><input type="checkbox" id="P" name="kanbanStatus" value="<spring:message code='ezPMS.t138' />" onchange="selectStatus('P', 'checkbox')"><spring:message code='ezPMS.t138' /></td>
							</tr>
							<tr class="white hover" style="border: 1px solid #ddd; cursor:pointer;" ondblclick="selectStatus('C', 'tr')" onclick="selectOneStatus('C')">
								<td><input type="checkbox" id="C" name="kanbanStatus" value="<spring:message code='ezPMS.t34' />" onchange="selectStatus('C', 'checkbox')"><spring:message code='ezPMS.t34' /></td>
							</tr>
							<tr class="white hover" style="border: 1px solid #ddd; cursor:pointer;" ondblclick="selectStatus('L', 'tr')" onclick="selectOneStatus('L')">
								<td><input type="checkbox"  id="L" name="kanbanStatus" value="<spring:message code='ezPMS.t139' />" onchange="selectStatus('L', 'checkbox')"><spring:message code='ezPMS.t139' /></td>
							</tr>
							<tr class="white hover" style="border: 1px solid #ddd; cursor:pointer;" ondblclick="selectStatus('W', 'tr')" onclick="selectOneStatus('W')">
								<td><input type="checkbox" id="W" name="kanbanStatus" value="<spring:message code='ezPMS.t140' />" onchange="selectStatus('W', 'checkbox')"><spring:message code='ezPMS.t140' /></td>
							</tr>
							<tr class="white hover" style="border: 1px solid #ddd; cursor:pointer;" ondblclick="selectStatus('B', 'tr')" onclick="selectOneStatus('B')">									
								<td><input type="checkbox" id="B" name="kanbanStatus" value="<spring:message code='ezPMS.t141' />" onchange="selectStatus('B', 'checkbox')"><spring:message code='ezPMS.t141' /></td>
							</tr>
						</table>
					</td>
					<td style="width: 30px; text-align: center;">
						<div>
	                        <img src="/images/arr_r.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer; margin-top: 10px;" onclick="addStatus()"><br>
	                        <img src="/images/arr_l.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="deleteStatus()">
	                    </div>
	                </td>
	                
	                <td id="kanbanList" style="width:46%; vertical-align: top; background-color: rgb(246, 246, 246); border:1px solid rgb(200, 200, 200);">
						
	                </td>
	           </tr>
	         </table>
			<table style="width:100%;">
			<tr>
				<td><div class="btnpositionNew"><a class="imgbtn" id="submit" onclick="updateKanbanStatus()"><span><spring:message code='ezPMS.t265' /></span></a></div></td>
			</tr>
		</table>	
	</form>
</body>
</html>