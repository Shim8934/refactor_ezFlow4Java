<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
	<title><spring:message code='email.appr.menu.normal.manager' /></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<style>
		#apprManagerUL > li {width: calc(100vw /3.4); min-width: 280px; padding:0 5px; box-sizing:border-box; }
		.apprManagerUL_listDIV {height:500px; overflow-y:auto; border:1px solid #f0f1f2; }
		
		.selected {background: #DBE1E7; }
	</style>
</head>
<body>
	<div>
		<ul id="apprManagerUL" class="contentlayout">
			<!-- 발송허용 도메인 -->
            <li id="allowedDomain" class="contentlayout_left">
	            <div id="mainmenu">
					<ul>
						<li onClick="addAllowedDomain()"><span><spring:message code="common.add"/></span></li> <% //추가 %>
						<li onClick="delAllowedDomain()"><span><spring:message code="common.delete"/></span></li> <% //삭제 %>
				    </ul>
				</div>
             	<div class="apprManagerUL_listDIV">
	             	<table class="mainlist" style="width: 100%; ">
	             		<thead>
	             			<tr><th><spring:message code="email.appr.th.allow.domain"/></th></tr> <% //발송허용 도메인 %>
	             		</thead>
	             	</table>
	             	<div>
		             	<table id="allowedDomainListTable" class="mainlist mainlistBODY" style="width: 100%; "></table>
	             	</div>
	             </div>
            </li>
			<!-- 승인자 -->
            <li id="approver" class="contentlayout_left">
	            <div id="mainmenu">
					<ul>
						<li onClick="addApprover()"><span><spring:message code="common.add"/></span></li> <% //추가 %>
						<li onClick="delApprover()"><span><spring:message code="common.delete"/></span></li> <% //삭제 %>
				    </ul>
				</div>
             	<div class="apprManagerUL_listDIV">
	             	<table class="mainlist" style="width: 100%; ">
	             		<thead>
	             			<tr colspan="3"><th><spring:message code="email.appr.th.approver"/></th></tr> <% //승인자 %>
	             		</thead>
	             	</table>
	             	<div>
		             	<table id="approverListTable" class="mainlist mainlistBODY" style="width: 100%; "></table>
	             	</div>
	             </div>
            </li>
			<!-- 예외자 -->
            <li id="exceptionUser" class="contentlayout_left">
	            <div id="mainmenu">
					<ul>
						<li onClick="addExceptionUser()"><span><spring:message code="common.add"/></span></li> <% //추가 %>
						<li onClick="delExceptionUser()"><span><spring:message code="common.delete"/></span></li> <% //삭제 %>
				    </ul>
				</div>
             	<div class="apprManagerUL_listDIV">
	             	<table class="mainlist" style="width: 100%; ">
	             		<thead>
	             			<tr colspan="3"><th><spring:message code="email.appr.th.exception"/></th></tr> <% //예외자 %>
	             		</thead>
	             	</table>
	             	<div>
		             	<table id="exceptionListUserTable" class="mainlist mainlistBODY" style="width: 100%; "></table>
	             	</div>
	             </div>
            </li>
		</ul>
    </div>
    
    <template id="tmp-noData">
		<tr class="noDataTR"><td><spring:message code="main.t00026"/></td></tr>
    </template>
	<template id="tmp-allowedDomainList">
		<tr>
			<td class="tmp-allowedDomainList-domain"></td>
		</tr>
	</template>
	<template id="tmp-approverList">
		<tr>
			<td class="tmp-approverList-name"></td>
			<td class="tmp-approverList-dept"></td>
			<td class="tmp-approverList-title"></td>
		</tr>
	</template>
	<template id="tmp-exceptionUserList">
		<tr>
			<td class="tmp-exceptionUserList-name"></td>
			<td class="tmp-exceptionUserList-dept"></td>
			<td class="tmp-exceptionUserList-title"></td>
		</tr>
	</template>
	
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script>
	const COMPANYID = "<c:out value='${companyId}'/>";
		
	window.onload = function () {
		initPage();
	}
		
	function initPage() {
		makeAllowedDomainList();
		makeApproverList();
		makeExceptionUserList();
	}	
	
	// 도메인 리스트 가져오기
	function getAllowedDomainList() {
		return new Promise((resolve, reject) => {
			$.ajax({
				type: "POST",
				data: {
					"companyId" : COMPANYID
				},
				url: "/admin/ezEmail/appr/getAllowDomainList.do",
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
	
	// 도메인 리스트 출력
	async function makeAllowedDomainList() {
		const list = await getAllowedDomainList();
		const addPlace = document.getElementById("allowedDomainListTable");
		addPlace.innerHTML = "";
		
		if (list && list.length > 0) {
			const tmp = document.getElementById("tmp-allowedDomainList");
			
			list.forEach(function(e, i) {
				const tmpClone = tmp.content.cloneNode(true);
				const tmpClone_domain = tmpClone.querySelector(".tmp-allowedDomainList-domain");
				tmpClone_domain.textContent = e;
				
				tmpClone.querySelector("tr").setAttribute("domainname", e);
				
				addPlace.appendChild(tmpClone);
			});
		} else {
			const tmp = document.getElementById("tmp-noData");
			const tmpClone = tmp.content.cloneNode(true);
			addPlace.appendChild(tmpClone);
		}
	}
	
	function addAllowedDomain() {
		addAllowedDomainPopUp();
	}
	
	//도메인 추가 레이어 팝업
	var addAllowedDomain_arg = new Object();
	function addAllowedDomainPopUp() {
	    addAllowedDomain_arg.companyId = COMPANYID;
	    addAllowedDomain_arg.save = saveDomain;
	    addAllowedDomain_arg.ok = makeAllowedDomainList;
	
	    GetOpenWindow("/admin/ezEmail/appr/allowDomainPopUp.do", "", 560, 165, "no");
	}
	
	// 도메인 추가
	function saveDomain(domain) {
		return new Promise((resolve, reject) => {
			$.ajax({
				type : "POST",
				url : "/admin/ezEmail/appr/addAllowDomain.do",
				data : {
					companyId : COMPANYID,
					domainName : domain
				},
				success : function(data) {
					resolve(data);
				},
				error : function(e) {
					resolve("ERROR");
				}
			});
		});
	}
	
	function delAllowedDomain() {
		let list = $("#allowedDomainListTable tr.selected");
		
		if (list.length < 1) {
			alert("<spring:message code='common.warning.msg.select'/>"); return;
		}
		
		let domainList = new Array();
		list.each(function(i, e) {
			domainList.push(e.getAttribute("domainname"));
		});
		
	    deleteAllowedDomainList(domainList);
	}
	
	// 도메인 삭제 
	function deleteAllowedDomainList(domainList) {
		$.ajax({
			type: "POST",
			data: {
				"companyId" : COMPANYID,
				"domainList" : domainList
			},
			url: "/admin/ezEmail/appr/deleteAllowDomain.do",
			success: function(data) {
				alert("<spring:message code='common.success.msg.delete'/>");
				makeAllowedDomainList();
			},
			error: function() {
				alert("<spring:message code='common.error.msg'/>");
			}
		});
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
	
	//승인자 리스트 출력
	async function makeApproverList() {
		const list = await getApproverList(); 
		const addPlace = document.getElementById("approverListTable");
		addPlace.innerHTML = "";
		
		if (list && list.length > 0) {
			const tmp = document.getElementById("tmp-approverList");
			
			list.forEach(function(e, i) {
				const tmpClone = tmp.content.cloneNode(true);
	
				const tmpClone_TR = tmpClone.querySelector("tr");
				tmpClone_TR.setAttribute("data-userId", e.userId);
	
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
	
	function addApprover() {
		addApproverPopUp();
	}
	
	//승인자 추가 레이어 팝업
	var addUser_arg;
	function addApproverPopUp() {
		addUser_arg = new Object();
		addUser_arg.companyId = COMPANYID;
		addUser_arg.save = saveApprover;
		addUser_arg.ok = makeApproverList;
		addUser_arg.getUserList = getApproverList;
	
	    var popUrl = "/admin/ezEmail/appr/addApproverPopUp.do?companyId=" + COMPANYID;
	
	    GetOpenWindow(popUrl, "", 1100, 730, "no");
	}
	
	// 승인자 추가
	function saveApprover(userList) {
		return new Promise((resolve, reject) => {
			$.ajax({
				type: "POST",
				data: {
					"companyId" : COMPANYID,
					"userList" : userList
				},
				url: "/admin/ezEmail/appr/addApprover.do",
				success: function(data) {
					resolve("OK");
				},
				error: function(err) {
					resolve("ERROR");
				}
			});
		});
	}
	
	function delApprover() {
		let list = $("#approverListTable tr.selected");
		
		if (list.length < 1) {
			alert("<spring:message code='common.warning.msg.select'/>"); return;
		}
		
		let userList = new Array();
		list.each(function(i, e) {
			userList.push(e.getAttribute("data-userId"));
		});
		
		deleteApproverList(userList);
	}
	
	//승인자 삭제 
	function deleteApproverList(userList) {
		$.ajax({
			type: "POST",
			data: {
				"companyId" : COMPANYID,
				"userList" : userList
			},
			url: "/admin/ezEmail/appr/deleteApprover.do",
			success: function(data) {
				alert("<spring:message code='common.success.msg.delete'/>");
				makeApproverList();
			},
			error: function() {
				alert("<spring:message code='common.error.msg'/>");
			}
		});
	}
	
	//예외자 리스트 가져오기
	function getExceptionUserList() {
		return new Promise((resolve, reject) => {
		 	$.ajax({
				type: "POST",
				data: {
					"companyId" : COMPANYID
				},
				url: "/admin/ezEmail/appr/getExceptionUserList.do",
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
	
	//예외자 리스트 출력
	async function makeExceptionUserList() {
		const list = await getExceptionUserList(); 
		const addPlace = document.getElementById("exceptionListUserTable");
		addPlace.innerHTML = "";
		
		if (list && list.length > 0) {
			const tmp = document.getElementById("tmp-exceptionUserList");
			
			list.forEach(function(e, i) {
				const tmpClone = tmp.content.cloneNode(true);
	
				const tmpClone_TR = tmpClone.querySelector("tr");
				tmpClone_TR.setAttribute("data-userId", e.userId);
	
				const tmpClone_userName = tmpClone.querySelector(".tmp-exceptionUserList-name");
				tmpClone_userName.textContent = e.userName;
	
				const tmpClone_userDept = tmpClone.querySelector(".tmp-exceptionUserList-dept");
				tmpClone_userDept.textContent = e.deptName;
	
				const tmpClone_userTitle = tmpClone.querySelector(".tmp-exceptionUserList-title");
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
	
	function addExceptionUser() {
		addExceptionUserPopUp();
	}
	
	//예외자 추가 레이어 팝업
	function addExceptionUserPopUp() {
		addUser_arg = new Object();
		addUser_arg.companyId = COMPANYID;
		addUser_arg.save = saveExceptionUser;
		addUser_arg.ok = makeExceptionUserList;
		addUser_arg.getUserList = getExceptionUserList;
	
	    GetOpenWindow("/admin/ezEmail/appr/addExceptionUserPopUp.do", "", 1100, 730, "no");
	}
	
	//예외자 추가
	function saveExceptionUser(userList) {
		return new Promise((resolve, reject) => {
			$.ajax({
				type: "POST",
				data: {
					"companyId" : COMPANYID,
					"userList" : userList
				},
				url: "/admin/ezEmail/appr/addExceptionUser.do",
				success: function(data) {
					resolve("OK");
				},
				error: function(err) {
					resolve("ERROR");
				}
			});
		});
	}
	
	function delExceptionUser() {
		let list = $("#exceptionListUserTable tr.selected");
		
		if (list.length < 1) {
			alert("<spring:message code='common.warning.msg.select'/>"); return;
		}
		
		let userList = new Array();
		list.each(function(i, e) {
			userList.push(e.getAttribute("data-userId"));
		});
		
		deleteExceptionUserList(userList);
	}
	
	//승인자 삭제 
	function deleteExceptionUserList(userList) {
		$.ajax({
			type: "POST",
			data: {
				"companyId" : COMPANYID,
				"userList" : userList
			},
			url: "/admin/ezEmail/appr/deleteExceptionUser.do",
			success: function(data) {
				alert("<spring:message code='common.success.msg.delete'/>");
				makeExceptionUserList();
			},
			error: function() {
				alert("<spring:message code='common.error.msg'/>");
			}
		});
	}
	
	// event
	$(document).on("click", ".mainlistBODY tr:not(.noDataTR)", function(event) {
		let isCtrl 	= event.ctrlKey;
		let isShift = event.shiftKey;
		let parentTable = $(this).parent("table");
		let lastSelectedIndex = parentTable.attr("lastSelectedIndex");
		let nowSelectedIndex = $(this).index();
		
		if (isCtrl) {
			$(this).toggleClass("selected");
		} else if (isShift && lastSelectedIndex) {
			let s = Math.min(nowSelectedIndex, lastSelectedIndex);
			let e = Math.max(nowSelectedIndex, lastSelectedIndex);
	
			parentTable.find("tr").removeClass("selected");
			for (var i = s; i <= e; i++) {
				parentTable.find("tr:eq("+i+")").addClass("selected");
	        }
		} else {
			parentTable.find("tr").removeClass("selected");
			$(this).addClass("selected");
		}
		
		parentTable.attr("lastSelectedIndex", nowSelectedIndex);
	});
	</script>
</body>
</html>