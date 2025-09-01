<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCommunity.lyj17' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/community.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<!-- 페이징 -->
		<script type="text/javascript" src="${util.addVer('ezCommunity.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/lang/ezCommunity.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/ListView_list.js')}"></script>
		<script type="text/javascript">
		    var ReturnFunction;
			var RetValue;
			var code = "<c:out value = '${fn:escapeXml(code)}' />";
			var userIds = new Array();

			window.onload = function () {
				getGradeList();
			}

			$(document).ready(function(){
				try {
					RetValue = parent.change_grade_dialogArguments[0];
				} catch (e) {
					try {
						RetValue = opener.change_grade_dialogArguments[0];
					} catch (e) {
						RetValue = window.dialogArguments;
					}
				}

				userIds = RetValue;
			});

			function getGradeList() {
				$.ajax({
					type : "GET",
					url : "/ezCommunity/getAdminMemberGrade.do",
					dataType : "json",
					data : {
						code : code
					},
					success : function(result) {
						getGradeList_after(result);
					},
					error : function(xhr, status, error) {
						console.error("Error: " + error);
					}
				});
			}

			function getGradeList_after(gradeList) {
				var selectGrade = document.getElementById("gradeList");

				if (selectGrade) {
					selectGrade.innerHTML = "";

					for (var i = 2; i < gradeList.length-1; i++) {
						var option = document.createElement("option");

						option.value = gradeList[i].gradeCode;
						option.textContent = gradeList[i].gradeName;

						selectGrade.appendChild(option);
					}
				}
			}

			function save() {
				var selectedOption = document.getElementById("gradeList").value;

				userIds = userIds.filter((value, index, self) => {
					return self.indexOf(value) === index;
				});

				$.ajax({
					type : "POST",
					url : "/ezCommunity/adminMemberGradeUpdate.do",
					dataType : "json",
					contentType: "application/json;charset=UTF-8",
					async : false,
					data : JSON.stringify({
						code : code,
						grade : selectedOption,
						userIds : userIds
					}),
					success : function(result) {
						if (result == true) {
							ReturnFunction = opener.change_grade_dialogArguments[1];

							if (ReturnFunction != null) {
								ReturnFunction();
							}
							window.close();
						} else {
							alert("<spring:message code = 'ezCommunity.t283' />");
						}
					},
					error : function() {
						alert("<spring:message code = 'ezCommunity.t283' />");
					}
				});
			}
		</script>
	</head>
	<body class="popup" >
		<h1><spring:message code='ezCommunity.lyj17' /></h1>
		<div id="close">
			<ul>
				<li><span id="btn_OpinionCANCEL" onClick="return window.close();"></span></li>
			</ul>
		</div>
		<h2 id="h2Msg" style="font-weight: normal;margin-top:20px;">▒&nbsp;<spring:message code = 'ezCommunity.lyj18' /></h2>
		<select id="gradeList" style="font-size: 13px;vertical-align: middle;cursor: pointer;width:100%" onchange="">
			<option value="3" selected><spring:message code = 'ezCommunity.lyj07' /></option>
			<option value="4"><spring:message code = 'ezCommunity.lyj08' /></option>
		</select>
		<div class="btnposition btnpositionNew">
			<a class="imgbtn" id="btn_OpinionOK" onClick="return save();"><span><spring:message code='ezCommunity.t20'/></span></a>
		</div>
		<input id="publicModulus" value="${publicModulus}" type="hidden"/>
		<input id="publicExponent" value="${publicExponent}" type="hidden"/>
	</body>
</html>