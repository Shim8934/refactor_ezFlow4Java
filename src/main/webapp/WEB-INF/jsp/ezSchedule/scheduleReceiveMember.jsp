<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
        <script type="text/javascript" src="/js/mouseeffect.js"></script>
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
        <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>        
		<title><spring:message code='ezSchedule.t344'/></title>
		<script>
			var parentwin = null;
			var ReturnFunction;
			
			window.onload = function () {
			    try {
			        RetValue = parent.schedule_receive_member_dialogArguments[0];
			        ReturnFunction = parent.schedule_receive_member_dialogArguments[1];
			    } catch (e) {
			        try {
			            RetValue = opener.schedule_receive_member_dialogArguments[0];
			            ReturnFunction = opener.schedule_receive_member_dialogArguments[1];
			        } catch (e) {
			            RetValue = window.dialogArguments;
			        }
			    }
			    RetValue = parentwin;
			}
	
			function accept_group(status) {
			    var checks = document.all("receivelist").getElementsByTagName("input");
			    var count = 0;
			    var groupIdList = new Array();
			    
			    for (var i = 0; i < checks.length; i++) {
			        if (checks.item(i).checked == true) {
			            count++;			            
			            groupIdList[i] = GetAttribute(checks.item(i), "groupid");
			        }
			    }
	
			    if (count == 0) {
			        alert("<spring:message code='ezSchedule.t333'/>");
			        return;
			    }
			    
			    $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezSchedule/scheduleAcceptMember.do",
					data : {						
						status 	 : status,						
						groupIdList : groupIdList
					},
					success: function(result) {
						if (status == "1") {
				            window.returnValue = "1";
				            alert("<spring:message code='ezSchedule.t336'/>");
				        }
				        else
				            alert("<spring:message code='ezSchedule.t337'/>");
		
				        var checks = document.all("receivelist").getElementsByTagName("input");
				        for (var i = checks.length - 1; i > -1; i--) {
				            if (checks.item(i).checked == true)
				                checks.item(i).parentElement.parentElement.parentElement.removeChild(checks.item(i).parentElement.parentElement);
				        }
					},
					error: function() {
						if (status == "1")
				            alert("<spring:message code='ezSchedule.t334'/>");
				        else
				            alert("<spring:message code='ezSchedule.t335'/>");
					}
			    });
			
			    var checks2 = document.all("receivelist").getElementsByTagName("input");
			    if (checks2.length == 0) {
			        window.close();
			    }
			}
			window.onbeforeunload = function () {
			    if (ReturnFunction != null) {
			        ReturnFunction();
			    }
			}
		</script>
	</head>
	
	<body scroll="no" class="popup">
		<form method="post">
			<div id="menu">
		    	<ul>
		      		<li><span onClick="accept_group('1')"><spring:message code='ezSchedule.t338'/></span></li>
		      		<li><span onClick="accept_group('2')"><spring:message code='ezSchedule.t339'/></span></li>
		    	</ul>
		  	</div>
		  	<div id="close">
		    	<ul>
		      		<li><span onClick="window.close()"><spring:message code='ezSchedule.t16'/></span></li>
		    	</ul>
		  	</div>
		  	<div id="receivelist" style="OVERFLOW-Y:auto; OVERFLOW-X:hidden; WIDTH:100%; HEIGHT:295px">
		    	<table class="popuplist" style="WIDTH: 100%" >
		      		<tr>
				    	<th style="text-align:center; width:10px"><spring:message code='ezSchedule.t190'/></th>
				        <th style="text-align:center; width:80px"><spring:message code='ezSchedule.t340'/></th>
				        <th style="text-align:center; width:50px"><spring:message code='ezSchedule.t164'/></th>
				        <th style="text-align:center; width:150px"><spring:message code='ezSchedule.t159'/></th>
				        <th style="text-align:center"><spring:message code='ezSchedule.t260'/></th>
				        <th style="text-align:center; width:80px"><spring:message code='ezSchedule.t345'/></th>
					</tr>
					<c:forEach var="item" items="${receiveList}">
					<tr>
			            <td style="white-space:nowrap; text-align:center">
			                <input type='checkbox' value="1" groupid='${item.groupId}'>
			            </td>
			            <td style="white-space:nowrap; text-align:center" title="<spring:message code='ezSchedule.t162'/>"  onclick="parentwin.show_personinfo('${item.memberId}')">
			            	<c:if test="${userInfo.primary == '1'}">${item.memberName}</c:if>
			            	<c:if test="${userInfo.primary != '1'}">${item.memberName2}</c:if>
			            </td>
			            <td style="white-space:nowrap; text-align:center">
			            	<c:if test="${item.status == '0'}"><spring:message code='ezSchedule.t166'/></c:if>
			            	<c:if test="${item.status != '0'}"><spring:message code='ezSchedule.t169'/></c:if>
			            </td>
			            <td style="word-break:break-all; width:150px">${item.groupName}</td>
			            <td style="word-break:break-all; padding-top:3px; padding-bottom:3px;">${item.description}</td>
			            <td style="white-space:nowrap; text-align:center">${fn:substring(item.responseDate,0,16)}</td>
			        </tr>
					</c:forEach>
	    		</table>
		  	</div>
		  	<script type="text/javascript">
				selToggleList(document.getElementById("menu"), "ul", "li", "0");
				selToggleList(document.getElementById("close"), "ul", "li", "0");
			</script>
		</form>
	</body>
</html>