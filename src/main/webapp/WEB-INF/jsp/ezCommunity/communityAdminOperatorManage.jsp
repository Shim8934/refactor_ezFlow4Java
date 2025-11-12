<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t560' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/community.css')}" type="text/css">
		<style>
			textarea {
				resize:none;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			var code = "<c:out value = '${fn:escapeXml(code)}' />";

			function remove() {
				var checkboxes = document.querySelectorAll('.selectOperator');
				var userIds = [];
				
				checkboxes.forEach(function(checkbox) {
					if (checkbox.checked) {
						userIds.push(checkbox.id);
					}
				});

				if (userIds.length == 0) {
					alert("<spring:message code = 'ezCommunity.lyj19' />");
				} else {
					if (confirm("<spring:message code = 'ezCommunity.t426' />")) {
						$.ajax({
							type : "POST",
							url : "/ezCommunity/adminDeleteOperator.do",
							dataType : "json",
							contentType: "application/json;charset=UTF-8",
							async : false,
							data : JSON.stringify({
								code : code,
								userIds : userIds
							}),
							success : function(result) {
								if (result == true) {
									alert("<spring:message code = 'ezCommunity.t204' />");
									location.reload();
								} else {
									alert("<spring:message code = 'ezCommunity.t203' />");
								}
							},
							error : function(e) {
								alert("<spring:message code = 'ezCommunity.t203' />");
								console.log(e);
							}
						});
					}
				}
			}

			function add() {
				window.location.href = "/ezCommunity/adminAddOperator.do?code=" + encodeURIComponent(code);
			}
			
			function allCheck(element) {
				var checkboxes = document.querySelectorAll('.selectOperator');

				checkboxes.forEach(function(checkbox) {
					checkbox.checked = element.checked;
				});
			}
			
			function save(rowCount) {
				if (rowCount == 0) {
					alert("<spring:message code = 'ezCommunity.lyj42' />");
				} else {
					var manages = [];
					for (var i = 1; i <= rowCount; i++) {
						var strAuth = "";
						
						if (document.getElementById("adminAuthA" + i).checked) { // 회원관리
							strAuth = "A";
						} 
						if (document.getElementById("adminAuthB" + i).checked) { // 설문조사관리
							strAuth = strAuth + "B";
						}
						if (document.getElementById("adminAuthD" + i).checked) { // 홈화면관리
							strAuth = strAuth + "D";
						}
						if (document.getElementById("adminAuthF" + i).checked) { // 게시판관리
							strAuth = strAuth + "F";
						}
						if (strAuth.length > 0) {
							strAuth = strAuth + ";"
						}
						
						strAuth = strAuth + document.getElementById("adminAuthA" + i).getAttribute("userId");
						
						manages.push(strAuth);
					}
					
					$.ajax({
						type : "POST",
						url : "/ezCommunity/adminOperatorManageSave.do",
						dataType : "json",
						contentType: "application/json;charset=UTF-8",
						data : JSON.stringify({
							code : code,
							manages : manages
						}),
						success : function(result) {
							if (result == true) {
								alert("<spring:message code = 'ezCommunity.lyj43' />");
								manages = [];
								location.reload();
							} else {
								alert("<spring:message code = 'ezCommunity.t283' />");
							}
						},
						error : function(e) {
							alert("<spring:message code = 'ezCommunity.t283' />");
							console.log(e);
						}
					});
				}
			}
		</script>
	</head>
	<body class="mainbody communityMain">
		<h1><spring:message code = 'ezCommunity.lyj31' /></h1>
		<div class="point"><spring:message code = 'ezCommunity.lyj33' /></div>
		<hr style="margin-top:10px;">
		<div style="display:flex;justify-content: flex-start;margin-top:10px;">
			<div style="margin-top:2px;">
				▒ <spring:message code = 'ezCommunity.lyj06' /> <span class="point"><c:out value = '${fn:escapeXml(postCount)}' /></span><spring:message code = 'ezCommunity.lyj32' />
			</div>
			<div style="margin-left:10px;">
				<a class="imgbtn" style="vertical-align:middle;"><span id="btn_AttachAdd_logo" onclick="add()"><spring:message code = 'ezCommunity.lyj34' /></span></a>
				<a class="imgbtn" style="vertical-align:middle;"><span id="btn_AttachAdd_logo" onclick="remove()"><spring:message code = 'ezCommunity.lyj35' /></span></a>
			</div>
		</div>
		  
		<table class="mainlist" style ="width:100%;text-align:center;margin-top:10px">
			<tr>
			    <th style="width:15px;text-align: center;"><div class="custom_checkbox"><input type="checkbox" id="HeaderAllCheckBox" onclick="allCheck(this)"></div></th>
			    <th style="width:70px;text-align: center;"><spring:message code = 'ezCommunity.t10' /></th>
			    <th colspan="4" style="width:236px;text-align: center;"><spring:message code = 'ezCommunity.lyj36' /></th>
			</tr>
			<tbody id="idSpan">${idSpanValue}</tbody>
		</table>
		<br>
		<div style="display:flex;margin-bottom: 10px;"><div style="margin-top:2px;"><img src="../images/icon/battach.png"/></div><div class="txt" style="font-weight:bold;margin-left:5px;"><spring:message code='ezCommunity.lyj41' /></div></div>

		<div class="txt">▒ <spring:message code='ezCommunity.lyj37' /></div>
		<div class="txt" style="margin-top:3px">▒ <spring:message code='ezCommunity.lyj38' /></div>
		<div class="txt" style="margin-top:3px">▒ <spring:message code='ezCommunity.lyj39' /></div>
		<div class="txt" style="margin-top:3px">▒ <spring:message code='ezCommunity.lyj40' /></div>

		<br><br>
		<div class="btnposition btnpositionNew">
			<a class="imgbtn"	name="Submit"	onclick="javascript:save('<c:out value='${fn:escapeXml(postCount)}'/>');"><span><spring:message code ='ezCommunity.t20' /></span></a>
			<a class="imgbtn"	name="Submit2"	onclick="window.location.reload(false)" ><span><spring:message code ='ezCommunity.t109' /></span></a>
			<a class="imgbtn"	name="Submit3"	onclick="parent.parent.window.close()"><span><spring:message code ='ezCommunity.t21' /></span></a>
		</div>
	</body>
</html>