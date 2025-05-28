<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title><spring:message code='email.appr.approver.specify'/></title>
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<style>
		.descDiv>span {display: inline-block; width: 100%; }
		.searchInputDiv {width: 84%;display: inline-block;position: relative;border: 1px solid #dedede;box-sizing: border-box;border-radius: 2px;outline: none;}
		.searchInputDiv input {width: 94%;border: none; }
		.searchInputDiv a {position: absolute; right: 10px; top: 50%; transform: translateY(-50%); }
		table.com_list tr>th, table.com_list tr>td {width: 33%; }
		tr.noDataTR>td {text-align: center; }
		.selected {background: #DBE1E7; }
	</style>
</head>
<body class="popup approverSettingPopUp">
	<h1>
		<spring:message code='email.appr.approver.specify' /> <% // 발송 승인자 지정 %>
	</h1>
	<div id="close">
		<ul><li><span onclick="cancel();"></span></li></ul>
	</div>
	
	<div class="descDiv">
		<span>- <spring:message code='email.appr.approver.specify.info1' /></span>
		<span>- <spring:message code='email.appr.approver.specify.info2' /></span>
	</div>

	<div class="mt15">
		<!-- 검색 -->
		<div class="searchDiv">
			<select id="searchType" style="height: 27px; margin-right: 0px; border: 1px solid #cbcbcb; width: 15%; display: inline; ">
				<option value="displayname" selected><spring:message code='main.t76' /></option> <% // 이름 %>
				<option value="deptname"><spring:message code='main.t75' /></option> <% // 부서 %>
				<option value="title"><spring:message code='main.t77' /></option> <% // 직위 %>
			</select>
			<div class="searchInputDiv">
				<input id="searchValue" type="text" style="width: 95%; border: none; ">
				<a><img src="/images/bsearch_new2.png" border="0" onclick="approverSearch()"></a>
			</div>
		</div>
		<!-- 리스트 -->
		<div class="mt15">
			<!-- header -->
			<table class="mainlist" style="width: 100%; ">
				<tbody>
					<tr>
						<th><spring:message code='main.t76' /></th> <% // 이름 %>
						<th><spring:message code='main.t75' /></th> <% // 부서 %>
						<th><spring:message code='main.t77' /></th> <% // 직위 %>
					</tr>
				</tbody>
			</table>
			<!-- body -->
			<div class="apprList" style="height:calc(100vh - 48vh); overflow:auto; border: 1px solid #eaeaea;">
				<table id="approverListTable" class="mainlist mainlistBODY" style="width: 100%; "></table>
			</div>
		</div> <!-- 리스트 END-->
			
		<div>
			<div class="btnposition btnpositionNew">
				<a class="imgbtn" onclick="selectApprover(0)"><span><spring:message code='email.appr.approver' /></span></a> <% // 승인자 %>
				<a class="imgbtn" onclick="selectApprover(1)"><span><spring:message code='email.appr.approver.agent' /></span></a> <% // 대결자 %>
			</div>
		</div>
	</div> <!-- layout END -->
	
    <template id="tmp-noData">
		<tr class="noDataTR"><td><spring:message code="main.t00026"/></td></tr>
    </template>
	<template id="tmp-approverList">
		<tr>
			<td class="tmp-approverList-name"></td>
			<td class="tmp-approverList-dept"></td>
			<td class="tmp-approverList-title"></td>
		</tr>
	</template>
</body>
<script>
const COMPANYID = "<c:out value='${companyId}'/>";
const MY_ACCOUNT = "<c:out value='${userId}'/>";
const APPROVER_ACCOUNT = "<c:out value='${approverAccount}'/>";
const APPROVER_NAME = "<c:out value='${approverName}'/>";
const APPROVER_COUNT = "<c:out value='${approverCount}'/>";
const SHAREID = "<c:out value='${shareId}'/>";
const P_SAVEMODE = parent.appr_approverSetting_arg.savemode;
const P_COMPLETE_F = parent.appr_approverSetting_arg.complete;
var searchType = "";
var searchValue = "";

window.onload = function () {
	initPage();
}
	
function initPage() {
	makeApproverList();
}	

function cancel() {
   	parent.DivPopUpHidden();
}

//승인자 리스트 가져오기
function getApproverList() {
  return new Promise((resolve, reject) => {
  	$.ajax({
			type: "POST",
			data: {
				"companyId" : COMPANYID
			},
			url: "/admin/ezEmail/appr/getApproverList.do",
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

//승인자 리스트 검색
function getApproverSearchList() {
	return new Promise((resolve, reject) => {
		if (searchValue.trim() == "") { return []; }
		
		$.ajax({
				type: "POST",
				data: {
					"companyId" : COMPANYID,
					"searchType" : searchType,
					"searchValue" : searchValue
				},
				url: "/admin/ezEmail/appr/getApproverSearchList.do",
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

//승인자 리스트 출력
async function makeApproverList(search) {
	const list = (typeof(search) == "undefined" || !search) ? await getApproverList() : await getApproverSearchList(); 
	const addPlace = document.getElementById("approverListTable");
	addPlace.innerHTML = "";
	
	if (list && list.length > 0) {
		const tmp = document.getElementById("tmp-approverList");
		
		list.forEach(function(e, i) {
			if (e.userId == "${userId}") {return; }
			
			const tmpClone = tmp.content.cloneNode(true);

			const tmpClone_TR = tmpClone.querySelector("tr");
			tmpClone_TR.setAttribute("data-userId", e.userId);
			tmpClone_TR.setAttribute("data-userName", e.userName);
			tmpClone_TR.style.cursor = "pointer";

			const tmpClone_userName = tmpClone.querySelector(".tmp-approverList-name");
			tmpClone_userName.textContent = e.userName;

			const tmpClone_userDept = tmpClone.querySelector(".tmp-approverList-dept");
			tmpClone_userDept.textContent = e.deptName;

			const tmpClone_userTitle = tmpClone.querySelector(".tmp-approverList-title");
			tmpClone_userTitle.textContent = e.userTitle;
			
			addPlace.appendChild(tmpClone);
		});
	} else {
		const tmp = document.getElementById("tmp-noData");
		const tmpClone = tmp.content.cloneNode(true);
		
		tmpClone.querySelector("tr").setAttribute("colspan", 3)
		
		addPlace.appendChild(tmpClone);
	}
}

// 승인자 검색
function approverSearch() {
	searchValue = $("#searchValue").val();
	searchType = $("#searchType").val();
	
	let s = (searchValue.trim() != "");
	makeApproverList(s);
}

// 승인자/대결자 선택
async function selectApprover(mode) { <% // 0:승인자, 1:대결자 %>
	let approver = "";
	let approverName = "";
	let confirmMsg = "";

	if (mode == 0) {
		if (SHAREID == "" && MY_ACCOUNT == APPROVER_ACCOUNT) {
			alert("<spring:message code='email.appr.application.warning.msg.approver'/>"); <% // 메일승인 관리자는 대결자를 지정해 주세요. %>
			return;
		}
		
		if (APPROVER_COUNT == 0 || SHAREID != "") {
			alert("<spring:message code='email.appr.application.warning.msg.approver.not.exist'/>"); return; <% // 승인자가 없습니다. 대결자를 선택해 주세요. %>
		} else if (APPROVER_COUNT > 1) {
			alert("<spring:message code='email.appr.application.warning.msg.approver.several'/>"); return; <% // 동일 부서내 승인자가 1명일 때만 사용 가능합니다. 대결자를 선택해주세요. %>
		} else if (APPROVER_COUNT == 1 && APPROVER_ACCOUNT != "") {
			approver = APPROVER_ACCOUNT;
			approverName = APPROVER_NAME;
			confirmMsg = "<spring:message code='email.appr.application.confirm.msg.approver'/>"; <% // 메일 승인 신청을 하시겠습니까? \n 승인자:  %>
		}
	} else {
		let selectTR = $("#approverListTable tr.selected");
		
		if (selectTR.length < 1) {
			alert("<spring:message code='common.warning.msg.select'/>"); return;
		} else if (selectTR.length > 1) {
			alert("<spring:message code='common.warning.msg.select.one'/>"); return;
		}
		
		if (MY_ACCOUNT == selectTR[0].getAttribute("data-userId")) {
			alert("<spring:message code='email.appr.application.warning.msg.approver'/>"); return; <% // 메일승인 관리자는 대결자를 지정해 주세요. %>
		} else {
			approver = selectTR[0].getAttribute("data-userId");
			approverName = selectTR[0].getAttribute("data-userName");
			confirmMsg = "<spring:message code='email.appr.application.confirm.msg.agent'/>"; <% // 메일 승인 신청을 하시겠습니까? \n 대결자:  %>
		}
	}
	
	if (await confirm(confirmMsg + approverName)) {
		P_COMPLETE_F(P_SAVEMODE, approver);
		cancel();
	}
}

//event
$(document).on("keyup", "#searchValue", function(event){
	if(event.keyCode == 13) { approverSearch(); }
})
$(document).on("click", ".mainlistBODY tr:not(.noDataTR)", function(event) {
	let parentTable = $(this).parent("table");
	
	parentTable.find("tr").removeClass("selected");
	$(this).addClass("selected");
});
</script>
</html>