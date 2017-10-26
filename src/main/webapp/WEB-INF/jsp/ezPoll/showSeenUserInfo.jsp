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
			window.onload = function () {
				if (MACSAFARIYN()) {
					window.resizeTo(420, 480);
				}
				
				document.getElementById("seenUser_").style.color = "#5ea84b";
				document.getElementById("unseenUser_").style.color = "#cc8b12";				
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
			    <div id="menu1" style="float: left; display: block; padding-left: 140px;">
			        	<h1><spring:message code='ezPoll.t135'/></h1>
			    </div>				
			</div>
			<div style="height:359px; overflow: auto;">
				<table border=1 style="float: left;clear: none;width : 50%; border-color: grey">
					<tr> 
						<th> <a id="seenUser_"><spring:message code='ezPoll.t136'/> <c:out value='${numberOfSeenUsers}'/></a></th> 
					</tr>
					<c:forEach var="list1" items="${listOfSeenUsers}"> 
						<tr id="${list1.id}" class="white" style="border: 1px solid #b6b6b6;">
							<td >
								<img src="${list1.userImage}" style="display:inline-block;float:left; height:50px;width:50px; padding-left: 8px; cursor: pointer;" onClick="menuQst_DetailUserInfo('${list1.id}')">
								<a style="cursor:pointer; display:inline-block; padding-top: 17px; padding-left: 42px;" onClick="menuQst_DetailUserInfo('${list1.id}')">	
									<c:choose>
										<c:when test="${list1.primary == '1'}">
											<c:out value ="${list1.displayName1}"/>
										</c:when>
										<c:otherwise>
											<c:out value ="${list1.displayName2}"/>
										</c:otherwise>	
									</c:choose>									
								</a>
							</td>
						</tr>
					</c:forEach>
				</table>
				<table border=1px style="float: left;clear: none;width : 50%;">
					<tr> 
						<th> <a id="unseenUser_"><spring:message code='ezPoll.t137'/> <c:out value='${numberOfUnseenUsers}'/></a></th> 
					</tr>
					<c:forEach var="list2" items="${listOfUnSeenUsers}"> 
						<tr id="${list2.id}" class="white" style="border: 1px solid #b6b6b6;">
						   <td >
							<img src="${list2.userImage}" style="display:inline-block;float:left; height:50px;width:50px; padding-left: 8px; cursor: pointer;" onClick="menuQst_DetailUserInfo('${list1.id}')">
								<a style="cursor:pointer; display:inline-block; padding-top: 17px; padding-left: 42px;" onClick="menuQst_DetailUserInfo('${list1.id}')">	
									<c:choose>
										<c:when test="${list2.primary == '1'}">
											<c:out value ="${list2.displayName1}"/>
										</c:when>
										<c:otherwise>
											<c:out value ="${list2.displayName2}"/>
										</c:otherwise>	
									</c:choose>									
								</a>
							</td>
						</tr>
					</c:forEach>
				</table>
			</div>
		</form>
	</body>
</html>