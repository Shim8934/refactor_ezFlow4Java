<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>poll_res</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/community.css')}" />
		<style>
			.graphback {
				background-color: #f8f8fa;
				border: 1px solid #eee;
			}
			.graphbar {
				background-color: rgb(245, 117, 120);
			    height: 10px;
			    margin: 0px;
			    padding: 0px;
			    border: 1px solid rgb(225, 97, 100);
			}
			<%-- 2018-11-28 홍승비 - 설문 등록자의 이름이 화면을 뚫는 문제 수정 --%>
			.mainlist tr th.pollTitle {
				word-break: break-all;
				white-space: normal;
				width: 535px;
			}
			.mainlist tr th.pollWriter {
				text-align: right;
				white-space: pre-wrap;
				word-break: break-all;
				padding-right: 5px;
			}
			<%-- 2020-05-26 홍승비 - 설문 등록자의 이름이 우측 하단으로 내려가는 경우, UI가 깨지지 않도록 이름 전체를 하단에 표출 --%>
			.pollWriterName {
				display:inline-block;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript">
			function sendIt() {
				if ("${isSave}" == 0) {
					if (confirm("<spring:message code='ezPoll.t210' />")) {
						poll_res_ok.submit();
					}
				} else {
					if (confirm("<spring:message code='ezCommunity.t6' /><spring:message code='ezCommunity.t7' />")) {
						poll_res_ok.submit();
					}
				}
			}
			
			function etcview(etc, qID) {
				window.open("/ezCommunity/pollETCView.do?etc="+encodeURIComponent(etc)+"&questionID="+qID, "rts60", "width=430,height=420,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no" );
			}
			
			function goPage() {	
				window.location.href = "/ezCommunity/pollMain.do?code=${code}";
			}
		</script>
	</head>
	<body class = "cmhome_body">
		<form name = "poll_res_ok" action = "/ezCommunity/pollResOk.do" method = "post" onsubmit="return false">
			<input type = "hidden" name = "code" value = "${code}" />
			<input type = "hidden" name = "pollManagerID" value = "${pollManagerID}" />
			<input type = "hidden" name = "pollState" value = "${pollState}" />
			
			<h1 class = "type1_h1"><spring:message code = 'ezCommunity.t598' /></h1>
			<div id="mainmenu" style="margin-bottom:12px">
				<ul>
					<c:set var="t679"><spring:message code='ezCommunity.t679'/></c:set>
					<li><span onclick="goPage()" ><spring:message code = 'ezCommunity.t987' /></span></li>
					<c:if test="${pollState == t679 }">
						<c:choose>
							<c:when test="${isSave == 0 }">
								<li><span onclick="sendIt()" ><spring:message code = 'ezCommunity.t20' /></span></li>
							</c:when>							
							<c:otherwise>
								<li><span onclick="sendIt()" ><spring:message code = 'ezCommunity.t6' /></span></li>
							</c:otherwise>
						</c:choose>
					</c:if>
				</ul>
			</div>
			
			<script type="text/javascript">
				selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
			
			<span id = "idSpan">${idSpanValue }</span>

			<c:if test="${pollState != t679 }">
				<div style="font-weight:normal;font-size:12px;text-align:left;margin-top:30px;border-top:1px solid #ccc;padding-top:10px;color:black" class="subtxt"><spring:message code = 'ezCommunity.t683' /></div>
			</c:if>
			<c:if test="${pollState == t679 && isSave == 1}">
				<div style="font-weight:normal;font-size:12px;text-align:left;margin-top:30px;border-top:1px solid #ccc;padding-top:10px;color:black" class="subtxt"><spring:message code = 'ezCommunity.t684' /></div>
			</c:if>
			<c:if test="${pollState == t679 && isSave != 1}">
				<div style="font-weight:normal;font-size:12px;text-align:left;margin-top:30px;border-top:1px solid #ccc;padding-top:10px;color:black" class="subtxt">&nbsp;</div>
			</c:if>
			
			<input type = "hidden" name = "isSave" value = "${isSave }" />
		</form>
	</body>
</html>