<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPersonal.t4465'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			var apprAttachLimitMax = parseInt("<c:out value='${apprAttachLimitMax}'/>");
		
			document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        
		        selectCompanyID();
		    };
		    
		    // 현재 선택된 회사의 첨부파일 개수제한 설정값 표출
		    function selectCompanyID() {
		    	var pCompanyID = document.getElementById("ListCompany").value;
		    	
            	$.ajax({
                	type : "GET",
                	url : "/admin/ezApprovalG/getAttachLimit.do",
                	async : false,
                	cache : false,
                	data : {
                		companyID : pCompanyID
                	},
                	success : function(result) {
                		if (result != -1) {
                			document.getElementById("attachLimit").value = result;
                		} else {
                			document.getElementById("attachLimit").value = "";
                		}
                	},
                	error : function() {
                		alert("<spring:message code='ezApprovalG.hsbAL06'/>");
                	}
                });
		    }
		    
			// 숫자가 아닌 값 전부 제거 
		    function checkNumber(obj) {
		    	obj.value = obj.value.replace(/[^(0-9)]/gi, '');
			}
		    
		    // 개수제한 저장
		    function saveAttachLimit() {
		    	var numVal = document.getElementById("attachLimit").value;
		    	numVal = numVal.replace(/[^(0-9)]/gi, ''); // 숫자가 아닌 값 최종 제거
		    	
		    	if (numVal.trim() == "") {
		    		numVal = -1;
		    	}
		    	
		    	numVal = parseInt(numVal); // 정수로 전환
		    	if (numVal == -1) {
		    		alert("<spring:message code='ezApprovalG.hsbAL07'/>");
		    		selectCompanyID();
		    		return;
		    	}
		    	if (numVal > apprAttachLimitMax) { // 최대값 제한
		    		alert("<spring:message code='ezApprovalG.hsbAL02' arguments='" + apprAttachLimitMax + "'/>");
		    		selectCompanyID();
		    		return;
		    	}
		    	
		    	var pCompanyID = document.getElementById("ListCompany").value;
            	$.ajax({
                	type : "POST",
                	url : "/admin/ezApprovalG/saveAttachLimit.do",
                	async : false,
                	data : {
                		companyID : pCompanyID,
                		attachLimit : numVal
                	},
                	success : function(result) {
                		alert("<spring:message code='ezApprovalG.hsbAL08'/>");
                	},
                	error : function() {
                		alert("<spring:message code='ezApprovalG.hsbAL09'/>");
                	}
                });
            	
            	selectCompanyID();
		    }
		    
		    // 개수제한 삭제
		    function deleteAttachLimit() {
		    	var pCompanyID = document.getElementById("ListCompany").value;
		    	
		    	if (confirm("<spring:message code='ezApprovalG.hsbAL03'/>")) {
	            	$.ajax({
	                	type : "POST",
	                	url : "/admin/ezApprovalG/deleteAttachLimit.do",
	                	async : false,
	                	data : {
	                		companyID : pCompanyID
	                	},
	                	success : function(result) {
	                		document.getElementById("attachLimit").value = "";
	                		alert("<spring:message code='ezApprovalG.hsbAL10'/>");
	                	},
	                	error : function() {
	                		alert("<spring:message code='ezApprovalG.hsbAL11'/>");
	                	}
	                });
		    	}
		    }
		
		</script>
	</head>
	<body class="mainbody" marginwidth="0" marginheight="0">
		<h1><spring:message code='ezApprovalG.hsbAL01'/>
			<span class="title_bar"><img src="/images/name_bar.gif"></span>
		    <span>
			    <select class="companySelect" id="ListCompany" onChange="selectCompanyID()">
		        	<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
	            	</c:forEach>
			    </select>
		    </span>
		</h1>
		<br>
		<div class = "txt">
			<div><spring:message code='ezApprovalG.hsbAL04' arguments="${apprAttachLimitMax}"/></div>
			<div style="margin-top:3px"><spring:message code='ezApprovalG.hsbAL05'/></div>
			<br>
		</div>
		
		<table class="content" style="width:520px;margin-top:20px">
			<tr>
				<th><spring:message code='ezApprovalG.hsbAL01'/></th>
				<td>
					<input type="text" id="attachLimit" style="width:100%;" onKeyPress="checkNumber(this);" onKeyDown="checkNumber(this);" onKeyUp="checkNumber(this);" onMouseDown="checkNumber(this);"/>
				</td>
			</tr>
		</table>
		
		<div style="width:520px;text-align:center;margin-top:15px;">
			<div class="btnpositionJsp">
		    	<a class="imgbtn" onClick="saveAttachLimit()"><span><spring:message code='ezPersonal.t34'/></span></a>
		    	<a class="imgbtn" onClick="selectCompanyID()"><span><spring:message code='ezPersonal.t13'/></span></a>
		    	<a class="imgbtn" onClick="deleteAttachLimit()"><span><spring:message code='ezApprovalG.t1301'/></span></a>
	    	</div>
	  	</div>
		
	</body>
</html>