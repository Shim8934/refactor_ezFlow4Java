<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t193' /></title>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />"
	type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/dist/jstree.js"></script>

<script type="text/javascript">
var selMainListUserId = null;
var selMainListUserName = null;
var managerList = parent.managerArray;
var participantList = parent.participantArray;
var viewerList = parent.viewerArray;

$(function() {
	var strHTML = "";
	var data = {
			userList : managerList
	};
	
	$.ajax({
   		type:"POST",
   		url:"/ezPMS/getHeadManagerList.do",
		dataType : "json",
		contentType: "application/json;charset=UTF-8",
   		data:JSON.stringify(data),
   		async: false,
   		success: function(result){
   			for (var j = 0; j < result.userList.length; j++) {
   				strHTML += "<tr class='white hover' style='border: 1px solid #ddd; cursor:pointer;' id=" + result.userList[j].userId + " onclick='setMainListUserAuthorDept(this)'>";
   				strHTML += "<td style='border-right:none; max-width: 200px; width: 190px;'>";
   				strHTML += "<img src='" + result.userList[j].userImg + "' style='display:inline-block;float:left; height:40px; width:40px; padding:5px 0px 5px 8px; cursor: pointer;' onclick='menuQst_DetailUserInfo(" + result.userList[j].userId + ")'>";
   				strHTML += "<a style='cursor:pointer; display:inline-block; padding: 0px 10px 0px 10px; float: left; line-height: 40px; overflow: hidden; text-overflow: ellipsis; max-width:120px; white-space: nowrap;' onClick='menuQst_DetailUserInfo(" + result.userList[j].userId + ")'>";
   				strHTML += result.userList[j].userName;
   				strHTML += "(" + result.userList[j].deptName + ")";
   				strHTML += "</a>";
   				strHTML += "</td>";
   				strHTML += "</tr>";
   			}
   		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert("error : " + textStatus);
		}
   	});
	
	$("#managerName").html(strHTML);
});

function setMainListUserAuthorDept(elem) {
		if ($(elem).parent().attr("id") === "List_TBODY2") {
			$("#List_TBODY2 tr").removeClass("selectTR");
		} else if ($(elem).parent().parent().attr("id") === "managerName") {
			$("#managerName tr").removeClass("selectTR");
		} else if ($(elem).parent().parent().parent().attr("id") === "txtlist_Layer") {
			$("#txtlist_Layer tr").removeClass("selectTR");
		}
		
		$(elem).addClass("selectTR");
		selMainListUserId = $(elem).attr("id");
		selMainListUserName = $(elem).attr("name");
		// console.log("selMainListUserId : " + selMainListUserId)
}


function menuQst_DetailUserInfo(pUserID) {
	 var feature = GetOpenPosition(420, 438);
    window.open("/ezCommon/showPersonInfo.do?id=" + pUserID.id, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
}

function popupClose() {
	parent.DivPopUpHidden();
 }
 
 function selectHeadManager() {
	 if (selMainListUserId == null) {
		 alert("<spring:message code='ezPMS.t194' />");
		 return;
	 }
	 
	 if(parent.document.title == "<spring:message code='ezPMS.t167' />") {
		 parent.parent.headManagerId = selMainListUserId;
		 parent.parent.managerList = JSON.stringify(managerList);
		 parent.parent.applyList();
		 
		 popupClose();
		 parent.parent.DivPopUpHidden();
	 } else {
		 parent.opener.headManagerId = selMainListUserId;
		 parent.opener.managerList = JSON.stringify(managerList);
		 parent.opener.participantList = JSON.stringify(participantList);
		 parent.opener.viewerList = JSON.stringify(viewerList);
		 applyList();
		 
		 popupClose();
		 parent.window.close();
	 } 	 
 }
 
 function applyList() {
	 var managerNameList = "";
	 var participantNameList = "";
	 var viewerNameList = "";
	 var managerList = parent.managerArray;
	 var participantList = parent.participantArray;
	 var viewerList = parent.viewerArray;
	 var headManagerId = selMainListUserId;
	 
	 
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
	 
	 for (var i = 0; i < participantList.length; i++) {
		participantNameList += participantList[i].userName;
		participantNameList += "(" + participantList[i].userDeptname + "), ";
	}
	 
	 for (var i = 0; i < viewerList.length; i++) {
		viewerNameList += viewerList[i].userName;
		viewerNameList += "(" + viewerList[i].userDeptname + "), ";
	}
	 
	 managerNameList = managerNameList.substr(0, managerNameList.length - 2);
	 participantNameList = participantNameList.substr(0, participantNameList.length - 2);
	 viewerNameList = viewerNameList.substr(0, viewerNameList.length - 2);
	 
	 parent.opener.document.getElementById("managers").innerHTML = managerNameList;
	 parent.opener.document.getElementById("participants").innerHTML = participantNameList;
	 parent.opener.document.getElementById("viewers").innerHTML = viewerNameList;
 }
 
</script>
<style>
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
</style>
</head>
<body class = "popup" id="mainbody" style="overflow: hidden;">
		<form method = "POST">
			<div id="normalScreen" style="overflow: hidden;">
			    <div id="menu1" style="float: left; display: block; width:100%; text-align:left; padding-left:5px;">
					<h1 style="display: inline-block;"><spring:message code='ezPMS.t193' /></h1>
			    </div>					
			</div>
			<div style="height:203px; overflow-y: auto; overflow-x: hidden;" id="divTbl">
				<table border=1 style="width : 100%; border-color: grey;" id="managerName">
				</table>				
			</div>
			<table style="margin-top : 10px; margin-left:auto; margin-right:auto; border-spacing:10px 0; border-collapse: separate;">
			<tr>
				<td><a class="imgbtn" id="submit" onclick="selectHeadManager()"><span><spring:message code='ezPMS.t43' /></span></a></td>
				<td></td>
				<td><a class="imgbtn" id="cancel" onclick="popupClose()"><span><spring:message code='ezPMS.t41' /></span></a></td>
			</tr>
		</table>
		</form>
	</body>
</html>