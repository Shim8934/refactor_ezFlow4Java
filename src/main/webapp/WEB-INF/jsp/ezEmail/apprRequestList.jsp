<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<title><spring:message code='email.appr.title.request' /></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<style>
		.cp {cursor: pointer; }
	</style>
</head>
<body class="mainbody">
	<h1>
		<spring:message code='email.appr.title.request' /> <% // 발송요청목록 %>
		<span class='txt_color'>${listTotalCount}</span>
	</h1>
	
	<!-- 안내문구 -->
	<div style="margin: 15px 0; ">※ <spring:message code='email.appr.title.request.info.cancel' /></div> 

	<!-- 리스트 -->
   	<div>
		<!-- 기능 -->
		<div id="mainmenu">
			<ul>
				<li onclick="reloadPage()"><span class="icon16 icon16_refresh"></span></li>
			</ul>
		</div>
		
		<!-- header -->
		<table class="mainlist" style="width: 100%; ">
			<colgroup id="appr_request_td_colgroup">
				<col width="*">
				<col width="10%">
				<col width="15%">
				<col width="15%">
				<col width="10%">
				<col width="10%">
			</colgroup>
			<tbody>
				<tr class="fix">
					<th><spring:message code='email.appr.th.subject' /></th> <% // 제목 %>
					<th><spring:message code='email.appr.th.applicant.name' /></th> <% // 작성자명 %>
					<th><spring:message code='email.appr.th.applicant.email' /></th> <% // 작성자주소 %>
					<th><spring:message code='email.appr.th.application.date' /></th> <% // 승인요청일시 %>
					<th><spring:message code='email.appr.th.approver.name' /></th> <% // 승인자명 %>
					<th><spring:message code='email.appr.th.cancel' /></th> <% // 발송요청취소 %>
				</tr>
			</tbody>
		</table>
		<!-- body -->
		<div class="apprList" style="height:calc(100vh - 45vh); overflow:auto; ">
			<table class="mainlist" style="width: 100%; ">
				<colgroup>
					<col width="*">
					<col width="10%">
					<col width="15%">
					<col width="15%">
					<col width="10%">
					<col width="10%">
				</colgroup>
				<tbody id="appr-request-mail">
					<c:if test="${empty resultArry}">
				        <tr>
				            <td colspan="6" style="text-align:center;"><spring:message code='ezEmail.ls014' /></td>
				        </tr>
				    </c:if>
					<c:forEach var="appr" items="${resultArry}" varStatus="status">
						<c:set var="count" value="${status.index}" />
						<tr id="apprmail_${count}" data-href="<c:out value='${appr.href}'/>" data-content-class="IPM.Note" data-sender="<c:out value='${appr.senderId}'/>" data-approver="<c:out value='${appr.approverId}'/>" title="<c:out value='${appr.subject}'/>">
							<td class="cp" title="<c:out value='${appr.subject}'/>" onclick="openEmail(this.parentNode);"><c:out value='${appr.subject}'/></td>
							<td class="cp" title="<c:out value='${appr.senderName}'/>" onclick="openPersonalInfo('<c:out value='${appr.senderEmail}'/>')"><c:out value='${appr.senderName}'/></td>
							<td title="<c:out value='${appr.senderEmail}'/>"><c:out value='${appr.senderEmail}'/></td>
							<td title="<c:out value='${appr.writeDate}'/>"><c:out value='${appr.writeDate}'/></td>
							<td class="cp" title="<c:out value='${appr.approverName}'/>" onclick="openPersonalInfo('<c:out value='${appr.approverEmail}'/>');"><c:out value='${appr.approverName}'/></td>
							<td onclick="setCancel(this.parentNode);" ondblclick="setCancel(this.parentNode);"><a class="imgbtn ml5"><span><spring:message code='common.cancel' /></span></a></td> <% // 취소 %>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		<input id="cancel-message" type="hidden" data-cancel-message="<spring:message code='common.cancel' />"></span>
	</div> <!-- 리스트 END-->

    <!-- nav -->
    <div id="tblPageRayer" style="text-align:center"></div>
	
	<div id="MailProgress" style="width:200px;height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;">
	    <img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
	</div>
	<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/Newemail.js')}"></script>
	<script>
		//var shareId = "${shareId}";
		var userLang = "${lang}";
		var arrayLength = ${resultArry}.length;
		var pageStartNum = Number(${pageStartNum});
		var pageTotalNum = Number(${pageMax});
		var pageBlockSize = Number(${pageBlockSize});
		var pageUrl = "/ezEmail/appr/requestList.do?";
		
		window.onload = function() {
			mkPageSelPage();
		};
		
		function reloadPage() {
	        location.reload();
	    }

		function openEmail(object) {
			callMsgDlgAppr(object.dataset.href);
		}

		function openPersonalInfo(id) {
			if (id == null || id == "") {
				alert("<spring:message code='email.appr.noti.administrator' />");
				return;
			}

			show_personinfo(id);
		}

		function setCancel(object) {
			$.ajax({
				type	: "POST",
				data	: { "href" : object.dataset.href},
				contentType	: "application/x-www-form-urlencoded",
				url		: "/ezEmail/appr/setCancel.do",
				async	: true,
				success	: function(result) {
					if ("OK" === result) {
						reloadPage();
					} else {
						console.log(result);
						alert("<spring:message code='ezEmail.ls013' />");

						reloadPage();
					}
				},
				error	: function(error) {
					console.log(error);
					alert("<spring:message code='ezEmail.ls013' />");
				}
			})
		}


		const mailListElement = document.getElementById("apprmail");
		function isEmptyMailList() {

			// 메일 리스트가 비어있다면 함수 종료 (메일 없음)
			if (!mailListElement) {
				return true;
			}

			return arrayLength === 0;
		}
		
		function goToPageByNum(num) {
			location.href = pageUrl + "startNum=" + num;
		}
		function selbeforeBlock(num) {
		    var num = ((parseInt(pageStartNum / pageBlockSize) - 1) * pageBlockSize) + 1;
			goToPageByNum(num)
		}
		function selafterBlock() {
		    var num = ((parseInt((pageStartNum - 1) / pageBlockSize) + 1) * pageBlockSize) + 1;
			goToPageByNum(num)
		}
		
	</script>
	</body>
</html>