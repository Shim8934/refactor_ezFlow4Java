<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript">		
	    	var selectedUser ;
	    	var selectedUserName ;
	    
			function changeCompany() {
				var url = "/admin/ezJournal/author.do";
				parent.frames["right"].location.href = url + "?companyId=" + encodeURIComponent(companySelectID);
			}
			
			function insertAuth() {
				var url = "/admin/ezJournal/authorView.do";
				url+="?companyId=" + encodeURIComponent(companySelectID);
				
		    	if (navigator.userAgent.toLowerCase().indexOf("chrome") != -1) {
					window.open(url, "authorView", GetOpenWindowfeature(523, 215));
				} else {
					window.open(url, "authorView", GetOpenWindowfeature(520, 215));
				}	// 높이값 수정 (203,200 > 215) : 언어별 textarea 높이가 다름, 한국어가 가장 큼
			}
			
			function updateAuth() {
				var userId = selectedUser;
				var url = "/admin/ezJournal/authorView.do";
				url += "?companyId=" + encodeURIComponent(companySelectID);
				
				if (userId) {
					url += "&userId=" + encodeURIComponent(userId) + "&userName=" + encodeURIComponent(selectedUserName);
					
					if (navigator.userAgent.toLowerCase().indexOf("chrome") != -1) {
						window.open(url, "authorView", GetOpenWindowfeature(523, 215));
					} else {
						window.open(url, "authorView", GetOpenWindowfeature(520, 215));
					}	// 높이값 수정 (203,200 > 215) : 언어별 textarea 높이가 다름, 한국어가 가장 큼
				} else {
					alert("<spring:message code='ezJournal.t219' />");
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
			    	var flag =confirm("<spring:message code='ezJournal.t220' />");
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
					alert("<spring:message code='ezJournal.t221' />");
				}
		    }
		</script>
		<style>	
			tr:hover{background:#eee; color:#fff;}
			.selectTR{
				background-color: #f1f8ff;
			}
		</style>
	</head>
	<body class="mainbody"> 
		<h1>
			<spring:message code='ezJournal.t4' />
			<jsp:include page="/WEB-INF/jsp/admin/companySelect.jsp">
				<jsp:param name="companySelectID" value="${selectedCompany}" />
			</jsp:include>
		</h1>
		<form class="journalForm">
			<div id="mainmenu" style="padding-left: 5px;">
	  			<ul>
					<li class="important"><span onClick="insertAuth();"><spring:message code='ezJournal.t36' /></span></li>
					<li><span onClick="updateAuth();"><spring:message code='ezJournal.t362' /></span></li>
					<li><span class="icon16 icon16_delete" onClick="deleteAuthor();"></span></li>
	  			</ul>
			</div>
			<script type="text/javascript">
		   		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
			<div id="divlvtForm" style="height: 500px; width:100%; overflow-x:hidden; overflow-y:auto; padding:0px;">
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
			</div>
		</form>
	</body>
</html>

