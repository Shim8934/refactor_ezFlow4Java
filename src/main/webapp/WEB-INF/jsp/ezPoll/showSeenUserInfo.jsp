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
		    
		    function sendMailAll1(pQstID) {
		    	var feature = GetOpenPosition(890, 840);
		    	var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        window.open("/ezPoll/mailWrite.do?type=group&state=seen&qstId=" + pQstID, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no,resizable=1" + feature);	    	
		    }
		    
		    function sendMailAll2(pQstID) {
		    	var feature = GetOpenPosition(890, 840);
		    	var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        window.open("/ezPoll/mailWrite.do?type=group&state=unseen&qstId=" + pQstID, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no,resizable=1" + feature);	    	
		    }
		    
		</script>
	</head>
	
	<body class = "popup" id = "mainbody">
		<form method = "POST">
			<div id="normalScreen" style="overflow: hidden;">
			    <div id="menu1" style="float: left; display: block; padding-left: 315px;">
			        	<h1><spring:message code='ezPoll.t135'/></h1>
			    </div>				
			</div>
			<div style="height:359px; overflow: auto;">
				<table border=1 style="float: left;clear: none;width : 50%; border-color: grey" class="voteSeenTbl">
					<tr> 
						<th colspan="3" style="position: relative;"> 
							<a id="seenUser_" style="color:#FFF;"><spring:message code='ezPoll.t136'/> (<c:out value='${numberOfSeenUsers}'/>)</a>
							<img style="position: absolute; right: 10px; top: 3px; cursor: pointer; height: 40px; width: 40px;" src="/images/poll/sendEmailGroup.png" onClick="sendMailAll1('${qstID}')">
						</th> 
					</tr>
					<c:forEach var="list1" items="${listOfSeenUsers}"> 
						<tr id="${list1.id}" class="white" style="border: 1px solid #DDD;">
							<td style="border-right:none; max-width: 180px;  width: 160px;">
								<img src="${list1.userFileUrl}" style="display:inline-block;float:left; height:40px; width:40px; padding:5px 0px 5px 8px; cursor: pointer;" onClick="menuQst_DetailUserInfo('${list1.id}')">
								<a style="cursor:pointer; display:inline-block; float:left; width:80px; line-height:51px; padding:0px 10px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;" onClick="menuQst_DetailUserInfo('${list1.id}')">	
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
							<td style="border:none; width: 60px; max-width: 110px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;"><c:out value ="${list1.phone}"/></td>	
							<td style="border-left:none; position: relative;"><img src="/images/poll/sendMail.png" style="height:40px; width:40px; position: absolute; top: 5px; right: 10px; cursor: pointer;" onClick="sendMail('${list1.id}')"></td>					
						</tr>
					</c:forEach>
				</table>
				<table border=1px style="float: left;clear: none;width : 50%; margin:0px 0px 0px -1px;" class="voteUnseenTbl">
					<tr> 
						<th colspan="3" style="position: relative;"> 
							<a id="unseenUser_" style="color:#000;"><spring:message code='ezPoll.t137'/> (<c:out value='${numberOfUnseenUsers}'/>)</a>
							<img style="position: absolute; right: 10px; top: 3px; cursor: pointer; height: 40px; width: 40px;" src="/images/poll/sendEmailGroup.png" onClick="sendMailAll2('${qstID}')">
						</th> 
					</tr>
					<c:forEach var="list2" items="${listOfUnSeenUsers}"> 
						<tr id="${list2.id}" class="white" style="border: 1px solid #DDD;">
						   <td style="border-right:none; max-width: 180px; width: 160px;">
							<img src="${list2.userFileUrl}" style="display:inline-block;float:left; height:40px; width:40px; padding:5px 0px 5px 8px; cursor: pointer;" onClick="menuQst_DetailUserInfo('${list2.id}')">
								<a style="cursor:pointer; display:inline-block; float:left; line-height:51px; padding:0px 10px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; width: 80px;" onClick="menuQst_DetailUserInfo('${list2.id}')">	
									<c:choose>
										<c:when test="${primaryLang == '1'}">
											<c:out value ="${list2.displayName1}"/>
										</c:when>
										<c:otherwise>
											<c:out value ="${list2.displayName2}"/>
										</c:otherwise>	
									</c:choose>									
								</a>								
							</td>	
							<td style="border:none; width: 60px; max-width: 110px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;"><c:out value ="${list2.phone}"/></td>
							<td style="border-left:none; position: relative;"><img src="/images/poll/sendMail.png" style="height:40px; width:40px; position: absolute; top: 5px; right: 10px; cursor: pointer;" onClick="sendMail('${list2.id}')"></td>											
						</tr>
					</c:forEach>
				</table>
			</div>
		</form>
	</body>
</html>