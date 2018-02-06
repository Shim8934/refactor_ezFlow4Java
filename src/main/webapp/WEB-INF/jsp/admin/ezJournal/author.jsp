<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.t6000' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript">		
	    
			function changeSelectCompany(val) {			    
				var url = "/admin/ezJournal/author.do";
				parent.frames["right"].location.href = url+"?companyId="+val;
			}
			
			function insertAuth(userId){
				window.open(url, windowName, windowFeatures, optionalArg4);
			}
			
		    function Cancel_Click() {
		        window.location.reload(true);
		    }
		    function Change_Click() {
		    	var formData = $("form.journalForm").serialize();
		    	
		        $.ajax({
		    		type : "POST",
		    		url : "/admin/ezJournal/updatreFormType.do",
		    		data :formData,
		    		success: function(result) {
		    			alert("<spring:message code='ezSchedule.t4012' />");
		    		}
		        });
		    }
		</script>
		<style>
			tr:hover{background:#eee; color:#fff;}
		</style>
	</head>
	<body class="mainbody"> 
		<h1><spring:message code='ezJournal.t2' /></h1>
		<form class="journalForm">
			<div id="mainmenu">
				<span><b><spring:message code = 'ezApprovalG.t1512' /></b></span>
	            <select name="companyId" onchange="changeSelectCompany(this.value)">
	            	<c:forEach items="${compList}" var="company">
		            	<option value="${company.companyId }"
	            		<c:if test="${company.selected eq 'selected' }">
	            			selected
	            		</c:if>
		            	>${company.companyName }</option>
	            	</c:forEach>
	            </select>
			</div>
			<br/>
			<div id="mainmenu">
	  			<ul>
					<li><span onClick=""><spring:message code='ezJournal.t36' /></span></li>
					<li><span onClick=""><spring:message code='ezJournal.t37' /></span></li>
	  			</ul>
			</div>
			<table class="mainlist" style="width:80%;">
			    <tr>
			        <th style="text-align: center; width:20%;"><spring:message code='ezJournal.t38' /></th>
			        <th style="text-align: center; width:20%;"><spring:message code='ezJournal.t39' /></th>
			        <th style="text-align: center; width:20%;"><spring:message code='ezJournal.t40' /></th>
			        <th style="text-align: center; width:40%;"><spring:message code='ezJournal.t41' /></th>
			    </tr>
			    <c:choose>
				    <c:when test="${fn:length(authList) ne 0}">
					    <c:forEach items="${authList }" var="auth">
					    	<tr ondblclick="insertAuth(${auth.userId})">
					    		<td style="text-align: center;">${auth.userName } </td>
					    		<td style="text-align: center;">${auth.jikwi } </td>
					    		<td style="text-align: center;">${auth.deptName } </td>
					    		<td style="text-align: center;">${auth.authDept } </td>
					    	</tr>
					    </c:forEach>
				    </c:when>
				    <c:otherwise>
				    	<tr>
				    		<td style="text-align: center;" colspan="4"><spring:message code='ezJournal.t124' /></td>
				    	</tr>
				    </c:otherwise>
			    </c:choose>
			    
			</table>
		</form>
	</body>
</html>

