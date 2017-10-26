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
			    <div id="menu1" style="float: left; display: inline-block; padding-left: 25%;">
			        <h1 style="padding-left: 35px;"><spring:message code='ezPoll.t138'/><font color="red"> <c:out value='${totalVotes}'/></font></h1>
			    </div>				
			</div>
			<div style="display: inline-block; width: 100%;border-bottom: 1px solid #b6b6b6; padding-bottom: 10px; padding-left: 8px;"><b><c:out value='${content}'/></b></div>	
			<div style="display: inline-block; ">
				<img src="/images/group.png" height="16" width="16" style="float: left; display: block; padding-top: 5px; padding-left: 8px;">
				<div style="float: left; display: block;padding-top: 5px; padding-left: 5px;"><c:out value='${totalVotesForOption}'/></div>
			</div>	
			<div style="height:300px; overflow: auto;">
				<table border=1 style="width : 100%; border-color: grey;">
					<c:forEach var="list" items="${listOfVotedUsers}"> 
						<tr id="${list.userId}" class="white" style="border: 1px solid #b6b6b6;">
							<td >
								<img src="${list.userImage}" style="display:inline-block;float:left; height:50px;width:50px; padding-left: 8px; cursor: pointer;" onClick="menuQst_DetailUserInfo('${list.userId}')">
								<a style="cursor:pointer; display:inline-block; padding-top: 17px; padding-left: 42px;" onClick="menuQst_DetailUserInfo('${list.userId}')">			
									<c:out value ="${list.userName}"/>
								</a>
							</td>
						</tr>
					</c:forEach>
				</table>				
			</div>
		</form>
	</body>
</html>