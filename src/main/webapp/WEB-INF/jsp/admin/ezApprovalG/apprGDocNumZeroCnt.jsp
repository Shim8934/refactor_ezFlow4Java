<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezApprovalG.csj02'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('ezApprovalG.e2', 'msg')}" type="text/css">
	<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeView.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			ListChange();
		});
		
		//저장Btn Action
		function Save() {
			var docNumZeroCnt = document.getElementById("docNumZeroCnt"); 
			
			if (!ValidationValues(docNumZeroCnt)) {
				docNumZeroCnt.focus();
				return;
			} else {
				SaveDocNumConfig();
			}
		}
		
		//입력필드 유효성 검사
		function ValidationValues(target) {
			var resultVal = false;
			
			if (target.value.trim() == "") {
				alert("<spring:message code='ezApprovalG.csj05'/>");
			} else if (!target.value.match(/^\d+$/)) {
				alert("<spring:message code='ezApprovalG.csj06'/>");
			} else if (parseInt(target.value) >= 9) {
				alert("8 <spring:message code='ezApprovalG.csj08'/>");
			} else if (parseInt(target.value) < 2) {
				alert("2 <spring:message code='ezApprovalG.csj07'/>");
			} else {
				resultVal = true;
			}
			
			return resultVal;
		}
		
		//유효성 검사 후, 저장 ajax
		function SaveDocNumConfig() {
			var companyID = document.getElementById("ListCompany").value;
			var docNumVal = document.getElementById("docNumZeroCnt").value;
			
			$.ajax({
            	type : "POST",
            	dataType: "text",
            	url : "/admin/ezApprovalG/setDocNumZeroCnt.do",
            	async : false,
            	data : 
            	{
            		docNumCnt : docNumVal,
            		companyID : companyID
            	},
            	success : function (result) {
            		alert("<spring:message code='ezApprovalG.t1581'/>");
            	},
            	error : function(e) {
            		alert("<spring:message code='ezApprovalG.t1296'/>")
            	}
            });
		}
		
		//선택 회사 조회Action
		function ListChange() {
			var companyID = document.getElementById("ListCompany").value;
			
			$.ajax({
            	type : "POST",
            	dataType: "text",
            	url : "/admin/ezApprovalG/getDocNumZeroCnt.do",
            	async : false,
            	data : 
            	{
            		companyID : companyID
            	},
            	success : function (result) {
            		document.getElementById("docNumZeroCnt").value = result;
            	},
            	error : function(e) {
            		alert("listChange() error!");
            	}
            });
		}
		
		//조회Action Complete메소드(조회값이 1개뿐이라 만들어놓기만)
		/* function listChange_Complete(val) {
			document.getElementById("docNumZeroCnt").value = val;
		} */
	</script>
</head>
<body class="mainbody">
	<h1>
		<spring:message code='ezApprovalG.csj02'/>
		<select class="companySelect" id="ListCompany" onChange="ListChange()">
			<c:forEach var="item" items="${list}">
				<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
			</c:forEach>
		</select>
	</h1>
	<div id="mainmenu" style="width: 350px;margin-top:30px">
		<div style="margin-top:3px;">▒&nbsp;<spring:message code='ezApprovalG.csj04'/></div>
		<div style="margin-top:3px;">▒&nbsp;<spring:message code='ezApprovalG.csj12'/></div>
		<br/>
		<table class="content">
			<tr>
				<th><spring:message code='ezApprovalG.csj09'/></th>
				<td>
					<spring:message code='ezApprovalG.csj11'/> : 2 ,
					<spring:message code='ezApprovalG.csj10'/> : 8
				</td>
			</tr>
			<tr>
				<th><spring:message code='ezApprovalG.csj03'/></th>
				<td><input type="text" id="docNumZeroCnt" style="width: 275px; padding-left: 5px;"/></td>
			</tr>
		</table>
		<div class="btnpositionJsp">
			<a class="imgbtn" onClick="Save()"><span><spring:message code='main.sp09' /></span></a>
	    </div>
	</div>
</body>
</html>