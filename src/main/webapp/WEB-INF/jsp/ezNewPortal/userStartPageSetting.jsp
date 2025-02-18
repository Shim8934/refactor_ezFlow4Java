<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>User Startpage</title>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />

<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript">
function selectTR(event) {
	var menuId = event.data.menuId;
	$("#menuList").find("tr").removeClass("selectTR");
	$("#M" + menuId).addClass("selectTR");
}

$(function() {
	var menuList = JSON.parse('${menuList}');
	var menuListCount = menuList.length;
	
	$("#setStartPage").on("click", setStartPage);
	
	$("#M0").on("click", {"menuId" : 0}, selectTR);
	$("#M0").on("dblclick", {"menuId" : 0}, setStartPage);
	
	for (var i = 0; i < menuListCount; i++) {
		$("#M" + menuList[i].menuId).on("click", {"menuId" : menuList[i].menuId}, selectTR);
		$("#M" + menuList[i].menuId).on("dblclick", {"menuId" : menuList[i].menuId}, setStartPage);
	}
});

function setStartPage(event) {
	var oldStartPageId = "<c:out value='${menuId}'/>";
	var menuId = 0;
	
	if (event.data == undefined) {
		var selId = $(".selectTR").attr("id");
		
		if (selId == undefined) {
			alert("<spring:message code='ezNewPortal.t029' />");
			return;
		} else {
			menuId = selId.substring(1);
		}
	} else {
		menuId = event.data.menuId;
	}
	
	var menuName = $("#M" + menuId).find("td").eq(1).text();
	
	var result = confirm("<spring:message code='ezNewPortal.t030' />");
	
	if (result) {
		$.ajax({
			type : "POST",
			data : {"menuId" : menuId},
			url : "/ezNewPortal/updateUserStartPage.do",
			success : function() {
				$(".start_page").text("");
				$("td").removeClass("start_page");
				$("#M" + menuId).find("td").eq(2).text("<spring:message code='ezNewPortal.t031' />");
				$("#M" + menuId).find("td").eq(2).addClass("start_page");
			},
			fail : function () {
				//alert("<spring:message code='ezNewPortal.t032' />");
			}
		});
	}
}
</script>
<style type="text/css">
.mainlist {width : 640px}
.mainlist tr :first-child {width : 120px}
.mainlist tr :nth-child(3) {width : 150px}
.mainlist tr :nth-child(4) {width : 150px}
.mainlist tr {cursor : pointer}
.mainlist tr:hover {background-color : rgb(244,245,245)}
.selectTR {background-color: #edf4fd;}
</style>
</head>
<body class="mainbody">
	<h1><spring:message code='ezNewPortal.t136'/></h1>
	<div id="mainmenu">
		<ul>
			<li><span id="setStartPage"><spring:message code='ezNewPortal.t137'/></span></li>
		</ul>
	</div>
	<table border="0" cellspacing="0" cellpadding="0" class="ltitle">
		<tr>
			<td height="1" class="dotted"></td>
		</tr>	
		<tr>
			<td height="1"  bgcolor="#ffffff"></td>
		</tr>		
		<tr>
			<td height="50" > 
				<div>▒&nbsp;<spring:message code='ezNewPortal.t138'/></div>
                <div style="margin-top:3px">▒&nbsp;<spring:message code='ezNewPortal.t139'/></div>
			</td>
		</tr>
		<tr>
			<td height="1"  bgcolor="#ffffff"></td>
		</tr>
		<tr>
			<td  class="dotted"></td>
		</tr>
	</table>
	<table class="mainlist"> 
		<tr>
			<th>&nbsp;</th>
			<th><spring:message code='ezNewPortal.t140'/></th>
			<th><spring:message code='ezNewPortal.t141'/></th>
			<th> &nbsp;</th>
		</tr>
	</table>
	<table id="menuList" class="mainlist">
		<tr id="M0">
			<td></td>
			<td><spring:message code='ezNewPortal.t033' /></td>
		<c:choose>
			<c:when test="${menuId eq 0 }">
				<td class='start_page'><spring:message code='ezNewPortal.t031' /></td>
			</c:when>
			<c:otherwise>
				<td></td>
			</c:otherwise>
		</c:choose>
			<td></td>	
		</tr>
		<c:forEach items="${menuList}" var="menu">
		<c:choose>
			<c:when test="${menu.menuId eq '-1'}">
			</c:when>
			<c:when test="${menu.menuId eq menuId }">
				<tr id="M${menu.menuId }">
					<td></td>
					<td>${menu.menuName }</td>
					<td class='start_page'><spring:message code='ezNewPortal.t031' /></td>
			        <td></td>	
				</tr>
			</c:when>
			<c:otherwise>
				<tr id="M${menu.menuId }">
					<td></td>
					<td>${menu.menuName }</td>
					<td></td>
			        <td></td>	
			     </tr>
			</c:otherwise>
		</c:choose>
		</c:forEach>
	</table>
</body>
</html>
