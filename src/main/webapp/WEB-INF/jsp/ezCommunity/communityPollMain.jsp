<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>poll_main</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<link rel="stylesheet" href="/css/community.css" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var code = "<c:out value = '${code}' />";
// 			var ch_CommunityAdmin = "${chCommunityAdmin}";
		    var UserLevel = "<c:out value ='${userLevel}' />";
		    
		    document.onselectstart = function () { return false; };
		    
		    window.onload = function () {
			    if (navigator.userAgent.indexOf('Firefox') != -1) {
			        document.body.style.MozUserSelect = 'none';
			        document.body.style.WebkitUserSelect = 'none';
			        document.body.style.khtmlUserSelect = 'none';
			        document.body.style.oUserSelect = 'none';
			        document.body.style.UserSelect = 'none';
			    }
				
				$("#tblList").html($("#tblList").html() + '${strXML}'); 
			}
		    
		    function alertMessage() {
				alert("<spring:message code = 'ezCommunity.t667' />");
			}	  

			function poll_edit(pClubNo, managerID) {
				window.location.href = "/ezCommunity/pollEdit.do?pClubNo=" + encodeURIComponent(pClubNo) + "&managerID=" + encodeURIComponent(managerID);
			}

			function poll_Delete(pClubNo, managerID) {
				window.location.href = "/ezCommunity/pollDelete.do?code=" + encodeURIComponent(pClubNo) + "&managerID=" + encodeURIComponent(managerID);
			}
					
			function poll_add() {
				window.location.href = "/ezCommunity/pollAdd.do?code=" + encodeURIComponent(code);
			}
					
			function poll_chManage(strMsg) {
				alert("<spring:message code='ezCommunity.t668' />"+strMsg+"<spring:message code='ezCommunity.t669' />");
				return;
			}
			
		    function movepage(code, itemno, pollstate) {
		        if (UserLevel == "0" || UserLevel == "9") {
		            alert("<spring:message code='ezCommunity.t1102' />");
		            return;
		        }
		        
		        window.location.href = "/ezCommunity/pollRes.do?code=" + code + "&pollManagerID=" + itemno + "&pollState=" + pollstate;
		    }
		</script>
	</head>
	<body class ="cmhome_body">
		<h1 class="type1_h1"><spring:message code='ezCommunity.t598' /></h1>
		<div id="mainmenu">
			<ul>
				<c:if test="${guest != '1' }">
					<c:choose>
						<c:when test="${disable == false }">
							<c:choose>
								<c:when test="${chCommunityAdmin < 0 && (userLevel == '0' || userLevel == '9')}">
									<li><span onClick="poll_chManage('<spring:message code='ezCommunity.t670' />')"><spring:message code='ezCommunity.t671' /></span></li>
								</c:when>
								
								<c:otherwise>
									<li><span  onClick="poll_add()"><spring:message code='ezCommunity.t671' /></span></li>
								</c:otherwise>
							</c:choose>	
						</c:when>
						
						<c:otherwise>
							<li><span  onClick="javascript:alertMessage();"><spring:message code='ezCommunity.t671' /></span></li>
						</c:otherwise>
					</c:choose>
				</c:if>
			</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
		<table id="tblList" class="cmhomelist" style="width:100%;" >
			<tr>
				<th style="width:40px;"><spring:message code='ezCommunity.t32' /></th>
			    <th style="width:150px;"><spring:message code='ezCommunity.t672' /></th>
			    <th><spring:message code='ezCommunity.t673' /></th>
			    <th style="width:50px;"><spring:message code='ezCommunity.t674' /></th>
			    <th style="width:60px;"><spring:message code='ezCommunity.t675' /></th>
			    <th style="width:100px;"><spring:message code='ezCommunity.t676' /></th>
			</tr>
		</table>
	</body>
</html>