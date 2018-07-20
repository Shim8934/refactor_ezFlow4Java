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
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />"
	type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript">
 $(function(){
	 var memberList = JSON.parse('${memberList}');
	 var roleId = "${roleId}";
	 var roleName = "";
	 var memberCount = "${memberCount}";
	 
	 if (roleId == "1") {
		roleName = "<spring:message code='ezPMS.t63' />"; 
	 } else if (roleId == "2") {
		 roleName = "<spring:message code='ezPMS.t64' />";
	 } else {
		 roleName = "<spring:message code='ezPMS.t65' />";
	 }
	 
	 $("#menu1").find("h1").text(roleName + " <spring:message code='ezPMS.t156' />  (" + memberCount + ")");
	 $("title").prepend(roleName);
	 
	 var strHTML = "<table border='1' style='width:100%; border-color:grey;'>";
	 
	 if (memberList.length == null || memberList.length == 0) {
		 strHTML += "<tr id='noone' class='white' style='border:1px solid #ddd; height:35px;'>";
		 strHTML += "<td style='border-right:none; width:100%; text-align:center;'>";
		 strHTML += "<spring:message code='ezPMS.t157' /> " + roleName + "<spring:message code='ezPMS.t158' />";
		 strHTML += "</td></tr>";
	 } else {
		 for (var i = 0; i < memberList.length; i++) {
			strHTML += "<tr id='" + memberList[i].userId + "' class='white' style='border:1px solid #ddd'>";
			strHTML += "<td style='border-right:none; width:100%'>";
			strHTML += "<img src='" + memberList[i].userImage + "' style='display:inline-block;float:left; height:40px; width:40px; padding:5px 0px 5px 8px; cursor: pointer;' onclick='menuQst_DetailUserInfo(" + memberList[i].userId + ")'>";
			strHTML += "<a style='cursor:pointer; display:inline-block; padding:0px 10px; float:left; line-height:41px; overflow:hidden;";
			strHTML += "text-overflow:ellipsis; max-width:120px; white-space:nowrap;' onclick='menuQst_DetailUserInfo(\"" + memberList[i].userId + "\")'>";
			strHTML += memberList[i].userName;
			strHTML += "(" + memberList[i].userDeptname + ")";
			strHTML += "</a>";
			strHTML += "</td></tr>";
		 } 
	 }
	  
	 strHTML += "</table>";
	 
	 $("#divTbl").html(strHTML);
 });
 
 function menuQst_DetailUserInfo(pUserID) {
	var feature = GetOpenPosition(420, 438);
    window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
}
 
 function popupClose() {
	parent.DivPopUpHidden();
 }
</script>
</head>
<body class="popup" id="mainbody" style="overflow:hidden;">
<form method="POST">
	<div id="normalScreen" style="overflow: hidden;">
		<div id="menu1" style="float: left; display: block; width:100%; text-align:left; padding-left:5px;">
			<h1 style="display: inline-block;"></h1>
		</div>					
	</div>
	<div style="height:250px; overflow-y:auto; overflow-x:hidden;" id="divTbl">
	</div>
	<table style="margin-top : 10px; margin-left:auto; margin-right:auto; border-spacing:10px 0; border-collapse: separate;">
		<tr>
			<td><a class="imgbtn" onclick="popupClose()"><span><spring:message code='ezPMS.t43' /></span></a></td>
			<td>
		</tr>
	</table>
</form>
</body>
</html>