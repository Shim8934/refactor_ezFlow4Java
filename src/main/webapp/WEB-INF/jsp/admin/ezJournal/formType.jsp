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
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript">		
	    
			function journal_get_formuse(val) {			    
// 			    $.ajax({
// 		    		type : "POST",
// 		    		dataType : "json",
// 		    		async : true,
// 		    		url : "/admin/ezJournal/journalGetFormUse.do",
// 		    		data : {
// 		    			COMPANYID  : document.getElementById("ListCompany")[document.getElementById("ListCompany").selectedIndex].value		    			
// 		    		},
// 		    		success: function(result) {
		    			
// 		    			var leng = Object.keys(result.typeList).length;
		    			
// 		    			for(var i = 0; i < leng; i++) {
// 		    				if (result.typeList[i].journalUse == "use") {
// 		    					document.getElementById("USE" + i).checked = true;
// 		    				} else {
// 		    					document.getElementById("NUSE" + i).checked = true;
// 		    				}
// 		    			}
// 		    		}
// 		        });
				window.location.search += "&companyId="+val;
			}	
			
		    function Cancel_Click() {
		        window.location.reload(true);
		    }
		    function Change_Click() {	
		    	var strtype = "";
		    	for (var i = 0; i < 6; i++) {
			    	if (document.getElementById("USE" + i).checked == true) {
			    		strtype += "use";
			    	} else {
			    		strtype += "no";
			    	}
		    	}
		    	
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezSchedule/journalSaveFormUse.do",
		    		data : {
		    			COMPANYID  : document.getElementById("ListCompany")[document.getElementById("ListCompany").selectedIndex].value,
		    			FORMUSE : strtype
		    		},
		    		success: function(text) {
		    			alert("<spring:message code='ezSchedule.t4012' />");
		    		}
		        });
		    }
		</script>
		<style>
			.content td {
				text-align: center;
			}
		</style>
	</head>
	<body class="mainbody"> 
		<h1><spring:message code='ezJournal.t2' /></h1>
		<form id="Form1" method="post">
			<div id="mainmenu">
				<span><b><spring:message code = 'ezApprovalG.t1512' /></b></span>
	            <select id="ListCompany" onchange="journal_get_formuse(this.value)">
	            	<c:forEach items="${compList}" var="company">
		            	<option value="${company.companyId }">${company.companyName }</option>
	            	</c:forEach>
	            </select>
			</div>
			<br/>
			<table class="content" style="width: 260px; margin-left: 15px;">
			    <tr>
			        <th style="text-align: center;" width="100px"><spring:message code='ezJournal.t12' /></th>
			        <th style="text-align: center;" width="80px"><spring:message code='ezJournal.t13' /></th>
			        <th style="text-align: center;" width="80px"><spring:message code='ezJournal.t14' /></th>
			    </tr>
			    <c:forEach items="${typeList }" var="type">
			    <tr>
			    	<td style="text-align: center;" width="100px"><spring:message code="${type.journaltypeId }" /></td>
			    	<c:choose>
				    	<c:when test="${type.journalUse eq 'use'}">
					    	<td style="text-align: center;" width="100px">
					    	<input type="radio" name="${type.journaltypeId }" value="use" checked/>
					    	</td>
					    	<td style="text-align: center;" width="100px">
					    	<input type="radio" name="${type.journaltypeId }" value="no"/>
					    	</td>
				    	</c:when>
				    	<c:otherwise>
					    	<td style="text-align: center;" width="100px">
					    	<input type="radio" name="${type.journaltypeId }" value="use" />
					    	</td>
					    	<td style="text-align: center;" width="100px">
					    	<input type="radio" name="${type.journaltypeId }" value="no" checked/>
					    	</td>
				    	</c:otherwise>
			    	</c:choose>
			    	</tr>
			    </c:forEach>
			    
			</table>
			<div class="btnposition" style="width: 260px">
			    <a class="imgbtn" onclick="Change_Click()"><span><spring:message code='ezJournal.t15' /></span></a>
			    <a class="imgbtn" onclick="Cancel_Click()"><span><spring:message code='ezJournal.t16' /></span></a>
			</div>
		</form>
	</body>
</html>

