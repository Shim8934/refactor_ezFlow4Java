<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
	<title><spring:message code='email.appr.menu.allhands.pending' /></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<style>
		.apprList td {border:0; border-bottom: 1px solid #eaeaea; }
		.totalcountDIV {display: inline-block; vertical-align: middle; margin: 3px 3px 0 0;}
	</style>
</head>
<body>
	<div>
		<!-- 리스트 상단 옵션 -->
		<div id="mainmenu">
			<ul class="">
				<li class="important off"><span onclick="setApproval()"><spring:message code='email.appr.approval' /></span></li> <% // 발송승인 %>
				<li class=""><span onclick="setReject()"><spring:message code='email.appr.reject' /></span></li> <% // 발송거부 %>
				<div id="right">
					<span class="totalcountDIV"><span id="totalcount" class='txt_color'> ${listTotalCount} </span><spring:message code='common.count.unit' /></span>
					<span class="icon16 icon16_refresh" onclick="reloadPage()"></span>
	            </div>
			</ul>
		</div>
		
		<!-- 리스트 -->
		<div>
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
	                    <th><input type="checkbox" id="Checkbox1" onchange="checkChange(this);"></th>
	                    <th><spring:message code='email.appr.th.subject' /></th> 			<% // 제목 %>
	                    <th><spring:message code='email.appr.th.applicant.name' /></th> 	<% // 작성자명 %>
	                    <th><spring:message code='email.appr.th.applicant.email' /></th> 	<% // 작성자주소 %>
	                    <th><spring:message code='email.appr.th.application.date' /></th> 	<% // 승인요청일시 %>
					</tr>
				</tbody>
			</table>
			<!-- body -->
			<div class="apprList" style="height:calc(100vh - 40vh); overflow:auto; ">
				<table id="apprmail" class="mainlist" style="width: 100%; ">
					<colgroup>
                        <col width="5%">
                        <col width="*">
						<col width="10%">
						<col width="15%">
						<col width="15%">
					</colgroup>
					<tbody id="apprMailList"></tbody>
				</table>
			</div>
		</div> <!-- 리스트 END -->
		
	    <!-- nav -->
	    <div id="tblPageRayer" style="text-align:center"></div>
	</div>
	
    <template id="tmp-noData">
		<tr class="noDataTR"><td colspan="8" style="text-align:center;"><spring:message code="ezEmail.ls014"/></td></tr>
    </template>
	<template id="tmp-apprMailList">
		<tr id data-href data-content-class="IPM.Note" data-sender data-approver title>
			<td class="tmp-apprMailList-checkbox">
				<div class="input_wrap">
					<span class="listview-check checks">
	        			<input type="checkbox" id onchange="checkChangeEach(this);">
						<label></label>
	                </span>
				</div>
			</td>
			<td class="tmp-apprMailList-subject"></td>
			<td class="tmp-apprMailList-senderName"></td>
			<td class="tmp-apprMailList-senderEmail"></td>
			<td class="tmp-apprMailList-writeDate"></td>
		</tr>
	</template>
	
	<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/search_mail.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/Newemail.js')}"></script>
	<script type="text/javascript">
		var shareId = "${shareId}";
		var userLang = "${lang}";
		const COMPANYID = "<c:out value='${companyId}'/>";
		const mailListElement = document.getElementById("apprmail");
		var pageStartNum = 1;
		var pageTotalNum;
		var pageBlockSize = Number(${pageBlockSize});
		
		window.onload = function() {
			makeLogList();
		};
		
		function reloadPage() {
			document.getElementById("Checkbox1").checked = false;
			pageStartNum = 1;
			makeLogList();
		}
	
		function openEmail(object) {
			callMsgDlgAppr(object.dataset.href, "allHands");
		}
	
		function isEmptyMailList() {
	
			// 메일 리스트가 비어있다면 함수 종료 (메일 없음)
			if (!mailListElement) {
				return true;
			}
	
			return arrayLength === 0;
		}
	
		function checkChangeEach(checkbox) {
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
			// tr 노드들 (메일 리스트의 전체 행)
			const rows = mailListElement.querySelectorAll("tr:not(.empty)");
	        if (rows.length < 1) { return; }
	
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
	        // tr 노드들 (메일 리스트의 전체 행)
			const rows = mailListElement.querySelectorAll("tr:not(.empty)");
			if (rows.length < 1) { return; }
			
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
			$.ajax({
				type	: "POST",
				contentType	: "application/json",
				data	: JSON.stringify({hrefArray: hrefArray}),
				url		: "/admin/ezEmail/appr/allHands/setApproval.do",
				async	: true,
				success	: function(result) {
					if ("OK" == result) {
						console.log(result);
						alert("<spring:message code='email.appr.pending.approve.complete' />");
					} else if ("DONE" == result) {
                        alert("<spring:message code='email.appr.pending.done' />");
					} else {
						var erroCount = result.split('_')[1];
						alert(erroCount + " <spring:message code='ezEmail.fail.count' />");
					}
					reloadPage();
				},
				error	: function(error) {
					console.log(error);
					alert("<spring:message code='ezEmail.ls013' />");
					reloadPage();
				}
			})
		}
	
		var appr_reject_arg = new Object();
		function setReject() {
            // tr 노드들 (메일 리스트의 전체 행)
			const rows = mailListElement.querySelectorAll("tr:not(.empty)");
			if (rows.length < 1) { return; }
			
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
		    GetOpenWindow("/ezEmail/appr/setReject.do", "setReject", 500, 275, "no");
		}
	
		function setRejectAction(memo) {
			// tr 노드들 (메일 리스트의 전체 행)
			const rows = mailListElement.querySelectorAll("tr:not(.empty)");
			if (rows.length < 1) { return; }
			
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
				url		: "/admin/ezEmail/appr/allHands/setRejectAction.do",
				async	: true,
				success	: function(result) {
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
					console.log(error);
					alert("<spring:message code='ezEmail.ls013' />");
					reloadPage();
				}
			})
		}
		
		function setTotalCount(cnt) {
            document.getElementById("totalcount").textContent = cnt;
        }
        
		// 리스트 가져오기
		function getLogList() {
			var sNum = pageStartNum;
			
		    return new Promise((resolve, reject) => {
		    	$.ajax({
					type: "POST",
					data: {
						"companyId" : COMPANYID,
						"startNum" : sNum
					},
					url: "/admin/ezEmail/appr/allHands/getPendingList.do",
					dataType: "json",
					success: function(data) {
						resolve(data);
					},
					error: function() {
						reject("error");
						alert("<spring:message code='common.error.msg'/>");
					}
				});
		    });
		}
	
		// 리스트 출력
		async function makeLogList() {
			const reJson = await getLogList(); 
			const list = reJson.resultArry;
			const addPlace = document.getElementById("apprMailList");
			addPlace.innerHTML = "";
			
			setTotalCount(reJson.totalCnt);
			pageTotalNum = (reJson.pageMax <= 0 ? 1 : reJson.pageMax);
			
			if (list && list.length > 0) {
				const tmp = document.getElementById("tmp-apprMailList");
				
				list.forEach(function(e, i) {
					const tmpClone = tmp.content.cloneNode(true);
					
					const tmpClone_TR = tmpClone.querySelector("tr");
					tmpClone_TR.id = "apprmail_" + i;
					tmpClone_TR.setAttribute("data-href", e.href);
					tmpClone_TR.setAttribute("data-sender", e.userId);
					tmpClone_TR.setAttribute("data-approver", e.approverId);
					tmpClone_TR.setAttribute("title", e.subject);
					
					const tmpClone_checkbox = tmpClone.querySelector(".tmp-apprMailList-checkbox");
					tmpClone_checkbox.querySelector("input").id = "check_" + i;
					tmpClone_checkbox.querySelector("label").setAttribute("for", "check_" + i);
					
					const tmpClone_subject = tmpClone.querySelector(".tmp-apprMailList-subject");
					tmpClone_subject.setAttribute("title", e.subject);
					tmpClone_subject.setAttribute("onclick", "openEmail(this.parentNode)");
					tmpClone_subject.style.cursor = "pointer";
					tmpClone_subject.textContent = e.subject;
					
					const tmpClone_senderName = tmpClone.querySelector(".tmp-apprMailList-senderName");
					tmpClone_senderName.setAttribute("title", e.senderName);
					tmpClone_senderName.setAttribute("onclick", "show_personinfo('"+e.senderEmail+"')");
					tmpClone_senderName.style.cursor = "pointer";
					tmpClone_senderName.textContent = e.senderName;
					
					const tmpClone_senderEmail = tmpClone.querySelector(".tmp-apprMailList-senderEmail");
					tmpClone_senderEmail.setAttribute("title", e.senderEmail);
					tmpClone_senderEmail.style.cursor = "default";
					tmpClone_senderEmail.textContent = e.senderEmail;
					
					const tmpClone_senderWriteDate = tmpClone.querySelector(".tmp-apprMailList-writeDate");
					tmpClone_senderWriteDate.setAttribute("title", e.writeDate);
					tmpClone_senderWriteDate.style.cursor = "default";
					tmpClone_senderWriteDate.textContent = e.writeDate;
					
					addPlace.appendChild(tmpClone); 
				});
			} else {
				const tmp = document.getElementById("tmp-noData");
				const tmpClone = tmp.content.cloneNode(true);
				addPlace.appendChild(tmpClone);
			}
			
			mkPageSelPage();
		}
		
		function goToPageByNum(num) {
			pageStartNum = num;
			makeLogList();
		}
		
		function selbeforeBlock() {
		    var num = ((parseInt(pageStartNum / pageBlockSize) - 1) * pageBlockSize) + 1;
			goToPageByNum(num)
		}
		function selafterBlock() {
		    var num = ((parseInt((pageStartNum - 1) / pageBlockSize) + 1) * pageBlockSize) + 1;
            goToPageByNum(num);
		}
		
	</script>
</body>
</html>