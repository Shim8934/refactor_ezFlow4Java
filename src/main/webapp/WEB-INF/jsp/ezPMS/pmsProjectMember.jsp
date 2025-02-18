<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title> <spring:message code='ezPMS.t156' /></title>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>

<script type="text/javascript">
var projectId = parent.projectId;
var roleId = "${roleId}";

 $(function(){
	 var memberList = JSON.parse('${memberList}');
	 var roleName = "";
	 var memberCount = "${memberCount}";
	 var memberListCount = memberList.length;
	 
	 if (roleId == "1") {
		roleName = "<spring:message code='ezPMS.t63' />";
		
		// 담당자에서 관리자를 뺀다
		memberList = memberList.filter(function(member) {
			return member.userId != parent.headManagerId;
		});
		
		memberCount--;
		memberListCount = memberListCount - 1;
	 } else if (roleId == "2") {
		 roleName = "<spring:message code='ezPMS.t64' />";
	 } else {
		 roleName = "<spring:message code='ezPMS.t65' />";
	 }
	 
	 $("#menu1").find("h1").text(roleName + " <spring:message code='ezPMS.t156' />  (" + memberCount + ")");
	 $("title").prepend(roleName);
	 
	 var strHTML = "<table border='1' style='width:100%; border-color:grey;'>";
	 
	 if (memberListCount == null || memberListCount == 0) {
		 strHTML += "<tr id='noone' class='white' style='border:1px solid #ddd; height:35px;'>";
		 strHTML += "<td style='border-right:none; width:100%; text-align:center;'>";
		 strHTML += "<spring:message code='ezPMS.t157' arguments='" + roleName + "'/>";
		 strHTML += "</td></tr>";
	 } else {
		 $("#menu1").append("<img style='cursor: pointer; float: right; margin-top: 3px;;' src='/images/poll/sendMail01.png' onclick='sendMailAll()'>");
		 
		 for (var i = 0; i < memberListCount; i++) {
			var member = memberList[i];
			
			strHTML += "<tr id='" + member.userId + "' class='white' style='border:1px solid #ddd; width: 100%'>";
			strHTML += "<td style='border-right:none;'>";
			strHTML += "<img src='" + member.userImage + "' style='display:inline-block;float:left; height:40px; width:40px; padding:5px 0px 5px 8px; cursor: pointer;' onclick='menuQst_DetailUserInfo(" + member.userId + ")'>";
			strHTML += "<a style='cursor:pointer; display:inline-block; padding:0px 10px; float:left; line-height:41px; overflow:hidden;";
			strHTML += "text-overflow:ellipsis; max-width:120px; white-space:nowrap;' onclick='menuQst_DetailUserInfo(\"" + member.userId + "\")'>";
			strHTML += member.userName;
			strHTML += "(" + member.userDeptname + ")";
			strHTML += "</a>";
			strHTML += "</td><td style='border: none; width: 60px;'>";
			strHTML += "<img class='voteUserMailImg' style='padding-left: 10px; cursor: pointer;' src='/images/poll/sendMail.png' onclick='sendMail(\"" + member.userId + "\", \"" + member.userIdType + "\")'>";
			strHTML += "</td></tr>";
		 } 
	 }
	  
	 strHTML += "</table>";
	 
	 $("#divTbl").html(strHTML);
 });
 
 function menuQst_DetailUserInfo(pUserID) {
	var feature = GetOpenPosition(420, 450);
    window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
}
 
 function popupClose() {
	$("#blockLeft", parent.parent.parent.frames["left"].document).remove();
	$("#blockTop", parent.parent.parent.frames["right"].document).remove();
	parent.DivPopUpHidden();
}
 
 function sendMail(userId, userIdType) {
	var pheight = window.screen.availHeight;
	var conHeight = pheight * 0.8;
	var pwidth = window.screen.availWidth;
	var pTop = (pheight - conHeight) / 2;
	var pLeft = (pwidth - 890) / 2;
	var url = "/ezEmail/mailWrite.do?cmd=ezPMS&type=one&projectId=" + projectId + "&roleId=" + roleId + "&toUserId=" + userId + "&userIdType=" + userIdType;

	window.open(url, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height=" + conHeight + "px, width=890px, status=no, toolbar=no, menubar=no, location=no, resizable=1");
 }
 
 function sendMailAll() {
	var pheight = window.screen.availHeight;
	var conHeight = pheight * 0.8;
	var pwidth = window.screen.availWidth;
	var pTop = (pheight - conHeight) / 2;
	var pLeft = (pwidth - 890) / 2;
	var url = "/ezEmail/mailWrite.do?cmd=ezPMS&type=group&projectId=" + projectId + "&roleId=" + roleId;
	
	window.open(url, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height=" + conHeight + "px, width=890px, status=no, toolbar=no, menubar=no, location=no, resizable=1");
}
</script>
</head>
<body class="popup" id="mainbody" style="overflow:hidden;">
<form method="POST">
	<div id="normalScreen" style="overflow: hidden;">
		<div id="menu1" style="float: left; display: block; width:98%; text-align:left; padding-left:5px;">
			<h1 style="display: inline-block;"></h1>
		</div>					
	</div>
	<div style="height:250px; overflow-y:auto; overflow-x:hidden;" id="divTbl">
	</div>
	<table style="width:100%; margin-top : 10px; margin-left:auto; margin-right:auto; border-spacing:10px 0; border-collapse: separate;">
		<tr>
			<td><div class="btnpositionNew"><a class="imgbtn" onclick="popupClose()"><span><spring:message code='ezPMS.t43' /></span></a></div></td>
			<td>
		</tr>
	</table>
</form>
</body>
</html>