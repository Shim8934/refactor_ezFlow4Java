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
		    
		    function sendMail(pUserID) {	
		    	var feature = GetOpenPosition(890, 840);
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        window.open("/ezPoll/mailWrite.do?type=one&userId=" + pUserID, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no,resizable=1" + feature);	    	
		    }
		    
		    function sendMailAll(pQstID, pOptID) {
		    	var feature = GetOpenPosition(890, 840);
		    	var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        window.open("/ezPoll/mailWrite.do?type=group&state=voted&qstId=" + pQstID + "&optId=" + pOptID, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no,resizable=1" + feature);		       
		    }
		    
		</script>
	</head>
	
	<body class = "popup" id = "mainbody">
		<form method = "POST">
			<div id="normalScreen" style="overflow: hidden;">
			    <div id="menu1" style="float: left; display: inline-block; padding-left: 25%;">
			        <h1 style="padding-left: 35px;"><spring:message code='ezPoll.t138'/><font color="white"> <c:out value='${totalVotes}'/></font></h1>
			    </div>				
			</div>
			<div style="display: inline-block; width: 100%; height:35px; line-height:34px; text-align:center; font-size:16px; background:#d1e3f5; border-radius:5px; color:#212121;"><b><c:out value='${content}'/></b></div>	
			<div style="display: inline-block; padding:8px 0px 2px 0px;">
				<img src="/images/group2.png" height="22" width="35" style="float:left; display:block; vertical-align:middle; padding:0px 5px 0px 0px;">
				<div style="float:left; display:block;"><c:out value='${totalVotesForOption}'/></div>
				<img style="position: fixed; right: 20px; top: 95px; cursor: pointer; height: 32px; width: 32px;" src="/images/poll/sendMail.png" onClick="sendMailAll('${qstID}','${optID}')">
			</div>	
			<div style="height:313px; overflow: auto;">
				<table border=1 style="width : 100%; border-color: grey;">
					<c:forEach var="list" items="${listOfVotedUsers}"> 
						<tr id="${list.userId}" class="white" style="border: 1px solid #b6b6b6;">
							<td style="border-right:none; max-width: 200px; width: 190px;">
								<img src="${list.userImage}" style="display:inline-block;float:left; height:40px; width:40px; padding:5px 0px 5px 8px; cursor: pointer;" onClick="menuQst_DetailUserInfo('${list.userId}')">								
								<a style="cursor:pointer; display:inline-block; padding: 0px 10px 0px 10px; float: left; line-height: 51px; overflow: hidden; text-overflow: ellipsis; max-width:120px; white-space: nowrap;" onClick="menuQst_DetailUserInfo('${list.userId}')">			
									<c:choose>
										<c:when test="${primaryLang == '1'}">
											<c:out value ="${list.userName1}"/>
										</c:when>
										<c:otherwise>
											<c:out value ="${list.userName2}"/>
										</c:otherwise>	
									</c:choose>											
								</a>
							</td>
							<td style="border:none; width: 60px; max-width: 110px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;"><c:out value ="${list.phone}"/></td>
							<td style="border-left:none; position: relative;"><img src="/images/poll/sendMail.png" style="height:40px; width:40px; position: absolute; top: 5px; right: 10px; cursor: pointer;" onClick="sendMail('${list.userId}')"></td>		
						</tr>
					</c:forEach>
				</table>				
			</div>
		</form>
	</body>
</html>