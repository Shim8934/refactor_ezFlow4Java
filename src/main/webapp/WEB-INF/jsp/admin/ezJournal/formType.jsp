<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezJournal.t224' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript">		
	    
			function changeCompany(val) {
				var url = "/admin/ezJournal/formType.do";
				parent.frames["right"].location.href = url+"?companyId="+val;
			}

			
		    function Cancel_Click() {
		        window.location.reload(true);
		    }
		    function Change_Click() {
		    	var formData = $("form.journalForm").serialize();
		    	var companyId = $("select[name='companyId']").val();
		    	formData += "&companyId=" + companySelectID;
		        $.ajax({
		    		type : "POST",
		    		url : "/admin/ezJournal/updatreFormType.do",
		    		data :formData,
		    		success: function(result) {
		    			if(result.status=='ok'){
			    			alert("<spring:message code='ezJournal.t137' />");
			    			window.location.reload(true);
		    			} else {
		    				alert("<spring:message code='ezJournal.t225' />");
		    			}
		    		}
		        });
		    }
		</script>
		<style>
			.content td {
				text-align: center;
				width: 100px;
			}
			.content th{
				width:50px;
			}
		</style>
	</head>
	<body class="mainbody"> 
		<h1>
			<spring:message code='ezJournal.t2' />
			<jsp:include page="/WEB-INF/jsp/admin/companySelect.jsp">
				<jsp:param name="companySelectID" value="${selectedCompany}" />
			</jsp:include>
		</h1>
		<form class="journalForm">
			<table class="content" style="width: 400px; margin-left: 5px; margin-top:30px">
			    <tr>
			        <th style="text-align: center; width:250px;"><spring:message code='ezJournal.t12' /></th>
			        <th style="text-align: center; width:50px;"><spring:message code='ezJournal.t13' /></th>
			        <th style="text-align: center; width:50px;"><spring:message code='ezJournal.t14' /></th>
			    </tr>
			    <c:forEach items="${typeList }" var="type">
			    <tr>
			    	<td style="text-align: center;"><spring:message code="${type.journaltypeId }" /></td>
			    	<c:choose>
				    	<c:when test="${type.journalUse eq 'use'}">
					    	<td style="text-align: center;">
					    		<input type="radio" name="${type.journaltypeId }" value="use" checked/>
					    	</td>
					    	<td style="text-align: center;">
					    		<input type="radio" name="${type.journaltypeId }" value="no"/>
					    	</td>
				    	</c:when>
				    	<c:otherwise>
					    	<td style="text-align: center;">
					    		<input type="radio" name="${type.journaltypeId }" value="use" />
					    	</td>
					    	<td style="text-align: center;">
					    		<input type="radio" name="${type.journaltypeId }" value="no" checked/>
					    	</td>
				    	</c:otherwise>
			    	</c:choose>
			    	</tr>
			    </c:forEach>
			    
			</table>
			<div class="btnpositionJsp" style="width: 391px;">
			    <a class="imgbtn" onclick="Change_Click()"><span><spring:message code='ezJournal.t26' /></span></a>
			    <a class="imgbtn" onclick="Cancel_Click()"><span><spring:message code='ezJournal.t16' /></span></a>
			</div>
		</form>
	</body>
</html>

