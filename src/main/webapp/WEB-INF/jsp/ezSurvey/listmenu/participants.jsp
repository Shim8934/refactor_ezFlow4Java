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
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js'				   )}"></script>
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
					<div style="float:right;">
						<c:if test="${useLottery eq 'YES'}">
							<li id="lotteryBttn"><a><span><spring:message code='ezSurvey.yjh06'/></span></a></li>
						</c:if>
						<li id="exportBttn"><a><span><spring:message code='ezSurvey.yjh02'/></span></a></li>
					</div>
				</ul>
			</div>

			<div style="margin-top: 15px; height: 78vh; overflow-y: auto;">
				<table class="mainlist users" id="userTable">
				</table>
			</div>

			<div id="tblPageRayer"></div>
		</div>

		<%--레이어팝업 영역 추가--%>
		<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
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
			var useLottery = "<c:out value='${useLottery}'/>"

			window.onload = function () {				
				/* 버튼 이벤트 셋팅 */
				var cancelBttn = document.getElementById("cancelBttn");
				if (cancelBttn) {cancelBttn.onclick = function(e) {window.close();};}
				var exportBttn = document.getElementById("exportBttn");
				if (exportBttn) {exportBttn.onclick = function(e) {exportUserList();};}
				var lotteryBttn = document.getElementById("lotteryBttn");
				if (lotteryBttn) {lotteryBttn.onclick = function(e) {lotteryBtn_Onclick();};}
				
				makeUsersHeader();
				getUserList(1);
			}

			/* 참여자 리스트 헤더, 페이징 */
			var tableUser = document.getElementById("userTable");
			function makeUsersHeader() {
				tableUser.innerHTML = "";

				var trHeader = document.createElement("tr");
				var headers = [
					{ id : "USERID", text : "<spring:message code='ezOrgan.t218'/>"}, /*아이디*/
					{ id : "USERNAME", text : "<spring:message code='ezSurvey.t57'/>"}, /*이름*/
					{ id : "DEPTNAME", text : "<spring:message code='ezSurvey.t59'/>"}, /*부서명*/
					{ id : "RESPONSEDATE", text : "<spring:message code='ezSchedule.t165'/>"} /*응답일*/
				];
				if (useLottery == "YES") {
					headers.push({ id : "LOTTERYRESULT", text : "<spring:message code='ezSurvey.yjh07'/>"});
				}

				headers.forEach(function(target) {
					var thHeader = document.createElement("th");
					thHeader.id = target.id;
					thHeader.textContent = target.text;					
					thHeader.onclick = function () { sortByHeader(thHeader)};
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
			var pPage = 1;
			function getUserList(page) {
				pPage = page;
				$.ajax({
					type: "GET",
					url: "/ezSurvey/getSurveyParticipantList.do",
					data: {
						surveyId : pSurveyId,
						currentPage : pPage,
						orderCol : orderColumn,
						orderType : order,
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
					
					if (useLottery == "YES") {
						var lotteryRes = participantList[i].lotteryRes;
						contents.push(lotteryRes == 0 ? "" : (lotteryRes == -1 ? "<spring:message code='ezSurvey.yjh08'/>" : lotteryRes));
					}

					contents.forEach(function(text) {
						var tdElmt = document.createElement("td");
						tdElmt.className = "mainTd";
						tdElmt.setAttribute("title", text);
						tdElmt.textContent = text;
						if(useLottery == "YES" && text == "당첨") {
							tdElmt.style.color = "red";
						}
						trElmt.appendChild(tdElmt);
					});
					
					tableUser.appendChild(trElmt);
				}

				if (useLottery == "YES") { setResponseColWidth(); }
			}
			
			/* 응답일 컬럼 사이즈 조정 */
			function setResponseColWidth() {
				$('#userTable tr:first th').each(function (index) {
					if ($(this).text().includes("<spring:message code='ezSchedule.t165'/>")) {
						$('#userTable tr:gt(0)').each(function () {
							$(this).find('td').eq(index).css('width', '200px');
						});
						$(this).css('width', '200px');
					}
				});
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

			var survey_cross_dialogArguments = new Array();
			function lotteryBtn_Onclick() {
				if ("${finishYN}" === "N") {
					alert("<spring:message code='ezSurvey.yjh09'/>");
					return;
				} else if ("${hasLotteryRes}" === "true") {
					if (!confirm("<spring:message code='ezSurvey.yjh10'/>")) {
						return;
					}
				}
				if (CrossYN()) {
					survey_cross_dialogArguments[0] = pSurveyId;
					survey_cross_dialogArguments[1] = lotteryBtn_Onclick_Complete;
					DivPopUpShow(400, 215, "/ezSurvey/surveyLotteryChoice.do");

				} else {
					var parameter = survey_cross_dialogArguments[0];
					var url = "/ezSurvey/surveyLotteryChoice.do";
					var feature = "status:no;dialogWidth:400px;dialogHeight:215px;help:no;";
					feature = feature + GetShowModalPosition(400, 215);
					lotteryBtn_Onclick_Complete(window.showModalDialog(url, parameter, feature));
				}
			}
			
			function lotteryBtn_Onclick_Complete(RtnVal) {
				DivPopUpHidden();

				if (RtnVal != undefined) {
					surveyLottery(RtnVal.type, RtnVal.cnt);
				}
			}
			
			function surveyLottery(type, cnt) {
				$.ajax({
					type: "POST",
					url: "/ezSurvey/surveyLottery.do",
					dataType: "text",
					async: false,
					data: {
						surveyId : pSurveyId,
						type : type,
						cnt : cnt
					},
					success : function() {
						window.location.reload();
					},
					error : function() {
						alert(SurveyMessages.strError);
					}
				});
			}

			var _selectedHeader = null;
			var orderColumn;
			var order;
			function sortByHeader(thHeader) {
				if (!thHeader) {return;}

				if (_selectedHeader != null) {
					var orderOption = thHeader.getAttribute("orderoption") == "DESC" ? "ASC" : "DESC";
					thHeader.setAttribute("orderoption", orderOption);

					if (thHeader != _selectedHeader) {
						_selectedHeader.removeChild(_selectedHeader.lastElementChild);
						var spanElmt = document.createElement("span");
						thHeader.appendChild(spanElmt);
					}

					var spanImg       = thHeader.lastElementChild;
					spanImg.className = orderOption == "DESC" ? "spanDown" : "spanUp";
				}
				else {
					thHeader.setAttribute("orderoption", "DESC");
					var spanElmt       = document.createElement("span");
					spanElmt.className = "spanDown";
					thHeader.appendChild(spanElmt);
				}

				_selectedHeader = thHeader;
				orderColumn = thHeader.id;
				order = thHeader.getAttribute("orderoption");
				
				getUserList(pPage);
			}
		</script>
	</body>
</html>