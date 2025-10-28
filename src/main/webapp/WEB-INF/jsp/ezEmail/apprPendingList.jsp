<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<title><spring:message code='email.appr.title.pending' /></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<style>
		.cp {cursor: pointer; }
	</style>
</head>
<body class="mainbody">
	<h1>
		<spring:message code='email.appr.title.pending' /> <% // 발송승인대기 %>
		<span class='txt_color'>${listTotalCount}</span>
	</h1>
	
	<!-- 안내문구 -->
	<div style="margin: 15px 0; ">※ <spring:message code='email.appr.title.pending.info' /></div>
	
	<!-- 리스트 -->
   	<div>
		<!-- 기능 -->
		<div id="mainmenu">
			<ul>
				<li class="important off"><span onclick="setApproval()"><spring:message code='email.appr.approval' /></span></li> <% // 발송승인 %>
				<li><span onclick="setReject()"><spring:message code='email.appr.reject' /></span></li> <% // 발송거부 %>
				<li onclick="reloadPage()"><span class="icon16 icon16_refresh"></span></li>
			</ul>
		</div>
		
		<!-- header -->
		<table class="mainlist" style="width: 100%; ">
			<colgroup>
				<col width="5%">
				<col width="*">
				<col width="10%">
				<col width="15%">
				<col width="15%">
			</colgroup>
			<tbody>
				<tr>
					<th>
					    <div class="custom_checkbox">
					        <input type="checkbox" id="Checkbox1" onchange="checkChange(this);">
					    </div>        
                    </th>
					<th><spring:message code='email.appr.th.subject' /></th> <% // 제목 %>
					<th><spring:message code='email.appr.th.applicant.name' /></th> <% // 작성자명 %>
					<th><spring:message code='email.appr.th.applicant.email' /></th> <% // 작성자주소 %>
					<th><spring:message code='email.appr.th.application.date' /></th> <% // 승인요청일시 %>
				</tr>
			</tbody>
		</table>
		<!-- body -->
		<div class="apprList" style="height:calc(100vh - 45vh); overflow:auto; ">
			<table id="apprmail" class="mainlist" style="width: 100%; ">
				<colgroup>
					<col width="5%">
					<col width="*">
					<col width="10%">
					<col width="15%">
					<col width="15%">
				</colgroup>
				<tbody>
					<c:if test="${empty resultArry}">
				        <tr>
				            <td colspan="6" style="text-align:center;"><spring:message code='ezEmail.ls014' /></td>
				        </tr>
				    </c:if>
					<c:forEach var="appr" items="${resultArry}" varStatus="status">
						<c:set var="count" value="${status.index}" />
						<tr id="apprmail_${count}" data-href="<c:out value='${appr.href}'/>" data-content-class="IPM.Note" data-sender="<c:out value='${appr.senderId}'/>" data-approver="<c:out value='${appr.approverId}'/>" title="<c:out value='${appr.subject}'/>">
							<td>
                                <div class="input_wrap">
                                    <%--<span class="listview-check checks">--%>
                                    <span class="custom_checkbox">
                                        <input type="checkbox" id="check_${count}" onchange="checkChangeEach(this);">
                                       	<label for="check_${count}"></label>
                                    </span>
                                </div>
                            </td>
							<td class="cp" title="<c:out value='${appr.subject}'/>" onclick="openEmail(this.parentNode);"><c:out value='${appr.subject}'/></td>
							<td class="cp" title="<c:out value='${appr.senderName}'/>" onclick="show_personinfo('<c:out value='${appr.senderEmail}'/>');"><c:out value='${appr.senderName}'/></td>
							<td title="<c:out value='${appr.senderEmail}'/>"><c:out value='${appr.senderEmail}'/></td>
							<td title="<c:out value='${appr.writeDate}'/>"><c:out value='${appr.writeDate}'/></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div> <!-- 리스트 END-->

    <!-- nav -->
    <div id="tblPageRayer" style="text-align:center"></div>

	<div style="width:200px;height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
	    <img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
	</div>
	<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/Newemail.js')}"></script>
	<script>
	var shareId = "${shareId}";
	var userLang = "${lang}";
	var arrayLength = ${resultArry}.length;
	var pageStartNum = Number(${pageStartNum});
	var pageTotalNum = Number(${pageMax});
	var pageBlockSize = Number(${pageBlockSize});
	var pageUrl = "/ezEmail/appr/pendingList.do?";

	window.onload = function() {
		mkPageSelPage();
	};
	
	function reloadPage() {
        location.reload();
    }

	function openEmail(object) {
		callMsgDlgAppr(object.dataset.href, "appr");
	}

	const mailListElement = document.getElementById("apprmail");
	function isEmptyMailList() {

		// 메일 리스트가 비어있다면 함수 종료 (메일 없음)
		if (!mailListElement) {
			return true;
		}

		return arrayLength === 0;
	}

	function checkChangeEach(checkbox) {
		
		if (isEmptyMailList()) {
			return;
		}

		// tr 노드들 (메일 리스트의 전체 행)
		const row = checkbox.closest('tr');

		if (checkbox.checked) {
			row.classList.add("starting-point", "on");
			row.querySelector("input").checked = true;
			listContentArry.push(row.id);
		} else {
			row.classList.remove("on");
			row.querySelector("input").checked = false;
		}
	}

	function checkChange(checkbox) {

		if (isEmptyMailList()) {
			return;
		}

		// tr 노드들 (메일 리스트의 전체 행)
		const rows = mailListElement.querySelectorAll("tr:not(.empty)");

		listContentArry = [];
		document.querySelector(".starting-point")?.classList.remove("starting-point");

		if (checkbox.checked) {
			rows[0].classList.add("starting-point");

			for (const row of rows) {
				row.classList.add("on");
				row.querySelector("input").checked = true;
				listContentArry.push(row.id);
			}
		} else {
			for (const row of rows) {
				row.classList.remove("on");
				row.querySelector("input").checked = false;
			}
		}
	}

	function setApproval() {

		if (isEmptyMailList()) {
			return;
		}

		// tr 노드들 (메일 리스트의 전체 행)
		const rows = mailListElement.querySelectorAll("tr:not(.empty)");
		const hrefArray = [];
		
		rows.forEach(row => {
	        const checkbox = row.querySelector("input[type='checkbox']");
	        if (checkbox && checkbox.checked) {
	            hrefArray.push(row.dataset.href);
	        }
	    });
		
		if (hrefArray.length === 0) {
			alert("<spring:message code='ezEmail.t99000002' />");
			return;
		}
		
		if (confirm("<spring:message code='email.appr.pending.approve.confirm' />")) {
			setApprovalAction(hrefArray);
		}
	}
		
	function setApprovalAction(hrefArray) {
		//showLoadingWithLock();

		$.ajax({
			type	: "POST",
			contentType	: "application/json",
			data	: JSON.stringify({hrefArray: hrefArray}),
			url		: "/ezEmail/appr/setApproval.do",
			async	: true,
			success	: function(result) {
				//hideLoading();
				if ("OK" == result) {
					console.log(result);
					alert("<spring:message code='email.appr.pending.approve.complete' />");
                } else if ("DONE" == result) {
                    console.log(result);
                    alert("<spring:message code='email.appr.pending.done' />");
				} else {
					console.log(result);
					var erroCount = result.split('_')[1];
					alert(erroCount + " <spring:message code='ezEmail.fail.count' />");
				}
				reloadPage();
			},
			error	: function(error) {
				//hideLoading();
				console.log(error);
				alert("<spring:message code='ezEmail.ls013' />");
				reloadPage();
			}
		})
	}
	
	var appr_reject_arg = new Object();
	function setReject() {
		if (isEmptyMailList()) {
			return;
		}

		// tr 노드들 (메일 리스트의 전체 행)
		const rows = mailListElement.querySelectorAll("tr:not(.empty)");
		const hrefArray = [];
		
		rows.forEach(row => {
	        const checkbox = row.querySelector("input[type='checkbox']");
	        if (checkbox && checkbox.checked) {
	            hrefArray.push(row.dataset.href);
	        }
	    });

		if(hrefArray.length === 0) {
			alert("<spring:message code='ezEmail.t99000002' />");
			return;
		}
		
		appr_reject_arg.complete = setRejectAction;
	    GetOpenWindow("/ezEmail/appr/setReject.do", "setReject", 500, 285, "no");
	}

	function setRejectAction(memo) {
		//showLoadingWithLock();
		// tr 노드들 (메일 리스트의 전체 행)
		const rows = mailListElement.querySelectorAll("tr:not(.empty)");
		const hrefArray = [];
		
		rows.forEach(row => {
	        const checkbox = row.querySelector("input[type='checkbox']");
	        if (checkbox && checkbox.checked) {
	            hrefArray.push(row.dataset.href);
	        }
	    });

		$.ajax({
			type	: "POST",
			contentType	: "application/json",
			data	: JSON.stringify({hrefArray: hrefArray, memo: memo}),
			url		: "/ezEmail/appr/setRejectAction.do",
			async	: true,
			success	: function(result) {
				//hideLoading();
				if ("OK" == result) {
				    alert("<spring:message code='email.appr.pending.reject.complete' />");
				} else if ("DONE" == result) {
                    alert("<spring:message code='email.appr.pending.done' />");
				} else {
					console.log(result);
                    var erroCount = result.split('_')[1];
                    alert(erroCount + " <spring:message code='ezEmail.fail.count' />");
				}

				reloadPage();
			},
			error	: function(error) {
				//hideLoading();
				console.log(error);
				alert("<spring:message code='ezEmail.ls013' />");
				reloadPage();
			}
		})
	}
	
	function goToPageByNum(num) {
		location.href = pageUrl + "startNum=" + num;
	}
	function selbeforeBlock() {
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