<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
	<title><spring:message code='email.appr.menu.allhands.sending' /></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
	<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
	<style>
		.apprList td {border:0; border-bottom: 1px solid #eaeaea; }
		#datepickerData, #btnDIV {line-height: 34px; display:inline-block;}
		#btnDIV > a {margin-left: 10px; vertical-align: middle; }
		#btnDIV > a > span {vertical-align: middle !important; }
		.totalcountDIV {display: inline-block; vertical-align: middle; margin: 3px 3px 0 0;}
	</style>
</head>
<body>
	<div>
    	<!-- 검색 -->
    	<div>
	        <table class="content">
	            <tbody>
	                <tr>
	                    <th><spring:message code='email.appr.search.duration' /></th> <% // 검색기간 %>
	                    <td>
	                    	<div id="datepickerData" class="input_wrap">
								<input id="Sdatepicker" type="text" style="width: 100px; text-align: center" readonly>
								<span class="bar">-</span>
								<input id="Edatepicker" type="text" style="width: 100px; text-align: center" readonly>
							</div>
	                    
							<div id="btnDIV">
						        <a class="imgbtn" onclick="makeLogList()"><span><spring:message code='email.appr.search' /></span></a> <% // 검색 %>
						        <a class="imgbtn" onclick="logExport()"><span><spring:message code='email.appr.search.download' /></span></a> <% // 내려받기 %>
							</div>
	                    </td>
	                </tr>
	            </tbody>
	        </table>
	    </div>
	    <br>
		<!--  리스트 상단 옵션 -->
		<div id="mainmenu">
			<ul class="">
				<li><span onclick="deleteApprLog()"><spring:message code='email.appr.delete' /></span></li> <% // 삭제 %>
				<div id="right">
					<span class="totalcountDIV"><span id="totalcount" class="txt_color"></span><spring:message code='common.count.unit' /></span>
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
					<col width="10%">
					<col width="15%">
					<col width="7%">
				</colgroup>
				<tbody>
					<tr>
                        <th>
                            <div class="custom_checkbox">
                                <input type="checkbox" id="Checkbox1" onchange="checkChange(this);">
                            </div>
                        </th>
                        <th><spring:message code='email.appr.th.subject' /></th> 			<% // 제목 %>
                        <th><spring:message code='email.appr.th.applicant.name' /></th> 	<% // 작성자명 %>
                        <th><spring:message code='email.appr.th.applicant.email' /></th> 	<% // 작성자주소 %>
                        <th><spring:message code='email.appr.th.application.date' /></th> 	<% // 승인요청일시 %>
                        <th><spring:message code='email.appr.th.approver.name' /></th> 		<% // 승인자명 %>
                        <th><spring:message code='email.appr.th.approver.date' /></th> 		<% // 승인일시 %>
                        <th><spring:message code='email.appr.th.approver.status' /></th> 	<% // 상태 %>
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
						<col width="10%">
						<col width="15%">
						<col width="7%">
					</colgroup>
					<tbody id="apprMailList"></tbody>
				</table>
			</div>
		</div> <!-- 리스트 END-->
	      
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
	        			<div class="custom_checkbox">
                            <input type="checkbox" id onchange="checkChangeEach(this);">
                            <label></label>
                        </div>
	                </span>
				</div>
			</td>
			<td class="tmp-apprMailList-subject"></td>
			<td class="tmp-apprMailList-senderName"></td>
			<td class="tmp-apprMailList-senderEmail"></td>
			<td class="tmp-apprMailList-writeDate"></td>
			<td class="tmp-apprMailList-approverName"></td>
			<td class="tmp-apprMailList-updatedt"></td>
			<td class="tmp-apprMailList-state"></td>
		</tr>
	</template>
    
	<form id="saveExcelForm" name="saveExcelForm" target="saveExcel" method="POST" action="/admin/ezEmail/appr/allHands/getCompleteLogListDownload.do">
		<input type="hidden" name="sDate" />
		<input type="hidden" name="eDate" />
		<input type="hidden" name="companyId" value="<c:out value='${companyId}'/>"/>
	</form>
	<iframe id="saveExcel" name="saveExcel" style="display:none"></iframe>
	
	<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/Newemail.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/date_component.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/datepicker.htc.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
	<script>
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
			callMsgDlgAppr(object.dataset.href);
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
		
		function deleteApprLog() {
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
				alert("<spring:message code='email.appr.no.list' />");
				return;
			}
	
			if (confirm("<spring:message code='email.appr.delete.confirm' />")) {
				deleteApprLogAction(hrefArray);
			}
		}
	
		function deleteApprLogAction(hrefArray) {
			$.ajax({
				type	: "POST",
				contentType	: "application/json",
				data	: JSON.stringify({hrefArray: hrefArray}),
				url		: "/admin/ezEmail/appr/allHands/deleteCompleteLogList.do",
				async	: true,
				success	: function(result) {
					if ("OK" !== result) {
						console.log(result);
						var erroCount = result.split('_')[1];
						alert(erroCount + " <spring:message code='ezEmail.fail.count' />");
					} else {
						alert("<spring:message code='common.success.msg.delete' />");
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
	
		// 승인로그 리스트 가져오기
		function getLogList() {
			var sDate = new Date($("#Sdatepicker").val());
			var eDate = new Date($("#Edatepicker").val());
			var sNum = pageStartNum;
			
		    return new Promise((resolve, reject) => {
		    	$.ajax({
					type: "POST",
					data: {
						"companyId" : COMPANYID,
						"startNum" : sNum,
						"sDate" : sDate,
						"eDate" : eDate,
					},
					url: "/admin/ezEmail/appr/allHands/getCompleteLogList.do",
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
	
		// 승인로그 리스트 출력
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
					tmpClone_senderName.setAttribute("title", e.userName);
					tmpClone_senderName.setAttribute("onclick", "show_personinfo('"+e.senderEmail+"')");
					tmpClone_senderName.style.cursor = "pointer";
					tmpClone_senderName.textContent = e.userName;
					
					const tmpClone_senderEmail = tmpClone.querySelector(".tmp-apprMailList-senderEmail");
					tmpClone_senderEmail.setAttribute("title", e.senderEmail);
					tmpClone_senderEmail.style.cursor = "default";
					tmpClone_senderEmail.textContent = e.senderEmail;
					
					const tmpClone_senderWriteDate = tmpClone.querySelector(".tmp-apprMailList-writeDate");
					tmpClone_senderWriteDate.setAttribute("title", e.writeDate);
					tmpClone_senderWriteDate.style.cursor = "default";
					tmpClone_senderWriteDate.textContent = e.writeDate;
					
					const tmpClone_approverName = tmpClone.querySelector(".tmp-apprMailList-approverName");
					tmpClone_approverName.setAttribute("title", e.approverName);
					tmpClone_approverName.setAttribute("onclick", "show_personinfo('"+e.approverEmail+"')");
					tmpClone_approverName.style.cursor = "pointer";
					tmpClone_approverName.textContent = e.approverName;
					
					const tmpClone_updatedt = tmpClone.querySelector(".tmp-apprMailList-updatedt");
					tmpClone_updatedt.setAttribute("title", e.updateDt);
					tmpClone_updatedt.style.cursor = "default";
					tmpClone_updatedt.textContent = e.updateDt;
					
					const tmpClone_state = tmpClone.querySelector(".tmp-apprMailList-state");
					tmpClone_state.setAttribute("title", e.stateStr);
					tmpClone_state.style.cursor = "default";
					tmpClone_state.textContent = e.stateStr;
					
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
			goToPageByNum(num)
		}
		
		function logExport() {
			saveExcelForm.sDate.value = new Date(Sdatepicker.value);
			saveExcelForm.eDate.value = new Date(Edatepicker.value);
			saveExcelForm.submit();
		}
	
		$(function() {
			$.datepicker.regional["<spring:message code='main.t0619' />"] = {
				closeText: "<spring:message code='main.t3' />",
				prevText: "<spring:message code='main.t0604' />",
				nextText: "<spring:message code='main.t0605' />",
				currentText: "<spring:message code='main.t0606' />",
				monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />",
					"<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
					"<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />",
					"<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
				monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />",
					"<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
					"<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />",
					"<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
				dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />",
					"<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />",
					"<spring:message code='main.t0627' />"],
				dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />",
					"<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />",
					"<spring:message code='main.t0627' />"],
				dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />",
					"<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />",
					"<spring:message code='main.t0627' />"],
				weekHeader: "Wk",
				dateFormat: "yy-mm-dd",
				firstDay: 0,
				isRTL: false,
				duration: 200,
				showAnim: "show",
				showMonthAfterYear: true
			};
			
			$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
			
			$("#Sdatepicker").datepicker({
				changeMonth: true,
				changeYear: true,
				autoSize: true,
				showOn: "focus",
				maxDate: 0,
				onSelect: function(selected) {
					$('#Edatepicker').datepicker("option", "minDate", selected);
				}
			});
			$("#Edatepicker").datepicker({
				changeMonth: true,
				changeYear: true,
				autoSize: true,
				showOn: "focus",
				maxDate: 0,
				onSelect: function(selected) {
					$('#Sdatepicker').datepicker("option", "maxDate", selected);
				}
			});
			var NowDate = new Date();
			$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			$("#Sdatepicker").datepicker('setDate', NowDate);
			$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			$("#Edatepicker").datepicker('setDate', NowDate);
			$(".ui-datepicker-trigger").style="opacity: 0.5; cursor: default;";
		});
	</script>
</body>
</html>