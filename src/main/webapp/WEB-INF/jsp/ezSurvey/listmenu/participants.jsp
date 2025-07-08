<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css'				)}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg'		)}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('/css/jquery-ui.css'				)}" type="text/css"/>
		<script type="text/javascript" src="${util.addVer('ezSurvey.lang', 'msg'                   )}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js'        )}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyNavi.js'			   )}"></script>
		<style>
			table, td, th, span {
				outline: none;         /* 포커스 윤곽선 제거 */
				caret-color: transparent; /* 커서 숨기기 */
			}
		</style>
	</head>
	
	<body class="surveyBody">
		<div class="header-wrapper">
			<div class="surveydetail-header" style="font-weight:bold"><spring:message code='ezSurvey.yjh03'/></div>
			<div id="close"><ul><li><span id="cancelBttn"></span></li></ul></div>
		</div>

		<div class="surveydetail-body" id="mainSurveyBody">
			<div id="mainmenu">
				<ul>
					<span id="user-header" style="font-weight:bold; line-height: 30px;"></span>
					<div style="float:right;"><li id="exportBttn"><a><span><spring:message code='ezSurvey.yjh02'/></span></a></li></div>
				</ul>
			</div>

			<div style="margin-top: 15px; height: 78vh; overflow-y: auto;">
				<table class="mainlist users" id="userTable">
				</table>
			</div>

			<div id="tblPageRayer"></div>
		</div>
		
		<form id="exportSurvey" name="exportSurvey" method="post" style="display:none;">
			<input name="surveyId" value="${surveyId}">
			<input name="surveyTitle" value="${surveyTitle}">
			<input name="totalUserCnt" value="${totalUserCnt}">
		</form>
		
		<script type="text/javascript">
			var totalUserCnt = ${totalUserCnt};
			var pSurveyId = "<c:out value='${surveyId}'/>";
			var listCnt = 13; /* 한 페이지 표출 개수 (현재는 고정 > 추후 개선) */

			window.onload = function () {				
				/* 버튼 이벤트 셋팅 */
				var cancelBttn = document.getElementById("cancelBttn");
				if (cancelBttn) {cancelBttn.onclick = function(e) {window.close();};}
				var exportBttn = document.getElementById("exportBttn");
				if (exportBttn) {exportBttn.onclick = function(e) {exportUserList();};}
				
				makeUsersHeader();
				getUserList(1);
			}

			/* 참여자 리스트 헤더, 페이징 */
			var tableUser = document.getElementById("userTable");
			function makeUsersHeader() {
				tableUser.innerHTML = "";

				var trHeader = document.createElement("tr");
				var headers = [
					"<spring:message code='ezOrgan.t218'/>", /*아이디*/
					"<spring:message code='ezSurvey.t57'/>", /*이름*/
					"<spring:message code='ezSurvey.t59'/>", /*부서명*/
					"<spring:message code='ezSchedule.t165'/>" /*응답일*/
				];

				headers.forEach(function(text) {
					var thHeader = document.createElement("th");
					thHeader.textContent = text;
					trHeader.appendChild(thHeader);
				});
				
				tableUser.appendChild(trHeader);
				
				var divHeader       = document.getElementById("user-header");
				divHeader.innerHTML = SurveyMessages.strAllUsers + " [&nbsp;<span id='userTotal' style='color: red;'></span>" + SurveyMessages.strUser3 + "&nbsp;]";

				var surveyNavi   = null;
				surveyNavi = new SurveyNavi({
					divId    : "tblPageRayer",
					divClass : "pagenavi",
					headerId : "userTotal",
					callback : getUserList
				});
				surveyNavi.init(1, totalUserCnt, parseInt((totalUserCnt-1)/listCnt)+1);
			}
			
			/* 참여자 리스트 호출 */
			function getUserList(pPage) {
				$.ajax({
					type: "GET",
					url: "/ezSurvey/getSurveyParticipantList.do",
					data: {
						surveyId : pSurveyId,
						currentPage : pPage,
						listCntSize : listCnt
					},
					dataType: "JSON",
					async: false,
					cache: false,
					success : function(data) {
						makeUsers(data);
					},
					error : function(error) {
						alert(SurveyMessages.strError + error);
					}
				});
			}
			
			/* 참여자 리스트 생성 */
			function makeUsers(participantList) {
				$(".usersTr").remove();
				
				for (var i = 0; i < participantList.length; i++) {
					var trElmt  = document.createElement("tr");
					trElmt.className = "usersTr";
					
					var userId = participantList[i].userId;
					trElmt.onclick = (function(userId) {
						return function() {
							showUserInfoFromId(userId);
						};
					})(userId);
					
					var contents = [
						userId,
						participantList[i].userName, 
						participantList[i].deptName, 
						participantList[i].responseDate.substring(0, 19)
					];

					contents.forEach(function(text) {
						var tdElmt = document.createElement("td");
						tdElmt.className = "mainTd";
						tdElmt.setAttribute("title", text);
						tdElmt.textContent = text;
						trElmt.appendChild(tdElmt);
					});
					
					tableUser.appendChild(trElmt);
				}
			}

			/* 사용자 정보 표출 */
			function showUserInfoFromId(userId) {
				var feature = "height=450px, width=420px, status=no, toolbar=no, menubar=no,location=no, resizable=1";
				feature = feature + getOpenWindowfeature(420, 450);
				window.open("/ezCommon/showPersonInfo.do?id=" + userId, "userInfo", feature);
			}
			function getOpenWindowfeature(popUpW, popUpH) {
				var heigth   = window.screen.availHeight;
				var width    = window.screen.availWidth;
				var left     = 0;
				var top      = 0;
				var pleftpos = parseInt(width) - popUpW;
				heigth       = parseInt(heigth) - popUpH;
				left         = pleftpos / 2;
				top          = heigth / 2;
				var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes";
				return feature;
			}

			/* 참여자 리스트 엑셀다운로드 */
			function exportUserList() {
				document.exportSurvey.action = "/ezSurvey/exportUserListExcel.do";
				document.exportSurvey.method = "POST";
				document.exportSurvey.submit();
			}
		</script>
	</body>
</html>