<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPoll.t123' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/css/ezPoll/sort.css')}" type="text/css">			
		<script type="text/javascript">
			window.onresize = function () {
				var height = document.documentElement.clientHeight;				
				var divElmt = document.getElementById("divTbl");
				divElmt.style.height = (height - 50) + "px";
			}
			
			window.onload = function() {
				if (MACSAFARIYN()) {
					window.resizeTo(420, 480);
				}					
			}
			
		    function menuQst_DetailUserInfo(pUserID, pDeptID) {
		    	 var feature = GetOpenPosition(420, 450);
		         window.open("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }	
		    
		    function sendMail(pUserID) {	
		    	var feature = GetOpenPosition(890, 840);
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        window.open("/ezEmail/mailWrite.do?cmd=POLL&type=one&userId=" + pUserID, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no,resizable=1" + feature);	    	
		    }
		    
		    function sendMailAll(pQstID) {
		    	var feature = GetOpenPosition(890, 840);
		    	var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        window.open("/ezEmail/mailWrite.do?cmd=POLL&type=group&state=notjoin&qstId=" + pQstID, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no,resizable=1" + feature);	    	
		    }
		</script>
	</head>
	
	<body class = "popup" id="mainbody" style="overflow: hidden;">
		<form method = "POST">
			<div id="normalScreen" style="overflow: hidden;">
			    <div id="menu1" style="float: left; display: block; width:100%; text-align:left; padding-left:5px;">
					<h1 style="display: inline-block;"><spring:message code='ezPoll.t123'/>&nbsp;(<c:out value='${numberOfUnVotedUsers}'/>)</h1>					
			    </div>
			    <div id="close">			    	
		            <ul>		            	
		                <li><span onclick="window.close()"></span></li>
		            </ul>
		        </div>
		        <div id="menu" class="extraMenu">
		            <ul>
		            	<li><img style="cursor: pointer;" src="/images/poll/sendMail01.png" onClick="sendMailAll('${qstID}')"></li>		                
		            </ul>
		        </div>
			</div>
			<div style="height:365px; overflow-y: auto; overflow-x: hidden;" id="divTbl">
				<table border=1 style="width : 100%; border-color: grey;">
					<c:forEach var="list" items="${listOfUnvotedUsers}"> 
						<tr id="${list.id}" class="white" style="border: 1px solid #ddd;">
							<td style="border-right:none; max-width: 200px; width: 190px;">
								<img src="${list.userFileUrl}" style="display:inline-block;float:left; height:40px; width:40px; padding:5px 0px 5px 8px; cursor: pointer;" onClick="menuQst_DetailUserInfo('${list.id}','${list.deptID}')">
								<a style="cursor:pointer; display:inline-block; padding: 0px 10px 0px 10px; float: left; line-height: 51px; overflow: hidden; text-overflow: ellipsis; max-width:120px; white-space: nowrap;" onClick="menuQst_DetailUserInfo('${list.id}','${list.deptID}')">	
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
							<td style="border-left:none; position: relative; background-clip: padding-box;"><img class="voteUserMailImg" src="/images/poll/sendMail.png" onClick="sendMail('${list.id}')"></td>		
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