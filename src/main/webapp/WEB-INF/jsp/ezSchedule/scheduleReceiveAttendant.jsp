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
		<title><spring:message code='ezSchedule.t332'/></title>
		<script>
			var parentwin = null;
			var RetValue;
			var ReturnFunction;
			
			window.onload = function () {
			    try {
			        RetValue = parent.schedule_receive_attendant_cross_dialogArguments[0];
			        ReturnFunction = parent.schedule_receive_attendant_cross_dialogArguments[1];
			    } catch (e) {
			        try {
			            RetValue = opener.schedule_receive_attendant_cross_dialogArguments[0];
			            ReturnFunction = opener.schedule_receive_attendant_cross_dialogArguments[1];
			        } catch (e) {
			            RetValue = window.dialogArguments;
			        }
			    }
			    parentwin = RetValue;
			}
	
			function accept_schedule(status)
			{
			    var checks = document.getElementById("receivelist").getElementsByTagName("input");
				var count = 0;
				var scheduleIdList = new Array();
				
				for (var i=0; i<checks.length; i++) {
					if (checks.item(i).checked == true)	{
					    count++;
					    scheduleIdList[i] = GetAttribute(checks.item(i), 'scheduleid');					    
					}
				}
	
				if (count == 0) {
					alert("<spring:message code='ezSchedule.t333' />");
					return;
				}		
				
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezSchedule/scheduleAcceptAttendant.do",
					data : {						
						status 	 : status,
						displayName : "${userInfo.displayName1}",
						displayName2 : "${userInfo.displayName2}",
						scheduleIdList : scheduleIdList
					},
					success: function(result) {
						if (status == "1")
						{
							window.returnValue = "1";
							alert("<spring:message code='ezSchedule.t336' />");
						} else
							alert("<spring:message code='ezSchedule.t337' />");
		
					    var checks = document.getElementById("receivelist").getElementsByTagName("input");
						for (var i=checks.length-1; i>-1; i--)
						{
							if (checks.item(i).checked == true)
								checks.item(i).parentElement.parentElement.parentElement.removeChild(checks.item(i).parentElement.parentElement);
						}
					},
					error: function() {
						if (status == "1")
							alert("<spring:message code='ezSchedule.t334' />");
						else
							alert("<spring:message code='ezSchedule.t335' />");
					}					
				});
				var checks2 = document.getElementById("receivelist").getElementsByTagName("input");
				if( checks2.length==0 )	{
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
	
	<body class="popup"> 
	    <form method="post">
	        <div id="menu">
	            <ul>
	                <li><span onClick="accept_schedule('1')"><spring:message code='ezSchedule.t338' /></span></li>
	                <li><span onClick="accept_schedule('2')"><spring:message code='ezSchedule.t339' /></span></li>
	            </ul>
	        </div>
	        <div id="close">
	            <ul>
	                <li><span onClick="window.close()"><spring:message code='ezSchedule.t16' /></span></li>
	            </ul>
	        </div> 
	
	        <div id="receivelist" style="OVERFLOW-Y:auto; OVERFLOW-X:hidden; WIDTH:100%; HEIGHT:295px"> 
	            <table class="popuplist" style="WIDTH: 100%">
	                <tr>
	                    <th style="white-space:nowrap; width:20px"><spring:message code='ezSchedule.t190' /></th> 
	                    <th style="white-space:nowrap; width:40px"><spring:message code='ezSchedule.t340' /></th> 
	                    <th style="white-space:nowrap; width:60px"><spring:message code='ezSchedule.t164' /></th> 
	                    <th style="white-space:nowrap; width:100px"><spring:message code='ezSchedule.t341' /></th> 
	                    <th style="white-space:nowrap"><spring:message code='ezSchedule.t272' /></th> 
	                    <th><spring:message code='ezSchedule.t318' /></th> 
	                </tr> 
	              	<c:forEach var="item" items="${receiveList}">
	              	<tr> 
	                    <td style="text-align:center">
	                    	<input type='checkbox' value="1" scheduleid='${item.scheduleId}' />
	                    </td> 
	                    <td title="<spring:message code='ezSchedule.t162' />" style="cursor:pointer" onClick="parentwin.show_personinfo('${item.creatorId}')">
	                    	<c:if test="${userInfo.primary == '1'}">${item.creatorName}</c:if>
	                    	<c:if test="${userInfo.primary != '1'}">${item.creatorName2}</c:if>	                    
	                    </td> 
	                    <td>
	                    	<c:if test="${item.status == '0'}"><spring:message code='ezSchedule.t166' /></c:if>
	                    	<c:if test="${item.status != '0'}"><spring:message code='ezSchedule.t169' /></c:if>
	                    </td> 
	                    <td>${item.location }</td> 
	                    <td title="<spring:message code='ezSchedule.t342' />" style="word-break:break-all;cursor:pointer;text-overflow:ellipsis;overflow:hidden" onClick="parentwin.open_schedule('${item.scheduleId}')">${item.title}</td> 
	                    <td style="white-space:nowrap">
	                    	<c:if test="${item.dateType == '1'}">
	                    		${fn:substring(item.startDate,0,16)} ~ ${fn:substring(item.endDate,0,16)}	
	                    	</c:if>
	                    	<c:if test="${item.dateType == '2'}">
	                    		<c:if test="${fn:substring(item.startDate,0,10) == fn:substring(item.endDate,0,10)}">${fn:substring(item.startDate,0,10)} (<spring:message code='ezSchedule.t280' /></c:if>
	                    		<c:if test="${fn:substring(item.startDate,0,10) != fn:substring(item.endDate,0,10)}">${fn:substring(item.startDate,0,10)} ~ ${fn:substring(item.endDate,0,10)} (<spring:message code='ezSchedule.t280' /></c:if>
	                    	</c:if>
	                    	<c:if test="${item.dateType == '3'}">
	                    		<spring:message code='ezSchedule.t343' />
	                    	</c:if>
	                    </td> 
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