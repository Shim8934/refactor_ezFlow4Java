<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t256' /></title>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />

<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>

<script type="text/javascript">
	var taskDetails;
	var nowStatus;

	$(function(){
		taskDetails = ${taskDetails};
		$(".overviewDiv").html(replaceString(revertString(taskDetails.overview)));
		
		var target = "${target}";
		
		if(target !== "task"){
			var managersNameList = "";
			var participantsNameList = "";
			var members = taskDetails.groupMember;
			var membersCount = members.length;
			
			for(var i = 0; i < membersCount; i++){
				var member = members[i];
				
				if(member.memberRoleId === 1){
					managersNameList += member.userName + ", "
				} else {
					participantsNameList += member.userName + ", "
				}
			}
			
			document.querySelector(".managers").innerText = managersNameList.substr(managersNameList, managersNameList.lastIndexOf(", "));
			document.querySelector(".participants").innerText = participantsNameList.substr(participantsNameList, participantsNameList.lastIndexOf(", "));
		}
	});
	
	function sendMail() {
		var taskId = taskDetails.taskId;
		var projectId = taskDetails.projectId;
		var pheight = window.screen.availHeight;
		var conHeight = pheight * 0.8;
		var pwidth = window.screen.availWidth;
		var pTop = (pheight - conHeight) / 2;
		var pLeft = (pwidth - 1200) / 2;
		var url = "/ezEmail/mailWrite.do?cmd=ezPMS&type=group&projectId=" + projectId + "&taskId=" + taskId;
		
		window.open(url, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height=" + conHeight + "px, width=1200px, status=no, toolbar=no, menubar=no, location=no, resizable=1");
	}
</script>
<style type="text/css">
	.tg    {border-collapse:collapse;border-spacing:0;width:100%;}
	.tg tr {height: 30px;}
	.tg td {padding:5px 5px;border:1px solid #ccc;}
	.tg th {padding:5px 5px;border:1px solid #ccc;width:60px;}
	th.overviewTh{height:260px;}
	td.overviewTd{height:260px; vertical-align:top;}
	.tooltip {
	    position: relative;
	    display: inline-block;
	}
	
	.tooltip .tooltiptext {
	    visibility: hidden;
	    width: 120px;
	    background-color: #555;
	    color: #fff;
	    text-align: center;
	    border-radius: 6px;
	    padding: 5px 0;
	    position: absolute;
	    z-index: 1;
	    bottom: 125%;
	    left: 50%;
	    margin-left: -60px;
	    opacity: 0;
	    transition: opacity 0.3s;
	}
	
	.tooltip .tooltiptext::after {
	    content: "";
	    position: absolute;
	    top: 100%;
	    left: 50%;
	    margin-left: -5px;
	    border-width: 5px;
	    border-style: solid;
	    border-color: #555 transparent transparent transparent;
	}
	
	.tooltip:hover .tooltiptext {
	    visibility: visible;
	    opacity: 1;
	}
	
	.managers, .participants{max-height: 100%;overflow-y: auto;}
	.memberTd{height:29px;}
	.overviewDiv{max-height: 100%; overflow-y: auto; word-break: break-all; width: 100%;}
</style>
</head>
<body class="taskInfoTabBody">
	<table class="tg">
	<c:choose>
	<c:when test="${target eq 'task' }">
	  <tr>
	    <th class=""><spring:message code='ezPMS.t57' /></th>
	    <td class="" colspan="2"><c:out value="${taskDetails.writerName}"/></td>
	  </tr>
	  <tr>
	    <th class=""><spring:message code='ezPMS.t131' /></th>
	    <td class="" colspan="2"><c:out value="${taskDetails.writeDate}"/></td>
	  </tr>
	  <tr>
	    <th class=""><spring:message code='ezPMS.t63' /></th>
	    <td class="memberTd" style="border-right: none;">
	    	<div class="managers">
	    		<c:forEach items="${taskDetails.taskMember}" var="member" varStatus="status">
	    			<c:out value="${status.last ? member.userName : member.userName += ','}"></c:out>
	    		</c:forEach>
	    	</div>
	    </td>
	    <td style="width: 50px; border-left: none;">
	    	<img class="voteUserMailImg" style="padding-left: 10px; cursor: pointer;" src="/images/poll/sendMail.png" onclick="sendMail()">
	    </td>
	  </tr>
	  <tr>
	    <th class=""><spring:message code='ezPMS.t42' /></th>
	    <td class="" colspan="2"><c:out value='${taskDetails.groupName == null ? "-" : taskDetails.groupName}'/></td>
	  </tr>
	</c:when>
	<c:otherwise>
	  <tr>
	    <th class=""><spring:message code='ezPMS.t57' /></th>
	    <td class="" colspan="2"><c:out value="${taskDetails.creatorName}"/></td>
	  </tr>
	  <tr>
	    <th class=""><spring:message code='ezPMS.t131' /></th>
	    <td class="" colspan="2"><c:out value="${taskDetails.createDate}"/></td>
	  </tr>
	  <tr>
	    <th class=""><spring:message code='ezPMS.t63' /></th>
	    <td class="memberTd" colspan="2">
	    	<div class="managers"></div>
	    </td>
	  </tr>
	  <tr>
	    <th class=""><spring:message code='ezPMS.t64' /></th>
	    <td class="memberTd" colspan="2">
	    	<div class="participants"></div>
	    </td>
	  </tr>
	   <tr>
	    <th class="" ><spring:message code='ezPMS.t42' /></th>
	    <td class="" colspan="2"><c:out value='${taskDetails.upperGroupName == null ? "-" : taskDetails.upperGroupName}'/></td>
	  </tr>
	</c:otherwise>
	</c:choose>
	  
	  <c:if test="${target eq 'task' }">
	   <tr>
	    <th class=""><spring:message code='ezPMS.t181' /></th>
	    <td id="pretaskNames" colspan="2">
	    	<c:choose>
	    		<c:when test="${taskDetails.pretaskNames ne null}">
	    			<c:forEach items="${taskDetails.pretaskNames}" var="pretaskName" varStatus="status">
			    		<c:choose>
			    			<c:when test="${status.count lt taskDetails.pretaskNames.size()}">
			    				<span class="tooltip">
			    					<c:out value="${pretaskName}, "/>
			    					<span class="tooltiptext"><c:out value="${taskDetails.pretaskFullNames[status.index]}"/></span>
			    				</span>
			    			</c:when>
			    			<c:otherwise>
			    				<span class="tooltip">
			    					<c:out value="${pretaskName}"/>
			    					<span class="tooltiptext"><c:out value="${taskDetails.pretaskFullNames[status.index]}"/></span>
			    				</span>
			    			</c:otherwise>
			    		</c:choose>
			    	</c:forEach>
	    		</c:when>
	    		<c:otherwise>-</c:otherwise>
	    	</c:choose>	
	    </td>
	  </tr>
	  </c:if>
	 
	  <tr>
	    <th class=""><spring:message code='ezPMS.t267' /></th>
	    <td class="" colspan="2"><fmt:formatNumber value="${taskDetails.weight == null ? 0 : taskDetails.weight}" pattern="0.0" />%</td>
	  </tr>
	  <tr>
		<c:choose>
		<c:when test="${target eq 'task' }">
	    <th class="overviewTh"><spring:message code='ezPMS.t104' /></th>
	    </c:when>
	    <c:otherwise>
	    <th class="overviewTh"><spring:message code='ezPMS.t88' /></th>
	    </c:otherwise>
	    </c:choose>
	    <td class="overviewTd" colspan="2"><div class="overviewDiv"></div></td>
	  </tr>
	</table>
</body>
</html>