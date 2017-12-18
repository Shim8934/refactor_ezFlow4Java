<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='main.t70' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='main.e15' />" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<link rel="stylesheet" href="/css/ezPoll/sort.css" type="text/css">			
		<script type="text/javascript">				
			window.onload = function() {
				if (MACSAFARIYN()) {
					window.resizeTo(420, 480);
				}					
			}
			
		    function menuQst_DetailUserInfo(pUserID) {
		    	 var feature = GetOpenPosition(420, 438);
		         window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }	
		</script>
	</head>
	
	<body class = "popup" id = "mainbody">
		<form method = "POST">
			<div id="normalScreen" style="overflow: hidden;">
			    <div id="menu1" style="float: left; display: block; width:100%; text-align:center;">
					<h1><spring:message code='ezPoll.t123'/>&nbsp;(<c:out value='${numberOfUnVotedUsers}'/>)</h1>
			    </div>					
			</div>
			<div style="height:359px; overflow: auto;">
				<table border=1 style="width : 100%; border-color: grey;">
					<c:forEach var="list" items="${listOfUnvotedUsers}"> 
						<tr id="${list.id}" class="white" style="border: 1px solid #ddd;">
							<td style="border-right:none; max-width: 200px; width: 190px;">
								<img src="${list.userFileUrl}" style="display:inline-block;float:left; height:40px; width:40px; padding:5px 0px 5px 8px; cursor: pointer;" onClick="menuQst_DetailUserInfo('${list.id}')">
								<a style="cursor:pointer; display:inline-block; padding: 0px 10px 0px 10px; float: left; line-height: 51px; overflow: hidden; text-overflow: ellipsis; max-width:120px; white-space: nowrap;" onClick="menuQst_DetailUserInfo('${list.id}')">	
									<c:choose>
										<c:when test="${primaryLang == '1'}">
											<c:out value ="${list.displayName1}"/>
										</c:when>
										<c:otherwise>
											<c:out value ="${list.displayName2}"/>
										</c:otherwise>	
									</c:choose>									
								</a>
							</td>
							<td style="border:none; width: 60px; max-width: 110px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;"><c:out value ="${list.phone}"/></td>
							<td style="border-left:none; position: relative;"><img src="/images/poll/sendMail.png" style="height:40px; width:40px; position: absolute; top: 5px; right: 10px; cursor: pointer;" onClick=""></td>		
						</tr>
					</c:forEach>
					<c:if test="${empty listOfUnvotedUsers}">
						<tr class="white" style="border: 1px solid #DDD;">
							<td style="height:51px;text-align: center"><spring:message code='ezPoll.t248'/></td>
						</tr>
					</c:if>
				</table>				
			</div>
		</form>
	</body>
</html>