<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezJournal.c1' />" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript">		
	    	var selectedUser ;
	    	var selectedUserName ;
	    
			function changeSelectCompany(val) {			    
				var url = "/admin/ezJournal/author.do";
				parent.frames["right"].location.href = url+"?companyId="+val;
			}
			
			function insertAuth() {			
				var url = "/admin/ezJournal/authorView.do";
				var companyId = document.getElementById("companyId").value;
				url+="?companyId="+companyId;
				window.open(url, "authorView", GetOpenWindowfeature(500, 200));
			}
			
			function updateAuth() {			
				var userId = selectedUser;
				var url = "/admin/ezJournal/authorView.do";
				var companyId = document.getElementById("companyId").value;
				url+="?companyId="+companyId;
				if (userId) {
					url+="&userId="+userId+"&userName="+selectedUserName;
					window.open(url, "authorView", GetOpenWindowfeature(500, 200));
				} else {
					alert("<spring:message code='ezPortal.t85' />");
				}
			}
			
			function selectedTR(elem) {
				selectedUser = $(elem).attr("id");
				selectedUserName = $(elem).attr("userName");
				$("*").removeClass("selectTR");
	   			$(elem).addClass("selectTR");
			}
			
		    function deleteAuthor() {
		    	if (selectedUser) {
			    	var flag =confirm("<spring:message code='ezResource.t351' />");
			    	if(flag){
				    	$.ajax({
			   				type:"post",
			   				dataType:"html",
			   				url:"/admin/ezJournal/deleteAuthor.do",
			   				data:{"userId":selectedUser},
			   				success: function(result){
			   					if (result == "ok") {
				   					alert("<spring:message code='ezJournal.t138'/>");
							        window.location.reload(true);
			   					}
			   				}
			   			});
			    	}
				} else {
					alert("<spring:message code='ezBoard.t601' />");
				}
		    }
		</script>
		<style>	
			tr:hover{background:#eee; color:#fff;}
			.selectTR{
				background-color: #efeff0;
			}
		</style>
	</head>
	<body class="mainbody"> 
		<h1><spring:message code='ezJournal.t4' /></h1>
		<form class="journalForm">
			<div id="mainmenu" style="padding-left: 5px;">
				<span><b><spring:message code = 'ezApprovalG.t1512' /></b>
		            <select name="companyId" id="companyId" onchange="changeSelectCompany(this.value)">
		            	<c:forEach items="${compList}" var="company">
			            	<option value="${company.companyId }"
		            		<c:if test="${company.selected eq 'selected' }">
		            			selected
		            		</c:if>
			            	><c:out value='${company.companyName }'/></option>
		            	</c:forEach>
		            </select><br/><br/>
	            </span>
	  			<ul>
					<li><span onClick="insertAuth();"><spring:message code='ezJournal.t36' /></span></li>
					<li><span onClick="updateAuth();"><spring:message code='ezJournal.t362' /></span></li>
					<li><span onClick="deleteAuthor();"><spring:message code='ezJournal.t37' /></span></li>
	  			</ul>
			</div>
			<script type="text/javascript">
		   		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
			<table class="mainlist" style="width:100%; margin-left:5px;">
			    <tr>
			        <th style="text-align: left; width:20%;"><spring:message code='ezJournal.t38' /></th>
			        <th style="text-align: left; width:20%;"><spring:message code='ezJournal.t39' /></th>
			        <th style="text-align: left; width:20%;"><spring:message code='ezJournal.t40' /></th>
			        <th style="text-align: left; width:40%;"><spring:message code='ezJournal.t41' /></th>
			    </tr>
			    <c:choose>
				    <c:when test="${fn:length(authList) ne 0}">
					    <c:forEach items="${authList }" var="auth">
					    	<tr ondblclick="updateAuth();" id="${auth.userId}" userName="${auth.userName }" onclick="selectedTR(this);" style="cursor: pointer;">
					    		<td style="text-align: left;"><c:out value='${auth.userName }'/> </td>
					    		<td style="text-align: left;"><c:out value='${auth.jikwi }'/> </td>
					    		<td style="text-align: left;"><c:out value='${auth.deptName }'/> </td>
					    		<td style="text-align: left;">${auth.authDept }</td>
					    	</tr>
					    </c:forEach>
				    </c:when>
				    <c:otherwise>
				    	<tr>
				    		<td style="text-align: center;" colspan="4"><spring:message code='ezJournal.t125' /></td>
				    	</tr>
				    </c:otherwise>
			    </c:choose>
			    
			</table>
		</form>
	</body>
</html>

